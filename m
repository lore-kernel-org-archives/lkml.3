Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3LKLJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:09:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60461 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3LKLI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:08:58 -0500
Date: Wed, 11 Dec 2013 03:08:36 -0800
From: tip-bot for Jean Pihet <tipbot@zytor.com>
Message-ID: <tip-ef517c6bee5d16404b06bee1d07f00ffb74fc21a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, will.deacon@arm.com, jean.pihet@linaro.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, will.deacon@arm.com, jean.pihet@linaro.org,
        jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1386678244-13535-2-git-send-email-jean.pihet@linaro.org>
References: <1386678244-13535-2-git-send-email-jean.pihet@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add per-feature check flags
Git-Commit-ID: ef517c6bee5d16404b06bee1d07f00ffb74fc21a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:08:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef517c6bee5d16404b06bee1d07f00ffb74fc21a
Gitweb:     http://git.kernel.org/tip/ef517c6bee5d16404b06bee1d07f00ffb74fc21a
Author:     Jean Pihet <jean.pihet@linaro.org>
AuthorDate: Tue, 10 Dec 2013 13:24:03 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Dec 2013 16:51:12 -0300

perf tools: Add per-feature check flags

Add CFLAGS and LDFLAGS for each feature to be checked. This allows to
pass flags and parameters to the feature checks compilation.  Also
simplifies the feature check makefile, to come in a subsequent patch.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linaro-kernel@lists.linaro.org
Cc: patches@linaro.org
Link: http://lkml.kernel.org/r/1386678244-13535-2-git-send-email-jean.pihet@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index bae1072..2afb132 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -102,7 +102,7 @@ endif
 
 feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS="$(LDFLAGS)" LIBUNWIND_LIBS="$(LIBUNWIND_LIBS)" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" LIBUNWIND_LIBS="$(LIBUNWIND_LIBS)" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
 feature_set = $(eval $(feature_set_code))
