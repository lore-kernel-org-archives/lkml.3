Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbaDKIF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:05:59 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:10475 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750817AbaDKIFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:05:55 -0400
X-IronPort-AV: E=Sophos;i="4.97,839,1389715200"; 
   d="scan'208";a="29139976"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: <gregkh@linuxfoundation.org>, <jg1.han@samsung.com>,
        <paul.gortmaker@windriver.com>, <broonie@linaro.org>,
        <b.zolnierkie@samsung.com>
CC: <linux-kernel@vger.kernel.org>, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] drivers/misc: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Fri, 11 Apr 2014 16:03:58 +0800
Message-ID: <1397203438-17199-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/misc/carma/carma-fpga.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 14d90ea..55e913b 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -954,10 +954,7 @@ static int data_debugfs_init(struct fpga_device *priv)
 {
 	priv->dbg_entry = debugfs_create_file(drv_name, S_IRUGO, NULL, priv,
 					      &data_debug_fops);
-	if (IS_ERR(priv->dbg_entry))
-		return PTR_ERR(priv->dbg_entry);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(priv->dbg_entry);
 }
 
 static void data_debugfs_exit(struct fpga_device *priv)
-- 
1.8.3.1

