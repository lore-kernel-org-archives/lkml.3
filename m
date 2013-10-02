Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3JBIfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 04:35:37 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50726 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3JBIff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:35:35 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf tool: simplify a git command in PERF-VERSION-GEN
Date: Wed,  2 Oct 2013 13:58:22 +0530
Message-Id: <1380702502-9171-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a complex git log invocation with a simpler git rev-parse
invocation.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/util/PERF-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 15a77b7..b23d11b 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -18,7 +18,7 @@ TAG=
 if test -d ../../.git -o -f ../../.git
 then
 	TAG=$(git describe --abbrev=0 --match "v[0-9].[0-9]*" 2>/dev/null )
-	CID=$(git log -1 --abbrev=4 --pretty=format:"%h" 2>/dev/null) && CID="-g$CID"
+	CID=$(git rev-parse --short HEAD 2>/dev/null) && CID="-g$CID"
 fi
 if test -z "$TAG"
 then
-- 
1.8.4.477.g5d89aa9

