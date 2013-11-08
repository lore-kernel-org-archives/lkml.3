Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab3KHCSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:18:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34573 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab3KHCQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:22 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 85/91] aacraid: missing capable() check in compat ioctl
Date: Thu,  7 Nov 2013 18:15:40 -0800
Message-Id: <1383876946-2396-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f856567b930dfcdbc3323261bf77240ccdde01f5 upstream.

In commit d496f94d22d1 ('[SCSI] aacraid: fix security weakness') we
added a check on CAP_SYS_RAWIO to the ioctl.  The compat ioctls need the
check as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/aacraid/linit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 408a42e..f0d432c 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -771,6 +771,8 @@ static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long
 static int aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
 	return aac_compat_do_ioctl(dev, cmd, (unsigned long)arg);
 }
 
-- 
1.8.1.2

