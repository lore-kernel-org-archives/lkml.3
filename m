Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbaLINNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:13:34 -0500
Received: from m12-15.163.com ([220.181.12.15]:39636 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057AbaLINNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:13:32 -0500
X-Coremail-DSSMTP: 117.88.175.67
From: weiyj_lk@163.com
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next] coresight-etb: use module_amba_driver to simplify the code
Date: Tue,  9 Dec 2014 21:12:39 +0800
Message-Id: <1418130759-25489-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: D8CowECZaElI9YZUPFCjBA--.22S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4fKw1DJFy5Zw4xZFW5Wrg_yoWDWrg_CF
	Z2qF9Fqry8u3W7KF4UGwn8Zw1YvFn8urs3ZFWrtFZ3G3srZw1Syr4DXrW7ua18Gw4kJa1D
	KFW7Jr1rZw1ktjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUns0ePUUUUU==
X-Originating-IP: [117.88.175.67]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiGQtd1lEAQCV05AAAs9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

module_amba_driver() makes the code simpler by eliminating
boilerplate code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/coresight/coresight-etb10.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/coresight/coresight-etb10.c b/drivers/coresight/coresight-etb10.c
index c922d4a..a1da702 100644
--- a/drivers/coresight/coresight-etb10.c
+++ b/drivers/coresight/coresight-etb10.c
@@ -521,17 +521,7 @@ static struct amba_driver etb_driver = {
 	.id_table	= etb_ids,
 };
 
-static int __init etb_init(void)
-{
-	return amba_driver_register(&etb_driver);
-}
-module_init(etb_init);
-
-static void __exit etb_exit(void)
-{
-	amba_driver_unregister(&etb_driver);
-}
-module_exit(etb_exit);
+module_amba_driver(etb_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("CoreSight Embedded Trace Buffer driver");

