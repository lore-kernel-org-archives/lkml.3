Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab3IRPbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:31:25 -0400
Received: from 4.mo4.mail-out.ovh.net ([178.32.98.131]:50622 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752037Ab3IRPbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:31:24 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH 2/2] pwm: atmel-tcb: fix max time computation for slow clk source
Date: Wed, 18 Sep 2013 17:06:21 +0200
Message-Id: <1379516781-23379-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379516720-23289-1-git-send-email-b.brezillon@overkiz.com>
References: <1379516720-23289-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 13938359371760892038
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the the tcb counter width to compute the maximum time that can be
represented using the slow clock source instead of the static 16 bit width.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/pwm/pwm-atmel-tcb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index 0266969..f3dcd02 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -307,7 +307,7 @@ static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		i = slowclk;
 		rate = 32768;
 		min = div_u64(NSEC_PER_SEC, rate);
-		max = min << 16;
+		max = min << tc->tcb_config->counter_width;
 
 		/* If period is too big return ERANGE error */
 		if (max < period_ns)
-- 
1.7.9.5

