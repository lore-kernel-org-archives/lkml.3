Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab3KYNYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:24:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57083 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab3KYNHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 29/78] aacraid: missing capable() check in compat ioctl
Date: Mon, 25 Nov 2013 13:06:16 +0000
Message-Id: <1385384825-21681-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f856567b930dfcdbc3323261bf77240ccdde01f5 upstream.

In commit d496f94d22d1 ('[SCSI] aacraid: fix security weakness') we
added a check on CAP_SYS_RAWIO to the ioctl.  The compat ioctls need the
check as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/aacraid/linit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 0d279c44..e9313f8 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -777,6 +777,8 @@ static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long
 static int aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
 	return aac_compat_do_ioctl(dev, cmd, (unsigned long)arg);
 }
 
-- 
1.8.3.2

