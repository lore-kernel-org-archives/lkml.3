Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaGVCWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:22:31 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:13004 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaGVCWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:22:30 -0400
From: Guillaume Morin <guillaume@morinfr.org>
To: gregkh@linuxfoundation.org
Cc: Guillaume Morin <guillaume@morinfr.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, oleg.drokin@intel.com,
        jinshan.xiong@intel.com, lai.siyao@intel.com, joe@perches.com,
        bergwolf@gmail.com, john.hammond@intel.com, sachin.kamat@linaro.org
Subject: [PATCH v2] staging: llite: rw.c: remove gfp_mask
Date: Tue, 22 Jul 2014 04:22:26 +0200
Message-Id: <d7c7a82154ca67654f1e6e76f341dce04a513e15.1405995367.git.guillaume@morinfr.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse reported that gfp_mask was of the wrong type to store gfp flags.  The
variable is not used so it can be removed.

Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
Suggested-by: gregkh@linuxfoundation.org
---
v2: remove the variable instead of just fixing the type since it is not used

 drivers/staging/lustre/lustre/llite/rw.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/rw.c b/drivers/staging/lustre/lustre/llite/rw.c
index 5616210..1b5416f 100644
--- a/drivers/staging/lustre/lustre/llite/rw.c
+++ b/drivers/staging/lustre/lustre/llite/rw.c
@@ -496,14 +496,9 @@ static int ll_read_ahead_page(const struct lu_env *env, struct cl_io *io,
 	struct cl_object *clob  = ll_i2info(mapping->host)->lli_clob;
 	struct cl_page   *page;
 	enum ra_stat      which = _NR_RA_STAT; /* keep gcc happy */
-	unsigned int      gfp_mask;
 	int	       rc    = 0;
 	const char       *msg   = NULL;
 
-	gfp_mask = GFP_HIGHUSER & ~__GFP_WAIT;
-#ifdef __GFP_NOWARN
-	gfp_mask |= __GFP_NOWARN;
-#endif
 	vmpage = grab_cache_page_nowait(mapping, index);
 	if (vmpage != NULL) {
 		/* Check if vmpage was truncated or reclaimed */
-- 
1.9.1

