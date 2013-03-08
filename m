Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab3CHMC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:02:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41505 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab3CHMC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:02:56 -0500
Date: Fri, 8 Mar 2013 15:01:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] bfa: Use GFP_ATOMIC under spin_lock
Message-ID: <20130308120115.GA18712@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is always called with spinlocks held so it should use
GFP_ATOMIC.  The call tree is:

-> bfad_drv_start()
   Takes spin_lock_irqsave(&bfad->bfad_lock, flags);
   -> bfa_fcs_pbc_vport_init()
      -> bfa_fcb_pbc_vport_create()

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index a5f7690..d144a06 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -491,7 +491,7 @@ bfa_fcb_pbc_vport_create(struct bfad_s *bfad, struct bfi_pbc_vport_s pbc_vport)
 	struct bfad_vport_s   *vport;
 	int rc;
 
-	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_KERNEL);
+	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_ATOMIC);
 	if (!vport) {
 		bfa_trc(bfad, 0);
 		return;
