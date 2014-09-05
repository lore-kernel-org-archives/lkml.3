Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbaIEKPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:15:22 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13217 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520AbaIEKPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:15:20 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-56-54098d35e0cb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND] mfd: max14577: Don't pass IRQ domain to mfd_add_devices
Date: Fri, 05 Sep 2014 12:15:10 +0200
Message-id: <1409912110-18120-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJMWRmVeSWpSXmKPExsVy+t/xK7qmvZwhBrNOq1m8fmFocf/rUUaL
	y7vmsFmc7mZ1YPG4c20Pm8e8k4EefVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlfGkv6TgGmvF
	+rd7GBsYr7B0MXJySAiYSBzsPs8EYYtJXLi3nq2LkYtDSGApo0Tv+6eMEE4fk8SyG32sIFVs
	AsYSm5cvYQOxRQSyJH5MWw02iVnAUOLnuz/sILawgKfE9x/7wKayCKhKPO/4A2RzcPAKuEsc
	/8QNsUxO4uSxyawTGLkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAjx+tcdjEuPWR1i
	FOBgVOLh7dDkDBFiTSwrrsw9xCjBwawkwvuvHijEm5JYWZValB9fVJqTWnyIkYmDU6qBMdb8
	zoV93Sfba+b9UVxkNVNwxfWCmudf48XuRLvw1Ii8/zSj9YXKh4qn3i8PBd+1Mwry/HHi70qe
	fFHZyhXmSvmLT9xd8KTLPpP1QFVqRVQ1U0zNf6t/v+e8e3Q2liv/172bEuu8Ats1tszw4H2q
	aOS9OCRnc/XmCuWplcwNP10yT5Uosd1TUWIpzkg01GIuKk4EAE6xCiHYAQAA
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
index 4a5e885383f8..ba2ac9c10b12 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -372,8 +372,7 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	}
 
 	ret = mfd_add_devices(max14577->dev, -1, mfd_devs,
-			mfd_devs_size, NULL, 0,
-			regmap_irq_get_domain(max14577->irq_data));
+			mfd_devs_size, NULL, 0, NULL);
 	if (ret < 0)
 		goto err_mfd;
 
-- 
1.9.1

