Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3JJHKC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:10:02 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:59384 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3JJHKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:10:00 -0400
Date: Thu, 10 Oct 2013 09:09:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tools/perf/build: Improve the 'stackprotector' feature test
Message-ID: <20131010070956.GJ10246@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-7-git-send-email-mingo@kernel.org>
 <87hacpk73g.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hacpk73g.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim noticed that the stackprotector testcase was incomplete:

  > The flag being checked should be -"W"stack-protector instead of
  > -"f"stack-protector.  And the gcc manpage says that -Wstack-protector is
  > only active when -fstack-protector is active.  So the end result should
  > look like
  >
  >         $(BUILD) -Werror -fstack-protector -Wstack-protector

Add -Wstack-protector.

Reported-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/feature-checks/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 2eb8346..c70d23e 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -45,7 +45,7 @@ test-stackprotector-all:
 	$(BUILD) -Werror -fstack-protector-all
 
 test-stackprotector:
-	$(BUILD) -Werror -fstack-protector
+	$(BUILD) -Werror -fstack-protector -Wstack-protector
 
 test-fortify-source:
 	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
