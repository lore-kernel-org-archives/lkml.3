Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbaFALhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 07:37:34 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44105 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbaFALhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 07:37:33 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: builtin-trace.c:  Cleaning up memory leak
Date: Sun,  1 Jun 2014 13:38:26 +0200
Message-Id: <1401622706-13802-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk for memory leak in when something unexpected happens
and the function returns.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/perf/builtin-trace.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f954c26..e6b3df9 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1855,6 +1855,7 @@ static int trace__record(int argc, const char **argv)
 		rec_argv[i] = "syscalls:sys_enter,syscalls:sys_exit";
 	else {
 		pr_err("Neither raw_syscalls nor syscalls events exist.\n");
+		free(rec_argv);
 		return -1;
 	}
 	i++;
-- 
1.7.10.4

