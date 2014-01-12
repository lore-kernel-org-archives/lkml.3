Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaALSdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:33:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45431 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaALSdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:33:05 -0500
Date: Sun, 12 Jan 2014 10:32:46 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-73db8f82619b7538d9b4badfe13f3ab2fef7d9b3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1387436411-20160-4-git-send-email-namhyung@kernel.org>
References: <1387436411-20160-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Get rid of a duplicate va_end()
  in error reporting routine
Git-Commit-ID: 73db8f82619b7538d9b4badfe13f3ab2fef7d9b3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:32:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73db8f82619b7538d9b4badfe13f3ab2fef7d9b3
Gitweb:     http://git.kernel.org/tip/73db8f82619b7538d9b4badfe13f3ab2fef7d9b3
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 19 Dec 2013 16:00:08 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 11:38:42 -0300

perf tools: Get rid of a duplicate va_end() in error reporting routine

The va_end() in _eprintf() should be removed since the caller also
invokes va_end().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1387436411-20160-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/debug.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 8640a91..299b555 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -25,7 +25,6 @@ static int _eprintf(int level, const char *fmt, va_list args)
 			ui_helpline__vshow(fmt, args);
 		else
 			ret = vfprintf(stderr, fmt, args);
-		va_end(args);
 	}
 
 	return ret;
