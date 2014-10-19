Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaJSMva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 08:51:30 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:31818 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbaJSMvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 08:51:06 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ratelimit: add initialization macro
Date: Sun, 19 Oct 2014 16:50:43 +0400
Message-Id: <1413723044-3275-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 include/linux/ratelimit.h |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 0a260d8..1810252 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -17,14 +17,20 @@ struct ratelimit_state {
 	unsigned long	begin;
 };
 
-#define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
-									\
-	struct ratelimit_state name = {					\
+#define RATELIMIT_STATE_INIT(name, interval_init, burst_init) {		\
 		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
 		.interval	= interval_init,			\
 		.burst		= burst_init,				\
 	}
 
+#define RATELIMIT_STATE_INIT_DISABLED					\
+	RATELIMIT_STATE_INIT(ratelimit_state, 0, DEFAULT_RATELIMIT_BURST)
+
+#define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
+									\
+	struct ratelimit_state name =					\
+		RATELIMIT_STATE_INIT(name, interval_init, burst_init)	\
+
 static inline void ratelimit_state_init(struct ratelimit_state *rs,
 					int interval, int burst)
 {
-- 
1.7.1

