Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3CTIoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:44:23 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:59599 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299Ab3CTIoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:44:20 -0400
Message-ID: <1363769057.1390.75.camel@x61.thuisdomein>
Subject: [PATCH] usb: gadget: net2272: finally convert
 "CONFIG_USB_GADGET_NET2272_DMA"
From: Paul Bolle <pebolle@tiscali.nl>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 09:44:17 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2013 08:44:17.0597 (UTC) FILETIME=[1B94DED0:01CE2547]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol USB_GADGET_NET2272_DMA was renamed to USB_NET2272_DMA
in commit 193ab2a6070039e7ee2b9b9bebea754a7c52fd1b ("usb: gadget: allow
multiple gadgets to be built"). That commit did not convert the only
occurrence of the corresponding Kconfig macro. Convert that macro now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested. I'll explain - at some length - why this patch needs testing.

1) The driver for the PLX NET2272 USB device controller and support for
its external DMA controller were added in v3.1-rc1, see commit
ceb80363b2ec1091dffd78064771e3d4679f69c7 ("USB: net2272: driver for PLX
NET2272 USB device controller").

2) Shortly after that driver and the support for its external DMA
controller (DMA support) were added, commit
193ab2a6070039e7ee2b9b9bebea754a7c52fd1b renamed the Kconfig symbol that
enables DMA support partially. It's this trivial oversight that this
patch fixes. That commit was also shipped in v3.1-rc1.

3) A consequence of all that is that it was (basically) never possible
to enable DMA support. Setting USB_NET2272_DMA had no effect. This also
makes me wonder whether DMA support is actually needed. But that is not
my call.

4) For those people still with me here, there's another reason why DMA
support couldn't be enabled from v3.1 up to v3.4. See, before commit
ed6c6f419f02a6da444e26374f3510ac57b6faf4 ("usb: gadget: conversion of
controllers choice to menu") both config USB_NET2272 and config
USB_NET2272_DMA were part of the same Kconfig choice. That means that
only one of these two could ever be selected. And selecting only
USB_NET2272_DMA, which depends on USB_NET2272, would therefore be
logically impossible. But I must admit that I couldn't be bothered to
run "make menuconfig" on the v3.4 tree to test my theory.

 drivers/usb/gadget/net2272.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/net2272.c b/drivers/usb/gadget/net2272.c
index d226058..437759a 100644
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@ -59,7 +59,7 @@ static const char * const ep_name[] = {
 };
 
 #define DMA_ADDR_INVALID	(~(dma_addr_t)0)
-#ifdef CONFIG_USB_GADGET_NET2272_DMA
+#ifdef CONFIG_USB_NET2272_DMA
 /*
  * use_dma: the NET2272 can use an external DMA controller.
  * Note that since there is no generic DMA api, some functions,
-- 
1.7.11.7

