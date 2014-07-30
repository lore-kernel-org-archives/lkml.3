Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaG3B5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:57:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbaG3BuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.15 08/37] block: provide compat ioctl for BLKZEROOUT
Date: Tue, 29 Jul 2014 18:48:44 -0700
Message-Id: <20140730014828.031369806@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 3b3a1814d1703027f9867d0f5cbbfaf6c7482474 upstream.

This patch provides the compat BLKZEROOUT ioctl. The argument is a pointer
to two uint64_t values, so there is no need to translate it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/compat_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -690,6 +690,7 @@ long compat_blkdev_ioctl(struct file *fi
 	case BLKROSET:
 	case BLKDISCARD:
 	case BLKSECDISCARD:
+	case BLKZEROOUT:
 	/*
 	 * the ones below are implemented in blkdev_locked_ioctl,
 	 * but we call blkdev_ioctl, which gets the lock for us


