Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaHRJfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:35:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42760 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaHRJe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 065/137] block: provide compat ioctl for BLKZEROOUT
Date: Mon, 18 Aug 2014 10:32:06 +0100
Message-Id: <1408354398-10226-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 3b3a1814d1703027f9867d0f5cbbfaf6c7482474 upstream.

This patch provides the compat BLKZEROOUT ioctl. The argument is a pointer
to two uint64_t values, so there is no need to translate it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/compat_ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 7e5d474dc6ba..351ba4f9d4eb 100644
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

