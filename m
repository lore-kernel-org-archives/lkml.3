Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799AbaFQTNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:13:54 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:61388 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932892AbaFQTNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:13:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQJAJuSoFNbsl1t/2dsb2JhbABagw2rKgUBAQEBAQEFAZkmgQ0XdYRgI4EaN4hGAcswF4VjiC9kHYQtBIRjA5VdizCIKINCO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jens Axboe <axboe@fb.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 2/3] drivers/block/skd_main.c: replace count*size kzalloc by kcalloc
Date: Tue, 17 Jun 2014 21:12:35 +0200
Message-Id: <1403032355-4932-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Jens Axboe <axboe@fb.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/block/skd_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index fac4c08..1756d26d 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -3936,7 +3936,7 @@ static int skd_acquire_msix(struct skd_device *skdev)
 	struct msix_entry *entries;
 	struct skd_msix_entry *qentry;
 
-	entries = kzalloc(sizeof(struct msix_entry) * SKD_MAX_MSIX_COUNT,
+	entries = kcalloc(SKD_MAX_MSIX_COUNT, sizeof(struct msix_entry),
 			  GFP_KERNEL);
 	if (!entries)
 		return -ENOMEM;
-- 
1.8.4.5

