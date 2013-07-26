Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab3GZWgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:36:10 -0400
Received: from leviathan.tchmachines.com ([208.76.85.180]:56641 "EHLO
	leviathan.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3GZWgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:36:06 -0400
X-Greylist: delayed 4267 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jul 2013 18:36:06 EDT
From: Eli Billauer <eli.billauer@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH] staging: xillybus: Multiple definition of xillyname resolved (bug fix)
Date: Sat, 27 Jul 2013 00:24:00 +0300
Message-Id: <1374873840-26015-1-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - leviathan.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - billauer.co.il
X-Get-Message-Sender-Via: leviathan.tchmachines.com: authenticated_id: billaue/sender_address_domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 drivers/staging/xillybus/xillybus.h      |    2 --
 drivers/staging/xillybus/xillybus_core.c |    2 ++
 drivers/staging/xillybus/xillybus_of.c   |    2 ++
 drivers/staging/xillybus/xillybus_pcie.c |    2 ++
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/xillybus/xillybus.h b/drivers/staging/xillybus/xillybus.h
index c260ebc..b62faeb 100644
--- a/drivers/staging/xillybus/xillybus.h
+++ b/drivers/staging/xillybus/xillybus.h
@@ -24,8 +24,6 @@
 #include <linux/list.h>
 #include <linux/workqueue.h>
 
-char xillyname[] = "xillybus";
-
 struct xilly_endpoint_hardware;
 
 struct xilly_page {
diff --git a/drivers/staging/xillybus/xillybus_core.c b/drivers/staging/xillybus/xillybus_core.c
index dd0a71c..7991e57 100644
--- a/drivers/staging/xillybus/xillybus_core.c
+++ b/drivers/staging/xillybus/xillybus_core.c
@@ -61,6 +61,8 @@ MODULE_LICENSE("GPL v2");
 #define XILLYMSG_OPCODE_FATAL_ERROR 4
 #define XILLYMSG_OPCODE_NONEMPTY 5
 
+static const char xillyname[] = "xillybus";
+
 static struct class *xillybus_class;
 
 /*
diff --git a/drivers/staging/xillybus/xillybus_of.c b/drivers/staging/xillybus/xillybus_of.c
index b875376..122d9ba 100644
--- a/drivers/staging/xillybus/xillybus_of.c
+++ b/drivers/staging/xillybus/xillybus_of.c
@@ -27,6 +27,8 @@ MODULE_VERSION("1.06");
 MODULE_ALIAS("xillybus_of");
 MODULE_LICENSE("GPL v2");
 
+static const char xillyname[] = "xillybus_of";
+
 /* Match table for of_platform binding */
 static struct of_device_id xillybus_of_match[] = {
 	{ .compatible = "xlnx,xillybus-1.00.a", },
diff --git a/drivers/staging/xillybus/xillybus_pcie.c b/drivers/staging/xillybus/xillybus_pcie.c
index 592f8f7..ad45bdb 100644
--- a/drivers/staging/xillybus/xillybus_pcie.c
+++ b/drivers/staging/xillybus/xillybus_pcie.c
@@ -28,6 +28,8 @@ MODULE_LICENSE("GPL v2");
 #define PCI_VENDOR_ID_ACTEL		0x11aa
 #define PCI_VENDOR_ID_LATTICE		0x1204
 
+static const char xillyname[] = "xillybus_pcie";
+
 static DEFINE_PCI_DEVICE_TABLE(xillyids) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_XILINX, PCI_DEVICE_ID_XILLYBUS)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ALTERA, PCI_DEVICE_ID_XILLYBUS)},
-- 
1.7.2.3

