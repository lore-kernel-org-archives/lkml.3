Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaGKMeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:34:08 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40727 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaGKMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:34:05 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-4e-53bfd9baa17b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] mfd: max14577: Don't pass IRQ domain to mfd_add_devices
Date: Fri, 11 Jul 2014 14:33:59 +0200
Message-id: <1405082039-27333-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJMWRmVeSWpSXmKPExsVy+t/xy7q7bu4PNri2wdzi9QtDi/tfjzJa
	XN41h83idDerA4vHnWt72DzmnQz06NuyitHj8ya5AJYoLpuU1JzMstQifbsErow1vYYF11gr
	Dt26yNzAeIWli5GTQ0LARGLGx/+MELaYxIV769m6GLk4hASWMkpceP6MFcLpY5J4e/A1E0gV
	m4CxxOblS9hAbBGBLIkf01aDTWIWMJT4+e4PO4gtLOAh0TxjD1icRUBVYu/7X2AbeAXcJRas
	eMQOsU1O4uSxyawTGLkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAjx+9cdjEuPWR1i
	FOBgVOLhnZG8P1iINbGsuDL3EKMEB7OSCK/5WaAQb0piZVVqUX58UWlOavEhRiYOTqkGRssJ
	kQ5bNt31MTKe+mSf1WT3rIA3r84ELypsXfQ4aFGfd4+0/gtxXwdLjn8CGdef1PHszv41WWJK
	1+kNDz82v4p8IH2tVDXz2PP7EtNEIrbeWf1L+es5u42qm7a8uWl4TP/Bch7rRsGbSs/+nAvR
	N9FVm/R1pcNqIc65jhdnO0ozmrGZXCx+Mk2JpTgj0VCLuag4EQAS5WfN2QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max14577 MFD cells do not have any resources so the IRQ domain
passed to mfd_add_devices is not used.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max14577.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index b8af263be594..de96b7fb1f6d 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -456,8 +456,7 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	}
 
 	ret = mfd_add_devices(max14577->dev, -1, mfd_devs,
-			mfd_devs_size, NULL, 0,
-			regmap_irq_get_domain(max14577->irq_data));
+			mfd_devs_size, NULL, 0, NULL);
 	if (ret < 0)
 		goto err_mfd;
 
-- 
1.9.1

