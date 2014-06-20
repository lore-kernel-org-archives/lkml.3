Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966672AbaFTKRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:17:21 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:58691 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966408AbaFTKQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:16:30 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/5] spi: sh-msiof: Add more register documentation
Date: Fri, 20 Jun 2014 12:16:16 +0200
Message-Id: <1403259380-13634-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403259380-13634-1-git-send-email-geert+renesas@glider.be>
References: <1403259380-13634-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/spi/spi-sh-msiof.c | 54 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 83c43707f093..7e5b15b48c04 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -113,9 +113,61 @@ struct sh_msiof_spi_priv {
 #define CTR_TXE		0x00000200 /* Transmit Enable */
 #define CTR_RXE		0x00000100 /* Receive Enable */
 
-/* STR and IER */
+/* FCTR */
+#define FCTR_TFWM_MASK	0xe0000000 /* Transmit FIFO Watermark */
+#define FCTR_TFWM_64	0x00000000 /*  Transfer Request when 64 empty stages */
+#define FCTR_TFWM_32	0x20000000 /*  Transfer Request when 32 empty stages */
+#define FCTR_TFWM_24	0x40000000 /*  Transfer Request when 24 empty stages */
+#define FCTR_TFWM_16	0x60000000 /*  Transfer Request when 16 empty stages */
+#define FCTR_TFWM_12	0x80000000 /*  Transfer Request when 12 empty stages */
+#define FCTR_TFWM_8	0xa0000000 /*  Transfer Request when 8 empty stages */
+#define FCTR_TFWM_4	0xc0000000 /*  Transfer Request when 4 empty stages */
+#define FCTR_TFWM_1	0xe0000000 /*  Transfer Request when 1 empty stage */
+#define FCTR_TFUA_MASK	0x07f00000 /* Transmit FIFO Usable Area */
+#define FCTR_TFUA_SHIFT		20
+#define FCTR_TFUA(i)	((i) << FCTR_TFUA_SHIFT)
+#define FCTR_RFWM_MASK	0x0000e000 /* Receive FIFO Watermark */
+#define FCTR_RFWM_1	0x00000000 /*  Transfer Request when 1 valid stages */
+#define FCTR_RFWM_4	0x00002000 /*  Transfer Request when 4 valid stages */
+#define FCTR_RFWM_8	0x00004000 /*  Transfer Request when 8 valid stages */
+#define FCTR_RFWM_16	0x00006000 /*  Transfer Request when 16 valid stages */
+#define FCTR_RFWM_32	0x00008000 /*  Transfer Request when 32 valid stages */
+#define FCTR_RFWM_64	0x0000a000 /*  Transfer Request when 64 valid stages */
+#define FCTR_RFWM_128	0x0000c000 /*  Transfer Request when 128 valid stages */
+#define FCTR_RFWM_256	0x0000e000 /*  Transfer Request when 256 valid stages */
+#define FCTR_RFUA_MASK	0x00001ff0 /* Receive FIFO Usable Area (0x40 = full) */
+#define FCTR_RFUA_SHIFT		 4
+#define FCTR_RFUA(i)	((i) << FCTR_RFUA_SHIFT)
+
+/* STR */
+#define STR_TFEMP	0x20000000 /* Transmit FIFO Empty */
+#define STR_TDREQ	0x10000000 /* Transmit Data Transfer Request */
 #define STR_TEOF	0x00800000 /* Frame Transmission End */
+#define STR_TFSERR	0x00200000 /* Transmit Frame Synchronization Error */
+#define STR_TFOVF	0x00100000 /* Transmit FIFO Overflow */
+#define STR_TFUDF	0x00080000 /* Transmit FIFO Underflow */
+#define STR_RFFUL	0x00002000 /* Receive FIFO Full */
+#define STR_RDREQ	0x00001000 /* Receive Data Transfer Request */
 #define STR_REOF	0x00000080 /* Frame Reception End */
+#define STR_RFSERR	0x00000020 /* Receive Frame Synchronization Error */
+#define STR_RFUDF	0x00000010 /* Receive FIFO Underflow */
+#define STR_RFOVF	0x00000008 /* Receive FIFO Overflow */
+
+/* IER */
+#define IER_TDMAE	0x80000000 /* Transmit Data DMA Transfer Req. Enable */
+#define IER_TFEMPE	0x20000000 /* Transmit FIFO Empty Enable */
+#define IER_TDREQE	0x10000000 /* Transmit Data Transfer Request Enable */
+#define IER_TEOFE	0x00800000 /* Frame Transmission End Enable */
+#define IER_TFSERRE	0x00200000 /* Transmit Frame Sync Error Enable */
+#define IER_TFOVFE	0x00100000 /* Transmit FIFO Overflow Enable */
+#define IER_TFUDFE	0x00080000 /* Transmit FIFO Underflow Enable */
+#define IER_RDMAE	0x00008000 /* Receive Data DMA Transfer Req. Enable */
+#define IER_RFFULE	0x00002000 /* Receive FIFO Full Enable */
+#define IER_RDREQE	0x00001000 /* Receive Data Transfer Request Enable */
+#define IER_REOFE	0x00000080 /* Frame Reception End Enable */
+#define IER_RFSERRE	0x00000020 /* Receive Frame Sync Error Enable */
+#define IER_RFUDFE	0x00000010 /* Receive FIFO Underflow Enable */
+#define IER_RFOVFE	0x00000008 /* Receive FIFO Overflow Enable */
 
 
 static u32 sh_msiof_read(struct sh_msiof_spi_priv *p, int reg_offs)
-- 
1.9.1

