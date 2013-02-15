Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab3BOQcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:32:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35796 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab3BOQcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:32:02 -0500
Date: Fri, 15 Feb 2013 08:30:18 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-e3a34029c635b7dee06e51d99441578b96c7d463@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        bp@alien8.de, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, bp@alien8.de, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1360227734-375-6-git-send-email-namhyung@kernel.org>
References: <1360227734-375-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Fix warning message on a missing vmlinux
Git-Commit-ID: e3a34029c635b7dee06e51d99441578b96c7d463
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 15 Feb 2013 08:30:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3a34029c635b7dee06e51d99441578b96c7d463
Gitweb:     http://git.kernel.org/tip/e3a34029c635b7dee06e51d99441578b96c7d463
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 7 Feb 2013 18:02:12 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Feb 2013 14:59:27 -0300

perf annotate: Fix warning message on a missing vmlinux

When perf annotate runs with no vmlinux file it cannot annotate kernel
symbols because the kallsyms only provides symbol addresses.  So it
recommends to run perf buildid-cache to install proper vmlinux image.

But running perf buildid-cache -av vmlinux as the message gives me a
following error:

  $ perf buildid-cache -av /home/namhyung/build/kernel/vmlinux
  Couldn't add v: No such file or directory

Since the -a option receives a parameter, 'v' should not be after the
option.

In addition -a option is not work for this case since the build-id cache
already has a kallsyms with same build-id so it'll fail with EEXIST.
Use recently added -u (--update) option for it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360227734-375-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 07aaeea..d33fe93 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -809,7 +809,7 @@ fallback:
 		pr_err("Can't annotate %s:\n\n"
 		       "No vmlinux file%s\nwas found in the path.\n\n"
 		       "Please use:\n\n"
-		       "  perf buildid-cache -av vmlinux\n\n"
+		       "  perf buildid-cache -vu vmlinux\n\n"
 		       "or:\n\n"
 		       "  --vmlinux vmlinux\n",
 		       sym->name, build_id_msg ?: "");
