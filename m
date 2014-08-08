Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbaHHUpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:45:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40339 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaHHUpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:45:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@fb.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 160/259] block: provide compat ioctl for BLKZEROOUT
Date: Fri,  8 Aug 2014 13:39:43 -0700
Message-Id: <1407530482-4483-161-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 3b3a1814d1703027f9867d0f5cbbfaf6c7482474 upstream.

This patch provides the compat BLKZEROOUT ioctl. The argument is a pointer
to two uint64_t values, so there is no need to translate it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 block/compat_ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index fbd5a67..a0926a6 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -690,6 +690,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case BLKROSET:
 	case BLKDISCARD:
 	case BLKSECDISCARD:
+	case BLKZEROOUT:
 	/*
 	 * the ones below are implemented in blkdev_locked_ioctl,
 	 * but we call blkdev_ioctl, which gets the lock for us
-- 
1.9.1

