Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3JKEkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 00:40:23 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:55166 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3JKEkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 00:40:22 -0400
MIME-Version: 1.0
Date: Fri, 11 Oct 2013 12:40:21 +0800
Message-ID: <CAPgLHd_vT4cJ1F1a6TDzYb2LFSb-me90K58K22Z=ae3VsOfbng@mail.gmail.com>
Subject: [PATCH] mtg: docg3: use free_bch() instead of kfree()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com, jg1.han@samsung.com,
        dan.carpenter@oracle.com, robert.jarzmik@free.fr
Cc: yongjun_wei@trendmicro.com.cn, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use free_bch() instead of kfree() to free init_bch()
allocated data.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mtd/devices/docg3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 3e1b0a0..4f091c1 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -2097,7 +2097,7 @@ notfound:
 	ret = -ENODEV;
 	dev_info(dev, "No supported DiskOnChip found\n");
 err_probe:
-	kfree(cascade->bch);
+	free_bch(cascade->bch);
 	for (floor = 0; floor < DOC_MAX_NBFLOORS; floor++)
 		if (cascade->floors[floor])
 			doc_release_device(cascade->floors[floor]);

