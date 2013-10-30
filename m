Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab3J3FXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 01:23:55 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:52005 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3J3FXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 01:23:54 -0400
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 13:23:53 +0800
Message-ID: <CAPgLHd-HqMsv_CAbHUUaOw=3GSZbGXLmYvQVXJVAk5j0JYxdNQ@mail.gmail.com>
Subject: [PATCH -next] skd: fix error return code in skd_pci_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: axboe@kernel.dk, rchinthekindi@stec-inc.com, abhansali@stec-inc.com,
        jmoyer@redhat.com, ramprasad.chinthekindi@hgst.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the skd construct error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/skd_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index ab17bff..1a8717f 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -5321,8 +5321,10 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	skdev = skd_construct(pdev);
-	if (skdev == NULL)
+	if (skdev == NULL) {
+		rc = -ENOMEM;
 		goto err_out_regions;
+	}
 
 	skd_pci_info(skdev, pci_str);
 	pr_info("(%s): %s 64bit\n", skd_name(skdev), pci_str);

