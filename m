Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbbALIjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:39:08 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:38373 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbALIjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:39:05 -0500
From: Kaixu Xia <xiakaixu@huawei.com>
To: <mathieu.poirier@linaro.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <xiakaixu@huawei.com>,
        <kaixu.xia@linaro.org>
Subject: [PATCH] coresight: fix the replicator subtype value
Date: Mon, 12 Jan 2015 16:32:26 +0800
Message-ID: <1421051546-60429-1-git-send-email-xiakaixu@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54B387DD.016A,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 1efe2cb6de0e04b3764a1e5fc7620f18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the classification, the type of replicator
is link, so the subtype should also be link_subtype.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
---
 drivers/coresight/coresight-replicator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/coresight/coresight-replicator.c b/drivers/coresight/coresight-replicator.c
index a2dfcf9..cdf0553 100644
--- a/drivers/coresight/coresight-replicator.c
+++ b/drivers/coresight/coresight-replicator.c
@@ -87,7 +87,7 @@ static int replicator_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	desc->type = CORESIGHT_DEV_TYPE_LINK;
-	desc->subtype.sink_subtype = CORESIGHT_DEV_SUBTYPE_LINK_SPLIT;
+	desc->subtype.link_subtype = CORESIGHT_DEV_SUBTYPE_LINK_SPLIT;
 	desc->ops = &replicator_cs_ops;
 	desc->pdata = pdev->dev.platform_data;
 	desc->dev = &pdev->dev;
-- 
1.8.5.5

