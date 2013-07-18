Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408Ab3GRT4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:56:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41974 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934321Ab3GRT4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:56:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <rric@kernel.org>,
        Robert Richter <robert.richter@linaro.org>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 69/76] perf tools: Fix 'make tools/perf'
Date: Thu, 18 Jul 2013 16:49:56 -0300
Message-Id: <1374177003-3706-70-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rric@kernel.org>

Boris just raised another variant of building perf tools which is
broken:

 $ make tools/perf
 ...
     LINK /home/robert/cx/linux/tools/perf/perf
 gcc: error: ../linux/tools/lib/lk/liblk.a: No such file or directory

The variant wasn't considered by:

 107de37 perf tools: Fix build errors with O and DESTDIR make vars set

There are other variant of building perf too:

 $ make -C tools perf
 $ make -C tools/perf

Plus variants with O= and DESTDIR set.

This patch fixes the above and was tested with the following:

 $ make O=... DESTDIR=... tools/perf
 $ make O=... DESTDIR=... -C tools/ perf
 $ make O=... DESTDIR=... -C tools/perf
 $ make tools/perf
 $ make -C tools/ perf
 $ make -C tools/perf

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-tip-commits@vger.kernel.org
Link: http://lkml.kernel.org/r/20130716145036.GH8731@rric.localhost
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5b7c6db..2a69026 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -124,7 +124,7 @@ strip-libs = $(filter-out -l%,$(1))
 ifneq ($(OUTPUT),)
   TE_PATH=$(OUTPUT)
 ifneq ($(subdir),)
-  LK_PATH=$(objtree)/lib/lk/
+  LK_PATH=$(OUTPUT)/../lib/lk/
 else
   LK_PATH=$(OUTPUT)
 endif
-- 
1.8.1.4

