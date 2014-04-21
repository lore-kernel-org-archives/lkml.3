Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaDUOh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 10:37:26 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48732 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaDUOhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 10:37:14 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, jolsa@redhat.com, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/v2] perf test x86: Fit memory leak in sample_ustack()
Date: Mon, 21 Apr 2014 23:37:04 +0900
Message-Id: <1398091024-7901-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.2.468.g3f0c02a
In-Reply-To: <1397920601-27712-1-git-send-email-standby24x7@gmail.com>
References: <1397920601-27712-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

buf is not freed, when program failed to get stack map

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
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
1.9.2.468.g3f0c02a

