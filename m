Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaC2R72 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:59:28 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:44418 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaC2R70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:59:26 -0400
Date: Sat, 29 Mar 2014 23:29:51 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eddie Wai <eddie.wai@broadcom.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 15/55] scsi: Mark function as static in bnx2fc/bnx2fc_io.c
Message-ID: <298b96ea3d7f1ca5b5e91af6d76928f7ff046e4d.1396114898.git.rashika.kheria@gmail.com>
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

Mark function as static in bnx2fc/bnx2fc_io.c because it is not used
outside this file.

This eliminates the following warning in bnx2fc/bnx2fc_io.c:
drivers/scsi/bnx2fc/bnx2fc_io.c:1108:5: warning: no previous prototype for ‘bnx2fc_expl_logo’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index ed88089..dfa72bf 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1105,7 +1105,7 @@ int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	return bnx2fc_initiate_tmf(sc_cmd, FCP_TMF_LUN_RESET);
 }
 
-int bnx2fc_expl_logo(struct fc_lport *lport, struct bnx2fc_cmd *io_req)
+static int bnx2fc_expl_logo(struct fc_lport *lport, struct bnx2fc_cmd *io_req)
 {
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	struct fc_rport_priv *rdata = tgt->rdata;
-- 
1.7.9.5

