Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab3LRKcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:32:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44630 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3LRKcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:32:15 -0500
Date: Wed, 18 Dec 2013 02:31:23 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-4mw7xrbs12tln6v2uthg7sqc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Remove needless static binary_type array
Git-Commit-ID: 631d34b5626a8de828f3ab8da54013293097e678
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:31:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  631d34b5626a8de828f3ab8da54013293097e678
Gitweb:     http://git.kernel.org/tip/631d34b5626a8de828f3ab8da54013293097e678
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 16 Dec 2013 16:57:43 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 16 Dec 2013 16:57:43 -0300

perf symbols: Remove needless static binary_type array

There are no references to that array anywhere, it is only used to try
a series of "binary" types in turn, always setting dso->data_type till
one can be used.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-4mw7xrbs12tln6v2uthg7sqc@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 436922f..e7f4449 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -161,7 +161,7 @@ static int open_dso(struct dso *dso, struct machine *machine)
 
 int dso__data_fd(struct dso *dso, struct machine *machine)
 {
-	static enum dso_binary_type binary_type_data[] = {
+	enum dso_binary_type binary_type_data[] = {
 		DSO_BINARY_TYPE__BUILD_ID_CACHE,
 		DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
 		DSO_BINARY_TYPE__NOT_FOUND,
