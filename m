Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3KHALn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:11:43 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:49310 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754717Ab3KHALG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:11:06 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, rjw@rjwysocki.net
Cc: Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] drivers/class: Add Legacy PM OPS usage check and warning to __class_register()
Date: Thu,  7 Nov 2013 17:03:49 -0700
Message-Id: <17d82f384b7165fce260f63d8a57c4469d392c1c.1383868060.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1383868060.git.shuah.kh@samsung.com>
References: <cover.1383868060.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1383868060.git.shuah.kh@samsung.com>
References: <cover.1383868060.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Legacy PM OPS usage checks to __class_register() function. If Legacy PM OPS
usage is found, print warning message to indicate the driver code needs
updating to use Dev PM OPS interfaces. This will help serve as a way to track
drivers that still use Legacy PM OPS and fix them.

The Legacy PM OPS check looks for suspend(struct device *, pm_message_t) or
resume(struct device *) class level interfaces.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/class.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 8b7818b..f26a3f2 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -180,6 +180,10 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 
 	pr_debug("device class '%s': registering\n", cls->name);
 
+	if (cls->suspend || cls->resume)
+		pr_warn("device class '%s': Please update to use dev pm ops\n",
+			cls->name);
+
 	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
 	if (!cp)
 		return -ENOMEM;
-- 
1.8.3.2

