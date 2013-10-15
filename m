Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab3JOF2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:28:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33313 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3JOF2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:28:19 -0400
Date: Mon, 14 Oct 2013 22:28:08 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-b6e8f8f4674be5a32f78027ec6e432f5ea33921e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1379900700-5186-2-git-send-email-dsahern@gmail.com>
References: <1379900700-5186-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Handle MSG_WAITFORONE not defined
Git-Commit-ID: b6e8f8f4674be5a32f78027ec6e432f5ea33921e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:28:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b6e8f8f4674be5a32f78027ec6e432f5ea33921e
Gitweb:     http://git.kernel.org/tip/b6e8f8f4674be5a32f78027ec6e432f5ea33921e
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 22 Sep 2013 19:44:56 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 17:42:37 -0300

perf trace: Handle MSG_WAITFORONE not defined

Needed for compiles on Fedora 12 for example.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1379900700-5186-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 39a947a..3ca6a85 100644
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
