Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaKYTla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:41:30 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:17061 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaKYTl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:41:28 -0500
X-IronPort-AV: E=Sophos;i="5.07,457,1413270000"; 
   d="scan'208";a="51807622"
From: Scott Branden <sbranden@broadcom.com>
To: Scott Branden <sbranden@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Ray Jui <rjui@broadcom.com>, Arun Ramamurthy <arunrama@broadcom.com>,
        Tim Kryger <tim.kryger@gmail.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/4] pwm: kona: Fix incorrect enable after channel polarity change
Date: Tue, 25 Nov 2014 11:40:39 -0800
Message-ID: <1416944441-12066-3-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416944441-12066-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1416944441-12066-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arun Ramamurthy <arunrama@broadcom.com>

The pwm core code requires a separate call for enabling the channel
and hence the driver does not need to set pwm_trigger after a
polarity change

Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
Reviewed-by: Ray Jui <rjui@broadcom.com>
Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/pwm/pwm-bcm-kona.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
index 29eef9e..fa0b5bf 100644
--- a/drivers/pwm/pwm-bcm-kona.c
+++ b/drivers/pwm/pwm-bcm-kona.c
@@ -173,11 +173,6 @@ static int kona_pwmc_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	writel(value, kp->base + PWM_CONTROL_OFFSET);
 
-	kona_pwmc_apply_settings(kp, chan);
-
-	/* Wait for waveform to settle before gating off the clock */
-	ndelay(400);
-
 	clk_disable_unprepare(kp->clk);
 
 	return 0;
-- 
2.1.3

