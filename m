Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab3KIGyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:54:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985Ab3KIGxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:53:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.11 66/94] aacraid: missing capable() check in compat ioctl
Date: Fri,  8 Nov 2013 22:52:12 -0800
Message-Id: <20131109065208.942380192@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f856567b930dfcdbc3323261bf77240ccdde01f5 upstream.

In commit d496f94d22d1 ('[SCSI] aacraid: fix security weakness') we
added a check on CAP_SYS_RAWIO to the ioctl.  The compat ioctls need the
check as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/aacraid/linit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -771,6 +771,8 @@ static long aac_compat_do_ioctl(struct a
 static int aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
 	return aac_compat_do_ioctl(dev, cmd, (unsigned long)arg);
 }
 


