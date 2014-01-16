Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaAPNjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:39:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38334 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAPNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:39:12 -0500
Date: Thu, 16 Jan 2014 05:38:34 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-540476de74c9b11403656791838ede91405d3859@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rodrigo@sdfg.com.ar,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rodrigo@sdfg.com.ar,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1389677157-30513-2-git-send-email-namhyung@kernel.org>
References: <1389677157-30513-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove symbol_conf.use_callchain check
Git-Commit-ID: 540476de74c9b11403656791838ede91405d3859
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:38:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  540476de74c9b11403656791838ede91405d3859
Gitweb:     http://git.kernel.org/tip/540476de74c9b11403656791838ede91405d3859
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 14 Jan 2014 14:25:34 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Jan 2014 15:31:08 -0300

perf tools: Remove symbol_conf.use_callchain check

The machine__resolve_callchain() is called only if symbol_conf.
use_callchain is set so no need to check it again.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rodrigo Campos <rodrigo@sdfg.com.ar>
Link: http://lkml.kernel.org/r/1389677157-30513-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 0130279..ded7459 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1314,8 +1314,6 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 				*root_al = al;
 				callchain_cursor_reset(&callchain_cursor);
 			}
-			if (!symbol_conf.use_callchain)
-				break;
 		}
 
 		err = callchain_cursor_append(&callchain_cursor,
