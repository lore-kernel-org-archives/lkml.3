Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbbAIX5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:57:50 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53065 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbbAIX5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:57:38 -0500
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH 03/11] coresight-funnel: use module_amba_driver to simplify the code
Date: Fri,  9 Jan 2015 16:57:14 -0700
Message-Id: <1420847842-31769-4-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420847842-31769-1-git-send-email-mathieu.poirier@linaro.org>
References: <1420847842-31769-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

module_amba_driver() makes the code simpler by eliminating
boilerplate code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/coresight/coresight-funnel.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/coresight/coresight-funnel.c b/drivers/coresight/coresight-funnel.c
index 2108edffe1f4..3db36f70b666 100644
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
-- 
1.9.1

