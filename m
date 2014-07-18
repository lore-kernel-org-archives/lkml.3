Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934521AbaGREZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:25:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33181 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934463AbaGREZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:25:12 -0400
Date: Thu, 17 Jul 2014 21:24:19 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-e38b43c3f3fd8ebe6f558400d1647a923bc19d44@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1405332185-4050-11-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-11-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf inject: Fix build id injection
Git-Commit-ID: e38b43c3f3fd8ebe6f558400d1647a923bc19d44
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

Commit-ID:  e38b43c3f3fd8ebe6f558400d1647a923bc19d44
Gitweb:     http://git.kernel.org/tip/e38b43c3f3fd8ebe6f558400d1647a923bc19d44
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:34 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:34 -0300

perf inject: Fix build id injection

Build Ids won't be injected unless the build id feature flag is set.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-11-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 16c7c11..cf6a605 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -389,6 +389,9 @@ static int __cmd_inject(struct perf_inject *inject)
 	ret = perf_session__process_events(session, &inject->tool);
 
 	if (!file_out->is_pipe) {
+		if (inject->build_ids)
+			perf_header__set_feat(&session->header,
+					      HEADER_BUILD_ID);
 		session->header.data_size = inject->bytes_written;
 		perf_session__write_header(session, session->evlist, file_out->fd, true);
 	}
