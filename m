Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbaDHEps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 00:45:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45667 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbaDHEpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 00:45:47 -0400
Date: Mon, 7 Apr 2014 21:44:07 -0700
From: Kees Cook <keescook@chromium.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ubi: avoid workqueue format string leak
Message-ID: <20140408044407.GA13141@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building the name for the workqueue thread, make sure a format
string cannot leak in from the disk name.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/mtd/ubi/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 7ff473c871a9..8d659e6a1b4c 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -431,7 +431,7 @@ int ubiblock_create(struct ubi_volume_info *vi)
 	 * Create one workqueue per volume (per registered block device).
 	 * Rembember workqueues are cheap, they're not threads.
 	 */
-	dev->wq = alloc_workqueue(gd->disk_name, 0, 0);
+	dev->wq = alloc_workqueue("%s", 0, 0, gd->disk_name);
 	if (!dev->wq)
 		goto out_free_queue;
 	INIT_WORK(&dev->work, ubiblock_do_work);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
