Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbaKSWbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:31:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878AbaKSUx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.17 036/141] mfd: max77693: Use proper regmap for handling MUIC interrupts
Date: Wed, 19 Nov 2014 12:50:59 -0800
Message-Id: <20141119205151.846234078@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 43fc9396cac3f7498e07a22e6a987b911462fa58 upstream.

Interrupts coming from Maxim77693 MUIC block (MicroUSB Interface
Controller) were not handled at all because wrong regmap was used for
MUIC's regmap_irq_chip.

The MUIC component of Maxim 77693 uses different I2C address thus second
regmap is created and used by max77693 extcon driver. The registers for
MUIC interrupts are also in that block and should be handled by that
second regmap.

However the regmap irq chip for MUIC was configured with default regmap
which could not read MUIC registers.

Fixes: 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/max77693.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -237,7 +237,7 @@ static int max77693_i2c_probe(struct i2c
 		goto err_irq_charger;
 	}
 
-	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
+	ret = regmap_add_irq_chip(max77693->regmap_muic, max77693->irq,
 				IRQF_ONESHOT | IRQF_SHARED |
 				IRQF_TRIGGER_FALLING, 0,
 				&max77693_muic_irq_chip,


