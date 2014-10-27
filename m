Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaJ0Pou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:44:50 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13412 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaJ0PoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:44:24 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-43-544e68550712
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sangbeom Kim <sbkim73@samsung.com>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/4] regulator: dummy: Make regulator_desc array const
Date: Mon, 27 Oct 2014 16:44:11 +0100
Message-id: <1414424654-27277-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t/xa7qhGX4hBtvnylpMffiEzeL1C0OL
	b1c6mCwu75rDZnFxxRcmB1aPnbPusntsWtXJ5tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	Z98cYy84xFrx9Pt5lgbGCyxdjJwcEgImEoc3b2aDsMUkLtxbD2RzcQgJLGWUOH7/NVhCSKCP
	SaKlUQbEZhMwlti8fAlYkYhAD6PE+0snwYqYBQwlfr77ww5iCwu4SVz68w5sA4uAqsSX+6uY
	QWxeAXeJn9cXM0Jsk5M4eWwy6wRG7gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQsLg
	6w7GpcesDjEKcDAq8fBOKPYNEWJNLCuuzD3EKMHBrCTCeyDNL0SINyWxsiq1KD++qDQntfgQ
	IxMHp1QDY9jVqE1XJizjz3j442DZksUMWh/mv8p2Df7oa3pqx8QIdsmHUR0JJTGJi1vXMt3u
	CStwmcDw2F1Ea9HMSp11qjfeLwqxPc8r86vSJ/XOpsKnJ3P6JUrbH064cKzn8wMN1WCxJcX7
	Pk7KEFwaEaS2O6F6xcmNl95amPz96v+i+nyqqsjl9TPNpZVYijMSDbWYi4oTAdWJ6BDhAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator_register() expects array of 'regulator_desc' to be const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/dummy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/dummy.c b/drivers/regulator/dummy.c
index 2436db9e2ca3..7aef9e4c6fbf 100644
--- a/drivers/regulator/dummy.c
+++ b/drivers/regulator/dummy.c
@@ -33,7 +33,7 @@ static struct regulator_init_data dummy_initdata = {
 
 static struct regulator_ops dummy_ops;
 
-static struct regulator_desc dummy_desc = {
+static const struct regulator_desc dummy_desc = {
 	.name = "regulator-dummy",
 	.id = -1,
 	.type = REGULATOR_VOLTAGE,
-- 
1.9.1

