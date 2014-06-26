Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbaFZNkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:40:23 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:45406 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaFZNkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:40:21 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] pinctrl: pinctrl-at91.c:  Cleaning up values that are never used
Date: Thu, 26 Jun 2014 15:41:31 +0200
Message-Id: <1403790091-11423-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove variable that are never used

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/pinctrl/pinctrl-at91.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 421493c..9854a29 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -793,9 +793,9 @@ static void at91_pinconf_dbg_show(struct pinctrl_dev *pctldev,
 				   struct seq_file *s, unsigned pin_id)
 {
 	unsigned long config;
-	int ret, val, num_conf = 0;
+	int val, num_conf = 0;
 
-	ret = at91_pinconf_get(pctldev, pin_id, &config);
+	at91_pinconf_get(pctldev, pin_id, &config);
 
 	DBG_SHOW_FLAG(MULTI_DRIVE);
 	DBG_SHOW_FLAG(PULL_UP);
-- 
1.7.10.4

