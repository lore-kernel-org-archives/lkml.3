Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbaE2Pfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:35:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59765 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757606AbaE2Pfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:35:31 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] extcon: arizona: Remove duplicate set of input parent device
Date: Thu, 29 May 2014 16:27:51 +0100
Message-Id: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_input_allocate_device already sets the parent device to be that
passed to it, we also set this manually in arizona_extcon_probe. This
patch removes the redundant set from arizona_extcon_probe.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index cf90743..21ee055 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1186,7 +1186,6 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 
 	info->input->name = "Headset";
 	info->input->phys = "arizona/extcon";
-	info->input->dev.parent = &pdev->dev;
 
 	if (pdata->num_micd_configs) {
 		info->micd_modes = pdata->micd_configs;
-- 
1.7.2.5

