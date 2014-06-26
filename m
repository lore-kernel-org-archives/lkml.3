Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbaFZLaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:30:11 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:40270 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280AbaFZLaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:30:08 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] pinctrl: pinctrl-msm.c:  Cleaning up if unsigned is less than zero
Date: Thu, 26 Jun 2014 13:31:19 +0200
Message-Id: <1403782279-10116-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove checking if a unsigned is less than zero

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/pinctrl/pinctrl-msm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index df6dda4c..cde8b2b 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -176,7 +176,7 @@ static void msm_pinmux_disable(struct pinctrl_dev *pctldev,
 
 	g = &pctrl->soc->groups[group];
 
-	if (WARN_ON(g->mux_bit < 0))
+	if (WARN_ON(g->mux_bit != 0))
 		return;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
-- 
1.7.10.4

