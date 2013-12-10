Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3LJMY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:24:28 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:51614 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3LJMYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:24:22 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo <acme@ghostprotocols.net>
Cc: patches@linaro.org, Will Deacon <will.deacon@arm.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 1/2] perf: add per-feature check flags
Date: Tue, 10 Dec 2013 13:24:03 +0100
Message-Id: <1386678244-13535-2-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386678244-13535-1-git-send-email-jean.pihet@linaro.org>
References: <1386678244-13535-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CFLAGS and LDFLAGS for each feature to be checked. This allows
to pass flags and parameters to the feature checks compilation.
Also simplifies the feature check makefile, to come in a subsequent patch.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
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
-- 
1.7.11.7

