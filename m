Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbaAFUJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:09:53 -0500
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:50516
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756003AbaAFUJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:09:36 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2014 15:09:36 EST
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, rjw@rjwysocki.net
Cc: Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] driver: Add Legacy PM OPS usage check and warning to driver_register()
Date: Mon,  6 Jan 2014 13:03:23 -0700
Message-Id: <d3beb1b236ab235e340ecbdecaf3ab14b071b74f.1389034060.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1389034060.git.shuah.kh@samsung.com>
References: <cover.1389034060.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1389034060.git.shuah.kh@samsung.com>
References: <cover.1389034060.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Legacy PM OPS usage checks to driver_register() function. If Legacy PM OPS
usage is found, print warning message to indicate that the driver code needs
updating to use Dev PM OPS interfaces. This will help serve as a way to track
drivers that still use Legacy PM OPS and fix them.

The Legacy PM OPS check looks for suspend(struct device *, pm_message_t) or
resume(struct device *) struct device_driver interfaces.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/driver.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 9e29943..7838a8a 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -157,6 +157,10 @@ int driver_register(struct device_driver *drv)
 		printk(KERN_WARNING "Driver '%s' needs updating - please use "
 			"bus_type methods\n", drv->name);
 
+	if (drv->suspend || drv->resume)
+		pr_warn("Driver '%s' needs updating - use pm pointer.\n",
+			drv->name);
+
 	other = driver_find(drv->name, drv->bus);
 	if (other) {
 		printk(KERN_ERR "Error: Driver '%s' is already registered, "
-- 
1.8.3.2

