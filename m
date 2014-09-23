Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaIWLBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:01:06 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45923 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbaIWLBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:01:03 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/5] ALSA: ctxfi: initialized snd_card
Date: Tue, 23 Sep 2014 16:30:21 +0530
Message-Id: <1411470024-25244-2-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1411470024-25244-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1411470024-25244-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initialized the reference of snd_card which was added to the various
structures through the previous patch of the series.
these references of snd_card will be used in a later patch to convert
the pr_* macros to dev_*

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ctxfi/ctamixer.c | 2 ++
 sound/pci/ctxfi/ctatc.c    | 1 +
 sound/pci/ctxfi/ctdaio.c   | 1 +
 sound/pci/ctxfi/ctsrc.c    | 2 ++
 4 files changed, 6 insertions(+)

diff --git a/sound/pci/ctxfi/ctamixer.c b/sound/pci/ctxfi/ctamixer.c
index fed6e6a..dc89fad 100644
--- a/sound/pci/ctxfi/ctamixer.c
+++ b/sound/pci/ctxfi/ctamixer.c
@@ -314,6 +314,7 @@ int amixer_mgr_create(void *hw, struct amixer_mgr **ramixer_mgr)
 
 	amixer_mgr->get_amixer = get_amixer_rsc;
 	amixer_mgr->put_amixer = put_amixer_rsc;
+	amixer_mgr->card = ((struct hw *)hw)->card;
 
 	*ramixer_mgr = amixer_mgr;
 
@@ -467,6 +468,7 @@ int sum_mgr_create(void *hw, struct sum_mgr **rsum_mgr)
 
 	sum_mgr->get_sum = get_sum_rsc;
 	sum_mgr->put_sum = put_sum_rsc;
+	sum_mgr->card = ((struct hw *)hw)->card;
 
 	*rsum_mgr = sum_mgr;
 
diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index d92a08c..b21eda4 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -1333,6 +1333,7 @@ static int atc_create_hw_devs(struct ct_atc *atc)
 		pr_err("Failed to create hw obj!!!\n");
 		return err;
 	}
+	hw->card = atc->card;
 	atc->hw = hw;
 
 	/* Initialize card hardware. */
diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index 6f0654e..990dd8a 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -727,6 +727,7 @@ int daio_mgr_create(void *hw, struct daio_mgr **rdaio_mgr)
 	daio_mgr->imap_add = daio_imap_add;
 	daio_mgr->imap_delete = daio_imap_delete;
 	daio_mgr->commit_write = daio_mgr_commit_write;
+	daio_mgr->card = ((struct hw *)hw)->card;
 
 	for (i = 0; i < 8; i++) {
 		((struct hw *)hw)->daio_mgr_dsb_dao(daio_mgr->mgr.ctrl_blk, i);
diff --git a/sound/pci/ctxfi/ctsrc.c b/sound/pci/ctxfi/ctsrc.c
index 19df9b4..029aff2 100644
--- a/sound/pci/ctxfi/ctsrc.c
+++ b/sound/pci/ctxfi/ctsrc.c
@@ -566,6 +566,7 @@ int src_mgr_create(void *hw, struct src_mgr **rsrc_mgr)
 	src_mgr->src_enable = src_enable;
 	src_mgr->src_disable = src_disable;
 	src_mgr->commit_write = src_mgr_commit_write;
+	src_mgr->card = ((struct hw *)hw)->card;
 
 	/* Disable all SRC resources. */
 	for (i = 0; i < 256; i++)
@@ -857,6 +858,7 @@ int srcimp_mgr_create(void *hw, struct srcimp_mgr **rsrcimp_mgr)
 	srcimp_mgr->put_srcimp = put_srcimp_rsc;
 	srcimp_mgr->imap_add = srcimp_imap_add;
 	srcimp_mgr->imap_delete = srcimp_imap_delete;
+	srcimp_mgr->card = ((struct hw *)hw)->card;
 
 	*rsrcimp_mgr = srcimp_mgr;
 
-- 
1.8.1.2

