Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3JHK0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:26:43 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:49420 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab3JHKMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:07 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/52] tools/perf/build: Add 'autodep' functionality, generate feature test dependencies automatically
Date: Tue,  8 Oct 2013 12:10:33 +0200
Message-Id: <1381227082-22039-4-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use GCC's -MD feature to generate a dependency file for each feature test .c file,
and include that .d file in the config/feature-checks/Makefile.

This allows us to do two things:

 - speed up feature tests
 - detect removal or changes in build dependencies - including system libraries/headers

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-Jfma8pmPnnqzpxjbs3hpgmsj@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/feature-checks/Makefile | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index b3f6372..4708cca 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -1,16 +1,20 @@
 
 FILES=test-hello
 
+CC := $(CC) -MD
+
 all: $(FILES)
 
 BUILD = $(CC) -o $(OUTPUT)$@ $@.c
 
 ###############################
 
-test-hello: test-hello.c
+test-hello:
 	$(BUILD)
 
+-include *.d */*.d
+
 ###############################
 
 clean:
-	rm -f $(FILES)
+	rm -f $(FILES) *.d
-- 
1.8.3.1

