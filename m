Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab3KLV5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:57:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40188 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab3KLV4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:56:35 -0500
Date: Tue, 12 Nov 2013 13:56:04 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-73faab3a421351c342b10b0177fec9eea1a1d809@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1384237500-22991-1-git-send-email-namhyung@kernel.org>
References: <1384237500-22991-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace: Beautify fifth argument of mmap()
  as fd
Git-Commit-ID: 73faab3a421351c342b10b0177fec9eea1a1d809
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:56:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73faab3a421351c342b10b0177fec9eea1a1d809
Gitweb:     http://git.kernel.org/tip/73faab3a421351c342b10b0177fec9eea1a1d809
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 12 Nov 2013 15:24:59 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Nov 2013 13:00:23 -0300

perf trace: Beautify fifth argument of mmap() as fd

The fifth argument of mmap syscall is fd and it often contains -1 as a
value for anon mappings.  Without this patch it doesn't show the file
name as well as it shows -1 as 4294967295.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1384237500-22991-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c3008b1..aeb6296 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -951,7 +951,8 @@ static struct syscall_fmt {
 	{ .name	    = "mmap",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX,	  /* addr */
 			     [2] = SCA_MMAP_PROT, /* prot */
-			     [3] = SCA_MMAP_FLAGS, /* flags */ }, },
+			     [3] = SCA_MMAP_FLAGS, /* flags */
+			     [4] = SCA_FD, 	  /* fd */ }, },
 	{ .name	    = "mprotect",   .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* start */
 			     [2] = SCA_MMAP_PROT, /* prot */ }, },
