Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaDZSzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 14:55:24 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:15183 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbaDZSzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 14:55:23 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcVAOP/W1NXQBKy/2dsb2JhbABYgwaCQKlAAwEBAgEEAZlyAgKBChd0glMTHCMYgQIkE4hFAcl6hVqIG2SEQAEDjnyKDwGSXoMzO4Es
Date: Sat, 26 Apr 2014 20:57:23 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/1] fs/gfs2/lops.c: replace 0 by NULL for pointers
Message-Id: <20140426205723.35360f20c80bd33d96c4863d@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse warning: fs/gfs2/lops.c:78:29:
"warning: Using plain integer as NULL pointer"

Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/gfs2/lops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index a294d8d..2c1ae86 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -75,7 +75,7 @@ static void maybe_release_space(struct gfs2_bufdata *bd)
 	unsigned int index = bd->bd_bh->b_blocknr - gl->gl_name.ln_number;
 	struct gfs2_bitmap *bi = rgd->rd_bits + index;
 
-	if (bi->bi_clone == 0)
+	if (bi->bi_clone == NULL)
 		return;
 	if (sdp->sd_args.ar_discard)
 		gfs2_rgrp_send_discards(sdp, rgd->rd_data0, bd->bd_bh, bi, 1, NULL);
-- 
1.8.4.5

