Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaC2R4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:56:14 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:38493 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbaC2R4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:56:12 -0400
Date: Sat, 29 Mar 2014 23:26:36 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eddie Wai <eddie.wai@broadcom.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 12/55] scsi: Mark function as static in bnx2fc/bnx2fc_els.c
Message-ID: <9fe78fd25af3c2f7623075c50d4f01a63b0d2286.1396114897.git.rashika.kheria@gmail.com>
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

Mark functions as static in bnx2fc/bnx2fc_els.c because they are not
used outside this file.

This eliminates the following warning in bnx2fc/bnx2fc_els.c:
drivers/scsi/bnx2fc/bnx2fc_els.c:256:6: warning: no previous prototype for ‘bnx2fc_srr_compl’ [-Wmissing-prototypes]
drivers/scsi/bnx2fc/bnx2fc_els.c:366:6: warning: no previous prototype for ‘bnx2fc_rec_compl’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bnx2fc/bnx2fc_els.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index b1c9a4f..3121da5 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -253,7 +253,7 @@ int bnx2fc_send_rls(struct bnx2fc_rport *tgt, struct fc_frame *fp)
 	return rc;
 }
 
-void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
+static void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
 {
 	struct bnx2fc_mp_req *mp_req;
 	struct fc_frame_header *fc_hdr, *fh;
@@ -363,7 +363,7 @@ srr_compl_done:
 	kref_put(&orig_io_req->refcount, bnx2fc_cmd_release);
 }
 
-void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg *cb_arg)
+static void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg *cb_arg)
 {
 	struct bnx2fc_cmd *orig_io_req, *new_io_req;
 	struct bnx2fc_cmd *rec_req;
-- 
1.7.9.5

