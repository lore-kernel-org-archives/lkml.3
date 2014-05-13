Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbaEMK7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:59:03 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64298 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760259AbaEMK7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:00 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-fc-5371faf31bad
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/16] mfd: db8500-prcmu: Make mfd_cell array const
Date: Tue, 13 May 2014 12:58:41 +0200
Message-id: <1399978733-13662-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xy7qffxUGG7w8I23x+oWhxf2vRxkt
	pvxZzmSx6fE1VovLu+awWSzquMRscbqb1YHd4861PWwe804GemxeUu/Rt2UVo8f3pWvYPT5v
	kgtgi+KySUnNySxLLdK3S+DKOPpzPVPBD7aKc5s7GRsYv7B2MXJwSAiYSEy/xNPFyAlkiklc
	uLeerYuRi0NIYCmjxL1nHSwQTh+TxI0DnxlBqtgEjCU2L1/CBmKLCGRJ/Ji2GqyIWWAno0T3
	4s3sIAlhAWeJQ4/ngBWxCKhKtK89AhbnFXCXeD3vLiPEOjmJk8cms4LYnAIeEi9unwWzhYBq
	bqyaxDKBkXcBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJDA+rKDcfExq0OMAhyMSjy8
	AVwFwUKsiWXFlbmHGCU4mJVEeN0/FQYL8aYkVlalFuXHF5XmpBYfYmTi4JRqYOwNPH1SfpmR
	XeuZti/V9RxfjhfO6GtPUWUVOJ2z8qvet77wKQ0SxwOmCX2bclDj918p0yexVqk/k3sqAq/V
	ndqiMin5jHLQI44jl3zFThQ+aRLVet74kvO/wpVni/2mNm3w8ffo0uQPSnL26dvGIBo0OaSk
	ynfSfPOND7esn/in68AUb7f+BiWW4oxEQy3mouJEAAaWQo0KAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mfd_add_devices() expects array of struct mfd_cell to be const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/mfd/db8500-prcmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 7694e0700d34..93d2cdcc8aa9 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -3115,7 +3115,7 @@ static int db8500_prcmu_register_ab8500(struct device *parent,
 {
 	struct device_node *np;
 	struct resource ab8500_resource;
-	struct mfd_cell ab8500_cell = {
+	const struct mfd_cell ab8500_cell = {
 		.name = "ab8500-core",
 		.of_compatible = "stericsson,ab8500",
 		.id = AB8500_VERSION_AB8500,
-- 
1.9.1

