Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaENVg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:36:56 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:63595 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaENVfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:35:21 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 07/11] block: Make partitions inherit namespace from whole disk device
Date: Wed, 14 May 2014 16:34:55 -0500
Message-Id: <1400103299-144589-8-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When adding block devices for paritions the devices default to
ownership by init_user_ns. Instead assign them to the same
namespace as the device for the whole disk.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 block/partition-generic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index 789cdea05893..7c1c83a072a6 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -17,6 +17,7 @@
 #include <linux/ctype.h>
 #include <linux/genhd.h>
 #include <linux/blktrace_api.h>
+#include <linux/user_namesapce.h>
 
 #include "partitions/check.h"
 
@@ -325,6 +326,7 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	pdev->class = &block_class;
 	pdev->type = &part_type;
 	pdev->parent = ddev;
+	dev_set_ns(pdev, ddev->ns);
 
 	err = blk_alloc_devt(p, &devt);
 	if (err)
-- 
1.9.1

