Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaAJLpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:45:11 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:44618 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaAJLpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:45:05 -0500
X-AuditID: cbfee690-b7f266d00000287c-3a-52cfdd40ddf0
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com
Subject: [PATCH 7/8 v3] crypto:s5p-sss: validate iv before memcpy
Date: Fri, 10 Jan 2014 17:15:21 +0530
Message-id: <1389354321-32096-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkRtfh7vkgg9mHDC1eHtK06H4lY3H/
	3k8mi8u75rBZzDi/j8li0bb/zBardv1htDg75xCTA4fHzll32T22HVD16NuyitHj8ya5AJYo
	LpuU1JzMstQifbsEroz/WxqZCy6wVTz49pipgXEraxcjJ4eEgInE9/X7GCFsMYkL99azdTFy
	cQgJLGWUWL5yEnMXIwdY0eWF1hDx6YwSq7f9YYJw+pkkTrbMBpvEJmAmcXDRanYQW0TAWeJ3
	8xpWkCJmgTmMEg+XtLOATBIWcJRoblIAMVkEVCVWv1MDKecVcJW4+KqLDWKXgsScSTYgYU4B
	N4mtl5+ATRQCKplz4iozyEQJgXnsEou2vWUGSbAICEh8m3yIBaJXVmLTAWaIXyQlDq64wTKB
	UXgBI8MqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMDgPv3v2YQdjPcOWB9iTAYaN5FZSjQ5
	HxgdeSXxhsZmRhamJqbGRuaWZqQJK4nzqj1KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	yLLBYs7mhnUedjt9JTb8X7twal7YowPmbBtzLtvv/qCYsbTretnSUKekT9/TnxssLPr7bePG
	Txobz/82bWfw/XLm+EbRJyVGWxuSRdoiPj3YFNopNfv4BvltzH1G8XPWLYzKyo+capnVsivm
	wqW/LMoXAjfcn/7riVCz4nnZ2sdPnhY8XPbnloUSS3FGoqEWc1FxIgBbV5r4hAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t9jQV2Hu+eDDKat0rR4eUjTovuVjMX9
	ez+ZLC7vmsNmMeP8PiaLRdv+M1us2vWH0eLsnENMDhweO2fdZffYdkDVo2/LKkaPz5vkAlii
	GhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COUFIo
	S8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm/N/SyFxwga3iwbfHTA2MW1m7
	GDk4JARMJC4vtO5i5AQyxSQu3FvP1sXIxSEkMJ1RYvW2P0wQTj+TxMmW2awgVWwCZhIHF61m
	B7FFBJwlfjevYQUpYhaYwyjxcEk7C8hUYQFHieYmBRCTRUBVYvU7NZByXgFXiYuvutgg9ipI
	zJlkAxLmFHCT2Hr5CdhEIaCSOSeuMk9g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cT
	Izh2nknvYFzVYHGIUYCDUYmHt2DW+SAh1sSy4srcQ4wSHMxKIrzmF4BCvCmJlVWpRfnxRaU5
	qcWHGJOBbprILCWanA+M67ySeENjE3NTY1NLEwsTM0vShJXEeQ+2WgcKCaQnlqRmp6YWpBbB
	bGHi4JRqYJxjcG9D6pw3DjmHFP/zHbO1NVDcfamEUf1uUXa19umkj5dufbYOWZa6PGYyi/vX
	jVMsr6zxLivY4+d5lqOcX8jvFlf29PrmKt9VpjfkjXZ+krz3x6703uXHk7KW8Pu9iJ1tJ/i5
	6GbVNkvGDZ9lr0pps7lX8f69V8TSnrDtqNTHTxf+vY1nEFViKc5INNRiLipOBADLxUck4QIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to validate "iv" buffer before trying to
memcpy the contents

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v2:
None

 drivers/crypto/s5p-sss.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index f274f5f..7058bb6 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -381,8 +381,9 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 	struct samsung_aes_variant *var = dev->variant;
 	void __iomem *keystart;
 
-	memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
-				(var->aes_offset, 0), iv, 0x10);
+	if (iv)
+		memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
+					(var->aes_offset, 0), iv, 0x10);
 
 	if (keylen == AES_KEYSIZE_256)
 		keystart = dev->ioaddr +
-- 
1.7.9.5

