Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3C1EcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:32:00 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:63649 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3C1Eb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:31:59 -0400
MIME-Version: 1.0
Date: Thu, 28 Mar 2013 12:31:55 +0800
Message-ID: <CAPgLHd87a0=e8pX4YRwpxzxk1=YgcVimjxTFnpJKH8wRs1WfjQ@mail.gmail.com>
Subject: [PATCH -next] mg_disk: fix error return code in mg_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: jg1.han@samsung.com, akpm@linux-foundation.org, rjw@sisk.pl
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/mg_disk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 532bb89..a56cfcd 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -892,8 +892,10 @@ static int mg_probe(struct platform_device *plat_dev)
 	gpio_direction_output(host->rst, 1);
 
 	/* reset out pin */
-	if (!(prv_data->dev_attr & MG_DEV_MASK))
+	if (!(prv_data->dev_attr & MG_DEV_MASK)) {
+		err = -EINVAL;
 		goto probe_err_3a;
+	}
 
 	if (prv_data->dev_attr != MG_BOOT_DEV) {
 		rsc = platform_get_resource_byname(plat_dev, IORESOURCE_IO,

