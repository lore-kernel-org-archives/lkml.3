Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaIHRN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:13:56 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54142 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaIHRNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:13:54 -0400
From: Nitin Kuppelur <nitinkuppelur@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nitin Kuppelur <nitinkuppelur@gmail.com>
Subject: [PATCH] Staging: octeon-hcd: removed unwanted return from void functions
Date: Mon,  8 Sep 2014 19:13:15 +0200
Message-Id: <1410196395-4595-1-git-send-email-nitinkuppelur@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the octeon-hcd.c file that fixes checkpatch.pl warning by removing return statement from void functions.

Signed-off-by: Nitin Kuppelur <nitinkuppelur@gmail.com>
---
 drivers/staging/octeon-usb/octeon-hcd.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index 3a5feb4..8a80982 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -1332,8 +1332,6 @@ static void __cvmx_usb_poll_rx_fifo(struct cvmx_usb_state *usb)
 		bytes -= 4;
 	}
 	CVMX_SYNCW;
-
-	return;
 }
 
 
@@ -1437,8 +1435,6 @@ static void __cvmx_usb_poll_tx_fifo(struct cvmx_usb_state *usb)
 					union cvmx_usbcx_gintmsk,
 					nptxfempmsk, 0);
 	}
-
-	return;
 }
 
 
@@ -1490,8 +1486,6 @@ static void __cvmx_usb_fill_tx_fifo(struct cvmx_usb_state *usb, int channel)
 		fifo->head = 0;
 
 	__cvmx_usb_poll_tx_fifo(usb);
-
-	return;
 }
 
 /**
@@ -1640,7 +1634,6 @@ static void __cvmx_usb_start_channel_control(struct cvmx_usb_state *usb,
 
 	__cvmx_usb_write_csr32(usb, CVMX_USBCX_HCTSIZX(channel, usb->index),
 			       usbc_hctsiz.u32);
-	return;
 }
 
 
@@ -1987,7 +1980,6 @@ static void __cvmx_usb_start_channel(struct cvmx_usb_state *usb,
 			union cvmx_usbcx_hccharx, chena, 1);
 	if (usb->init_flags & CVMX_USB_INITIALIZE_FLAGS_NO_DMA)
 		__cvmx_usb_fill_tx_fifo(usb, channel);
-	return;
 }
 
 
@@ -2116,7 +2108,6 @@ done:
 	}
 	USB_SET_FIELD32(CVMX_USBCX_GINTMSK(usb->index),
 			union cvmx_usbcx_gintmsk, sofmsk, need_sof);
-	return;
 }
 
 static inline struct octeon_hcd *cvmx_usb_to_octeon(struct cvmx_usb_state *p)
-- 
1.9.1

