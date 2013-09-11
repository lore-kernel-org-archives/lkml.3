Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3IKFmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:42:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab3IKE5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:14 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=4Dd-U-dHYkYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=wPn_hs0ji9gA:10 a=yPCof4ZbAAAA:8 a=NLZqzBF-AAAA:8 a=VwQbUJbxAAAA:8 a=tmtSDGaQAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=7DSvI1NPTFQA:10 a=_dQi-Dcv4p4A:10 a=jkObVMfX7fAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042920.022634292@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stuart Foster <smf.linux@ntlworld.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [166/251] Dont attempt to send extended INQUIRY command if skip_vpd_pages is
 set
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0166-Don-t-attempt-to-send-extended-INQUIRY-command-if-sk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

[ Upstream commit 7562523e84ddc742fe1f9db8bd76b01acca89f6b ]

If a device has the skip_vpd_pages flag set we should simply fail the
scsi_get_vpd_page() call.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Stuart Foster <smf.linux@ntlworld.com>
Cc: stable@vger.kernel.org
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/scsi/scsi.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2936b44..5dba497 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1030,6 +1030,9 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 {
 	int i, result;
 
+	if (sdev->skip_vpd_pages)
+		goto fail;
+
 	/* Ask for all the pages supported by this device */
 	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
 	if (result)
-- 
1.7.10.4


