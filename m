Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbaFZNlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:41:53 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:45617 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaFZNlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:41:51 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] pinctrl: pinctrl-single.c:  Cleaning up values that are never used
Date: Thu, 26 Jun 2014 15:43:01 +0200
Message-Id: <1403790181-11506-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove variable that are never used

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/pinctrl/pinctrl-single.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 2960557..36fd7aa 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1739,11 +1739,10 @@ static void pcs_irq_chain_handler(unsigned int irq, struct irq_desc *desc)
 {
 	struct pcs_soc_data *pcs_soc = irq_desc_get_handler_data(desc);
 	struct irq_chip *chip;
-	int res;
 
 	chip = irq_get_chip(irq);
 	chained_irq_enter(chip, desc);
-	res = pcs_irq_handle(pcs_soc);
+	pcs_irq_handle(pcs_soc);
 	/* REVISIT: export and add handle_bad_irq(irq, desc)? */
 	chained_irq_exit(chip, desc);
 
-- 
1.7.10.4

