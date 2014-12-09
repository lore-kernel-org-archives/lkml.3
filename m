Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbaLINNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:13:54 -0500
Received: from m12-15.163.com ([220.181.12.15]:40193 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757106AbaLINNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:13:46 -0500
X-Coremail-DSSMTP: 117.88.175.67
From: weiyj_lk@163.com
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next] coresight-tmc: use module_amba_driver to simplify the code
Date: Tue,  9 Dec 2014 21:13:12 +0800
Message-Id: <1418130792-27195-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: D8CowEB5Znho9YZUZVWjBA--.564S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4fKw1DJFy5Zw4xCFW5Awb_yoWDXFb_CF
	WvqFy7W348urZxKF17Xws8Zw1Y9Fn8ursayF48tas3J3srJw1Syr4DArW3Za1rWr4kAF4q
	yrsrXw1rZw12yjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUesmitUUUUU==
X-Originating-IP: [117.88.175.67]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbivwpd1lD+Xhw+ZwAAsL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

module_amba_driver() makes the code simpler by eliminating
boilerplate code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/coresight/coresight-tmc.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/coresight/coresight-tmc.c b/drivers/coresight/coresight-tmc.c
index ce2c293..3ff232f 100644
--- a/drivers/coresight/coresight-tmc.c
+++ b/drivers/coresight/coresight-tmc.c
@@ -760,17 +760,7 @@ static struct amba_driver tmc_driver = {
 	.id_table	= tmc_ids,
 };
 
-static int __init tmc_init(void)
-{
-	return amba_driver_register(&tmc_driver);
-}
-module_init(tmc_init);
-
-static void __exit tmc_exit(void)
-{
-	amba_driver_unregister(&tmc_driver);
-}
-module_exit(tmc_exit);
+module_amba_driver(tmc_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("CoreSight Trace Memory Controller driver");

