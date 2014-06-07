Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaFGIWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 04:22:37 -0400
Received: from ns.horizon.com ([71.41.210.147]:47753 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752854AbaFGIWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 04:22:36 -0400
Date: 7 Jun 2014 04:22:35 -0400
Message-ID: <20140607082235.9839.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: davem@davemloft.net, dborkman@redhat.com, linux@horizon.com,
        shemminger@osdl.org, tytso@mit.edu
Subject: [PATCH 3/7] lib/random32.c: Replace an #ifdef with a stub prandom_state_selftest()
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20140607081828.9294.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The preferred Linux style for optional features is to define
no-op stub functions rather than wrap each call site in #ifdef.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 lib/random32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/random32.c b/lib/random32.c
index 2e7c15c0..e8f3557b 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -40,6 +40,8 @@
 
 #ifdef CONFIG_RANDOM32_SELFTEST
 static void __init prandom_state_selftest(void);
+#else
+#define prandom_state_selftest() (void)0
 #endif
 
 static DEFINE_PER_CPU(struct rnd_state, net_rand_state);
@@ -188,9 +190,7 @@ static int __init prandom_init(void)
 {
 	int i;
 
-#ifdef CONFIG_RANDOM32_SELFTEST
 	prandom_state_selftest();
-#endif
 
 	for_each_possible_cpu(i) {
 		struct rnd_state *state = &per_cpu(net_rand_state,i);
-- 
2.0.0

