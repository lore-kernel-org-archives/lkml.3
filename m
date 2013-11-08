Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3KHALN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:11:13 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:59661 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756364Ab3KHALH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:11:07 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, rjw@rjwysocki.net
Cc: Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] driver: Add Legacy PM OPS usage check and warning to driver_register()
Date: Thu,  7 Nov 2013 17:03:50 -0700
Message-Id: <b33c1967bdaed9a36fa5a6d7855310c84cb9b910.1383868060.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1383868060.git.shuah.kh@samsung.com>
References: <cover.1383868060.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1383868060.git.shuah.kh@samsung.com>
References: <cover.1383868060.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Legacy PM OPS usage checks to driver_register() function. If Legacy PM OPS
usage is found, print warning message to indicate the driver code needs
updating to use Dev PM OPS interfaces. This will help serve as a way to track
drivers that still use Legacy PM OPS and fix them.

The Legacy PM OPS check looks for suspend(struct device *, pm_message_t) or
resume(struct device *) struct device_driver interfaces.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/driver.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 9e29943..10ff280 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -157,6 +157,10 @@ int driver_register(struct device_driver *drv)
 		printk(KERN_WARNING "Driver '%s' needs updating - please use "
 			"bus_type methods\n", drv->name);
 
+	if (drv->suspend || drv->resume)
+		pr_warn("Please update driver '%s' to use dev pm ops.\n",
+			drv->name);
+
 	other = driver_find(drv->name, drv->bus);
 	if (other) {
 		printk(KERN_ERR "Error: Driver '%s' is already registered, "
-- 
1.8.3.2

