Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaG3M0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:26:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36773 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986AbaG3MPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 79/94] block: provide compat ioctl for BLKZEROOUT
Date: Wed, 30 Jul 2014 14:15:08 +0200
Message-Id: <be8e93639cc104bf9da5eee99f3cbd63ce8c6c7c.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3b3a1814d1703027f9867d0f5cbbfaf6c7482474 upstream.

This patch provides the compat BLKZEROOUT ioctl. The argument is a pointer
to two uint64_t values, so there is no need to translate it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 block/compat_ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index fbd5a67cb773..a0926a6094b2 100644
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
2.0.1

