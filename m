Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab3I3KNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:13:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43758 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab3I3KNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 083/104] libceph: use pg_num_mask instead of pgp_num_mask for pg.seed calc
Date: Mon, 30 Sep 2013 11:11:00 +0100
Message-Id: <1380535881-9239-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 9542cf0bf9b1a3adcc2ef271edbcbdba03abf345 upstream.

Fix a typo that used the wrong bitmask for the pg.seed calculation.  This
is normally unnoticed because in most cases pg_num == pgp_num.  It is, however,
a bug that is easily corrected.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <alex.elder@linary.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/osdmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index d10a72b..dfedfd8 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1064,7 +1064,7 @@ static int *calc_pg_raw(struct ceph_osdmap *osdmap, struct ceph_pg pgid,
 
 	/* pg_temp? */
 	t = ceph_stable_mod(ps, le32_to_cpu(pool->v.pg_num),
-			    pool->pgp_num_mask);
+			    pool->pg_num_mask);
 	pgid.ps = cpu_to_le16(t);
 	pg = __lookup_pg_mapping(&osdmap->pg_temp, pgid);
 	if (pg) {
-- 
1.8.3.2

