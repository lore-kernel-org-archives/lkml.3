Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3J3Q1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:27:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab3J3Q13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:27:29 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-edac@vger.kernel.org
Cc: tony.luck@intel.com, Aristeu Rozanski <arozansk@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com> (maintainer:EDAC-SBRIDGE),
        Doug Thompson <dougthompson@xmission.com> (supporter:EDAC-CORE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 02/12] sb_edac: make RANK_CFG_A value part of sbridge_info
Date: Wed, 30 Oct 2013 12:26:56 -0400
Message-Id: <1383150426-24730-3-git-send-email-arozansk@redhat.com>
In-Reply-To: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation of Ivy Bridge support.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
---
 drivers/edac/sb_edac.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 4cdd948..466c313 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -245,7 +245,7 @@ static const u32 correrrthrsld[] = {
 
 /* Device 17, function 0 */
 
-#define RANK_CFG_A		0x0328
+#define SB_RANK_CFG_A		0x0328
 
 #define IS_RDIMM_ENABLED(reg)		GET_BITFIELD(reg, 11, 11)
 
@@ -258,6 +258,7 @@ static const u32 correrrthrsld[] = {
 
 struct sbridge_info {
 	u32	mcmtr;
+	u32	rankcfgr;
 };
 
 struct sbridge_channel {
@@ -503,6 +504,8 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 	enum edac_type mode;
 	enum mem_type mtype;
 
+	pvt->info.rankcfgr = SB_RANK_CFG_A;
+
 	pci_read_config_dword(pvt->pci_br, SAD_TARGET, &reg);
 	pvt->sbridge_dev->source_id = SOURCE_ID(reg);
 
@@ -541,7 +544,8 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 	}
 
 	if (pvt->pci_ddrio) {
-		pci_read_config_dword(pvt->pci_ddrio, RANK_CFG_A, &reg);
+		pci_read_config_dword(pvt->pci_ddrio, pvt->info.rankcfgr,
+				      &reg);
 		if (IS_RDIMM_ENABLED(reg)) {
 			/* FIXME: Can also be LRDIMM */
 			edac_dbg(0, "Memory is registered\n");
-- 
1.7.1

