Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaDRH7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 03:59:05 -0400
Received: from mail.ispras.ru ([83.149.199.45]:57403 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbaDRH7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 03:59:00 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH v2] [SCSI] bfa: allocate memory with GFP_ATOMIC in spinlock context
Date: Fri, 18 Apr 2014 00:58:42 -0700
Message-Id: <1397807922-21722-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bfa_fcb_pbc_vport_create() is called only from bfa_fcs_pbc_vport_init(),
that is called only from bfad_drv_start() with bfad_lock spinlock held.
So the patch replaces GFP_KERNEL with GFP_ATOMIC to avoid
sleeping in atomic spinlock context.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/bfa/bfad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index cc0fbcdc5192..7593b7c1d336 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -507,7 +507,7 @@ bfa_fcb_pbc_vport_create(struct bfad_s *bfad, struct bfi_pbc_vport_s pbc_vport)
 	struct bfad_vport_s   *vport;
 	int rc;
 
-	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_KERNEL);
+	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_ATOMIC);
 	if (!vport) {
 		bfa_trc(bfad, 0);
 		return;
-- 
1.8.3.2

