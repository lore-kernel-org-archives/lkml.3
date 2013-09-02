Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab3IBBXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 21:23:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12848 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab3IBBXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 21:23:17 -0400
X-AuditID: cbfee68e-b7f756d000004512-d9-5223e884cdee
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        "'Simon Horman'" <horms+renesas@verge.net.au>,
        "'Guennadi Liakhovetski'" <g.liakhovetski+renesas@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] dma: sh: use devm_ioremap_resource() instead of
 devm_request_and_ioremap()
Date: Mon, 02 Sep 2013 10:23:15 +0900
Message-id: <004c01cea77a$ffd30030$ff790090$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6nev+73G/gftskTrSsjC4jQpqUyA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t8zA92WF8pBBjNvCVps7n/AZnFz+iNm
	iwtvP7BZXF54idXi8q45bBYv+/azOLB5TGx+x+6xc9Zddo/Fe14yefRtWcXoMefnNxaPz5vk
	AtiiuGxSUnMyy1KL9O0SuDLaWncwFZxjq/i99iBLA+MF1i5GTg4JAROJz7tamCFsMYkL99az
	dTFycQgJLGOUePJrJjtM0dfth5kgEosYJVbMmA7l/GKUmNJ8BKydTUBN4suXw0AdHBwiAuoS
	S6/LgNQwC1xklLi55TkrSFxYIFHixVs7kHIWAVWJ7t+vWEBsXgFbid0zv0LZghI/Jt8Ds5kF
	tCTW7zzOBGHLS2xe85YZZIwE0PhHf3VBwiICehLXz31ghygRkdj34h0jxM3X2CW+7I+DWCUg
	8W3yIRaIVlmJTQeg/pWUOLjiBssERrFZSBbPQrJ4FpLFs5BsWMDIsopRNLUguaA4Kb3ISK84
	Mbe4NC9dLzk/dxMjJBb7djDePGB9iDEZaP1EZinR5HxgLOeVxBsamxlZmJqYGhuZW5qRJqwk
	zqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTH+FId11sxJOVaxnzlWTy1uOCDB83T5
	AvGAk9wbFX0veXJz71sq1vnyIXvj5ogN6n85D7xf8pB7L6u4/Ad2X8/VfrPdfQ9bHri5KmX+
	w8D1mR5n1zx4scJl+/csV9duzbyMCIWbM9gi2JStQroWd7xkFeY8/D7kbtmk20Y28a3XL+l5
	Su+Yf0aJpTgj0VCLuag4EQByIV8F2wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd2WF8pBBic28Fps7n/AZnFz+iNm
	iwtvP7BZXF54idXi8q45bBYv+/azOLB5TGx+x+6xc9Zddo/Fe14yefRtWcXoMefnNxaPz5vk
	AtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmtLXuYCo4x1bxe+1BlgbG
	C6xdjJwcEgImEl+3H2aCsMUkLtxbz9bFyMUhJLCIUWLFjOlMEM4vRokpzUeYQarYBNQkvnw5
	zN7FyMEhIqAusfS6DEgNs8BFRombW56zgsSFBRIlXry1AylnEVCV6P79igXE5hWwldg98yuU
	LSjxY/I9MJtZQEti/c7jTBC2vMTmNW+ZQcZIAI1/9FcXJCwioCdx/dwHdogSEYl9L94xTmAU
	mIVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGx/kx6B+OqBotD
	jAIcjEo8vArLlIOEWBPLiitzDzFKcDArifBWPQcK8aYkVlalFuXHF5XmpBYfYkwGenQis5Ro
	cj4wDeWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2PIJcvo
	m5c3b5bSmn3DqaS9tdUlocG4reHOndqjgacc2CpXsobMYm1jMbT49PMdk8fm+Od8E3+ud9Gv
	d1x86f4l3QlMXqrSnxg/Hd6i+5alpYtFY+9vzeXsN52Omff8cfb7wX9oX9KZhA0enbdSP/Jk
	H1lj37Lk/vT5Fb75O059iJXMaDHvVFNiKc5INNRiLipOBABy5ePrOQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource() because devm_request_and_ioremap() is
obsoleted by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/dma/sh/sudmac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index bf85b8e..7c1ffaa 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -358,9 +358,9 @@ static int sudmac_probe(struct platform_device *pdev)
 
 	dma_dev = &su_dev->shdma_dev.dma_dev;
 
-	su_dev->chan_reg = devm_request_and_ioremap(&pdev->dev, chan);
-	if (!su_dev->chan_reg)
-		return err;
+	su_dev->chan_reg = devm_ioremap_resource(&pdev->dev, chan);
+	if (IS_ERR(su_dev->chan_reg))
+		return PTR_ERR(su_dev->chan_reg);
 
 	dma_cap_set(DMA_SLAVE, dma_dev->cap_mask);
 
-- 
1.7.10.4


