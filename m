Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaCRIaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:30:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45655 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaCRIaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:30:39 -0400
Date: Tue, 18 Mar 2014 01:30:25 -0700
From: tip-bot for Don Zickus <tipbot@zytor.com>
Message-ID: <tip-0ea590ae8198547d5898c72b04fa9d8f23bd0b8f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@redhat.com, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@redhat.com,
        tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1393386227-149412-3-git-send-email-dzickus@redhat.com>
References: <1393386227-149412-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session:
  Change header.misc dump from decimal to hex
Git-Commit-ID: 0ea590ae8198547d5898c72b04fa9d8f23bd0b8f
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

Commit-ID:  0ea590ae8198547d5898c72b04fa9d8f23bd0b8f
Gitweb:     http://git.kernel.org/tip/0ea590ae8198547d5898c72b04fa9d8f23bd0b8f
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Tue, 25 Feb 2014 22:43:46 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Mar 2014 18:08:39 -0300

perf session: Change header.misc dump from decimal to hex

When printing the raw dump of a data file, the header.misc is
printed as a decimal.  Unfortunately, that field is a bit mask, so
it is hard to interpret as a decimal.

Print in hex, so the user can easily see what bits are set and more
importantly what type of info it is conveying.

V2: add 0x in front per Jiri Olsa

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1393386227-149412-3-git-send-email-dzickus@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1d555d6..55960f2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -794,7 +794,7 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (!dump_trace)
 		return;
 
-	printf("(IP, %d): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
+	printf("(IP, 0x%x): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
 	       event->header.misc, sample->pid, sample->tid, sample->ip,
 	       sample->period, sample->addr);
 
