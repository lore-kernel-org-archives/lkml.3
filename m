Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbaFYMW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:22:29 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:36384 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbaFYMW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:22:27 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Matthew Wilcox <matthew@wil.cx>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: advansys.c:  Cleaning up variable is set more than once
Date: Wed, 25 Jun 2014 14:23:28 +0200
Message-Id: <1403699008-22658-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A struct member variable is set to the same value more than once

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/advansys.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index d814588..8281ae0 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -11592,7 +11592,6 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 			    adv_dvc_varp->cfg->disc_enable;
 			ep_38C0800->bios_ctrl = adv_dvc_varp->bios_ctrl;
 			ep_38C0800->wdtr_able = adv_dvc_varp->wdtr_able;
-			ep_38C0800->tagqng_able = adv_dvc_varp->tagqng_able;
 			ep_38C0800->sdtr_speed1 = adv_dvc_varp->sdtr_speed1;
 			ep_38C0800->sdtr_speed2 = adv_dvc_varp->sdtr_speed2;
 			ep_38C0800->sdtr_speed3 = adv_dvc_varp->sdtr_speed3;
@@ -11620,7 +11619,6 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 			    adv_dvc_varp->cfg->disc_enable;
 			ep_38C1600->bios_ctrl = adv_dvc_varp->bios_ctrl;
 			ep_38C1600->wdtr_able = adv_dvc_varp->wdtr_able;
-			ep_38C1600->tagqng_able = adv_dvc_varp->tagqng_able;
 			ep_38C1600->sdtr_speed1 = adv_dvc_varp->sdtr_speed1;
 			ep_38C1600->sdtr_speed2 = adv_dvc_varp->sdtr_speed2;
 			ep_38C1600->sdtr_speed3 = adv_dvc_varp->sdtr_speed3;
-- 
1.7.10.4

