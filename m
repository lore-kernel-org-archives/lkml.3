Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3AXUKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:10:18 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54074
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755890Ab3AXUIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 37/74] perf symbols: Include elf.h header regardless LIBELF_SUPPORT
Date: Thu, 24 Jan 2013 17:07:46 -0300
Message-Id: <1359058103-31645-38-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The elf.h header file is used for NO_LIBELF build too so it should be
included anyway.  Also remove duplicated include of the header file in
symbol-*.c.  This patch fixes following build error on NO_LIBELF build:

    CC tests/hists_link.o
tests/hists_link.c: In function ‘setup_fake_machine’:
tests/hists_link.c:132:8: error: ‘STB_GLOBAL’ undeclared (first use in this function)
tests/hists_link.c:132:8: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1356679009-32122-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c     | 3 ---
 tools/perf/util/symbol-minimal.c | 1 -
 tools/perf/util/symbol.h         | 2 +-
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index f63557b..54efcb5 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1,6 +1,3 @@
-#include <libelf.h>
-#include <gelf.h>
-#include <elf.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <errno.h>
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 259f8f2..a7390cd 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -1,6 +1,5 @@
 #include "symbol.h"
 
-#include <elf.h>
 #include <stdio.h>
 #include <fcntl.h>
 #include <string.h>
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ec7b240..d97377a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -16,8 +16,8 @@
 #ifdef LIBELF_SUPPORT
 #include <libelf.h>
 #include <gelf.h>
-#include <elf.h>
 #endif
+#include <elf.h>
 
 #include "dso.h"
 
-- 
1.8.1.1.361.gec3ae6e

