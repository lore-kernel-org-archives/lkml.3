Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab3KHALJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:11:09 -0500
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:48931 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756320Ab3KHALF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:11:05 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, rjw@rjwysocki.net
Cc: Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] drivers/bus: Add Legacy PM OPS usage check and warning to bus_register()
Date: Thu,  7 Nov 2013 17:03:48 -0700
Message-Id: <05f575f1137642df7306564f6363ec5095a58779.1383868060.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1383868060.git.shuah.kh@samsung.com>
References: <cover.1383868060.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1383868060.git.shuah.kh@samsung.com>
References: <cover.1383868060.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Legacy PM OPS usage checks to bus_register() function. If Legacy PM OPS
usage is found, print warning message to indicate the driver code needs
updating to use Dev PM OPS interfaces. This will help serve as a way to track
drivers that still use Legacy PM OPS and fix them.

The Legacy PM OPS check looks for suspend(struct device *, pm_message_t) or
resume(struct device *) bus level interfaces.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/bus.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 4c289ab..9e68453 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -991,6 +991,9 @@ int bus_register(struct bus_type *bus)
 		goto bus_groups_fail;
 
 	pr_debug("bus: '%s': registered\n", bus->name);
+	if (bus->suspend || bus->resume)
+		pr_warn("bus '%s': Please update to use dev pm ops.\n",
+			bus->name);
 	return 0;
 
 bus_groups_fail:
-- 
1.8.3.2

