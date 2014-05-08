Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaEHSjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:39:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36088 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbaEHSjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:39:46 -0400
From: Borislav Petkov <bp@alien8.de>
To: linux-edac <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] EDAC, MCE, AMD: Remove leftover unused mask
Date: Thu,  8 May 2014 20:39:38 +0200
Message-Id: <1399574378-7593-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

295d8cda2689 ("EDAC, MCE, AMD: Drop local coreid reporting") removed the
code snippet which used that mask but forgot to drop the mask itself. Do
that now.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/edac/mce_amd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 51b9caa0b024..5f43620d580a 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -6,7 +6,6 @@
 static struct amd_decoder_ops *fam_ops;
 
 static u8 xec_mask	 = 0xf;
-static u8 nb_err_cpumask = 0xf;
 
 static bool report_gart_errors;
 static void (*nb_bus_decoder)(int node_id, struct mce *m);
@@ -852,7 +851,6 @@ static int __init mce_amd_init(void)
 		break;
 
 	case 0x14:
-		nb_err_cpumask  = 0x3;
 		fam_ops->mc0_mce = cat_mc0_mce;
 		fam_ops->mc1_mce = cat_mc1_mce;
 		fam_ops->mc2_mce = k8_mc2_mce;
-- 
1.9.0

