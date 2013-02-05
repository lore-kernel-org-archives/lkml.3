Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3BEQRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:17:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab3BEQRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:17:52 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Andrew Jones <drjones@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/2] perf scripts: Fix rwtop record script
Date: Tue,  5 Feb 2013 17:05:51 +0100
Message-Id: <1360080351-3246-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1360080351-3246-1-git-send-email-jolsa@redhat.com>
References: <1360080351-3246-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding -D option into the rwtop record command line, to get
immediate response when there's event in the buffer.

Otherwise we need to wait till half of the buffer is filled,
which is the default wattermark if it's not set.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Andrew Jones <drjones@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/scripts/perl/bin/rwtop-record | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/scripts/perl/bin/rwtop-record b/tools/perf/scripts/perl/bin/rwtop-record
index 7cb9db2..e4ec090 100644
--- a/tools/perf/scripts/perl/bin/rwtop-record
+++ b/tools/perf/scripts/perl/bin/rwtop-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
+perf record -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write -D $@
-- 
1.7.11.7

