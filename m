Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934721Ab3GQXFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:05:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56764 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934552Ab3GQW4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 033/145] [SCSI] mpt2sas: fix firmware failure with wrong task attribute
Date: Wed, 17 Jul 2013 15:46:05 -0700
Message-Id: <1374101277-7915-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

commit 48ba2efc382f94fae16ca8ca011e5961a81ad1ea upstream.

When SCSI command is received with task attribute not set, set it to SIMPLE.
Previously it is set to untagged. This causes the firmware to fail the commands.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 01dfbab..c78216c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3998,11 +3998,7 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 			else
 				mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
 		} else
-/* MPI Revision I (UNIT = 0xA) - removed MPI2_SCSIIO_CONTROL_UNTAGGED */
-/*			mpi_control |= MPI2_SCSIIO_CONTROL_UNTAGGED;
- */
-			mpi_control |= (0x500);
-
+			mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
 	} else
 		mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
 	/* Make sure Device is not raid volume.
-- 
1.8.1.2

