Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab3IRPl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:41:26 -0400
Received: from 14.mo4.mail-out.ovh.net ([46.105.40.29]:43829 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751848Ab3IRPlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:41:24 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH 1/2] pwm: atmel-tcb: add missing clk source config
Date: Wed, 18 Sep 2013 17:06:05 +0200
Message-Id: <1379516765-23342-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379516720-23289-1-git-send-email-b.brezillon@overkiz.com>
References: <1379516720-23289-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 13933855774228183174
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

Clock source changes are never applied to the CMR register.
This may lead to wrong period/duty cycle configuration.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/pwm/pwm-atmel-tcb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index ba6ce01..0266969 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -249,6 +249,8 @@ static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 		}
 	}
 
+	cmr |= (tcbpwm->div & ATMEL_TC_TCCLKS);
+
 	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));
 
 	if (index == 0)
-- 
1.7.9.5

