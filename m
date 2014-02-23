Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaBWUW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 15:22:56 -0500
Received: from mail.ispras.ru ([83.149.199.45]:49753 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbaBWUWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 15:22:24 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Todza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 3/3] staging: dgap: fix error handling in dgap_init_module()
Date: Mon, 24 Feb 2014 00:21:53 +0400
Message-Id: <1393186913-4687-3-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393186913-4687-1-git-send-email-khoroshilov@ispras.ru>
References: <1393186913-4687-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to call pci_unregister_driver() if pci_register_driver() failed.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/dgap/dgap_driver.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/dgap/dgap_driver.c b/drivers/staging/dgap/dgap_driver.c
index 136c879b560c..cc6933db6feb 100644
--- a/drivers/staging/dgap/dgap_driver.c
+++ b/drivers/staging/dgap/dgap_driver.c
@@ -254,18 +254,10 @@ int dgap_init_module(void)
 	/*
 	 * If something went wrong in the scan, bail out of driver.
 	 */
-	if (rc < 0) {
-		/* Only unregister the pci driver if it was actually registered. */
-		if (dgap_NumBoards)
-			pci_unregister_driver(&dgap_driver);
-		else
-			printk("WARNING: dgap driver load failed.  No DGAP boards found.\n");
-
+	if (rc < 0)
 		dgap_cleanup_module();
-	}
-	else {
+	else
 		dgap_create_driver_sysfiles(&dgap_driver);
-	}
   
 	DPR_INIT(("Finished init_module. Returning %d\n", rc));
 	return (rc);
-- 
1.8.3.2

