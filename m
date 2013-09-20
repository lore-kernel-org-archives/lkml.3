Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3ITUPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:15:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41770 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab3ITUP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:15:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 70/93] libceph: use pg_num_mask instead of pgp_num_mask for pg.seed calc
Date: Fri, 20 Sep 2013 13:09:05 -0700
Message-Id: <1379707768-1804-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 9542cf0bf9b1a3adcc2ef271edbcbdba03abf345 upstream.

Fix a typo that used the wrong bitmask for the pg.seed calculation.  This
is normally unnoticed because in most cases pg_num == pgp_num.  It is, however,
a bug that is easily corrected.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <alex.elder@linary.org>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ceph/osdmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index de73214..652c11e 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1128,7 +1128,7 @@ static int *calc_pg_raw(struct ceph_osdmap *osdmap, struct ceph_pg pgid,
 
 	/* pg_temp? */
 	t = ceph_stable_mod(ps, le32_to_cpu(pool->v.pg_num),
-			    pool->pgp_num_mask);
+			    pool->pg_num_mask);
 	pgid.ps = cpu_to_le16(t);
 	pg = __lookup_pg_mapping(&osdmap->pg_temp, pgid);
 	if (pg) {
-- 
1.8.1.2

