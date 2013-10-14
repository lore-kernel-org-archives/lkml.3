Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab3JNURE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:17:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39070 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745Ab3JNUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 147/161] tools/perf/build: Fix non-existent build directory handling
Date: Mon, 14 Oct 2013 17:02:16 -0300
Message-Id: <1381780950-25642-148-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

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
index 5aa3d040bbf3..914704495166 100644
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
-- 
1.8.1.4

