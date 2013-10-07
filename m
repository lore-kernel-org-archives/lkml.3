Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab3JGMLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:11:11 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53408 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3JGL5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:57:51 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/50] tools/perf/build: Add 'autodep' functionality, generate feature test dependencies automatically
Date: Mon,  7 Oct 2013 13:55:56 +0200
Message-Id: <1381147003-2574-4-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
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
1.7.11.7

