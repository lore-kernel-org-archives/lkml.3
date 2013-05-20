Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab3ETTXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:23:31 -0400
Received: from mout.gmx.net ([212.227.15.19]:50864 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab3ETTXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:23:30 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/ukDtIz2HueAs08auchRMDjwifmLhaPFBFiLDo39
	elRT+Ucs2Vbmyt
From: Peter Huewe <peterhuewe@gmx.de>
To: Michael Hennerich <michael.hennerich@analog.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] mfd/adp5520: Use module_i2c_driver to register driver
Date: Mon, 20 May 2013 21:28:35 +0200
Message-Id: <1369078115-25377-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_i2c_driver instead of calling
register and unregister in the otherwise empty init/exit functions

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/mfd/adp5520.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index 210dd03..2cc1689 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -360,18 +360,7 @@ static struct i2c_driver adp5520_driver = {
 	.id_table 	= adp5520_id,
 };
 
-static int __init adp5520_init(void)
-{
-	return i2c_add_driver(&adp5520_driver);
-}
-module_init(adp5520_init);
-
-static void __exit adp5520_exit(void)
-{
-	i2c_del_driver(&adp5520_driver);
-}
-module_exit(adp5520_exit);
-
+module_i2c_driver(adp5520_driver);
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("ADP5520(01) PMIC-MFD Driver");
 MODULE_LICENSE("GPL");
-- 
1.8.1.5

