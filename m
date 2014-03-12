Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaCLWmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:42:19 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:40545 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaCLWmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:42:17 -0400
From: Patrick Palka <patrick@parcs.ath.cx>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@redhat.com, paulus@samba.org,
        a.p.zijlstra@chello.nl, Patrick Palka <patrick@parcs.ath.cx>
Subject: [PATCH] perf bench: Fix NULL pointer dereference in "perf bench all"
Date: Wed, 12 Mar 2014 18:40:51 -0400
Message-Id: <1394664051-6037-1-git-send-email-patrick@parcs.ath.cx>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for_each_bench() must check that the "benchmarks" field of a collection
is not NULL before dereferencing it because the "all" collection in
particular has a NULL "benchmarks" field (signifying that it has no
benchmarks to iterate over).

This fixes a NULL pointer dereference when running "perf bench all".

Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
---
 tools/perf/builtin-bench.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index e47f90c..8a987d2 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -76,7 +76,7 @@ static struct collection collections[] = {
 
 /* Iterate over all benchmarks within a collection: */
 #define for_each_bench(coll, bench) \
-	for (bench = coll->benchmarks; bench->name; bench++)
+	for (bench = coll->benchmarks; bench && bench->name; bench++)
 
 static void dump_benchmarks(struct collection *coll)
 {
-- 
1.9.0

