Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaI2JD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:03:57 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36251 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaI2JDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:03:54 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/6] ALSA: ctxfi: initialized snd_card
Date: Mon, 29 Sep 2014 14:33:24 +0530
Message-Id: <1411981406-10611-4-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1411981406-10611-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1411981406-10611-1-git-send-email-sudipm.mukherjee@gmail.com>
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
index 4671cbe7..4d389c3 100644
--- a/sound/pci/ctxfi/ctamixer.c
+++ b/sound/pci/ctxfi/ctamixer.c
@@ -314,6 +314,7 @@ int amixer_mgr_create(struct hw *hw, struct amixer_mgr **ramixer_mgr)
 
 	amixer_mgr->get_amixer = get_amixer_rsc;
 	amixer_mgr->put_amixer = put_amixer_rsc;
+	amixer_mgr->card = hw->card;
 
 	*ramixer_mgr = amixer_mgr;
 
@@ -467,6 +468,7 @@ int sum_mgr_create(struct hw *hw, struct sum_mgr **rsum_mgr)
 
 	sum_mgr->get_sum = get_sum_rsc;
 	sum_mgr->put_sum = put_sum_rsc;
+	sum_mgr->card = hw->card;
 
 	*rsum_mgr = sum_mgr;
 
diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index e536ab9..5cc8c38 100644
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
index 3d47fd8..9486ae2 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -725,6 +725,7 @@ int daio_mgr_create(struct hw *hw, struct daio_mgr **rdaio_mgr)
 	daio_mgr->imap_add = daio_imap_add;
 	daio_mgr->imap_delete = daio_imap_delete;
 	daio_mgr->commit_write = daio_mgr_commit_write;
+	daio_mgr->card = hw->card;
 
 	for (i = 0; i < 8; i++) {
 		hw->daio_mgr_dsb_dao(daio_mgr->mgr.ctrl_blk, i);
diff --git a/sound/pci/ctxfi/ctsrc.c b/sound/pci/ctxfi/ctsrc.c
index d3ef213..50fa35b 100644
--- a/sound/pci/ctxfi/ctsrc.c
+++ b/sound/pci/ctxfi/ctsrc.c
@@ -566,6 +566,7 @@ int src_mgr_create(struct hw *hw, struct src_mgr **rsrc_mgr)
 	src_mgr->src_enable = src_enable;
 	src_mgr->src_disable = src_disable;
 	src_mgr->commit_write = src_mgr_commit_write;
+	src_mgr->card = hw->card;
 
 	/* Disable all SRC resources. */
 	for (i = 0; i < 256; i++)
@@ -857,6 +858,7 @@ int srcimp_mgr_create(struct hw *hw, struct srcimp_mgr **rsrcimp_mgr)
 	srcimp_mgr->put_srcimp = put_srcimp_rsc;
 	srcimp_mgr->imap_add = srcimp_imap_add;
 	srcimp_mgr->imap_delete = srcimp_imap_delete;
+	srcimp_mgr->card = hw->card;
 
 	*rsrcimp_mgr = srcimp_mgr;
 
-- 
1.8.1.2

