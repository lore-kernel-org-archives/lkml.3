Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137AbaFCWIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:08:48 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:38691 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965067AbaFCWIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:08:43 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 05/32] perf kbuild: fix recursive invocation of config/features-checks
Date: Wed,  4 Jun 2014 00:05:58 +0200
Message-Id: <1401833185-10347-6-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/perf/Makefile.kbuild | 2 +-
 tools/perf/config/Makefile | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.kbuild b/tools/perf/Makefile.kbuild
index 1e3621f..b2d0d08 100644
--- a/tools/perf/Makefile.kbuild
+++ b/tools/perf/Makefile.kbuild
@@ -90,7 +90,7 @@ VPATH += $(src-perf)
 
 export src-perf obj-perf
 
-OUTPUT := $(obj-perf)
+OUTPUT := $(obj-perf)/
 
 export OUTPUT
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 78ee62d..1760f57 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -135,7 +135,7 @@ endif
 
 feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" -C config/feature-checks test-$1.bin >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" -C $(src-perf)/config/feature-checks test-$1.bin >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
 feature_set = $(eval $(feature_set_code))
@@ -234,7 +234,7 @@ ifeq ($(feature-all), 1)
   #
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
 else
-  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(addsuffix .bin,$(CORE_FEATURE_TESTS)) >/dev/null 2>&1)
+  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS=$(LDFLAGS) -i -j -C $(src-perf)/config/feature-checks $(addsuffix .bin,$(CORE_FEATURE_TESTS)) >/dev/null 2>&1)
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
 endif
 
-- 
1.9.3

