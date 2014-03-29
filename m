Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaC2Rpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:45:42 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59492 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaC2Rpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:45:40 -0400
Date: Sat, 29 Mar 2014 23:16:05 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <agurumur@brocade.com>,
        Vijaya Mohan Guvva <vmohan@brocade.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 04/55] scsi: Mark function as static in bfa/bfad_attr.c
Message-ID: <2578f45ed96f8d4eb6af5b4d96e14208fb55a0b1.1396114897.git.rashika.kheria@gmail.com>
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

Mark functions as static in bfa/bfad_attr.c because they are not used
outside this file.

This eliminates the following warning in bfa/bfad_attr.c:
drivers/scsi/bfa/bfad_attr.c:446:1: warning: no previous prototype for ‘bfad_im_issue_fc_host_lip’ [-Wmissing-prototypes]
drivers/scsi/bfa/bfad_attr.c:574:1: warning: no previous prototype for ‘bfad_im_vport_set_symbolic_name’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bfa/bfad_attr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 40be670..9937ce3 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -442,7 +442,7 @@ bfad_im_vport_create(struct fc_vport *fc_vport, bool disable)
 	return status;
 }
 
-int
+static int
 bfad_im_issue_fc_host_lip(struct Scsi_Host *shost)
 {
 	struct bfad_im_port_s *im_port =
@@ -570,7 +570,7 @@ bfad_im_vport_disable(struct fc_vport *fc_vport, bool disable)
 	return 0;
 }
 
-void
+static void
 bfad_im_vport_set_symbolic_name(struct fc_vport *fc_vport)
 {
 	struct bfad_vport_s *vport = (struct bfad_vport_s *)fc_vport->dd_data;
-- 
1.7.9.5

