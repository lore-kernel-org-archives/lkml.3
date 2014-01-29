Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaA2VBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 16:01:46 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:61545 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbaA2VAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 16:00:18 -0500
From: Matt Porter <mporter@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        linux-pwm@vger.kernel.org,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH 4/5] pwm: enable TI PWMSS if the IIO tiecap driver is selected
Date: Wed, 29 Jan 2014 15:59:58 -0500
Message-Id: <1391029199-3670-5-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1391029199-3670-1-git-send-email-mporter@linaro.org>
References: <1391029199-3670-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IIO TI ECAP driver depends on the TI PWMSS management
driver in this subsystem. Enable PWMSS when the IIO TI ECAP
driver is selected.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
 drivers/pwm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 22f2f28..bd3cc65 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -219,7 +219,7 @@ config  PWM_TIEHRPWM
 
 config  PWM_TIPWMSS
 	bool
-	default y if SOC_AM33XX && (PWM_TIECAP || PWM_TIEHRPWM)
+	default y if SOC_AM33XX && (IIO_TIECAP || PWM_TIECAP || PWM_TIEHRPWM)
 	help
 	  PWM Subsystem driver support for AM33xx SOC.
 
-- 
1.8.4

