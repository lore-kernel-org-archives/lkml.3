Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbaLINNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:13:42 -0500
Received: from m12-14.163.com ([220.181.12.14]:43003 "EHLO m12-14.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757083AbaLINNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:13:40 -0500
X-Coremail-DSSMTP: 117.88.175.67
From: weiyj_lk@163.com
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next] coresight-funnel: use module_amba_driver to simplify the code
Date: Tue,  9 Dec 2014 21:12:58 +0800
Message-Id: <1418130778-26900-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DsCowEBJL1RZ9YZU0iVUAA--.645S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4fKw1DJFy5Zw4xKr1UGFg_yoWDCrc_CF
	Z5WFy7ArykWrW7KF4UGw15ZryYv3Z09rs3Aw1kt393J3s7J3WSkw4DZrW7Aa1kWr4kJFZ2
	yr43Zr1rZr1UtjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUn4E_tUUUUU==
X-Originating-IP: [117.88.175.67]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiRwdd1lD+XfQSxAAAsa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

module_amba_driver() makes the code simpler by eliminating
boilerplate code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/coresight/coresight-funnel.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/coresight/coresight-funnel.c b/drivers/coresight/coresight-funnel.c
index 2108edf..3db36f7 100644
--- a/drivers/coresight/coresight-funnel.c
+++ b/drivers/coresight/coresight-funnel.c
@@ -252,17 +252,7 @@ static struct amba_driver funnel_driver = {
 	.id_table	= funnel_ids,
 };
 
-static int __init funnel_init(void)
-{
-	return amba_driver_register(&funnel_driver);
-}
-module_init(funnel_init);
-
-static void __exit funnel_exit(void)
-{
-	amba_driver_unregister(&funnel_driver);
-}
-module_exit(funnel_exit);
+module_amba_driver(funnel_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("CoreSight Funnel driver");

