Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbaFANHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:07:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36162 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaFANHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:07:45 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: mpt3sas_transport.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:08:37 +0200
Message-Id: <1401628118-17506-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 65170cb..f648dc4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -305,8 +305,8 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 	void *data_out = NULL;
 	dma_addr_t data_out_dma;
 	dma_addr_t data_in_dma;
-	size_t data_in_sz;
-	size_t data_out_sz;
+	size_t data_in_sz = sizeof(struct rep_manu_reply);
+	size_t data_out_sz = sizeof(struct rep_manu_request);
 	u16 wait_state_count;
 
 	if (ioc->shost_recovery || ioc->pci_error_recovery) {
@@ -357,8 +357,6 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	ioc->transport_cmds.smid = smid;
 
-	data_out_sz = sizeof(struct rep_manu_request);
-	data_in_sz = sizeof(struct rep_manu_reply);
 	data_out = pci_alloc_consistent(ioc->pdev, data_out_sz + data_in_sz,
 	    &data_out_dma);
 
-- 
1.7.10.4

