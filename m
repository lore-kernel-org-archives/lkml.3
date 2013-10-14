Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab3JNUGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:06:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39143 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811Ab3JNUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 152/161] tools/perf/build: Improve the 'stackprotector' feature test
Date: Mon, 14 Oct 2013 17:02:21 -0300
Message-Id: <1381780950-25642-153-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

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
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/feature-checks/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 2eb83467cca2..c70d23ecb64e 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -45,7 +45,7 @@ test-stackprotector-all:
 	$(BUILD) -Werror -fstack-protector-all
 
 test-stackprotector:
-	$(BUILD) -Werror -fstack-protector
+	$(BUILD) -Werror -fstack-protector -Wstack-protector
 
 test-fortify-source:
 	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
-- 
1.8.1.4

