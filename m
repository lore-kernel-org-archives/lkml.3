Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaGZW2j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 18:28:39 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52368 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaGZW2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 18:28:38 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: scsi_tgt_if.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 00:30:03 +0200
Message-Id: <1406413803-7917-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are going to use memset before strncpy you must copy sizeof -1

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/scsi_tgt_if.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index 6209110..7dc98eb 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -190,7 +190,7 @@ int scsi_tgt_uspace_send_it_nexus_request(int host_no, u64 itn_id,
 	ev.p.it_nexus_req.itn_id = itn_id;
 	if (initiator_id)
 		strncpy(ev.p.it_nexus_req.initiator_id, initiator_id,
-			sizeof(ev.p.it_nexus_req.initiator_id));
+			sizeof(ev.p.it_nexus_req.initiator_id) - 1);
 
 	dprintk("%d %x %llx\n", host_no, function, (unsigned long long)itn_id);
 
-- 
1.7.10.4

