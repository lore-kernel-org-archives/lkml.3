Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaHEA61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 20:58:27 -0400
Received: from s87.loopia.se ([194.9.94.112]:16630 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbaHEA60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 20:58:26 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: sivanich@sgi.com, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 1/1] gru: fix %d confusingly prefixed with 0x in format string
Date: Mon,  4 Aug 2014 17:58:05 -0700
Message-Id: <1407200285-10544-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <20140804133037.GA31042@sgi.com>
References: <20140804133037.GA31042@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/misc/sgi-gru/grumain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
index ae16c8c..161a940 100644
--- a/drivers/misc/sgi-gru/grumain.c
+++ b/drivers/misc/sgi-gru/grumain.c
@@ -283,7 +283,7 @@ static void gru_unload_mm_tracker(struct gru_state *gru,
 	spin_lock(&gru->gs_asid_lock);
 	BUG_ON((asids->mt_ctxbitmap & ctxbitmap) != ctxbitmap);
 	asids->mt_ctxbitmap ^= ctxbitmap;
-	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%d, asidmap 0x%lx\n",
+	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum %d, asidmap 0x%lx\n",
 		gru->gs_gid, gts, gms, gts->ts_ctxnum, gms->ms_asidmap[0]);
 	spin_unlock(&gru->gs_asid_lock);
 	spin_unlock(&gms->ms_asid_lock);
-- 
2.0.0.526.g5318336

