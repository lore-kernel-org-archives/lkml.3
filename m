Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbbABU14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:27:56 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:46917 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbbABU1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:27:55 -0500
X-Greylist: delayed 98661 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2015 15:27:55 EST
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: aic7770:  Remove unused function
Date: Fri,  2 Jan 2015 21:30:56 +0100
Message-Id: <1420230656-2240-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function aic7770_find_device() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/aic7xxx/aic7770.c |   14 --------------
 drivers/scsi/aic7xxx/aic7xxx.h |    1 -
 2 files changed, 15 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7770.c b/drivers/scsi/aic7xxx/aic7770.c
index 5000bd6..cbe10755 100644
--- a/drivers/scsi/aic7xxx/aic7770.c
+++ b/drivers/scsi/aic7xxx/aic7770.c
@@ -107,20 +107,6 @@ struct aic7770_identity aic7770_ident_table[] =
 };
 const int ahc_num_aic7770_devs = ARRAY_SIZE(aic7770_ident_table);
 
-struct aic7770_identity *
-aic7770_find_device(uint32_t id)
-{
-	struct	aic7770_identity *entry;
-	int	i;
-
-	for (i = 0; i < ahc_num_aic7770_devs; i++) {
-		entry = &aic7770_ident_table[i];
-		if (entry->full_id == (id & entry->id_mask))
-			return (entry);
-	}
-	return (NULL);
-}
-
 int
 aic7770_config(struct ahc_softc *ahc, struct aic7770_identity *entry, u_int io)
 {
diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index f695774..ead8924 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -1144,7 +1144,6 @@ void			 ahc_pci_resume(struct ahc_softc *ahc);
 #endif
 
 /*************************** EISA/VL Front End ********************************/
-struct aic7770_identity *aic7770_find_device(uint32_t);
 int			 aic7770_config(struct ahc_softc *ahc,
 					struct aic7770_identity *,
 					u_int port);
-- 
1.7.10.4

