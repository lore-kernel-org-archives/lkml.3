Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaELBmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:42:55 -0400
Received: from 1wt.eu ([62.212.114.60]:34645 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbaELBmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:53 -0400
Message-Id: <20140512003206.440691258@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 138/143] aacraid: missing capable() check in compat ioctl
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f856567b930dfcdbc3323261bf77240ccdde01f5 upstream

In commit d496f94d22d1 ('[SCSI] aacraid: fix security weakness') we
added a check on CAP_SYS_RAWIO to the ioctl.  The compat ioctls need the
check as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/scsi/aacraid/linit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 9b97c3e..387872c 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -754,6 +754,8 @@ static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long
 static int aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
 	return aac_compat_do_ioctl(dev, cmd, (unsigned long)arg);
 }
 
-- 
1.7.12.2.21.g234cd45.dirty



