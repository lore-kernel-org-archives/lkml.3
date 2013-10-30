Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab3J3Q33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:29:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab3J3Q1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:27:30 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-edac@vger.kernel.org
Cc: tony.luck@intel.com, Aristeu Rozanski <arozansk@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com> (maintainer:EDAC-SBRIDGE),
        Doug Thompson <dougthompson@xmission.com> (supporter:EDAC-CORE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 04/12] sb_edac: rename pci_br
Date: Wed, 30 Oct 2013 12:26:58 -0400
Message-Id: <1383150426-24730-5-git-send-email-arozansk@redhat.com>
In-Reply-To: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivy Bridge has more than one, so rename pci_br to pci_br0

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
---
 drivers/edac/sb_edac.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 3e4837f..eb6c9d4 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -292,7 +292,7 @@ struct sbridge_dev {
 struct sbridge_pvt {
 	struct pci_dev		*pci_ta, *pci_ddrio, *pci_ras;
 	struct pci_dev		*pci_sad0, *pci_sad1, *pci_ha0;
-	struct pci_dev		*pci_br;
+	struct pci_dev		*pci_br0;
 	struct pci_dev		*pci_tad[NUM_CHANNELS];
 
 	struct sbridge_dev	*sbridge_dev;
@@ -517,10 +517,10 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 
 	pvt->info.rankcfgr = SB_RANK_CFG_A;
 
-	pci_read_config_dword(pvt->pci_br, SAD_TARGET, &reg);
+	pci_read_config_dword(pvt->pci_br0, SAD_TARGET, &reg);
 	pvt->sbridge_dev->source_id = SOURCE_ID(reg);
 
-	pci_read_config_dword(pvt->pci_br, SAD_CONTROL, &reg);
+	pci_read_config_dword(pvt->pci_br0, SAD_CONTROL, &reg);
 	pvt->sbridge_dev->node_id = NODE_ID(reg);
 	edac_dbg(0, "mc#%d: Node ID: %d, source ID: %d\n",
 		 pvt->sbridge_dev->mc,
@@ -1250,7 +1250,7 @@ static int mci_bind_devs(struct mem_ctl_info *mci,
 		case 13:
 			switch (func) {
 			case 6:
-				pvt->pci_br = pdev;
+				pvt->pci_br0 = pdev;
 				break;
 			default:
 				goto error;
-- 
1.7.1

