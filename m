Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab3HNKiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:38:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34675 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457Ab3HNKiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 60/75] [SCSI] Don't attempt to send extended INQUIRY command if skip_vpd_pages is set
Date: Wed, 14 Aug 2013 11:36:49 +0100
Message-Id: <1376476624-10011-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit 7562523e84ddc742fe1f9db8bd76b01acca89f6b upstream.

If a device has the skip_vpd_pages flag set we should simply fail the
scsi_get_vpd_page() call.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Stuart Foster <smf.linux@ntlworld.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/scsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index bbbc9c9..203c7c5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1029,6 +1029,9 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 {
 	int i, result;
 
+	if (sdev->skip_vpd_pages)
+		goto fail;
+
 	/* Ask for all the pages supported by this device */
 	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
 	if (result)
-- 
1.8.3.2

