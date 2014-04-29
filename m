Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbaD2JcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:32:10 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33851 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaD2JcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:32:06 -0400
Date: Tue, 29 Apr 2014 18:31:37 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: axboe@fb.com
Cc: b.zolnierkie@samsung.com, kyungmin.park@samsung.com, agordeev@redhat.com,
        bhansaliakhil@gmail.com, rchinthekindi@stec-inc.com,
        snitzer@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] skd: remove redundant null check for kfree()
Message-ID: <20140429093136.GA10359@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smatch says:
 skd_acquire_msix() info: redundant null check
on entries calling kfree()

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/block/skd_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

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
1.7.4.4

