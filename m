Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaKDIuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:50:11 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35376 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaKDIuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:50:03 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-ac-54589337cae0
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/6] regulator: max77686: Initialize opmode explicitly to
 normal mode
Date: Tue, 04 Nov 2014 09:49:42 +0100
Message-id: <1415090986-30623-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
References: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4NV3zyREhBhcPylpsnLGe1WLqwyds
	Fkd/F1i8fmFocbbpDbvF/a9HGS2+Xelgsri8aw6bxdojd9ktTnezOnB5/H1+ncVj56y77B6b
	VnWyedy5tofNY97JQI++LasYPT5vkgtgj+KySUnNySxLLdK3S+DKWHLyN3NBH0fF/nbLBsYf
	bF2MnBwSAiYSP5q+sULYYhIX7q0HinNxCAksZZRoOr+BBcLpY5L48L0BrIpNwFhi8/IlYFUi
	ApsYJSb1XwFLMAs0M0mcfp8DYgsLhEssap7JDGKzCKhKXLh4mRHE5hVwl/iw5QQ7xDo5iZPH
	JgP1cnBwCnhI3O8GKxcCKmlav4hlAiPvAkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxgh
	4fd1B+PSY1aHGAU4GJV4eFfER4QIsSaWFVfmHmKU4GBWEuFdXQUU4k1JrKxKLcqPLyrNSS0+
	xMjEwSnVwGi5+r5feWCldcuro5F/imojpRdvbWtJ+i6w1vOZ5r5sJQ/F1zypZUx2DlNr+Vcf
	NWPm8d99/ehi8ef2vkXOQmwm50JXRp6tcLsr6OafO/cy77STgaw3thZumb08eMuJ7U+YjfgV
	X91/5GfUm50uUsg6xyzkfJfWul98XGe0W6wF9+q0Cb3Zq8RSnJFoqMVcVJwIAEGCQOEdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor nit: Initialize the opmode for each regulator to normal mode in a
readable explicit way.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77686.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 27c5f4556044..28f4eab82a09 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -519,8 +519,7 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 		config.init_data = pdata->regulators[i].initdata;
 		config.of_node = pdata->regulators[i].of_node;
 
-		max77686->opmode[id] = regulators[i].enable_mask >>
-						max77686_get_opmode_shift(id);
+		max77686->opmode[id] = MAX77686_NORMAL;
 		rdev = devm_regulator_register(&pdev->dev,
 						&regulators[i], &config);
 		if (IS_ERR(rdev)) {
-- 
1.9.1

