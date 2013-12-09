Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab3LIThd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:37:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54949 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760421Ab3LIThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/21] perf kvm: Make perf kvm diff support --guestmount.
Date: Mon,  9 Dec 2013 16:37:04 -0300
Message-Id: <1386617830-18926-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

In manpage of perf-kvm, --guestmount is supported by diff command, but
it does not work well.

This patch change the extend the checking in buildid-diff from
guestkallsyms or guestmodules to perf_guest. Then this checking can
cover the all cases perf kvm is used for.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/72857ed89642e0633f5e88f7e7abbc9645359e8e.1386368672.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 3b67ea2444bd..2a85cc9a2d09 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1000,8 +1000,7 @@ static int data_init(int argc, const char **argv)
 			data__files_cnt = argc;
 			use_default = false;
 		}
-	} else if (symbol_conf.default_guest_vmlinux_name ||
-		   symbol_conf.default_guest_kallsyms) {
+	} else if (perf_guest) {
 		defaults[0] = "perf.data.host";
 		defaults[1] = "perf.data.guest";
 	}
-- 
1.8.1.4

