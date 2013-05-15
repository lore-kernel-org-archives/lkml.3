Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab3EOMED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:04:03 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:58042 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab3EOMEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:04:01 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 01/10] usb: musb: enable ux500 host side dma support
Date: Wed, 15 May 2013 14:03:24 +0200
Message-Id: <1368619413-24647-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
References: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>

Host side dma support for ux500 is enabled by piggybacking on Inventra
dma support.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/musb/musb_host.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 8914dec..1a6b5a9 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -625,7 +625,7 @@ static bool musb_tx_dma_program(struct dma_controller *dma,
 	u16			csr;
 	u8			mode;
 
-#ifdef	CONFIG_USB_INVENTRA_DMA
+#if defined(CONFIG_USB_INVENTRA_DMA) || defined(CONFIG_USB_UX500_DMA)
 	if (length > channel->max_len)
 		length = channel->max_len;
 
@@ -1659,7 +1659,7 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 
 	/* FIXME this is _way_ too much in-line logic for Mentor DMA */
 
-#ifndef CONFIG_USB_INVENTRA_DMA
+#if !defined(CONFIG_USB_INVENTRA_DMA) && !defined(CONFIG_USB_UX500_DMA)
 	if (rx_csr & MUSB_RXCSR_H_REQPKT)  {
 		/* REVISIT this happened for a while on some short reads...
 		 * the cleanup still needs investigation... looks bad...
@@ -1691,7 +1691,7 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 			| MUSB_RXCSR_RXPKTRDY);
 		musb_writew(hw_ep->regs, MUSB_RXCSR, val);
 
-#ifdef CONFIG_USB_INVENTRA_DMA
+#if defined(CONFIG_USB_INVENTRA_DMA) || defined(CONFIG_USB_UX500_DMA)
 		if (usb_pipeisoc(pipe)) {
 			struct usb_iso_packet_descriptor *d;
 
@@ -1747,7 +1747,7 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 		}
 
 		/* we are expecting IN packets */
-#ifdef CONFIG_USB_INVENTRA_DMA
+#if defined(CONFIG_USB_INVENTRA_DMA) || defined(CONFIG_USB_UX500_DMA)
 		if (dma) {
 			struct dma_controller	*c;
 			u16			rx_count;
-- 
1.8.2

