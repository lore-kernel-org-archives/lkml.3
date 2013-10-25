Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3JYKdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:33:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52440 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab3JYKdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:33:07 -0400
Date: Fri, 25 Oct 2013 03:32:41 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-56921becdd1eb0720603fc2e6e4c7f518196d917@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1382427258-17495-14-git-send-email-adrian.hunter@intel.com>
References: <1382427258-17495-14-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Do not accept parse_tag_value()
  overflow
Git-Commit-ID: 56921becdd1eb0720603fc2e6e4c7f518196d917
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 25 Oct 2013 03:32:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56921becdd1eb0720603fc2e6e4c7f518196d917
Gitweb:     http://git.kernel.org/tip/56921becdd1eb0720603fc2e6e4c7f518196d917
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Oct 2013 10:34:17 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Oct 2013 10:59:09 -0300

perf tools: Do not accept parse_tag_value() overflow

parse_tag_value() accepts an "unsigned long" and multiplies it according
to a tag character.  Do not accept the value if the multiplication
overflows.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382427258-17495-14-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index c25e57b..28a0a89 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -386,6 +386,8 @@ unsigned long parse_tag_value(const char *str, struct parse_tag *tags)
 			if (s != endptr)
 				break;
 
+			if (value > ULONG_MAX / i->mult)
+				break;
 			value *= i->mult;
 			return value;
 		}
