Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaJ0Po2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:44:28 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13412 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaJ0PoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:44:25 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-4a-544e68569bc7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sangbeom Kim <sbkim73@samsung.com>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4/4] regulator: s2mpa01: Make regulator_desc array const
Date: Mon, 27 Oct 2014 16:44:14 +0100
Message-id: <1414424654-27277-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414424654-27277-1-git-send-email-k.kozlowski@samsung.com>
References: <1414424654-27277-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsVy+t/xa7phGX4hBqf3S1hMffiEzeL1C0OL
	b1c6mCwu75rDZnFxxRcmB1aPnbPusntsWtXJ5tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	uzbMZiz4yVqxd+MJ9gbGdtYuRg4OCQETiWl7FLsYOYFMMYkL99azdTFycQgJLGWUeDztFZTT
	xySxZ/d1VpAqNgFjic3Ll4AlRAR6GCXeXzrJBpJgFjCU+PnuDzuILSzgIfGm7xIjyAYWAVWJ
	x/fqQUxeAXeJG5+qIZbJSZw8NhlsJCdQ9cIFuxlBbCGgksfbGtkmMPIuYGRYxSiaWppcUJyU
	nmukV5yYW1yal66XnJ+7iRESMl93MC49ZnWIUYCDUYmHd0Kxb4gQa2JZcWXuIUYJDmYlEd4D
	aX4hQrwpiZVVqUX58UWlOanFhxiZODilGhi1In72uupw3nOZsGmx5JI2+9/Tn+2d8+3Q1mhB
	O3emdRVv9rxbfXPKcTWJ9FkF+a7eJ5/mn2b/WGxlo3Z+W+cEAxvPT9PvzC9qr1yXmXPhwe5s
	52vfYk/61kjU/RPlvnBR4raGy4MSqUlKi2Y5KM0wvlzx9kD+rx09/vMND80M4Xoi49p4rz9C
	iaU4I9FQi7moOBEAKU/1X/cBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator_register() expects array of 'regulator_desc' to be const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s2mpa01.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
index 4acefa6b462e..2263071414e2 100644
--- a/drivers/regulator/s2mpa01.c
+++ b/drivers/regulator/s2mpa01.c
@@ -298,7 +298,7 @@ static struct regulator_ops s2mpa01_buck_ops = {
 	.enable_mask	= S2MPA01_ENABLE_MASK			\
 }
 
-static struct regulator_desc regulators[] = {
+static const struct regulator_desc regulators[] = {
 	regulator_desc_ldo(1, STEP_25_MV),
 	regulator_desc_ldo(2, STEP_50_MV),
 	regulator_desc_ldo(3, STEP_50_MV),
-- 
1.9.1

