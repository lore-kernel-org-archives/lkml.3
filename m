Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab3E1VYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:24:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59645 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758461Ab3E1VY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:24:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Alasdair G Kergon <agk@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 33/78] dm snapshot: fix error return code in snapshot_ctr
Date: Tue, 28 May 2013 14:19:42 -0700
Message-Id: <1369776027-17859-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 09e8b813897a0f85bb401435d009228644c81214 upstream.

Return -ENOMEM instead of success if unable to allocate pending
exception mempool in snapshot_ctr.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-snap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index df74f9f..900eb23 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1119,6 +1119,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->pending_pool = mempool_create_slab_pool(MIN_IOS, pending_cache);
 	if (!s->pending_pool) {
 		ti->error = "Could not allocate mempool for pending exceptions";
+		r = -ENOMEM;
 		goto bad_pending_pool;
 	}
 
-- 
1.8.1.2

