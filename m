Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3LSJiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:38:20 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34946 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3LSJiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:38:17 -0500
Date: Thu, 19 Dec 2013 15:07:47 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        josh@joshtriplett.org
Subject: [PATCH 05/13] drivers: block: Move prototype declaration to
 appropriate header file from drbd_main.c
Message-ID: <abcddebb1d8f39a081838be28fb29c77a3611d45.1387445396.git.rashika.kheria@gmail.com>
References: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration of functions drbdd_init() and drbd_asender()
from drbd/drbd_main.c to header file drbd/drbd_int.h because these
functions are used by more than one file.

This eliminates the following warning in drbd/drbd_receiver.c:
drivers/block/drbd/drbd_receiver.c:4836:5: warning: no previous prototype for ‘drbdd_init’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_receiver.c:5245:5: warning: no previous prototype for ‘drbd_asender’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/block/drbd/drbd_int.h  |    4 ++++
 drivers/block/drbd/drbd_main.c |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 0e06f0c..0cc79f4 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -587,6 +587,10 @@ struct drbd_epoch {
 	unsigned long flags;
 };
 
+/* Prototype declaration of function defined in drbd_receiver.c */
+int drbdd_init(struct drbd_thread *);
+int drbd_asender(struct drbd_thread *);
+
 /* drbd_epoch flag bits */
 enum {
 	DE_HAVE_BARRIER_NUMBER,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9e3818b..4a24e71 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -57,9 +57,7 @@
 #include "drbd_vli.h"
 
 static DEFINE_MUTEX(drbd_main_mutex);
-int drbdd_init(struct drbd_thread *);
 int drbd_worker(struct drbd_thread *);
-int drbd_asender(struct drbd_thread *);
 
 int drbd_init(void);
 static int drbd_open(struct block_device *bdev, fmode_t mode);
-- 
1.7.9.5

