Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaKJUxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:53:44 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47019 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaKJUxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:53:42 -0500
From: Roman Byshko <rbyshko@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: musb: replace hard coded registers with defines
Date: Mon, 10 Nov 2014 21:53:32 +0100
Message-Id: <1415652812-30387-1-git-send-email-rbyshko@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141110194013.GA1041@saruman>
References: <20141110194013.GA1041@saruman>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

musb registers can be dumped using the file regdump
which is created in debugfs. Up to now  hard coded
register addresses are used for that. Different glue
layers however have different register addresses. The
patch addresses this issue by substituting bare register
addresses with defines.

Signed-off-by: Roman Byshko <rbyshko@gmail.com>
---
 drivers/usb/musb/musb_debugfs.c | 57 ++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/usb/musb/musb_debugfs.c b/drivers/usb/musb/musb_debugfs.c
index 4c21679..ad3701a 100644
--- a/drivers/usb/musb/musb_debugfs.c
+++ b/drivers/usb/musb/musb_debugfs.c
@@ -49,33 +49,36 @@ struct musb_register_map {
 };
 
 static const struct musb_register_map musb_regmap[] = {
-	{ "FAddr",		0x00,	8 },
-	{ "Power",		0x01,	8 },
-	{ "Frame",		0x0c,	16 },
-	{ "Index",		0x0e,	8 },
-	{ "Testmode",		0x0f,	8 },
-	{ "TxMaxPp",		0x10,	16 },
-	{ "TxCSRp",		0x12,	16 },
-	{ "RxMaxPp",		0x14,	16 },
-	{ "RxCSR",		0x16,	16 },
-	{ "RxCount",		0x18,	16 },
-	{ "ConfigData",		0x1f,	8 },
-	{ "DevCtl",		0x60,	8 },
-	{ "MISC",		0x61,	8 },
-	{ "TxFIFOsz",		0x62,	8 },
-	{ "RxFIFOsz",		0x63,	8 },
-	{ "TxFIFOadd",		0x64,	16 },
-	{ "RxFIFOadd",		0x66,	16 },
-	{ "VControl",		0x68,	32 },
-	{ "HWVers",		0x6C,	16 },
-	{ "EPInfo",		0x78,	8 },
-	{ "RAMInfo",		0x79,	8 },
-	{ "LinkInfo",		0x7A,	8 },
-	{ "VPLen",		0x7B,	8 },
-	{ "HS_EOF1",		0x7C,	8 },
-	{ "FS_EOF1",		0x7D,	8 },
-	{ "LS_EOF1",		0x7E,	8 },
-	{ "SOFT_RST",		0x7F,	8 },
+	{ "FAddr",	MUSB_FADDR,	8 },
+	{ "Power",	MUSB_POWER,	8 },
+	{ "Frame",	MUSB_FRAME,	16 },
+	{ "Index",	MUSB_INDEX,	8 },
+	{ "Testmode",	MUSB_TESTMODE,	8 },
+	{ "TxMaxPp",	MUSB_TXMAXP,	16 },
+	{ "TxCSRp",	MUSB_TXCSR,	16 },
+	{ "RxMaxPp",	MUSB_RXMAXP,	16 },
+	{ "RxCSR",	MUSB_RXCSR,	16 },
+	{ "RxCount",	MUSB_RXCOUNT,	16 },
+	{ "ConfigData",	MUSB_CONFIGDATA,8 },
+	{ "IntrRxE",	MUSB_INTRRXE,	16 },
+	{ "IntrTxE",	MUSB_INTRTXE,	16 },
+	{ "IntrUsbE",	MUSB_INTRUSBE,	8 },
+	{ "DevCtl",	MUSB_DEVCTL,	8 },
+	{ "BabbleCtl",	MUSB_BABBLE_CTL,8 },
+	{ "TxFIFOsz",	MUSB_TXFIFOSZ,	8 },
+	{ "RxFIFOsz",	MUSB_RXFIFOSZ,	8 },
+	{ "TxFIFOadd",	MUSB_TXFIFOADD,	16 },
+	{ "RxFIFOadd",	MUSB_RXFIFOADD,	16 },
+	{ "VControl",	0x68,		32 },
+	{ "HWVers",	0x69,		16 },
+	{ "EPInfo",	MUSB_EPINFO,	8 },
+	{ "RAMInfo",	MUSB_RAMINFO,	8 },
+	{ "LinkInfo",	MUSB_LINKINFO,	8 },
+	{ "VPLen",	MUSB_VPLEN,	8 },
+	{ "HS_EOF1",	MUSB_HS_EOF1,	8 },
+	{ "FS_EOF1",	MUSB_FS_EOF1,	8 },
+	{ "LS_EOF1",	MUSB_LS_EOF1,	8 },
+	{ "SOFT_RST",	0x7F,		8 },
 	{ "DMA_CNTLch0",	0x204,	16 },
 	{ "DMA_ADDRch0",	0x208,	32 },
 	{ "DMA_COUNTch0",	0x20C,	32 },
-- 
2.1.2

