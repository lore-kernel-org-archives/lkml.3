Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935040Ab3GWWlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:41:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934684Ab3GWW1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 065/103] SCSI: mpt2sas: fix firmware failure with wrong task attribute
Date: Tue, 23 Jul 2013 15:26:16 -0700
Message-Id: <20130723220426.316016790@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

commit 48ba2efc382f94fae16ca8ca011e5961a81ad1ea upstream.

When SCSI command is received with task attribute not set, set it to SIMPLE.
Previously it is set to untagged. This causes the firmware to fail the commands.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3994,11 +3994,7 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd,
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


