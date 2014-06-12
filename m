Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaFLMCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:02:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60543 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaFLMCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:02:03 -0400
Date: Thu, 12 Jun 2014 05:01:42 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-b0815d07ec12959da2104822561e0df26dc4bf3d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1401893676-32205-1-git-send-email-jolsa@kernel.org>
References: <1401893676-32205-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Prettify the tags/TAGS/
 cscope targets output
Git-Commit-ID: b0815d07ec12959da2104822561e0df26dc4bf3d
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

Commit-ID:  b0815d07ec12959da2104822561e0df26dc4bf3d
Gitweb:     http://git.kernel.org/tip/b0815d07ec12959da2104822561e0df26dc4bf3d
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 4 Jun 2014 14:43:58 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 9 Jun 2014 12:21:02 +0200

perf tools: Prettify the tags/TAGS/cscope targets output

Add tags/TAGS/cscope targets to the quiet family.

  $ make tags cscope
  BUILD:   Doing 'make -j4' parallel build
  GEN      tags

  $ make cscope
  BUILD:   Doing 'make -j4' parallel build
  GEN      cscope

Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401893676-32205-1-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index ae20edf..9670a16 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -819,15 +819,15 @@ TAG_FOLDERS= . ../lib/traceevent ../lib/api ../lib/symbol
 TAG_FILES= ../../include/uapi/linux/perf_event.h
 
 TAGS:
-	$(RM) TAGS
+	$(QUIET_GEN)$(RM) TAGS; \
 	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs etags -a $(TAG_FILES)
 
 tags:
-	$(RM) tags
+	$(QUIET_GEN)$(RM) tags; \
 	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs ctags -a $(TAG_FILES)
 
 cscope:
-	$(RM) cscope*
+	$(QUIET_GEN)$(RM) cscope*; \
 	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs cscope -b $(TAG_FILES)
 
 ### Detect prefix changes
