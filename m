Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab3LWWBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:01:19 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60679 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab3LWV7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:59:00 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/27] drbd: Define the size of res_opts->cpu_mask in a single place
Date: Mon, 23 Dec 2013 22:50:35 +0100
Message-Id: <1387835456-29695-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_main.c |    3 +--
 include/linux/drbd.h           |    2 ++
 include/linux/drbd_genl.h      |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 824bc7a..cab0641 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2505,8 +2505,7 @@ int set_resource_options(struct drbd_resource *resource, struct res_opts *res_op
 
 	/* silently ignore cpu mask on UP kernel */
 	if (nr_cpu_ids > 1 && res_opts->cpu_mask[0] != 0) {
-		/* FIXME: Get rid of constant 32 here */
-		err = bitmap_parse(res_opts->cpu_mask, 32,
+		err = bitmap_parse(res_opts->cpu_mask, DRBD_CPU_MASK_SIZE,
 				   cpumask_bits(new_cpu_mask), nr_cpu_ids);
 		if (err) {
 			drbd_warn(resource, "bitmap_parse() failed with %d\n", err);
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index de7d74a..6f60136 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -382,4 +382,6 @@ enum drbd_timeout_flag {
 #define DRBD_MD_INDEX_FLEX_EXT -2
 #define DRBD_MD_INDEX_FLEX_INT -3
 
+#define DRBD_CPU_MASK_SIZE 32
+
 #endif
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index b14a2e8..4193f5f 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -135,7 +135,7 @@ GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
 )
 
 GENL_struct(DRBD_NLA_RESOURCE_OPTS, 4, res_opts,
-	__str_field_def(1,	DRBD_GENLA_F_MANDATORY,	cpu_mask,       32)
+	__str_field_def(1,	DRBD_GENLA_F_MANDATORY,	cpu_mask,       DRBD_CPU_MASK_SIZE)
 	__u32_field_def(2,	DRBD_GENLA_F_MANDATORY,	on_no_data, DRBD_ON_NO_DATA_DEF)
 )
 
-- 
1.7.9.5

