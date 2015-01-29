Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbbA2IWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:22:07 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50938 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbbA2IJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:09:57 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/42] perf header: Set header version correctly
Date: Thu, 29 Jan 2015 17:06:45 +0900
Message-Id: <1422518843-25818-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When check_magic_endian() is called, it checks the magic number in the
perf data file to determine version and endianness.  But if it uses a
same endian the verison number wasn't updated and makes confusion.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b20e40c74468..1f407f7352a7 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2237,6 +2237,7 @@ static int check_magic_endian(u64 magic, uint64_t hdr_sz,
 	 * - unique number to identify actual perf.data files
 	 * - encode endianness of file
 	 */
+	ph->version = PERF_HEADER_VERSION_2;
 
 	/* check magic number with one endianness */
 	if (magic == __perf_magic2)
@@ -2247,7 +2248,6 @@ static int check_magic_endian(u64 magic, uint64_t hdr_sz,
 		return -1;
 
 	ph->needs_swap = true;
-	ph->version = PERF_HEADER_VERSION_2;
 
 	return 0;
 }
-- 
2.2.2

