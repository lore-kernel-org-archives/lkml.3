Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaKYTlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:41:12 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:28865 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaKYTlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:41:09 -0500
X-IronPort-AV: E=Sophos;i="5.07,457,1413270000"; 
   d="scan'208";a="51465153"
From: Scott Branden <sbranden@broadcom.com>
To: Scott Branden <sbranden@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Ray Jui <rjui@broadcom.com>, Arun Ramamurthy <arunrama@broadcom.com>,
        Tim Kryger <tim.kryger@gmail.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/4] pwm: kona: Remove setting default smooth type and polarity for all channels
Date: Tue, 25 Nov 2014 11:40:38 -0800
Message-ID: <1416944441-12066-2-git-send-email-sbranden@broadcom.com>
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

The probe routine unnecessarily sets the smooth type and polarity for
all channels. This causes the channel for the speaker to click at the same
time the backlight turns on. The smooth type and polarity should be set individually
for each channel as required and no defaults need to be set.

Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
Reviewed-by: Ray Jui <rjui@broadcom.com>
Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/pwm/pwm-bcm-kona.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
index 02bc048..29eef9e 100644
--- a/drivers/pwm/pwm-bcm-kona.c
+++ b/drivers/pwm/pwm-bcm-kona.c
@@ -266,12 +266,9 @@ static int kona_pwmc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	/* Set smooth mode, push/pull, and normal polarity for all channels */
-	for (chan = 0; chan < kp->chip.npwm; chan++) {
-		value |= (1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
+	/* Set push/pull for all channels */
+	for (chan = 0; chan < kp->chip.npwm; chan++)
 		value |= (1 << PWM_CONTROL_TYPE_SHIFT(chan));
-		value |= (1 << PWM_CONTROL_POLARITY_SHIFT(chan));
-	}
 
 	writel(value, kp->base + PWM_CONTROL_OFFSET);
 
-- 
2.1.3

