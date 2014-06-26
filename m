Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbaFZQ5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:57:42 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33599 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbaFZQ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:57:41 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] pinctrl: pinctrl-single.c:  Cleaning up wrong format string usage
Date: Thu, 26 Jun 2014 18:58:46 +0200
Message-Id: <1403801926-22996-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

%d in format string used, but the type is unsigned int

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/pinctrl/pinctrl-single.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 2960557..a0a8bdf 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -836,7 +836,7 @@ static int pcs_add_pin(struct pcs_device *pcs, unsigned offset,
 
 	pin = &pcs->pins.pa[i];
 	pn = &pcs->names[i];
-	sprintf(pn->name, "%lx.%d",
+	sprintf(pn->name, "%lx.%u",
 		(unsigned long)pcs->res->start + offset, pin_pos);
 	pin->name = pn->name;
 	pin->number = i;
-- 
1.7.10.4

