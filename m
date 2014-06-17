Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343AbaFQTNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:13:25 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43010 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933053AbaFQTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:13:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQJANiRoFNbsl1t/2dsb2JhbABagw2rKgUBAQEBAQEFAZkmgQ0XdYRgI4EaN4hGAcsyF4VjiRMdhC0EhGMDlV2LMIgog0I7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jens Axboe <axboe@fb.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 1/3] drivers/block/skd_main.c: remove null test before kfree
Date: Tue, 17 Jun 2014 21:12:05 +0200
Message-Id: <1403032325-4861-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Jens Axboe <axboe@fb.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/block/skd_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 608532d..fac4c08 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -3998,8 +3998,7 @@ static int skd_acquire_msix(struct skd_device *skdev)
 	return 0;
 
 msix_out:
-	if (entries)
-		kfree(entries);
+	kfree(entries);
 	skd_release_msix(skdev);
 	return rc;
 }
-- 
1.8.4.5

