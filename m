Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab3JOFeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:34:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933564Ab3JOFeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:34:09 -0400
Date: Mon, 14 Oct 2013 22:33:54 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-3fb66335e13ef7426affe9efa48c08857202c1cb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <20131009150023.GA10167@gmail.com>
References: <20131009150023.GA10167@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Fix non-existent build directory handling
Git-Commit-ID: 3fb66335e13ef7426affe9efa48c08857202c1cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:34:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fb66335e13ef7426affe9efa48c08857202c1cb
Gitweb:     http://git.kernel.org/tip/3fb66335e13ef7426affe9efa48c08857202c1cb
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 9 Oct 2013 17:00:23 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Oct 2013 10:29:05 -0300

tools/perf/build: Fix non-existent build directory handling

Arnaldo reported that non-existent build directories were not
recognized  properly. The reason is readlink failure causing 'O'
to become empty.

Solve it by passing through the 'O' variable unmodified if
readlink fails.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131009150023.GA10167@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5aa3d04..9147044 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -34,7 +34,7 @@ endif
 # Only pass canonical directory names as the output directory:
 #
 ifneq ($(O),)
-  FULL_O := $(shell readlink -f $(O))
+  FULL_O := $(shell readlink -f $(O) || echo $(O))
 endif
 
 define print_msg
