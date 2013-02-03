Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab3BCBV3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:21:29 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:44819 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab3BCBVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:21:14 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/62] idr: cosmetic updates to struct / initializer definitions
Date: Sat,  2 Feb 2013 17:20:02 -0800
Message-Id: <1359854463-2538-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tab align fields like a normal person.

* Drop the unnecessary 0 inits from IDR_INIT().

This patch is purely cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/idr.h | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 1b932e7..c78c26d 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -49,28 +49,24 @@
 #define MAX_IDR_FREE (MAX_IDR_LEVEL * 2)
 
 struct idr_layer {
-	unsigned long		 bitmap; /* A zero bit means "space here" */
+	unsigned long		bitmap;	/* A zero bit means "space here" */
 	struct idr_layer __rcu	*ary[1<<IDR_BITS];
-	int			 count;	 /* When zero, we can release it */
-	int			 layer;	 /* distance from leaf */
-	struct rcu_head		 rcu_head;
+	int			count;	/* When zero, we can release it */
+	int			layer;	/* distance from leaf */
+	struct rcu_head		rcu_head;
 };
 
 struct idr {
-	struct idr_layer __rcu *top;
-	struct idr_layer *id_free;
-	int		  layers; /* only valid without concurrent changes */
-	int		  id_free_cnt;
-	spinlock_t	  lock;
+	struct idr_layer __rcu	*top;
+	struct idr_layer	*id_free;
+	int			layers;	/* only valid w/o concurrent changes */
+	int			id_free_cnt;
+	spinlock_t		lock;
 };
 
-#define IDR_INIT(name)						\
-{								\
-	.top		= NULL,					\
-	.id_free	= NULL,					\
-	.layers 	= 0,					\
-	.id_free_cnt	= 0,					\
-	.lock		= __SPIN_LOCK_UNLOCKED(name.lock),	\
+#define IDR_INIT(name)							\
+{									\
+	.lock			= __SPIN_LOCK_UNLOCKED(name.lock),	\
 }
 #define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
 
-- 
1.8.1

