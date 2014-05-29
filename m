Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbaE2FmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:42:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbaE2Eeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sumit Saxena <sumit.saxena@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.14 003/140] SCSI: megaraid: missing bounds check in mimd_to_kioc()
Date: Wed, 28 May 2014 21:32:22 -0700
Message-Id: <20140529043050.024592974@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3de2260140417759c669d391613d583baf03b0cf upstream.

pthru32->dataxferlen comes from the user so we need to check that it's
not too large so we don't overflow the buffer.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/megaraid/megaraid_mm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -486,6 +486,8 @@ mimd_to_kioc(mimd_t __user *umimd, mraid
 
 	pthru32->dataxferaddr	= kioc->buf_paddr;
 	if (kioc->data_dir & UIOC_WR) {
+		if (pthru32->dataxferlen > kioc->xferlen)
+			return -EINVAL;
 		if (copy_from_user(kioc->buf_vaddr, kioc->user_data,
 						pthru32->dataxferlen)) {
 			return (-EFAULT);


