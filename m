Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaCRAnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:43:47 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:53882 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaCRAna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:43:30 -0400
Message-Id: <20140318004213.812935479@telegraphics.com.au>
User-Agent: quilt/0.50-1
Date: Tue, 18 Mar 2014 11:42:16 +1100
From: Finn Thain <fthain@telegraphics.com.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>
Cc: Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-m68k@vger.kernel.org>
Subject: [PATCH 04/12] scsi/NCR5380: use NCR5380_dprint() instead of NCR5380_print()
References: <20140318004212.612472697@telegraphics.com.au>
Content-Disposition: inline; filename=ncr5380-debug-macros-sun3-NCR5380_print
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only the NCR5380_dprint() macro should invoke the NCR5380_print() function.
That's why NCR5380.c only defines the function #if NDEBUG. Use the standard
macro.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/sun3_scsi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-m68k/drivers/scsi/sun3_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.c	2014-03-18 00:18:32.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.c	2014-03-18 00:18:33.000000000 +1100
@@ -79,8 +79,6 @@
 #include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
 
-static void NCR5380_print(struct Scsi_Host *instance);
-
 /* #define OLDDMA */
 
 #define USE_WRAPPER
@@ -463,7 +461,7 @@ static unsigned long sun3scsi_dma_setup(
 		printk("scsi%d: fifo_mismatch %04x not %04x\n",
 		       default_instance->host_no, dregs->fifo_count,
 		       (unsigned int) count);
-		NCR5380_print(default_instance);
+		NCR5380_dprint(NDEBUG_DMA, default_instance);
 	}
 
 	/* setup udc */

