Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaC2SAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:00:35 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:49877 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaC2SAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:00:33 -0400
Date: Sat, 29 Mar 2014 23:30:59 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rashika Kheria <rashika.kheria@gmail.com>, linux-scsi@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 16/55] scsi: Mark function as static in cxgbi/libcxgbi.c
Message-ID: <362da499bafb18e192a6d31a689f1b5aeddfbf5d.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in cxgbi/libcxgbi.c because it is not used
outside this file.

This eliminates the following warning in cxgbi/libcxgbi.c:
drivers/scsi/cxgbi/libcxgbi.c:1307:5: warning: no previous prototype for ‘cxgbi_ddp_reserve’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/cxgbi/libcxgbi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index b44c1cf..db6bf76 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1304,7 +1304,7 @@ unmark_entries:
 	return err;
 }
 
-int cxgbi_ddp_reserve(struct cxgbi_sock *csk, unsigned int *tagp,
+static int cxgbi_ddp_reserve(struct cxgbi_sock *csk, unsigned int *tagp,
 			unsigned int sw_tag, unsigned int xferlen,
 			struct scatterlist *sgl, unsigned int sgcnt, gfp_t gfp)
 {
-- 
1.7.9.5

