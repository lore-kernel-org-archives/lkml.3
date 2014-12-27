Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaL0UsE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 15:48:04 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55719 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaL0Ur6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 15:47:58 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Greg Donald <gdonald@gmail.com>, Anton Saraev <antonysaraev@gmail.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>, Joe Perches <joe@perches.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 2/5] staging: lustre: selftest: fix "not declared" by declaring static
Date: Sat, 27 Dec 2014 12:46:47 -0800
Message-Id: <1419713210-8198-3-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419713210-8198-1-git-send-email-jmmahler@gmail.com>
References: <1419713210-8198-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix several "symbol '...' was not declared" sparse warnings
for variables which are only used locally by declaring them static.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/staging/lustre/lnet/selftest/framework.c | 2 +-
 drivers/staging/lustre/lnet/selftest/rpc.c       | 2 +-
 drivers/staging/lustre/lnet/selftest/timer.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lnet/selftest/framework.c b/drivers/staging/lustre/lnet/selftest/framework.c
index cc9d182..56b4ef4 100644
--- a/drivers/staging/lustre/lnet/selftest/framework.c
+++ b/drivers/staging/lustre/lnet/selftest/framework.c
@@ -103,7 +103,7 @@ do {				    \
 #define sfw_test_active(t)      (atomic_read(&(t)->tsi_nactive) != 0)
 #define sfw_batch_active(b)     (atomic_read(&(b)->bat_nactive) != 0)
 
-struct smoketest_framework {
+static struct smoketest_framework {
 	struct list_head	 fw_zombie_rpcs;     /* RPCs to be recycled */
 	struct list_head	 fw_zombie_sessions; /* stopping sessions */
 	struct list_head	 fw_tests;	   /* registered test cases */
diff --git a/drivers/staging/lustre/lnet/selftest/rpc.c b/drivers/staging/lustre/lnet/selftest/rpc.c
index b602077..bb6aa2e 100644
--- a/drivers/staging/lustre/lnet/selftest/rpc.c
+++ b/drivers/staging/lustre/lnet/selftest/rpc.c
@@ -54,7 +54,7 @@ typedef enum {
 	SRPC_STATE_STOPPING,
 } srpc_state_t;
 
-struct smoketest_rpc {
+static struct smoketest_rpc {
 	spinlock_t	 rpc_glock;	/* global lock */
 	srpc_service_t	*rpc_services[SRPC_SERVICE_MAX_ID + 1];
 	lnet_handle_eq_t rpc_lnet_eq;	/* _the_ LNet event queue */
diff --git a/drivers/staging/lustre/lnet/selftest/timer.c b/drivers/staging/lustre/lnet/selftest/timer.c
index f8352c2..441f947 100644
--- a/drivers/staging/lustre/lnet/selftest/timer.c
+++ b/drivers/staging/lustre/lnet/selftest/timer.c
@@ -57,7 +57,7 @@
 #define STTIMER_SLOT(t)	       (&stt_data.stt_hash[(((t) >> STTIMER_MINPOLL) & \
 						    (STTIMER_NSLOTS - 1))])
 
-struct st_timer_data {
+static struct st_timer_data {
 	spinlock_t	 stt_lock;
 	/* start time of the slot processed previously */
 	unsigned long       stt_prev_slot;
-- 
2.1.4

