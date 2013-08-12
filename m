Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3HLKUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:20:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47894 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575Ab3HLKUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:20:32 -0400
Date: Mon, 12 Aug 2013 03:20:18 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-2bbf03f16a634f675c49c473b2b6528571990aea@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1375490473-1503-5-git-send-email-andi@firstfloor.org>
References: <1375490473-1503-5-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat:
  Flush output after each line in interval mode
Git-Commit-ID: 2bbf03f16a634f675c49c473b2b6528571990aea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:20:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2bbf03f16a634f675c49c473b2b6528571990aea
Gitweb:     http://git.kernel.org/tip/2bbf03f16a634f675c49c473b2b6528571990aea
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 2 Aug 2013 17:41:12 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:29 -0300

perf stat: Flush output after each line in interval mode

When interval mode is outputting to a pipe, each measurement should be
flushed individually, so that the reader sees it timely.

With a terminal each line is automatically flushed by stdio, but that is
disabled with non terminal output.

Simply fflush output after each time interval

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375490473-1503-5-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2e637e4..f686d5f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -416,6 +416,8 @@ static void print_interval(void)
 		list_for_each_entry(counter, &evsel_list->entries, node)
 			print_counter_aggr(counter, prefix);
 	}
+
+	fflush(output);
 }
 
 static void handle_initial_delay(void)
