Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab3GKO0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:26:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43102 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921Ab3GKO0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 58/98] [SCSI] mpt2sas: fix firmware failure with wrong task attribute
Date: Thu, 11 Jul 2013 15:24:28 +0100
Message-Id: <1373552708-15235-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

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
index 9cfe117..4d8bd35 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3999,11 +3999,7 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
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

