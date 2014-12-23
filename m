Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbaLWSCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 13:02:17 -0500
Received: from www.osadl.org ([62.245.132.105]:33813 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502AbaLWSCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 13:02:11 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: iscsi-driver@qlogic.com, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] scsi: unnecessary double init_completion removed
Date: Tue, 23 Dec 2014 18:54:26 +0100
Message-Id: <1419357266-22964-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The double call to init_completion(&ha->disable_acb_comp); looks like
an editing mistake only - dropped.

patch is against 3.18.0 linux-next

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/scsi/qla4xxx/ql4_os.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6d25879..0c1da76 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -8672,7 +8672,6 @@ static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 	init_completion(&ha->disable_acb_comp);
 	init_completion(&ha->idc_comp);
 	init_completion(&ha->link_up_comp);
-	init_completion(&ha->disable_acb_comp);

 	spin_lock_init(&ha->hardware_lock);
 	spin_lock_init(&ha->work_lock);
--
1.7.10.4

