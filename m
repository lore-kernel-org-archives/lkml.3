Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaCYPSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 11:18:48 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:43271 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaCYPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 11:18:46 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2014 11:18:46 EDT
From: Christoph Jaeger <christophjaeger@linux.com>
To: JBottomley@parallels.com, agurumur@brocade.com, vmohan@brocade.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] scsi: bfa: Use ARRAY_SIZE
Date: Tue, 25 Mar 2014 16:11:12 +0100
Message-Id: <1395760272-5846-2-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395760272-5846-1-git-send-email-christophjaeger@linux.com>
References: <1395760272-5846-1-git-send-email-christophjaeger@linux.com>
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ARRAY_SIZE to calculate the size of an array.

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 drivers/scsi/bfa/bfa_core.c |  2 +-
 drivers/scsi/bfa/bfa_fcs.c  | 10 ++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 520540a..4cc8763 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -1941,7 +1941,7 @@ bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids)
 		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT_FC},
 	};
 
-	*npciids = sizeof(__pciids) / sizeof(__pciids[0]);
+	*npciids = ARRAY_SIZE(__pciids);
 	*pciids = __pciids;
 }
 
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index a3ab5cc..6a00008 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -81,7 +81,7 @@ bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
 	bfa->fcs = BFA_TRUE;
 	fcbuild_init();
 
-	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
 		mod = &fcs_modules[i];
 		if (mod->attach)
 			mod->attach(fcs);
@@ -97,7 +97,7 @@ bfa_fcs_init(struct bfa_fcs_s *fcs)
 	int	i;
 	struct bfa_fcs_mod_s  *mod;
 
-	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
 		mod = &fcs_modules[i];
 		if (mod->modinit)
 			mod->modinit(fcs);
@@ -180,13 +180,11 @@ void
 bfa_fcs_exit(struct bfa_fcs_s *fcs)
 {
 	struct bfa_fcs_mod_s  *mod;
-	int		nmods, i;
+	int i;
 
 	bfa_wc_init(&fcs->wc, bfa_fcs_exit_comp, fcs);
 
-	nmods = sizeof(fcs_modules) / sizeof(fcs_modules[0]);
-
-	for (i = 0; i < nmods; i++) {
+	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
 
 		mod = &fcs_modules[i];
 		if (mod->modexit) {
-- 
1.8.3.1

