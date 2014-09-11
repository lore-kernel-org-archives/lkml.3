Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaIKNEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:04:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980AbaIKNEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:14 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Zheng Liu" <wenqing.lz@taobao.com>,
        "Zheng Liu" <gnehzuil.liu@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.701966010@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 033/131] ext4: cleanup in ext4_discard_allocated_blocks()
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Liu <gnehzuil.liu@gmail.com>

commit 400db9d30146dc062aaba97a6301b425eb6015bc upstream.

remove 'len' variable in ext4_discard_allocated_blocks() because it is
useless.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/mballoc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3128,13 +3128,9 @@ static void ext4_mb_collect_stats(struct
 static void ext4_discard_allocated_blocks(struct ext4_allocation_context *ac)
 {
 	struct ext4_prealloc_space *pa = ac->ac_pa;
-	int len;
-
-	if (pa && pa->pa_type == MB_INODE_PA) {
-		len = ac->ac_b_ex.fe_len;
-		pa->pa_free += len;
-	}
 
+	if (pa && pa->pa_type == MB_INODE_PA)
+		pa->pa_free += ac->ac_b_ex.fe_len;
 }
 
 /*

