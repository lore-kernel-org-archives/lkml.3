Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab3JNUip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:38:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38791 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab3JNUDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 107/161] perf trace: Handle MSG_WAITFORONE not defined
Date: Mon, 14 Oct 2013 17:01:36 -0300
Message-Id: <1381780950-25642-108-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Needed for compiles on Fedora 12 for example.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1379900700-5186-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 39a947a0d122..3ca6a856ba62 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -363,6 +363,9 @@ static size_t syscall_arg__scnprintf_socket_type(char *bf, size_t size,
 #ifndef MSG_PROBE
 #define MSG_PROBE	     0x10
 #endif
+#ifndef MSG_WAITFORONE
+#define MSG_WAITFORONE	0x10000
+#endif
 #ifndef MSG_SENDPAGE_NOTLAST
 #define MSG_SENDPAGE_NOTLAST 0x20000
 #endif
-- 
1.8.1.4

