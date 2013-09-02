Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab3IBB01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 21:26:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13462 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924Ab3IBB00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 21:26:26 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-96-5223e94018f9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        "'Zhangfei Gao'" <zhangfei.gao@linaro.org>,
        "'Kai Yang'" <jean.yangkai@huawei.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004c01cea77a$ffd30030$ff790090$%han@samsung.com>
In-reply-to: <004c01cea77a$ffd30030$ff790090$%han@samsung.com>
Subject: [PATCH 2/2] dma: k3dma: use devm_ioremap_resource() instead of
 devm_request_and_ioremap()
Date: Mon, 02 Sep 2013 10:26:23 +0900
Message-id: <005101cea77b$6fe297a0$4fa7c6e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6nev+73G/gftskTrSsjC4jQpqUyAAAFocg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zQ12Hl8pBBo0rRSw29z9gs1j8dBaL
	xeWFl1gtLu+aw2bxsm8/i8XNNRfYHdg8Jja/Y/doOfKW1WPxnpdMHneu7WHz6NuyitHj8ya5
	ALYoLpuU1JzMstQifbsEroyHP9YxFsxhqzj4oYW9gXE6axcjJ4eEgInEqxU72SBsMYkL99YD
	2VwcQgLLGCUmTljKAlP0fv9VVojEIkaJy6eugCWEBH4xSmyclQpiswmoSXz5cpi9i5GDQ0RA
	XWLpdRmQemaBbYwST7ftYIKot5WYdaUTrJdTwE5i//SbzCC2sECKxOTV18EuYhFQlbix9ChY
	nBeovnfrCiYIW1Dix+R7YL3MAloS63ceZ4Kw5SU2r3nLDLJXAmjvo7+6IGERASOJL///MUOU
	iEjse/GOEeQeCYG37BINE1+yQewSkPg2+RALRK+sxKYDzBD/SkocXHGDZQKjxCwkm2ch2TwL
	yeZZSFYsYGRZxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iRESvf07GO8esD7EmAy0fiKzlGhy
	PjD680riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	aNrW2+SqKuhyvGvngxNaT3Ses2scm/W+6fkn0YLWzKmepR0hnBF2wQHscqfFv/0wf8RZve7R
	iqnZdxfmX5plFPC3qipl6xTVGc3RE1KUNt3Pi3pdmtGqlKD2tsRdO2zamdZH+hJXeW6tl//G
	1K2zpMbhppjFBu7GekGN7RyOk36yuPpN+cyixFKckWioxVxUnAgAJgpupvQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAV2Hl8pBBh2bBSw29z9gs1j8dBaL
	xeWFl1gtLu+aw2bxsm8/i8XNNRfYHdg8Jja/Y/doOfKW1WPxnpdMHneu7WHz6NuyitHj8ya5
	ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKA7
	lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZD3+sYyyYw1Zx8EMLewPj
	dNYuRk4OCQETiff7r0LZYhIX7q1n62Lk4hASWMQocfnUFRaQhJDAL0aJjbNSQWw2ATWJL18O
	s3cxcnCICKhLLL0uA1LPLLCNUeLpth1MEPW2ErOudIL1cgrYSeyffpMZxBYWSJGYvPo62DIW
	AVWJG0uPgsV5gep7t65ggrAFJX5MvgfWyyygJbF+53EmCFteYvOat8wgeyWA9j76qwsSFhEw
	kvjy/x8zRImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0
	veT83E2M4NTwTGoH48oGi0OMAhyMSjy8FSuUg4RYE8uKK3MPMUpwMCuJ8FY9BwrxpiRWVqUW
	5ccXleakFh9iTAZ6dCKzlGhyPjBt5ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7
	NbUgtQhmCxMHp1QDY/BKx6VHhLq8Y7dNUDn3Mr3w7LsYZc6uiEs5TvXRZ9RX1Dcv6hWc3yXy
	t/6p1eT1c5tXirotW7vX0MJ92fN/Ud19fzVk2hl3pelf+Wnnrs6y+r8ro8tq3W9L/rxstQrj
	m6v7K2T3z87y8KsTRP1sRHoTpsyOijzW9P281p+8Fx/4zDIZZGM/KrEUZyQaajEXFScCAIwg
	Gs1RAwAA
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
 drivers/dma/k3dma.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index ef7bc85..a2c330f 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -673,9 +673,9 @@ static int k3_dma_probe(struct platform_device *op)
 	if (!d)
 		return -ENOMEM;
 
-	d->base = devm_request_and_ioremap(&op->dev, iores);
-	if (!d->base)
-		return -EADDRNOTAVAIL;
+	d->base = devm_ioremap_resource(&op->dev, iores);
+	if (IS_ERR(d->base))
+		return PTR_ERR(d->base);
 
 	of_id = of_match_device(k3_pdma_dt_ids, &op->dev);
 	if (of_id) {
-- 
1.7.10.4


