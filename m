Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab3FQKPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:15:54 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:49920 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932307Ab3FQKPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:15:53 -0400
Message-ID: <1371464151.26299.12.camel@x61.thuisdomein>
Subject: [PATCH] rbd: remove RBD_DEBUG
From: Paul Bolle <pebolle@tiscali.nl>
To: Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>,
        Alex Elder <elder@inktank.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Jun 2013 12:15:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2013 10:15:51.0725 (UTC) FILETIME=[A51A05D0:01CE6B43]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RBD_DEBUG macro is always defined, so it serves no purpose.
Removing it has the benefit that readers of the code won't be tricked
into thinking that rbd_assert() will compile away because they didn't
define RBD_DEBUG themselves.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only.

 drivers/block/rbd.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index b8a58178..d3869b4 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -44,8 +44,6 @@
 
 #include "rbd_types.h"
 
-#define RBD_DEBUG	/* Activate rbd_assert() calls */
-
 /*
  * The basic unit of block I/O is a sector.  It is interpreted in a
  * number of contexts in Linux (blk, bio, genhd), but the default is
@@ -444,7 +442,6 @@ void rbd_warn(struct rbd_device *rbd_dev, const char *fmt, ...)
 	va_end(args);
 }
 
-#ifdef RBD_DEBUG
 #define rbd_assert(expr)						\
 		if (unlikely(!(expr))) {				\
 			printk(KERN_ERR "\nAssertion failure in %s() "	\
@@ -453,9 +450,6 @@ void rbd_warn(struct rbd_device *rbd_dev, const char *fmt, ...)
 					__func__, __LINE__, #expr);	\
 			BUG();						\
 		}
-#else /* !RBD_DEBUG */
-#  define rbd_assert(expr)	((void) 0)
-#endif /* !RBD_DEBUG */
 
 static int rbd_img_obj_request_submit(struct rbd_obj_request *obj_request);
 static void rbd_img_parent_read(struct rbd_obj_request *obj_request);
-- 
1.8.1.4

