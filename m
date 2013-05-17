Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3EQInV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:43:21 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:38381 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab3EQInR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:43:17 -0400
MIME-Version: 1.0
Date: Fri, 17 May 2013 16:43:15 +0800
Message-ID: <CAPgLHd9nrgGuozisTZnQrQZFDi9vwBss=n8-U57OYf8RsQ5LHQ@mail.gmail.com>
Subject: [PATCH -next] staging: wlags49_h2: fix error return code in wl_adapter_insert()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org, khoroshilov@ispras.ru
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

When return from wl_adapter_insert() in the register_netdev() error
handling case, 'ret' which is 0 is returned, but we should return a
negative error code instead, so fix to return the return value of
register_netdev().

Introduce by commit 657d4c86d4cd85a4696445f6fb2fe0941a5724ff
(staging: wlags49_h2: fix error handling in pcmcia probe function)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/wlags49_h2/wl_cs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index f9e5fd3..b55dc43 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -259,7 +259,8 @@ int wl_adapter_insert(struct pcmcia_device *link)
 	dev->base_addr  = link->resource[0]->start;
 
 	SET_NETDEV_DEV(dev, &link->dev);
-	if (register_netdev(dev) != 0) {
+	ret = register_netdev(dev);
+	if (ret != 0) {
 		printk("%s: register_netdev() failed\n", MODULE_NAME);
 		goto failed;
 	}

