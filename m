Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaGVA6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:58:13 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:32580 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbaGVA6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:58:12 -0400
From: Guillaume Morin <guillaume@morinfr.org>
To: gregkh@linuxfoundation.org
Cc: Guillaume Morin <guillaume@morinfr.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, oleg.drokin@intel.com,
        jinshan.xiong@intel.com, lai.siyao@intel.com, joe@perches.com,
        bergwolf@gmail.com, john.hammond@intel.com, sachin.kamat@linaro.org
Subject: [PATCH] staging: llite: rw.c: use gfp_t to store GFP flags
Date: Tue, 22 Jul 2014 02:57:57 +0200
Message-Id: <22be101821a4af2c92ca597832cbb720c655418e.1405990074.git.guillaume@morinfr.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gfp_t to store GPF_* flags instead of unsigned int. 
This was reported by sparse.

Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
---
 drivers/staging/lustre/lustre/llite/rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/rw.c b/drivers/staging/lustre/lustre/llite/rw.c
index 5616210..3554272 100644
--- a/drivers/staging/lustre/lustre/llite/rw.c
+++ b/drivers/staging/lustre/lustre/llite/rw.c
@@ -496,7 +496,7 @@ static int ll_read_ahead_page(const struct lu_env *env, struct cl_io *io,
 	struct cl_object *clob  = ll_i2info(mapping->host)->lli_clob;
 	struct cl_page   *page;
 	enum ra_stat      which = _NR_RA_STAT; /* keep gcc happy */
-	unsigned int      gfp_mask;
+	gfp_t             gfp_mask;
 	int	       rc    = 0;
 	const char       *msg   = NULL;
 
-- 
1.9.1

