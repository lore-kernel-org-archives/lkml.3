Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab3AYLwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:52:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42053 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3AYLwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:52:19 -0500
Date: Fri, 25 Jan 2013 03:51:45 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-3cf0cb1f899640f1eb8b3984739cfd70375c9c36@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20130114140245.GA4692@quad>
References: <20130114140245.GA4692@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Mark branch_info maps as referenced
Git-Commit-ID: 3cf0cb1f899640f1eb8b3984739cfd70375c9c36
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:51:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3cf0cb1f899640f1eb8b3984739cfd70375c9c36
Gitweb:     http://git.kernel.org/tip/3cf0cb1f899640f1eb8b3984739cfd70375c9c36
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 14 Jan 2013 15:02:45 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:38 -0300

perf tools: Mark branch_info maps as referenced

As noticed by Jiri, the hist_entry->branch_info.to/from maps need to be
marked as referenced to avoid problems later on.  So we do this when the
hist_entry is allocated.

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130114140245.GA4692@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9485c70..8170a3d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -245,6 +245,14 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 
 		if (he->ms.map)
 			he->ms.map->referenced = true;
+
+		if (he->branch_info) {
+			if (he->branch_info->from.map)
+				he->branch_info->from.map->referenced = true;
+			if (he->branch_info->to.map)
+				he->branch_info->to.map->referenced = true;
+		}
+
 		if (symbol_conf.use_callchain)
 			callchain_init(he->callchain);
 
