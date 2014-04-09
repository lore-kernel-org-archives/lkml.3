Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101AbaDILyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:54:45 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20475 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482AbaDILyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:54:43 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f796d000005a13-42-534535016ef6
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] [media] V4L: s5c73m3: Fix build after
 v4l2_of_get_next_endpoint rename
Date: Wed, 09 Apr 2014 13:54:06 +0200
Message-id: <1397044446-2257-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xy7qMpq7BBnNeCVvcWneO1eL1C0OL
	s01v2C0u75rDZtGzYSurxcV18haH37SzOrB79G1ZxejxeZNcAFMUl01Kak5mWWqRvl0CV8av
	/gnMBT85Kz4f+8ncwHibo4uRg0NCwETi1oyQLkZOIFNM4sK99WxdjFwcQgJLGSUmfzrCApLg
	FRCU+DH5HgtIPbOAvMSRS9kgYWYBdYlJ8xYxQ9T3MUn8uHSeFSTBJmAssXn5ErBBIgIHGSWm
	bDnODNGRIDH780swW1ggUuJl63UmEJtFQFXi8a7FzBDL3CRW3VjODnGRgsSyL2uZJzDyzUJy
	xyyEO2YhuWMBI/MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJCA/LKDcfExq0OMAhyMSjy8
	CpYuwUKsiWXFlbmHGCU4mJVEeNsMXIOFeFMSK6tSi/Lji0pzUosPMTJxcEo1MMa7fPhdtcT/
	QEHjT8eyHV9Uz/Y3PnuhNVvFuNcmseRB1M1p1tpHv1SKOdssv7dNfdreqE5eLvNVf1tYznic
	uR4W934Jm1b6uh2LOqb5z4h9pBG36cFRNYE4Dmn7/IfGV/fHnli5b2GmaJD0speacz6fmZAS
	uSBJt2jzjse7/j2YZbdjReLGGmslluKMREMt5qLiRADumbmiJgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error after v4l2_of_get_next_endpoint rename (fd9fdb78a9bf:
"[media] of: move graph helpers from drivers/media/v4l2-core..."):

drivers/media/i2c/s5c73m3/s5c73m3-core.c: In function ‘s5c73m3_get_platform_data’:
drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:2: error: implicit declaration of function ‘v4l2_of_get_next_endpoint’ [-Werror=implicit-function-declaration]
drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:10: warning: assignment makes pointer from integer without a cast [enabled by default]

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index a4459301b5f8..ee0f57e01b56 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1616,7 +1616,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
 	if (ret < 0)
 		return -EINVAL;
 
-	node_ep = v4l2_of_get_next_endpoint(node, NULL);
+	node_ep = of_graph_get_next_endpoint(node, NULL);
 	if (!node_ep) {
 		dev_warn(dev, "no endpoint defined for node: %s\n",
 						node->full_name);
-- 
1.8.3.2

