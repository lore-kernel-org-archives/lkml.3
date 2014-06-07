Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaFGITh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 04:19:37 -0400
Received: from ns.horizon.com ([71.41.210.147]:59938 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752864AbaFGITf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 04:19:35 -0400
Date: 7 Jun 2014 04:19:34 -0400
Message-ID: <20140607081934.9387.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: davem@davemloft.net, dborkman@redhat.com, linux@horizon.com,
        shemminger@osdl.org, tytso@mit.edu
Subject: [PATCH 1/7] lib/random32.c: Mark self-test data as __initconst
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20140607081828.9294.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it can be thrown away along with the code that uses it.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 lib/random32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/random32.c b/lib/random32.c
index fa5da61c..4da5d281 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -296,7 +296,7 @@ late_initcall(prandom_reseed);
 static struct prandom_test1 {
 	u32 seed;
 	u32 result;
-} test1[] = {
+} const test1[] __initconst = {
 	{ 1U, 3484351685U },
 	{ 2U, 2623130059U },
 	{ 3U, 3125133893U },
@@ -307,7 +307,7 @@ static struct prandom_test2 {
 	u32 seed;
 	u32 iteration;
 	u32 result;
-} test2[] = {
+} const test2[] __initconst = {
 	/* Test cases against taus113 from GSL library. */
 	{  931557656U, 959U, 2975593782U },
 	{ 1339693295U, 876U, 3887776532U },
-- 
2.0.0

