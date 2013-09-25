Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab3IYARJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:17:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3IYARH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:17:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sage Weil <sage@inktank.com>, Alex Elder <alex.elder@linary.org>
Subject: [ 100/110] libceph: use pg_num_mask instead of pgp_num_mask for pg.seed calc
Date: Tue, 24 Sep 2013 17:15:38 -0700
Message-Id: <20130925001334.254867117@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 9542cf0bf9b1a3adcc2ef271edbcbdba03abf345 upstream.

Fix a typo that used the wrong bitmask for the pg.seed calculation.  This
is normally unnoticed because in most cases pg_num == pgp_num.  It is, however,
a bug that is easily corrected.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <alex.elder@linary.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/osdmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1129,7 +1129,7 @@ static int *calc_pg_raw(struct ceph_osdm
 
 	/* pg_temp? */
 	pgid.seed = ceph_stable_mod(pgid.seed, pool->pg_num,
-				    pool->pgp_num_mask);
+				    pool->pg_num_mask);
 	pg = __lookup_pg_mapping(&osdmap->pg_temp, pgid);
 	if (pg) {
 		*num = pg->len;


