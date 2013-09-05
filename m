Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763304Ab3IEHDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 03:03:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13152 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757517Ab3IEHDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:03:15 -0400
X-IronPort-AV: E=Sophos;i="4.90,845,1371052800"; 
   d="scan'208";a="8420180"
Message-ID: <52282C86.9050306@cn.fujitsu.com>
Date: Thu, 05 Sep 2013 15:02:30 +0800
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: dwmw2@infradead.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: bcm47xxsflash: the argument to kfree should not be the
 address of a structure field
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/05 15:00:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/05 15:00:59,
	Serialize complete at 2013/09/05 15:00:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/mtd/devices/bcm47xxsflash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/bcm47xxsflash.c b/drivers/mtd/devices/bcm47xxsflash.c
index 18e7761..9b8aaf3 100644
--- a/drivers/mtd/devices/bcm47xxsflash.c
+++ b/drivers/mtd/devices/bcm47xxsflash.c
@@ -87,7 +87,7 @@ static int bcm47xxsflash_bcma_probe(struct platform_device *pdev)
 	return 0;
 
 err_dev_reg:
-	kfree(&b47s->mtd);
+	kfree(b47s);
 out:
 	return err;
 }
-- 
1.8.3.1
