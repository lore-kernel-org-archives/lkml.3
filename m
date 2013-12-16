Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3LPP1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:27:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47584 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3LPP1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:27:23 -0500
Date: Mon, 16 Dec 2013 07:26:56 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-d645c442e68d24e64c46845bc8bb5d5a0a70b249@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, ak@linux.intel.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1386765443-26966-17-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-17-git-send-email-alexander.shishkin@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header: Allow header->
 data_offset to be predetermined
Git-Commit-ID: d645c442e68d24e64c46845bc8bb5d5a0a70b249
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:27:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d645c442e68d24e64c46845bc8bb5d5a0a70b249
Gitweb:     http://git.kernel.org/tip/d645c442e68d24e64c46845bc8bb5d5a0a70b249
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 11 Dec 2013 14:36:28 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:20 -0300

perf header: Allow header->data_offset to be predetermined

It will be necessary to predetermine header->data_offset to allow space
for attributes that are added later.  Consequently, do not change
header->data_offset if it is non-zero.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386765443-26966-17-git-send-email-alexander.shishkin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 0bb830f..61c5421 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2327,7 +2327,8 @@ int perf_session__write_header(struct perf_session *session,
 		}
 	}
 
-	header->data_offset = lseek(fd, 0, SEEK_CUR);
+	if (!header->data_offset)
+		header->data_offset = lseek(fd, 0, SEEK_CUR);
 	header->feat_offset = header->data_offset + header->data_size;
 
 	if (at_exit) {
