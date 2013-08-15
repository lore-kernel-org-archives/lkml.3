Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3HONB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:01:58 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:52186 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab3HONB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:01:56 -0400
Message-ID: <520CD134.4030203@huawei.com>
Date: Thu, 15 Aug 2013 21:01:40 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <emilio@elopez.com.ar>, Greg KH <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH v3 4/7] net: sunbmac: use platform_{get,set}_drvdata()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &op->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/net/ethernet/sun/sunbmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunbmac.c b/drivers/net/ethernet/sun/sunbmac.c
index 0d43fa9..0a32ca5 100644
--- a/drivers/net/ethernet/sun/sunbmac.c
+++ b/drivers/net/ethernet/sun/sunbmac.c
@@ -1239,7 +1239,7 @@ static int bigmac_sbus_probe(struct platform_device *op)

 static int bigmac_sbus_remove(struct platform_device *op)
 {
-	struct bigmac *bp = dev_get_drvdata(&op->dev);
+	struct bigmac *bp = platform_get_drvdata(op);
 	struct device *parent = op->dev.parent;
 	struct net_device *net_dev = bp->dev;
 	struct platform_device *qec_op;
-- 
1.7.1

