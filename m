Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3LJJWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:22:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3LJJWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:22:39 -0500
Date: Tue, 10 Dec 2013 01:22:15 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-789790791ad254408267eb6a216ae7a90973c05a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Fix install dependency
Git-Commit-ID: 789790791ad254408267eb6a216ae7a90973c05a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:22:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  789790791ad254408267eb6a216ae7a90973c05a
Gitweb:     http://git.kernel.org/tip/789790791ad254408267eb6a216ae7a90973c05a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 5 Dec 2013 12:13:54 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Dec 2013 13:26:14 +0100

tools/perf/build: Fix install dependency

The traceevents-plugins install targets needs a proper dependency,
otherwise it might be executed prematurely and in parallel to an
actual build.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/n/tip-rvlbzena4ovzgqiPm6teBofz@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile.perf | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index ca3b87d..9a8cf37 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -722,7 +722,7 @@ $(LIBTRACEEVENT)-clean:
 	$(call QUIET_CLEAN, libtraceevent)
 	@$(MAKE) -C $(TRACE_EVENT_DIR) O=$(OUTPUT) clean >/dev/null
 
-install-traceevent-plugins:
+install-traceevent-plugins: $(LIBTRACEEVENT)
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) install_plugins
 
 LIBLK_SOURCES = $(wildcard $(LK_PATH)*.[ch])
