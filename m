Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab3CNKrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:47:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11116 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828Ab3CNKrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:47:42 -0400
X-AuditID: cbfee68e-b7f946d000001e37-9d-5141aacd4b3c
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        dianders@chromium.org
Subject: [PATCH 2/2] usb: dwc3: exynos: use clk_prepare_enable and
 clk_disable_unprepare
Date: Thu, 14 Mar 2013 16:14:58 +0530
Message-id: <1363257898-17504-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1363257898-17504-1-git-send-email-gautam.vivek@samsung.com>
References: <1363257898-17504-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWyRsSkTvfsKsdAgw3HtSwO3q+3ODD7IavF
	2WUH2SyaF69ns+hdcJXN4vKuOWwWs5f0s1jMOL+PyWLRslZmi8MrDjBZHJuxhNGB22PB5yvs
	HrMbLrJ43Lm2h81j/9w17B7nZyxk9OjbsorR4/iN7UwenzfJBXBEcdmkpOZklqUW6dslcGWc
	3jCZreAPZ8XZLwfYGhi3cHQxcnJICJhILPm0mAnCFpO4cG89G4gtJLCUUWLjVzeYmkcbDzBB
	xKczStyep9HFyAVkT2GS2LfyGiNIgk1AV6Lp7S4wW0QgXeL/3X4wm1ngDKPEyxexILawQJTE
	9z2HwQaxCKhKnJlzHszmFfCQuL+4ix1imYLEm9vPmLsYOTg4BTwlLm/PhdjrIXFq/SZGkL0S
	AufYJZ78OMwOMUdA4tvkQywg9RICshKbDjBDjJGUOLjiBssERuEFjAyrGEVTC5ILipPSi4z0
	ihNzi0vz0vWS83M3MQLj5PS/Z307GG8esD7EmAw0biKzlGhyPjDO8kriDY3NjCxMTUyNjcwt
	zUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAGJKX3nb6f8GTPp2F867+fXX9
	r/TKpk2sT01ns1ifm8V/cNqkh8fZJlzdEN53/oBeer7Gs1n/Et2UTq+TlmM4U2YVe6/v1eXp
	1suWPppzpHB+lundK6E3t+td15yYF3I/bnWbQ4l1Bq+zztLvMtvCvv09rtEX989L0cbky2fD
	gjcab9wz2rpeZymxFGckGmoxFxUnAgDmW+dnqQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQd2zqxwDDf7OUbQ4eL/e4sDsh6wW
	Z5cdZLNoXryezaJ3wVU2i8u75rBZzF7Sz2Ix4/w+JotFy1qZLQ6vOMBkcWzGEkYHbo8Fn6+w
	e8xuuMjicefaHjaP/XPXsHucn7GQ0aNvyypGj+M3tjN5fN4kF8AR1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0qZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsIYx4/SGyWwFfzgrzn45wNbAuIWji5GTQ0LAROLRxgNMELaY
	xIV769lAbCGB6YwSt+dpdDFyAdlTmCT2rbzGCJJgE9CVaHq7C8wWEUiX+H+3H8xmFjjDKPHy
	RSyILSwQJfF9z2GwoSwCqhJn5pwHs3kFPCTuL+5ih1imIPHm9jPmLkYODk4BT4nL23Mh9npI
	nFq/iXECI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFx+ExqB+PKBotDjAIcjEo8
	vAf6HQKFWBPLiitzDzFKcDArifB6ejkGCvGmJFZWpRblxxeV5qQWH2JMBjpqIrOUaHI+MEXk
	lcQbGpuYmxqbWppYmJhZkiasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAPjmYf/+t4ueye4
	nTuD78Qf/fAwpsVHH+yQevpq33vVjV3MS7V3xSst+iIT/dswhb3prLb0tMqva2Y2H41b8TZH
	0NVn8l/RL6Yy/97bTtXR/VHBkF9WnTWp5lhMpU+WdKvLu83nBKYEnj7qvr8iSXDChGVLnOIM
	vF/tK95yeEsr97a3tot2rhGYp8RSnJFoqMVcVJwIAHYZLRMHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
calls as required by common clock framework.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
CC: Felipe Balbi <balbi@ti.com>
CC: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/usb/dwc3/dwc3-exynos.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 66ca9ac..b03f609 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -129,7 +129,7 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 	exynos->dev	= dev;
 	exynos->clk	= clk;
 
-	clk_enable(exynos->clk);
+	clk_prepare_enable(exynos->clk);
 
 	if (node) {
 		ret = of_platform_populate(node, NULL, NULL, dev);
@@ -146,7 +146,7 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 	return 0;
 
 err2:
-	clk_disable(clk);
+	clk_disable_unprepare(clk);
 err1:
 	return ret;
 }
@@ -158,7 +158,7 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 	platform_device_unregister(exynos->usb2_phy);
 	platform_device_unregister(exynos->usb3_phy);
 
-	clk_disable(exynos->clk);
+	clk_disable_unprepare(exynos->clk);
 
 	return 0;
 }
-- 
1.7.6.5

