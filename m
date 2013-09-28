Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3I1RrJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:47:09 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:58554 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab3I1RrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:47:07 -0400
X-Greylist: delayed 157938 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Sep 2013 13:47:05 EDT
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH linux-next] skd: fix some VPRINTK() specifiers for size_t
Date: Sat, 28 Sep 2013 19:37:58 +0200
Message-Id: <1380389878-15497-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %zu for VPRINTK() as size_t specifier in replacement of %u.

This fixes 7 compilation warnings on x86_64 like the following:

  drivers/block/skd_main.c:4628:42: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 6 has type ‘long unsigned int’ [-Wformat=]

While at it, remove one cast to unsigned long for a size_t VPRINTK() argument
and specify it as %zu, too.

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

Hi,

This can be seen on e.g. linux next-20130927.

Best regards,

V.

 drivers/block/skd_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 3110f68..ee7f7a8 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4556,11 +4556,10 @@ static int skd_cons_skmsg(struct skd_device *skdev)
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skmsg_table kzalloc, struct %u, count %u total %lu\n",
+	VPRINTK(skdev, "skmsg_table kzalloc, struct %zu, count %u total %zu\n",
 		sizeof(struct skd_fitmsg_context),
 		skdev->num_fitmsg_context,
-		(unsigned long) sizeof(struct skd_fitmsg_context) *
-					skdev->num_fitmsg_context);
+		sizeof(struct skd_fitmsg_context) * skdev->num_fitmsg_context);
 
 	skdev->skmsg_table = kzalloc(sizeof(struct skd_fitmsg_context)
 				     *skdev->num_fitmsg_context, GFP_KERNEL);
@@ -4611,7 +4610,7 @@ static int skd_cons_skreq(struct skd_device *skdev)
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skreq_table kzalloc, struct %u, count %u total %u\n",
+	VPRINTK(skdev, "skreq_table kzalloc, struct %zu, count %u total %zu\n",
 		sizeof(struct skd_request_context),
 		skdev->num_req_context,
 		sizeof(struct skd_request_context) * skdev->num_req_context);
@@ -4623,7 +4622,7 @@ static int skd_cons_skreq(struct skd_device *skdev)
 		goto err_out;
 	}
 
-	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %u total %u\n",
+	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %zu total %zu\n",
 		skdev->sgs_per_request, sizeof(struct scatterlist),
 		skdev->sgs_per_request * sizeof(struct scatterlist));
 
@@ -4668,7 +4667,7 @@ static int skd_cons_skspcl(struct skd_device *skdev)
 	int rc = 0;
 	u32 i, nbytes;
 
-	VPRINTK(skdev, "skspcl_table kzalloc, struct %u, count %u total %u\n",
+	VPRINTK(skdev, "skspcl_table kzalloc, struct %zu, count %u total %zu\n",
 		sizeof(struct skd_special_context),
 		skdev->n_special,
 		sizeof(struct skd_special_context) * skdev->n_special);
-- 
1.8.4.rc3

