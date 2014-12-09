Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbaLINOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:14:22 -0500
Received: from m12-16.163.com ([220.181.12.16]:46749 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158AbaLINON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:14:13 -0500
X-Coremail-DSSMTP: 117.88.175.67
From: weiyj_lk@163.com
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next] coresight-tpiu: use module_amba_driver to simplify the code
Date: Tue,  9 Dec 2014 21:13:23 +0800
Message-Id: <1418130803-27443-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EMCowECZiWt09YZURf8hAg--.103S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4fKw1DJFy5Zw4xKr1UGFg_yoWDWwc_GF
	ykWa47X3s5Cr42kFyUWr15Zr1S9Fn8urn3Ar10y3s3J3srtw1Syw4DArW7Za18Gr4kJF1D
	tr43Xrn5Zr13tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUesmitUUUUU==
X-Originating-IP: [117.88.175.67]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbioxVd1lD+YHdheAAAsd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

module_amba_driver() makes the code simpler by eliminating
boilerplate code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/coresight/coresight-tpiu.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/coresight/coresight-tpiu.c b/drivers/coresight/coresight-tpiu.c
index ae10108..3b33af2 100644
--- a/drivers/coresight/coresight-tpiu.c
+++ b/drivers/coresight/coresight-tpiu.c
@@ -201,17 +201,7 @@ static struct amba_driver tpiu_driver = {
 	.id_table	= tpiu_ids,
 };
 
-static int __init tpiu_init(void)
-{
-	return amba_driver_register(&tpiu_driver);
-}
-module_init(tpiu_init);
-
-static void __exit tpiu_exit(void)
-{
-	amba_driver_unregister(&tpiu_driver);
-}
-module_exit(tpiu_exit);
+module_amba_driver(tpiu_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("CoreSight Trace Port Interface Unit driver");

