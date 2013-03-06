Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3CFK4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:56:52 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27519 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab3CFK4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:56:47 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-e1-513720edf595
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, kgene.kim@samsung.com, t.figa@samsung.com,
        patches@linaro.org
Subject: [PATCH v2 2/3] gpio: samsung: skip gpiolib registration if pinctrl
 support is enabled for exynos5250
Date: Wed, 06 Mar 2013 16:48:31 +0530
Message-id: <1362568712-13586-3-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1362568712-13586-1-git-send-email-thomas.abraham@linaro.org>
References: <1362568712-13586-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e+xoO47BfNAg13bWC16F1xls5jyZzmT
	xabH11gtLu+aw2Yx4/w+Josph7+wWKyf8ZrFgd3jzrU9bB6bl9R79G1ZxejxeZNcAEsUl01K
	ak5mWWqRvl0CV8avEyUFK9grNp5YzNzAOJ+ti5GTQ0LARGLftP1QtpjEhXvrwWwhgemMEusv
	2nQxcgHZbUwSU7csYwFJsAkYSDxa+I4dxBYRUJDY3PuMFaSIWWAFo8SJrq9gCWGBfImrM5eC
	TWIRUJW4+Hc2WJxXwFNiQ8NuRohtShIbeo8ydTFycHAKeEl8vG4EsdhT4uH8p4wTGHkXMDKs
	YhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAgOo2fSOxhXNVgcYhTgYFTi4Z2gYhYoxJpYVlyZ
	e4hRgoNZSYR3q7R5oBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFexlNPAoQE0hNLUrNTUwtSi2Cy
	TBycUg2MEXsNOWM93j205upkmpJg0z3xyrqcMwXWR+/uljgVIF/0lKn+S5qJEcsOzW1bnxl/
	3qES+8zYhenE8qN+XHeTSpPOKOfx6Ky9Y+X4bWqUEu+9ULWEp2/T/7HP0Fj7Oznxh4L1L/2K
	1s2POA0eBZ6+Z/FATS7tpOeV95Ehgj7T9e8cuXHjWPNLJZbijERDLeai4kQACYYd/R8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip exynos5250 gpiolib registration if pinctrl support for exynos5250
is enabled.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-samsung.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index b3643ff..49b4292 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -3024,6 +3024,7 @@ static __init int samsung_gpiolib_init(void)
 	static const struct of_device_id exynos_pinctrl_ids[] = {
 		{ .compatible = "samsung,exynos4210-pinctrl", },
 		{ .compatible = "samsung,exynos4x12-pinctrl", },
+		{ .compatible = "samsung,exynos5250-pinctrl", },
 		{ .compatible = "samsung,exynos5440-pinctrl", },
 	};
 	for_each_matching_node(pctrl_np, exynos_pinctrl_ids)
-- 
1.6.6.rc2

