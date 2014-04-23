Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaDWLbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:31:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbaDWLbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:31:33 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/4] perf tests x86: Fix memory leak in sample_ustack()
Date: Wed, 23 Apr 2014 13:31:19 +0200
Message-Id: <1398252682-17185-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
References: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>

The buf is not freed, when kernel failed to get stack map
and return.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Link: http://lkml.kernel.org/r/1398091024-7901-1-git-send-email-standby24x7@gmail.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/arch/x86/tests/dwarf-unwind.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/arch/x86/tests/dwarf-unwind.c b/tools/perf/arch/x86/tests/dwarf-unwind.c
index b602ad9..b8c0102 100644
--- a/tools/perf/arch/x86/tests/dwarf-unwind.c
+++ b/tools/perf/arch/x86/tests/dwarf-unwind.c
@@ -26,6 +26,7 @@ static int sample_ustack(struct perf_sample *sample,
 	map = map_groups__find(&thread->mg, MAP__FUNCTION, (u64) sp);
 	if (!map) {
 		pr_debug("failed to get stack map\n");
+		free(buf);
 		return -1;
 	}
 
-- 
1.8.3.1

