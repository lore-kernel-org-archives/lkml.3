Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab3CNPTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:19:48 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:51822 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998Ab3CNPTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:19:46 -0400
MIME-Version: 1.0
Date: Thu, 14 Mar 2013 23:19:45 +0800
Message-ID: <CAPgLHd-8dxVHPbeZgcSu3XcyJozuws5YUftDO3W9W1OQVGy1Kw@mail.gmail.com>
Subject: [PATCH] cciss: fix invalid use of sizeof in cciss_find_cfgtables()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mike.miller@hp.com, scameron@beardog.cce.hp.com, axboe@kernel.dk,
        akpm@linux-foundation.org
Cc: yongjun_wei@trendmicro.com.cn, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

sizeof() when applied to a pointer typed expression gives the
size of the pointer, not that of the pointed data.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/cciss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ade58bc..1c1b8e5 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4206,7 +4206,7 @@ static int cciss_find_cfgtables(ctlr_info_t *h)
 	if (rc)
 		return rc;
 	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
-		cfg_base_addr_index) + cfg_offset, sizeof(h->cfgtable));
+		cfg_base_addr_index) + cfg_offset, sizeof(*h->cfgtable));
 	if (!h->cfgtable)
 		return -ENOMEM;
 	rc = write_driver_ver_to_cfgtable(h->cfgtable);


