Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaGGTHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:07:09 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:58147 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaGGTHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:07:08 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH v2] pinctrl: pinctrl-msm.c:  Cleaning up variable that is never used
Date: Mon,  7 Jul 2014 21:08:22 +0200
Message-Id: <1404760102-24471-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/pinctrl/pinctrl-msm.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index df6dda4c..821c562 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -176,9 +176,6 @@ static void msm_pinmux_disable(struct pinctrl_dev *pctldev,
 
 	g = &pctrl->soc->groups[group];
 
-	if (WARN_ON(g->mux_bit < 0))
-		return;
-
 	spin_lock_irqsave(&pctrl->lock, flags);
 
 	/* Clear the mux bits to select gpio mode */
-- 
1.7.10.4

