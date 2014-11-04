Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaKDIuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:50:07 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51926 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaKDIuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:50:01 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-89-54589336934f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/6] regulator: max77686: Consistently index opmode array by
 rdev id
Date: Tue, 04 Nov 2014 09:49:41 +0100
Message-id: <1415090986-30623-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
References: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4NV2zyREhBpcfWFtsnLGe1WLqwyds
	Fkd/F1i8fmFocbbpDbvF/a9HGS2+Xelgsri8aw6bxdojd9ktTnezOnB5/H1+ncVj56y77B6b
	VnWyedy5tofNY97JQI++LasYPT5vkgtgj+KySUnNySxLLdK3S+DKuLl8N2vBda6Khwf2sDcw
	PuHoYuTkkBAwkbi68xQbhC0mceHeeiCbi0NIYCmjxKa3k1ggnD4miStv3jGDVLEJGEtsXr4E
	rEpEYBOjxKT+K6wgCWaBZiaJ0+9zQGxhgTCJh7s3gcVZBFQl5jy6zQJi8wq4S3ya84kRYp2c
	xMljk4FqODg4BTwk7neDzRcCKmlav4hlAiPvAkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5
	mxghAfhlB+PiY1aHGAU4GJV4eDPUI0KEWBPLiitzDzFKcDArifCurgIK8aYkVlalFuXHF5Xm
	pBYfYmTi4JRqYJzcX966uPpli/1TlR3Til1e628tmfR4BeMGvpAAU57Pl5KSpnp9ujrth7K6
	lf/L/I9Ged8Pre3431F5pt9hV/iHWxPvcz322svxtjB67t5AB869+zdMYeRp8hJ55MPWLfVq
	j4zB9DiX0MtHpP7+lo64e2xmzMmDZr9VenbqWsg8PPNsodSTyWJKLMUZiYZazEXFiQDosEso
	HgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mixed indexes were used for array of opmodes in max77686_data structure:
id of regulator and index of regulator_desc array.

These indexes are exactly the same but the mixture may confuse. Use
consistently the id of regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77686.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 09b0d8c20a9d..27c5f4556044 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -82,6 +82,7 @@ enum max77686_ramp_rate {
 };
 
 struct max77686_data {
+	/* Array indexed by regulator id */
 	unsigned int opmode[MAX77686_REGULATORS];
 };
 
@@ -513,12 +514,13 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < MAX77686_REGULATORS; i++) {
 		struct regulator_dev *rdev;
+		int id = regulators[i].id;
 
 		config.init_data = pdata->regulators[i].initdata;
 		config.of_node = pdata->regulators[i].of_node;
 
-		max77686->opmode[i] = regulators[i].enable_mask >>
-						max77686_get_opmode_shift(i);
+		max77686->opmode[id] = regulators[i].enable_mask >>
+						max77686_get_opmode_shift(id);
 		rdev = devm_regulator_register(&pdev->dev,
 						&regulators[i], &config);
 		if (IS_ERR(rdev)) {
-- 
1.9.1

