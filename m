Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaHRIZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:25:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51675 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaHRIZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:25:39 -0400
Date: Mon, 18 Aug 2014 01:25:14 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-f9f33fdba159a9c163ecf1dc0106ebd4c2498130@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, naota@elisp.net, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        naota@elisp.net, namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20140814022251.3545.83718.stgit@kbuild-fedora.novalocal>
References: <20140814022251.3545.83718.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Use strerror_r instead of strerror
Git-Commit-ID: f9f33fdba159a9c163ecf1dc0106ebd4c2498130
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9f33fdba159a9c163ecf1dc0106ebd4c2498130
Gitweb:     http://git.kernel.org/tip/f9f33fdba159a9c163ecf1dc0106ebd4c2498130
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Aug 2014 02:22:51 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 13:08:14 -0300

perf kvm: Use strerror_r instead of strerror

Use strerror_r instead of strerror in error messages for thread-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814022251.3545.83718.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 14d03ed..1a4ef9c 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -990,6 +990,7 @@ static int kvm_live_open_events(struct perf_kvm_stat *kvm)
 	int err, rc = -1;
 	struct perf_evsel *pos;
 	struct perf_evlist *evlist = kvm->evlist;
+	char sbuf[STRERR_BUFSIZE];
 
 	perf_evlist__config(evlist, &kvm->opts);
 
@@ -1026,12 +1027,14 @@ static int kvm_live_open_events(struct perf_kvm_stat *kvm)
 
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
-		printf("Couldn't create the events: %s\n", strerror(errno));
+		printf("Couldn't create the events: %s\n",
+		       strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out;
 	}
 
 	if (perf_evlist__mmap(evlist, kvm->opts.mmap_pages, false) < 0) {
-		ui__error("Failed to mmap the events: %s\n", strerror(errno));
+		ui__error("Failed to mmap the events: %s\n",
+			  strerror_r(errno, sbuf, sizeof(sbuf)));
 		perf_evlist__close(evlist);
 		goto out;
 	}
