Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422754Ab3LTNwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:52:30 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37598 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422680Ab3LTNw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:52:26 -0500
From: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>
To: michael.hoefler@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, Christoph Kohl <christoph.kohl@t-online.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rupert Muchembled <rupert@rmuch.net>, Chad Williamson <chad@dahc.us>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2 3/3] silicom: remaining checkpatch issues in bypass.c
Date: Fri, 20 Dec 2013 14:51:13 +0100
Message-Id: <1387547475-7135-4-git-send-email-michael.hoefler@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387547475-7135-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
References: <1387547475-7135-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch we fix some "logical" errors in bypass.c of the silicom bypass
driver (in staging).

Checkpatch complains about the following errors:
 - unnecessary forward declarations in a source file
 - assignment in if condition

In addition to that the __init and __exit macros were missing at the init and
cleanup function.

There are still two warnings left for this file related to too many leadingtabs
at nested blocks. I did not touch this issue becasue the code needs really some
refactoring. And since i do not have the appropriate hardware to test the code,
i do not change the functionality in any way.

Signed-off-by: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>
Signed-off-by: Christoph Kohl <christoph.kohl@t-online.de>
---
 drivers/staging/silicom/bypasslib/bypass.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/silicom/bypasslib/bypass.c b/drivers/staging/silicom/bypasslib/bypass.c
index ff0c517..9b771c9 100644
--- a/drivers/staging/silicom/bypasslib/bypass.c
+++ b/drivers/staging/silicom/bypasslib/bypass.c
@@ -40,9 +40,6 @@ MODULE_AUTHOR("www.silicom.co.il");
 
 MODULE_LICENSE("GPL");
 
-int init_lib_module(void);
-void cleanup_lib_module(void);
-
 static int do_cmd(struct net_device *dev, struct ifreq *ifr, int cmd, int *data)
 {
 	int ret = -1;
@@ -151,9 +148,10 @@ static int is_bypass_dev(int if_index)
 	int data = 0;
 
 	while ((pdev = pci_get_class(PCI_CLASS_NETWORK_ETHERNET << 8, pdev))) {
-		if ((dev = pci_get_drvdata(pdev)) != NULL)
-			if (((dev = pci_get_drvdata(pdev)) != NULL) &&
-			    (dev->ifindex == if_index)) {
+		dev = pci_get_drvdata(pdev);
+		if (dev != NULL) {
+			dev = pci_get_drvdata(pdev);
+			if ((dev != NULL) && (dev->ifindex == if_index)) {
 				if ((pdev->vendor == SILICOM_VID) &&
 				    (pdev->device >= SILICOM_BP_PID_MIN) &&
 				    (pdev->device <= SILICOM_BP_PID_MAX)) {
@@ -183,6 +181,7 @@ static int is_bypass_dev(int if_index)
 #endif
 				return -1;
 			}
+		}
 	}
  send_cmd:
 	ret = do_cmd(dev, &ifr, IS_BYPASS, &data);
@@ -526,13 +525,13 @@ static int get_bypass_info(int if_index, struct bp_info *bp_info)
 }
 EXPORT_SYMBOL(get_bypass_info);
 
-int init_lib_module(void)
+int __init init_lib_module(void)
 {
 	printk(VERSION);
 	return 0;
 }
 
-void cleanup_lib_module(void)
+void __exit cleanup_lib_module(void)
 {
 }
 
-- 
1.8.1.2

