Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3IWBpO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:45:14 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35673 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3IWBpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:45:10 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/5] perf trace: Handle MSG_WAITFORONE not defined
Date: Sun, 22 Sep 2013 19:44:56 -0600
Message-Id: <1379900700-5186-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1379900700-5186-1-git-send-email-dsahern@gmail.com>
References: <1379900700-5186-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed for compiles on Fedora 12 for example.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-trace.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f869c87..9c7f017 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -340,6 +340,9 @@ static size_t syscall_arg__scnprintf_socket_type(char *bf, size_t size,
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
1.7.10.1

