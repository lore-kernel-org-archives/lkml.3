Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaDDHve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:51:34 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15135 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaDDHvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:51:31 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-24-533e648227a8
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] leds: 88pm860x: Use of_get_child_by_name
Date: Fri, 04 Apr 2014 09:51:19 +0200
Message-id: <1396597880-2325-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t/xy7pNKXbBBmcn8Foc3TmRyeL1C0OL
	y7vmsFlsfbOO0WL3rqesDqweO2fdZffYM/8Hq0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	nPj0hKngPlvFognH2BsYb7F2MXJySAiYSMz/sx/KFpO4cG89WxcjF4eQwFJGiV9br7NAOH1M
	Ev/v3GUCqWITMJbYvHwJWJWIQCOjROej/WAJZgFDiZ/v/rCD2MICthLHnn5jA7FZBFQlVjz8
	DmbzCrhJvJj0CmgdB9A6BYk5k2wmMHIvYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRES
	Bl92MC4+ZnWIUYCDUYmHNyHTNliINbGsuDL3EKMEB7OSCG9foF2wEG9KYmVValF+fFFpTmrx
	IUYmDk6pBkavD9E/lV9nKGzXLIm08ncVtZHjPHlyF6vKCpE1K+YFSGevX8kr66ZzzftHiqoM
	v6d8zEfHozsZNj8I+C4ldedq1rbnJZan499OKGNT8xHMiXR8FXVpw9bgzKO/k1eve5p3ehmf
	f8vU7Hzb8MRbDyq0oqxz1Q61pmpMSjqyjJnJ8trPAub2eUosxRmJhlrMRcWJAG/kQkzhAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of_get_child_by_name to obtain reference to charger node instead of
of_find_node_by_name which can walk outside of the parent node.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/leds/leds-88pm860x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
index 5f588c0a376e..2f9ee538f30d 100644
--- a/drivers/leds/leds-88pm860x.c
+++ b/drivers/leds/leds-88pm860x.c
@@ -134,7 +134,7 @@ static int pm860x_led_dt_init(struct platform_device *pdev,
 	nproot = of_node_get(pdev->dev.parent->of_node);
 	if (!nproot)
 		return -ENODEV;
-	nproot = of_find_node_by_name(nproot, "leds");
+	nproot = of_get_child_by_name(nproot, "leds");
 	if (!nproot) {
 		dev_err(&pdev->dev, "failed to find leds node\n");
 		return -ENODEV;
-- 
1.7.9.5

