Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab3HMGdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:33:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab3HMGdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stuart Foster <smf.linux@ntlworld.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 01/60] SCSI: Dont attempt to send extended INQUIRY command if skip_vpd_pages is set
Date: Mon, 12 Aug 2013 23:33:28 -0700
Message-Id: <20130813063332.096498852@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit 7562523e84ddc742fe1f9db8bd76b01acca89f6b upstream.

If a device has the skip_vpd_pages flag set we should simply fail the
scsi_get_vpd_page() call.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Stuart Foster <smf.linux@ntlworld.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1031,6 +1031,9 @@ int scsi_get_vpd_page(struct scsi_device
 {
 	int i, result;
 
+	if (sdev->skip_vpd_pages)
+		goto fail;
+
 	/* Ask for all the pages supported by this device */
 	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
 	if (result)


