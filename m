Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbaGBQq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:46:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbaGBQq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:46:28 -0400
Date: Wed, 2 Jul 2014 12:46:23 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: provide compat ioctl for BLKZEROOUT
Message-ID: <alpine.LRH.2.02.1407021244360.20183@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the compat BLKZEROOUT ioctl. The argument is a pointer
to two uint64_t values, so there is no need to translate it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# 3.7+

---
 block/compat_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-3.16-rc3/block/compat_ioctl.c
===================================================================
--- linux-3.16-rc3.orig/block/compat_ioctl.c	2014-07-02 18:19:02.000000000 +0200
+++ linux-3.16-rc3/block/compat_ioctl.c	2014-07-02 18:19:37.000000000 +0200
@@ -690,6 +690,7 @@ long compat_blkdev_ioctl(struct file *fi
 	case BLKROSET:
 	case BLKDISCARD:
 	case BLKSECDISCARD:
+	case BLKZEROOUT:
 	/*
 	 * the ones below are implemented in blkdev_locked_ioctl,
 	 * but we call blkdev_ioctl, which gets the lock for us
