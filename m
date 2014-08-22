Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaHVX5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:57:48 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:57741 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaHVX5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:57:46 -0400
From: Spencer Baugh <sbaugh@andrew.cmu.edu>
To: gregkh@linuxfoundation.org
Cc: Spencer Baugh <sbaugh@andrew.cmu.edu>, Oleg Drokin <oleg.drokin@intel.com>,
        Niu Yawei <yawei.niu@intel.com>, Masanari Iida <standby24x7@gmail.com>,
        Alex Zhuravlev <alexey.zhuravlev@intel.com>,
        Hongchao Zhang <hongchao.zhang@intel.com>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] staging: fix style in lustre_import.h
Date: Fri, 22 Aug 2014 19:57:40 -0400
Message-Id: <1408751862-31454-1-git-send-email-sbaugh@andrew.cmu.edu>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes style errors and warnings reported by
scripts/checkpatch.pl

Signed-off-by: Spencer Baugh <sbaugh@andrew.cmu.edu>

---
 .../staging/lustre/lustre/include/lustre_import.h   | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_import.h b/drivers/staging/lustre/lustre/include/lustre_import.h
index 8304a55..b39b283 100644
--- a/drivers/staging/lustre/lustre/include/lustre_import.h
+++ b/drivers/staging/lustre/lustre/include/lustre_import.h
@@ -103,15 +103,15 @@ enum lustre_imp_state {
 };
 
 /** Returns test string representation of numeric import state \a state */
-static inline char * ptlrpc_import_state_name(enum lustre_imp_state state)
+static inline char *ptlrpc_import_state_name(enum lustre_imp_state state)
 {
-	static char* import_state_names[] = {
+	static char *import_state_names[] = {
 		"<UNKNOWN>", "CLOSED",  "NEW", "DISCONN",
 		"CONNECTING", "REPLAY", "REPLAY_LOCKS", "REPLAY_WAIT",
 		"RECOVER", "FULL", "EVICTED",
 	};
 
-	LASSERT (state <= LUSTRE_IMP_EVICTED);
+	LASSERT(state <= LUSTRE_IMP_EVICTED);
 	return import_state_names[state];
 }
 
@@ -302,12 +302,12 @@ struct obd_import {
 	int		       imp_connect_error;
 
 	__u32		     imp_msg_magic;
-	__u32		     imp_msghdr_flags;       /* adjusted based on server capability */
+	__u32		     imp_msghdr_flags;   /* adjusted based on server capability */
 
-	struct ptlrpc_request_pool *imp_rq_pool;	  /* emergency request pool */
+	struct ptlrpc_request_pool *imp_rq_pool; /* emergency request pool */
 
 	struct imp_at	     imp_at;		 /* adaptive timeout data */
-	time_t		    imp_last_reply_time;    /* for health check */
+	time_t		    imp_last_reply_time; /* for health check */
 };
 
 typedef void (*obd_import_callback)(struct obd_import *imp, void *closure,
@@ -346,21 +346,24 @@ static inline unsigned int at_timeout2est(unsigned int val)
 	return (max((val << 2) / 5, 5U) - 4);
 }
 
-static inline void at_reset(struct adaptive_timeout *at, int val) {
+static inline void at_reset(struct adaptive_timeout *at, int val)
+{
 	spin_lock(&at->at_lock);
 	at->at_current = val;
 	at->at_worst_ever = val;
 	at->at_worst_time = get_seconds();
 	spin_unlock(&at->at_lock);
 }
-static inline void at_init(struct adaptive_timeout *at, int val, int flags) {
+static inline void at_init(struct adaptive_timeout *at, int val, int flags)
+{
 	memset(at, 0, sizeof(*at));
 	spin_lock_init(&at->at_lock);
 	at->at_flags = flags;
 	at_reset(at, val);
 }
 extern unsigned int at_min;
-static inline int at_get(struct adaptive_timeout *at) {
+static inline int at_get(struct adaptive_timeout *at)
+{
 	return (at->at_current > at_min) ? at->at_current : at_min;
 }
 int at_measured(struct adaptive_timeout *at, unsigned int val);
-- 
2.0.4

