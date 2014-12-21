Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaLUU33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 15:29:29 -0500
Received: from sauhun.de ([89.238.76.85]:52836 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbaLUU31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 15:29:27 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH] usb: host: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 21:28:24 +0100
Message-Id: <1419193753-8664-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These platform_drivers do not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---

Those were missed by the original coccinelle script because of the strange
include-mechanism. I now detected all included files with something like:

awk '/#include.*\.c/ { print $2 }' *.c

and let this cocci script run over those files:

@@
identifier __driver;
@@
	static struct platform_driver __driver = {
		.driver = {
-			.owner = THIS_MODULE,
		}
	};


 drivers/usb/host/ehci-fsl.c       | 1 -
 drivers/usb/host/ehci-grlib.c     | 1 -
 drivers/usb/host/ehci-pmcmsp.c    | 1 -
 drivers/usb/host/ehci-ppc-of.c    | 1 -
 drivers/usb/host/ehci-sead3.c     | 1 -
 drivers/usb/host/ehci-sh.c        | 1 -
 drivers/usb/host/ehci-tilegx.c    | 1 -
 drivers/usb/host/ehci-xilinx-of.c | 1 -
 drivers/usb/host/ohci-da8xx.c     | 1 -
 drivers/usb/host/ohci-jz4740.c    | 1 -
 drivers/usb/host/ohci-ppc-of.c    | 1 -
 drivers/usb/host/ohci-sm501.c     | 1 -
 drivers/usb/host/ohci-tilegx.c    | 1 -
 drivers/usb/host/ohci-tmio.c      | 1 -
 drivers/usb/host/uhci-grlib.c     | 1 -
 drivers/usb/host/uhci-platform.c  | 1 -
 16 files changed, 16 deletions(-)

diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index fb7bd0c7dc15..ab4eee3df97a 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -709,7 +709,6 @@ static struct platform_driver ehci_fsl_driver = {
 	.shutdown = usb_hcd_platform_shutdown,
 	.driver = {
 		.name = "fsl-ehci",
-		.owner	= THIS_MODULE,
 		.pm = EHCI_FSL_PM_OPS,
 	},
 };
diff --git a/drivers/usb/host/ehci-grlib.c b/drivers/usb/host/ehci-grlib.c
index 495b6fbcbcd9..21650044b09e 100644
--- a/drivers/usb/host/ehci-grlib.c
+++ b/drivers/usb/host/ehci-grlib.c
@@ -187,7 +187,6 @@ static struct platform_driver ehci_grlib_driver = {
 	.shutdown	= usb_hcd_platform_shutdown,
 	.driver = {
 		.name = "grlib-ehci",
-		.owner = THIS_MODULE,
 		.of_match_table = ehci_hcd_grlib_of_match,
 	},
 };
diff --git a/drivers/usb/host/ehci-pmcmsp.c b/drivers/usb/host/ehci-pmcmsp.c
index 7d75465d97c7..342816a7f8b1 100644
--- a/drivers/usb/host/ehci-pmcmsp.c
+++ b/drivers/usb/host/ehci-pmcmsp.c
@@ -325,6 +325,5 @@ static struct platform_driver ehci_hcd_msp_driver = {
 	.remove		= ehci_hcd_msp_drv_remove,
 	.driver		= {
 		.name	= "pmcmsp-ehci",
-		.owner	= THIS_MODULE,
 	},
 };
diff --git a/drivers/usb/host/ehci-ppc-of.c b/drivers/usb/host/ehci-ppc-of.c
index 547924796d29..1a10c8d542ca 100644
--- a/drivers/usb/host/ehci-ppc-of.c
+++ b/drivers/usb/host/ehci-ppc-of.c
@@ -234,7 +234,6 @@ static struct platform_driver ehci_hcd_ppc_of_driver = {
 	.shutdown	= usb_hcd_platform_shutdown,
 	.driver = {
 		.name = "ppc-of-ehci",
-		.owner = THIS_MODULE,
 		.of_match_table = ehci_hcd_ppc_of_match,
 	},
 };
diff --git a/drivers/usb/host/ehci-sead3.c b/drivers/usb/host/ehci-sead3.c
index 9b6e8d0eac43..3d86cc2ffe68 100644
--- a/drivers/usb/host/ehci-sead3.c
+++ b/drivers/usb/host/ehci-sead3.c
@@ -178,7 +178,6 @@ static struct platform_driver ehci_hcd_sead3_driver = {
 	.shutdown	= usb_hcd_platform_shutdown,
 	.driver = {
 		.name	= "sead3-ehci",
-		.owner	= THIS_MODULE,
 		.pm	= SEAD3_EHCI_PMOPS,
 	}
 };
diff --git a/drivers/usb/host/ehci-sh.c b/drivers/usb/host/ehci-sh.c
index 0e0ce684aff3..5caf88d679e4 100644
--- a/drivers/usb/host/ehci-sh.c
+++ b/drivers/usb/host/ehci-sh.c
@@ -189,7 +189,6 @@ static struct platform_driver ehci_hcd_sh_driver = {
 	.shutdown	= ehci_hcd_sh_shutdown,
 	.driver		= {
 		.name	= "sh_ehci",
-		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/usb/host/ehci-tilegx.c b/drivers/usb/host/ehci-tilegx.c
index 0d247673c3ca..bdb93b6a356f 100644
--- a/drivers/usb/host/ehci-tilegx.c
+++ b/drivers/usb/host/ehci-tilegx.c
@@ -210,7 +210,6 @@ static struct platform_driver ehci_hcd_tilegx_driver = {
 	.shutdown	= ehci_hcd_tilegx_drv_shutdown,
 	.driver = {
 		.name	= "tilegx-ehci",
-		.owner	= THIS_MODULE,
 	}
 };
 
diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
index a2328361dc80..f54480850bb8 100644
--- a/drivers/usb/host/ehci-xilinx-of.c
+++ b/drivers/usb/host/ehci-xilinx-of.c
@@ -236,7 +236,6 @@ static struct platform_driver ehci_hcd_xilinx_of_driver = {
 	.shutdown	= usb_hcd_platform_shutdown,
 	.driver = {
 		.name = "xilinx-of-ehci",
-		.owner = THIS_MODULE,
 		.of_match_table = ehci_hcd_xilinx_of_match,
 	},
 };
diff --git a/drivers/usb/host/ohci-da8xx.c b/drivers/usb/host/ohci-da8xx.c
index 1c76999b2184..e5c33bc98ea4 100644
--- a/drivers/usb/host/ohci-da8xx.c
+++ b/drivers/usb/host/ohci-da8xx.c
@@ -431,7 +431,6 @@ static struct platform_driver ohci_hcd_da8xx_driver = {
 	.resume		= ohci_da8xx_resume,
 #endif
 	.driver		= {
-		.owner	= THIS_MODULE,
 		.name	= "ohci",
 	},
 };
diff --git a/drivers/usb/host/ohci-jz4740.c b/drivers/usb/host/ohci-jz4740.c
index 8ddd8f5470cb..4db78f169256 100644
--- a/drivers/usb/host/ohci-jz4740.c
+++ b/drivers/usb/host/ohci-jz4740.c
@@ -239,7 +239,6 @@ static struct platform_driver ohci_hcd_jz4740_driver = {
 	.remove = jz4740_ohci_remove,
 	.driver = {
 		.name = "jz4740-ohci",
-		.owner = THIS_MODULE,
 	},
 };
 
diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
index 965e3e9e688a..4f87a5c61b08 100644
--- a/drivers/usb/host/ohci-ppc-of.c
+++ b/drivers/usb/host/ohci-ppc-of.c
@@ -229,7 +229,6 @@ static struct platform_driver ohci_hcd_ppc_of_driver = {
 	.shutdown	= usb_hcd_platform_shutdown,
 	.driver = {
 		.name = "ppc-of-ohci",
-		.owner = THIS_MODULE,
 		.of_match_table = ohci_hcd_ppc_of_match,
 	},
 };
diff --git a/drivers/usb/host/ohci-sm501.c b/drivers/usb/host/ohci-sm501.c
index 4e81c804c73e..a8b8d8b8d9f3 100644
--- a/drivers/usb/host/ohci-sm501.c
+++ b/drivers/usb/host/ohci-sm501.c
@@ -265,7 +265,6 @@ static struct platform_driver ohci_hcd_sm501_driver = {
 	.suspend	= ohci_sm501_suspend,
 	.resume		= ohci_sm501_resume,
 	.driver		= {
-		.owner	= THIS_MODULE,
 		.name	= "sm501-usb",
 	},
 };
diff --git a/drivers/usb/host/ohci-tilegx.c b/drivers/usb/host/ohci-tilegx.c
index bef6dfb0405a..e1b208da460a 100644
--- a/drivers/usb/host/ohci-tilegx.c
+++ b/drivers/usb/host/ohci-tilegx.c
@@ -199,7 +199,6 @@ static struct platform_driver ohci_hcd_tilegx_driver = {
 	.shutdown	= ohci_hcd_tilegx_drv_shutdown,
 	.driver = {
 		.name	= "tilegx-ohci",
-		.owner	= THIS_MODULE,
 	}
 };
 
diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
index bb409588d39c..e9a6eec39142 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -368,6 +368,5 @@ static struct platform_driver ohci_hcd_tmio_driver = {
 	.resume		= ohci_hcd_tmio_drv_resume,
 	.driver		= {
 		.name	= "tmio-ohci",
-		.owner	= THIS_MODULE,
 	},
 };
diff --git a/drivers/usb/host/uhci-grlib.c b/drivers/usb/host/uhci-grlib.c
index 05f57ffdf9ab..0342991c9507 100644
--- a/drivers/usb/host/uhci-grlib.c
+++ b/drivers/usb/host/uhci-grlib.c
@@ -188,7 +188,6 @@ static struct platform_driver uhci_grlib_driver = {
 	.shutdown	= uhci_hcd_grlib_shutdown,
 	.driver = {
 		.name = "grlib-uhci",
-		.owner = THIS_MODULE,
 		.of_match_table = uhci_hcd_grlib_of_match,
 	},
 };
diff --git a/drivers/usb/host/uhci-platform.c b/drivers/usb/host/uhci-platform.c
index cf8f46003f62..3a3e3eeba291 100644
--- a/drivers/usb/host/uhci-platform.c
+++ b/drivers/usb/host/uhci-platform.c
@@ -147,7 +147,6 @@ static struct platform_driver uhci_platform_driver = {
 	.shutdown	= uhci_hcd_platform_shutdown,
 	.driver = {
 		.name = "platform-uhci",
-		.owner = THIS_MODULE,
 		.of_match_table = platform_uhci_ids,
 	},
 };
-- 
2.1.3

