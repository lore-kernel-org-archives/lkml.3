Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaANQl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:41:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaANQlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:41:51 -0500
Date: Tue, 14 Jan 2014 08:41:33 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-741a0c59032faeddac80a6237f3d7846231a3740@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1389276059-8829-5-git-send-email-namhyung@kernel.org>
References: <1389276059-8829-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools include: Include <linux/compiler.h>
  from asm/bug.h
Git-Commit-ID: 741a0c59032faeddac80a6237f3d7846231a3740
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:41:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  741a0c59032faeddac80a6237f3d7846231a3740
Gitweb:     http://git.kernel.org/tip/741a0c59032faeddac80a6237f3d7846231a3740
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 9 Jan 2014 23:00:55 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:14:13 -0300

tools include: Include <linux/compiler.h> from asm/bug.h

Since it uses unlikely() macro inside WARN()

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389276059-8829-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/asm/bug.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/asm/bug.h b/tools/include/asm/bug.h
index eca78df..9e5f484 100644
--- a/tools/include/asm/bug.h
+++ b/tools/include/asm/bug.h
@@ -1,6 +1,8 @@
 #ifndef _TOOLS_ASM_BUG_H
 #define _TOOLS_ASM_BUG_H
 
+#include <linux/compiler.h>
+
 #define __WARN_printf(arg...)	do { fprintf(stderr, arg); } while (0)
 
 #define WARN(condition, format...) ({		\
