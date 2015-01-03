Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbbACQc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 11:32:57 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:58272 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbbACQc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 11:32:56 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: aic7xxx_core:  Remove some unused functions
Date: Sat,  3 Jan 2015 17:35:57 +0100
Message-Id: <1420302957-12653-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
ahc_outq() ahc_inq()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c   |   26 --------------------------
 drivers/scsi/aic7xxx/aic7xxx_inline.h |    4 ----
 2 files changed, 30 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 10172a3..6f91465 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -494,32 +494,6 @@ ahc_outl(struct ahc_softc *ahc, u_int port, uint32_t value)
 	ahc_outb(ahc, port+3, ((value) >> 24) & 0xFF);
 }
 
-uint64_t
-ahc_inq(struct ahc_softc *ahc, u_int port)
-{
-	return ((ahc_inb(ahc, port))
-	      | (ahc_inb(ahc, port+1) << 8)
-	      | (ahc_inb(ahc, port+2) << 16)
-	      | (ahc_inb(ahc, port+3) << 24)
-	      | (((uint64_t)ahc_inb(ahc, port+4)) << 32)
-	      | (((uint64_t)ahc_inb(ahc, port+5)) << 40)
-	      | (((uint64_t)ahc_inb(ahc, port+6)) << 48)
-	      | (((uint64_t)ahc_inb(ahc, port+7)) << 56));
-}
-
-void
-ahc_outq(struct ahc_softc *ahc, u_int port, uint64_t value)
-{
-	ahc_outb(ahc, port, value & 0xFF);
-	ahc_outb(ahc, port+1, (value >> 8) & 0xFF);
-	ahc_outb(ahc, port+2, (value >> 16) & 0xFF);
-	ahc_outb(ahc, port+3, (value >> 24) & 0xFF);
-	ahc_outb(ahc, port+4, (value >> 32) & 0xFF);
-	ahc_outb(ahc, port+5, (value >> 40) & 0xFF);
-	ahc_outb(ahc, port+6, (value >> 48) & 0xFF);
-	ahc_outb(ahc, port+7, (value >> 56) & 0xFF);
-}
-
 /*
  * Get a free scb. If there are none, see if we can allocate a new SCB.
  */
diff --git a/drivers/scsi/aic7xxx/aic7xxx_inline.h b/drivers/scsi/aic7xxx/aic7xxx_inline.h
index 0b57b78..cef8d98 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_inline.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_inline.h
@@ -77,10 +77,6 @@ uint32_t
 	ahc_inl(struct ahc_softc *ahc, u_int port);
 void	ahc_outl(struct ahc_softc *ahc, u_int port,
 		 uint32_t value);
-uint64_t
-	ahc_inq(struct ahc_softc *ahc, u_int port);
-void	ahc_outq(struct ahc_softc *ahc, u_int port,
-		 uint64_t value);
 struct scb*
 	ahc_get_scb(struct ahc_softc *ahc);
 void	ahc_free_scb(struct ahc_softc *ahc, struct scb *scb);
-- 
1.7.10.4

