Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747AbaCUMSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:18:32 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52546 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbaCUMSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:18:30 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-c6-532c2e14a54c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] clk: s2mps11: Fix possible NULL pointer dereference
Date: Fri, 21 Mar 2014 13:18:17 +0100
Message-id: <1395404297-12133-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t/xa7oiejrBBou/M1psnLGe1eL1C0OL
	s01v2C02Pb7GanF51xw2ixnn9zFZrD1yl93i6YSLbBYLNj5itFg/4zWLRfvfvWwO3B53ru1h
	89i8pN6jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4Mu69PcxWcJCtomXdO9YGxr2sXYycHBIC
	JhIn3/VD2WISF+6tZ+ti5OIQEljKKHH+2BIop49JYuLDW4wgVWwCxhKbl0MkRASmMkpsXL+I
	CcRhFljLJLF/2RaWLkYODmEBD4nN99NAGlgEVCUmTV7ADmLzCrhL9P7YDVYiIaAgMWeSzQRG
	7gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQgLo6w7GpcesDjEKcDAq8fBWcGoHC7Em
	lhVX5h5ilOBgVhLhldPSCRbiTUmsrEotyo8vKs1JLT7EyMTBKdXAWP0vq3RdlUNN+96TsmGb
	uUxXf/i8oPLtlZSP7VpKhpzs1p/2eVmX7sy5GuNgXjv758ETd2t41arOifcvT2RcXfDlzU6r
	8C0nqjy9fnl89v7zMVW2aM0nY5ebidkGK/3vLpp2t/mqiqivzlonr4X7OLaG72aRsV/nVvF4
	0f7V/BZ7X31+oDfJRomlOCPRUIu5qDgRABVTA/H+AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If parent device does not have of_node set the s2mps11_clk_parse_dt()
returned NULL. This NULL was later passed to of_clk_add_provider() which
dereferenced it in pr_debug() call.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
---
 drivers/clk/clk-s2mps11.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 00a3abe103a5..27c83e45eaed 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -130,7 +130,7 @@ static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev)
 	int i;
 
 	if (!iodev->dev->of_node)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	clk_np = of_find_node_by_name(iodev->dev->of_node, "clocks");
 	if (!clk_np) {
-- 
1.7.9.5

