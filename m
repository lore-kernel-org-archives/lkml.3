Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaC2RzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:55:16 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35112 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaC2RzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:55:14 -0400
Date: Sat, 29 Mar 2014 23:25:39 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <agurumur@brocade.com>,
        Vijaya Mohan Guvva <vmohan@brocade.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 11/55] scsi: Mark function as static in bfa/bfa_svc.c
Message-ID: <8c3573b88a2b2d379301d8568852f491b8c5b90b.1396114897.git.rashika.kheria@gmail.com>
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

Mark functions as static in bfa/bfa_svc.c because they are not used
outside this file.

This eliminates the following warning in bfa/bfa_svc.c:
drivers/scsi/bfa/bfa_svc.c:4378:1: warning: no previous prototype for ‘bfa_fcport_ddportenable’ [-Wmissing-prototypes]
drivers/scsi/bfa/bfa_svc.c:4387:1: warning: no previous prototype for ‘bfa_fcport_ddportdisable’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bfa/bfa_svc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 625225f..a8329d3 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -4374,7 +4374,7 @@ bfa_fcport_dportdisable(struct bfa_s *bfa)
 	bfa_port_set_dportenabled(&bfa->modules.port, BFA_FALSE);
 }
 
-void
+static void
 bfa_fcport_ddportenable(struct bfa_s *bfa)
 {
 	/*
@@ -4383,7 +4383,7 @@ bfa_fcport_ddportenable(struct bfa_s *bfa)
 	bfa_sm_send_event(BFA_FCPORT_MOD(bfa), BFA_FCPORT_SM_DDPORTENABLE);
 }
 
-void
+static void
 bfa_fcport_ddportdisable(struct bfa_s *bfa)
 {
 	/*
-- 
1.7.9.5

