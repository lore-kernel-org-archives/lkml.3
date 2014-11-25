Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbaKYKmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:42:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58696 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaKYKmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 134/254] xen-blkback: fix leak on grant map error path
Date: Tue, 25 Nov 2014 10:38:04 +0000
Message-Id: <1416912004-5928-135-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>

commit 61cecca865280bef4f8a9748d0a9afa5df351ac2 upstream.

Fix leaking a page when a grant mapping has failed.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reported-and-Tested-by: Tao Chen <boby.chen@huawei.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/xen-blkback/blkback.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 64c60edcdfbc..63fc7f06a014 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -763,6 +763,7 @@ again:
 			BUG_ON(new_map_idx >= segs_to_map);
 			if (unlikely(map[new_map_idx].status != 0)) {
 				pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
+				put_free_pages(blkif, &pages[seg_idx]->page, 1);
 				pages[seg_idx]->handle = BLKBACK_INVALID_HANDLE;
 				ret |= 1;
 				goto next;
-- 
2.1.0

