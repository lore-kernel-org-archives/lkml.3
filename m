Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaC2R6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:58:33 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41380 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaC2R6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:58:31 -0400
Date: Sat, 29 Mar 2014 23:28:56 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eddie Wai <eddie.wai@broadcom.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 14/55] scsi: Mark function as static in bnx2fc/bnx2fc_hwi.c
Message-ID: <8c16abbcb9ee06829ac9b528264cfddb316dae2b.1396114898.git.rashika.kheria@gmail.com>
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

Mark function as static in bnx2fc/bnx2fc_hwi.c because it is not used
outside this file.

This eliminates the following warning in bnx2fc/bnx2fc_hwi.c:
drivers/scsi/bnx2fc/bnx2fc_hwi.c:996:21: warning: no previous prototype for ‘bnx2fc_alloc_work’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 46a3765..7f01cda 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -993,7 +993,7 @@ void bnx2fc_arm_cq(struct bnx2fc_rport *tgt)
 
 }
 
-struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe)
+static struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe)
 {
 	struct bnx2fc_work *work;
 	work = kzalloc(sizeof(struct bnx2fc_work), GFP_ATOMIC);
-- 
1.7.9.5

