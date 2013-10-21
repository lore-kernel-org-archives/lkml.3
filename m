Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3JUOTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:19:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49908 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3JUOTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:19:14 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-75-526537e19c14
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, kishon@ti.com, sw0312.kim@samsung.com,
        inki.dae@samsung.com, rahul.sharma@samsung.com, kgene.kim@samsung.com,
        s.nawrocki@samsung.com, thomas.abraham@linaro.org,
        mturquette@linaro.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 05/12] phy: use of_phy_simple_xlate for NULL xlate function
Date: Mon, 21 Oct 2013 16:18:24 +0200
Message-id: <1382365111-6533-6-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jAd1H5qlBBhemMlrMP3KO1eLK1/ds
	FpPuT2Cx6F1wlc3iwtMeNouzTW/YLS7vmsNmMeP8PiaLpxMusllMWXSY1eLwm3ZWixmTX7JZ
	rJ/xmsViXvtLVotjM5YwOvB73Lm2h83jfvdxJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllq
	kb5dAlfG9I8bWAums1U0Lm1ga2BczNrFyMkhIWAicXzNBzYIW0ziwr31QDYXh5DAIkaJY+e6
	2CGcLiaJH6fmsYNUsQF1HFvymRHEFhFIlPjVfJcZpIhZ4BCTxO6WKcwgCWEBT4nlMy6CjWUR
	UJXYdOMnmM0r4C7x+ttUdoh18hJP7/eBxTkFPCROvVwLNlQIqObdt3ksExh5FzAyrGIUTS1I
	LihOSs810itOzC0uzUvXS87P3cQIDtRn0jsYVzVYHGIU4GBU4uENcEkJEmJNLCuuzD3EKMHB
	rCTCW2WaGiTEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qB
	MSZ5Tmd87dno+GfnDiiL9x88v7m6VNjL99x8w7XbOPpuy/CsXCTwSvCTf1cxe2TzimbjnL8T
	aqc9nrS83UGq2Dtjt7zj5s03Z1x8ofjfbZPNh+Uyk47nHxGeM/WP2//K96EqW2pn7nzzzOPb
	adU17bXprI7c//PfCz+etXAnM+eGy67WPdbmXkosxRmJhlrMRcWJAF04/mhQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use default handler of_phy_simple_xlate() when NULL is passed as argument to
of_phy_provider_register().

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/phy/phy-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb..c38ae1e7 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -575,7 +575,7 @@ struct phy_provider *__of_phy_provider_register(struct device *dev,
 
 	phy_provider->dev = dev;
 	phy_provider->owner = owner;
-	phy_provider->of_xlate = of_xlate;
+	phy_provider->of_xlate = of_xlate ? of_xlate : of_phy_simple_xlate;
 
 	mutex_lock(&phy_provider_mutex);
 	list_add_tail(&phy_provider->list, &phy_provider_list);
-- 
1.7.9.5

