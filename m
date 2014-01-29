Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaA2JSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:18:06 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49185 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaA2JO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:14:58 -0500
Subject: [PATCH -tip v2 2/8] perf-probe: Remove incorrect symbol check for
 --list
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 29 Jan 2014 09:14:55 +0000
Message-ID: <20140129091455.22141.59802.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unneeded symbol check for --list option.
This code actually checks whether the given symbol exists
in the kernel. But this is incorrect for online kernel/module
and offline module too.
 - For online kernel/module, the kprobes itself already
  ensured the symbol exist in the kernel.
 - For offline module, this code can't access the offlined
  modules. Ignore it.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/probe-event.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 14c649df..48498c6 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -743,14 +743,6 @@ out:
 static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 					struct perf_probe_point *pp)
 {
-	struct symbol *sym;
-
-	sym = __find_kernel_function_by_name(tp->symbol, NULL);
-	if (!sym) {
-		pr_err("Failed to find symbol %s in kernel.\n", tp->symbol);
-		return -ENOENT;
-	}
-
 	return convert_to_perf_probe_point(tp, pp);
 }
 


