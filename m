Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaC0Kny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 06:43:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37593 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaC0Knw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 06:43:52 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-21-533400e2acf8
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.brezillon@overkiz.com, khilman@linaro.org, festevam@gmail.com,
        shawn.guo@linaro.org, nicolas.ferre@atmel.com,
        sebastian.hesselbarth@gmail.com, plagnioj@jcrosoft.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] clk: reverse default clk provider initialization order in
 of_clk_init()
Date: Thu, 27 Mar 2014 11:43:32 +0100
Message-id: <1395917012-23483-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jAd1HDCbBBmvO81pcOHeY0eLhVX+L
	r4dXMFpsenyN1eLyrjlsFk8nXGSz+Ha5md1i3cMXTBaH37SzWrz/6WjxdN0SZgdujwW/trJ4
	7Jx1l93j1YU7LB53ru1h89i8pN5j0uI/bB59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CVsXZW
	E2vBY/aKbZ/4Gxj3sXUxcnJICJhI/Dp4EcoWk7hwbz2QzcUhJLCIUWLq053sEE4Hk0Tj0d/M
	IFVsAoYSvUf7GEFsEQFJiQefp7OAFDELLGaSWHJrGwtIQlggSuL03h4gm4ODRUBVYtvGehCT
	V8BNYsk8RRBTQkBBYs4kmwmM3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAfYM6kd
	jCsbLA4xCnAwKvHw7rhvFCzEmlhWXJl7iFGCg1lJhLf/r3GwEG9KYmVValF+fFFpTmrxIUZp
	DhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBsY1VYxVSQ84rpvIpz2dXH3xzPxbeZNKub3i
	WU2SxRafeKFo2jB5n/fSZL37G+YffeTWMGNV0bqQOXJMYq/mPzOt0irx89/u+P2/9dL7/1V3
	L1R/mXH0ZlhpbNDmwiyba9/32ecL+5w7WqY5ZeuebK11r25XH2VeEV7y+N1Xb6Zjsa+a/wtU
	605SYinOSDTUYi4qTgQAac5jVSwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This restores the default clocks registration order as parsed from
devicetree, i.e. as before commit 1771b10d605d26ccee771a7fb4b08718
"clk: respect the clock dependencies in of_clk_init", for when there
is no explicit parent clock dependencies between clock providers
specified in the device tree.

It prevents regressions (boot failure, division by 0 errors) on
imx and exynos platforms.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/clk/clk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 07cba07..c859adf 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2596,7 +2596,7 @@ void __init of_clk_init(const struct of_device_id *matches)
 
 		parent->clk_init_cb = match->data;
 		parent->np = np;
-		list_add(&parent->node, &clk_provider_list);
+		list_add_tail(&parent->node, &clk_provider_list);
 	}
 
 	while (!list_empty(&clk_provider_list)) {
-- 
1.7.9.5

