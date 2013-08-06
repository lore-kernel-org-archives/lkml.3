Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3HFKfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:35:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38446 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab3HFKfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:35:15 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-5a-5200d16129ce
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>, "'Xiang Wang'" <wangx@marvell.com>,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/3] dma: mmp_pdma: Staticize mmp_pdma_alloc_descriptor()
Date: Tue, 06 Aug 2013 19:35:13 +0900
Message-id: <000001ce9290$a25a83f0$e70f8bd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6SkJEqqNJgGlhnTNieFqtyUrKRqg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zA93EiwxBBisWW1ps7n/AZnF54SVW
	i8u75rBZvOzbz2Jx+sMjdgdWj4nN79g9Fu95yeQxeeFFZo++LasYPT5vkgtgjeKySUnNySxL
	LdK3S+DK6Lrzk6ngNVvFvBUnWBsYX7B2MXJwSAiYSLw4lN7FyAlkiklcuLeerYuRi0NIYBmj
	xMpNp1ghEiYSL58cZIJILAJKbL/HAuH8YpR4Nr2TGaSKTUBN4suXw+wgU0UE1CWWXpcBqWEW
	aGGU2DjrHwtIjbCAp8SSxzPZQGwWAVWJ/aufgdm8ApYSbyfuYISwBSV+TL4HVs8soCWxfudx
	JghbXmLzmrfMEBcpSOw4+xqsXkRAT2LmzYVsEDUiEvtevGMEWSwhcIxd4uqKT4wQywQkvk0+
	xALxsqzEpgNQcyQlDq64wTKBUWwWktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y0StOzC0u
	zUvXS87P3cQIib0JOxjvHbA+xJgMtH4is5Rocj4wdvNK4g2NzYwsTE1MjY3MLc1IE1YS51Vv
	sQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwBiXK/GsO0P99JkHhz5YWgdURN70eed0pdub
	7fqGRf3hTZp9E/iENH33P129jzMm1ltNwlhZw5Lv50R/b+mZHr0pvn81FzRXRYabK53jtHqa
	PT3z/K1pj555ZhyQkphsKiBY6vvqSG3zl/9/Hyy0E7lk4+b4b8lFdenVvSd+b7o2w+9Puus5
	IyWW4oxEQy3mouJEAAh6djDTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd3EiwxBBh8umlps7n/AZnF54SVW
	i8u75rBZvOzbz2Jx+sMjdgdWj4nN79g9Fu95yeQxeeFFZo++LasYPT5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzOi685Op4DVbxbwVJ1gbGF+wdjFyckgImEi8
	fHKQCcIWk7hwbz1bFyMXh5DAIkaJldvvsUA4vxglnk3vZAapYhNQk/jy5TB7FyMHh4iAusTS
	6zIgNcwCLYwSG2f9YwGpERbwlFjyeCYbiM0ioCqxf/UzMJtXwFLi7cQdjBC2oMSPyffA6pkF
	tCTW7zzOBGHLS2xe85YZ4iIFiR1nX4PViwjoScy8uZANokZEYt+Ld4wTGAVmIRk1C8moWUhG
	zULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcGw/k9rBuLLB4hCjAAejEg9v4tX/
	gUKsiWXFlbmHGCU4mJVEeFV2MgQJ8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4w7eSVxBsa
	m5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUAyPXgz7PL42lR926twjU
	/xFQUQgXPXWIgbF286cd7QXH5k0z00naXvp+haG3jfAe1sSK+P+hbP90vnjbzZ1xu7xxVWRA
	qZ/QH70jU49ce/mfYevcQo5i6dX25+/FiWzWSqgN1BDVS/AuTfnw/lU1e9kN7USLaWYfJe2f
	me1IOjjP9IHqL8+LvEosxRmJhlrMRcWJANxvFU0xAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmp_pdma_alloc_descriptor() is used only in this file.
Fix the following sparse warning:

drivers/dma/mmp_pdma.c:359:25: warning: symbol 'mmp_pdma_alloc_descriptor' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/dma/mmp_pdma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index 9a32f2d..3bf9c91 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -356,7 +356,8 @@ static dma_cookie_t mmp_pdma_tx_submit(struct dma_async_tx_descriptor *tx)
 	return cookie;
 }
 
-struct mmp_pdma_desc_sw *mmp_pdma_alloc_descriptor(struct mmp_pdma_chan *chan)
+static struct mmp_pdma_desc_sw *
+mmp_pdma_alloc_descriptor(struct mmp_pdma_chan *chan)
 {
 	struct mmp_pdma_desc_sw *desc;
 	dma_addr_t pdesc;
-- 
1.7.10.4


