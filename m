Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbaAFUJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:09:37 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:60050 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754806AbaAFUJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:09:35 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, rjw@rjwysocki.net
Cc: Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] drivers/class: Add Legacy PM OPS usage check and warning to __class_register()
Date: Mon,  6 Jan 2014 13:03:22 -0700
Message-Id: <480191469165334594d1027fb2ccae68d7fb71a9.1389034060.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1389034060.git.shuah.kh@samsung.com>
References: <cover.1389034060.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1389034060.git.shuah.kh@samsung.com>
References: <cover.1389034060.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Legacy PM OPS usage checks to __class_register() function. If Legacy PM OPS
usage is found, print warning message to indicate that the driver code needs
updating to use Dev PM OPS interfaces. This will help serve as a way to track
drivers that still use Legacy PM OPS and fix them.

The Legacy PM OPS check looks for suspend(struct device *, pm_message_t) or
resume(struct device *) class level interfaces.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/class.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index f96f704..2f20be5 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -169,6 +169,10 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 
 	pr_debug("device class '%s': registering\n", cls->name);
 
+	if (cls->suspend || cls->resume)
+		pr_warn("device class '%s' needs updating - use pm pointer.\n",
+			cls->name);
+
 	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
 	if (!cp)
 		return -ENOMEM;
-- 
1.8.3.2

