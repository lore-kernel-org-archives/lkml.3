Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbaCUMjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:39:35 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49559 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbaCUMjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:39:33 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-81-532c330243da
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] clk: s2mps11: Use of_get_child_by_name
Date: Fri, 21 Mar 2014 13:39:20 +0100
Message-id: <1395405560-11733-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395404297-12133-1-git-send-email-k.kozlowski@samsung.com>
References: <1395404297-12133-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t/xK7pMxjrBBmvXyllsnLGe1eL1C0OL
	s01v2C02Pb7GanF51xw2ixnn9zFZrD1yl93i6YSLbBbrZ7xmsWj/u5fNgcvjzrU9bB6bl9R7
	9G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8aRRStYC16yVTRNmMLewPiCtYuRk0NCwERiS9sW
	dghbTOLCvfVsILaQwFJGiStzQ7oYuYDsPiaJY+23wRJsAsYSm5cvYQNJiAhMZZTYuH4RE4jD
	LDCZSWLZsoOMIFXCAtYSV26dYwGxWQRUJaZ2PwLr5hVwl+ievRyohgNonYLEnEk2IGFOAQ+J
	5Zv+sUJsdpf4fmUX0wRG3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQsLs6w7Gpces
	DjEKcDAq8fBWcGoHC7EmlhVX5h5ilOBgVhLh3WmgEyzEm5JYWZValB9fVJqTWnyIkYmDU6qB
	8bbHzE0VAv8XVkxnbuDbP3/G5J+bzTex3zitknv7lry/UnTbx9ev99ypPBJ1l/fUlAU8/H03
	z/+qlW0+YcTp8iRO8aHXn68HftYmt06VmtrO8l1k8XKhK5u6D3wv8J0XYLq/NXBCdNoDTzue
	tG36Km7/OnYl7Jh1fe/a6e+z3jAo8Ky/+IZdykSJpTgj0VCLuag4EQCLt0SIEQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_node_by_name() walks over all nodes and can thus walk outside of
the parent node. Use of_get_child_by_name() instead.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/clk-s2mps11.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 27c83e45eaed..6de6a970c086 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -132,7 +132,7 @@ static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev)
 	if (!iodev->dev->of_node)
 		return ERR_PTR(-EINVAL);
 
-	clk_np = of_find_node_by_name(iodev->dev->of_node, "clocks");
+	clk_np = of_get_child_by_name(iodev->dev->of_node, "clocks");
 	if (!clk_np) {
 		dev_err(&pdev->dev, "could not find clock sub-node\n");
 		return ERR_PTR(-EINVAL);
-- 
1.7.9.5

