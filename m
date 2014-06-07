Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaFGIbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 04:31:23 -0400
Received: from ns.horizon.com ([71.41.210.147]:22300 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752856AbaFGIbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 04:31:22 -0400
Date: 7 Jun 2014 04:31:21 -0400
Message-ID: <20140607083121.10274.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: davem@davemloft.net, dborkman@redhat.com, linux@horizon.com,
        shemminger@osdl.org, tytso@mit.edu
Subject: [PATCH 7/7] lib/random32.c: Remove redundant U suffixes on integers
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20140607081828.9294.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of a few of the extraneous U suffixes on ordinary integers.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 lib/random32.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/random32.c b/lib/random32.c
index 9cc410dd..ad0c2ed1 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -58,10 +58,10 @@ u32 prandom_u32_state(struct rnd_state *state)
 {
 #define TAUSWORTHE(s,a,b,c,d) ((s&c)<<d) ^ (((s <<a) ^ s)>>b)
 
-	state->s1 = TAUSWORTHE(state->s1,  6U, 13U, 4294967294U, 18U);
-	state->s2 = TAUSWORTHE(state->s2,  2U, 27U, 4294967288U,  2U);
-	state->s3 = TAUSWORTHE(state->s3, 13U, 21U, 4294967280U,  7U);
-	state->s4 = TAUSWORTHE(state->s4,  3U, 12U, 4294967168U, 13U);
+	state->s1 = TAUSWORTHE(state->s1,  6, 13, 4294967294U, 18);
+	state->s2 = TAUSWORTHE(state->s2,  2, 27, 4294967288U,  2);
+	state->s3 = TAUSWORTHE(state->s3, 13, 21, 4294967280U,  7);
+	state->s4 = TAUSWORTHE(state->s4,  3, 12, 4294967168U, 13);
 
 	return (state->s1 ^ state->s2 ^ state->s3 ^ state->s4);
 }
@@ -77,9 +77,8 @@ EXPORT_SYMBOL(prandom_u32_state);
 u32 prandom_u32(void)
 {
 	struct rnd_state *state = &get_cpu_var(net_rand_state);
-	u32 res;
+	u32 res = prandom_u32_state(state);
 
-	res = prandom_u32_state(state);
 	put_cpu_var(state);
 
 	return res;
-- 
2.0.0

