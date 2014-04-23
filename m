Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaDWNOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:14:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37403 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaDWNOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:14:05 -0400
Date: Wed, 23 Apr 2014 06:13:24 -0700
From: tip-bot for Masanari Iida <tipbot@zytor.com>
Message-ID: <tip-763d7f5f2718f085bab5a9e63308349728f3ad12@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, standby24x7@gmail.com, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, standby24x7@gmail.com, jolsa@redhat.com
In-Reply-To: <1398091024-7901-1-git-send-email-standby24x7@gmail.com>
References: <1398091024-7901-1-git-send-email-standby24x7@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tests x86:
  Fix memory leak in sample_ustack()
Git-Commit-ID: 763d7f5f2718f085bab5a9e63308349728f3ad12
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  763d7f5f2718f085bab5a9e63308349728f3ad12
Gitweb:     http://git.kernel.org/tip/763d7f5f2718f085bab5a9e63308349728f3ad12
Author:     Masanari Iida <standby24x7@gmail.com>
AuthorDate: Sun, 20 Apr 2014 00:16:41 +0900
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Wed, 23 Apr 2014 13:19:01 +0200

perf tests x86: Fix memory leak in sample_ustack()

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
 
