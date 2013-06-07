Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3FGQ0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:26:48 -0400
Received: from 15.mo1.mail-out.ovh.net ([188.165.38.232]:36778 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756597Ab3FGQ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:26:46 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC PATCH 30/50] pwm: atmel-tcb: prepare clk before calling enable
Date: Fri,  7 Jun 2013 18:26:42 +0200
Message-Id: <1370622402-19693-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 671880771389716508
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
avoid common clk framework warnings.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/pwm/pwm-atmel-tcb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index 0a7b658..09be626 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -76,7 +76,7 @@ static int atmel_tcb_pwm_request(struct pwm_chip *chip,
 	if (!tcbpwm)
 		return -ENOMEM;
 
-	ret = clk_enable(tc->clk[group]);
+	ret = clk_prepare_enable(tc->clk[group]);
 	if (ret) {
 		devm_kfree(chip->dev, tcbpwm);
 		return ret;
@@ -124,7 +124,7 @@ static void atmel_tcb_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct atmel_tcb_pwm_device *tcbpwm = pwm_get_chip_data(pwm);
 	struct atmel_tc *tc = tcbpwmc->tc;
 
-	clk_disable(tc->clk[pwm->hwpwm / 2]);
+	clk_disable_unprepare(tc->clk[pwm->hwpwm / 2]);
 	tcbpwmc->pwms[pwm->hwpwm] = NULL;
 	devm_kfree(chip->dev, tcbpwm);
 }
-- 
1.7.9.5

