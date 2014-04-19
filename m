Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaDSPQw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 11:16:52 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43217 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaDSPQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 11:16:49 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: a.p.zijlstra@chello.nl, jolsa@redhat.com, paulus@samba.org,
        mingo@redhat.com, acme@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] perf test x86: Fit memory leak in sample_ustack()
Date: Sun, 20 Apr 2014 00:16:41 +0900
Message-Id: <1397920601-27712-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.2.468.g3f0c02a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

buf is not freed, when kernel failed to get stack map
and return.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 tools/perf/arch/x86/tests/dwarf-unwind.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/arch/x86/tests/dwarf-unwind.c b/tools/perf/arch/x86/tests/dwarf-unwind.c
index b602ad9..68f2711 100644
--- a/tools/perf/arch/x86/tests/dwarf-unwind.c
+++ b/tools/perf/arch/x86/tests/dwarf-unwind.c
@@ -26,6 +26,7 @@ static int sample_ustack(struct perf_sample *sample,
 	map = map_groups__find(&thread->mg, MAP__FUNCTION, (u64) sp);
 	if (!map) {
 		pr_debug("failed to get stack map\n");
+		kfree(buf);
 		return -1;
 	}
 
-- 
1.9.2.468.g3f0c02a

