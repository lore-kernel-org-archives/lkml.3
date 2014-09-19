Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaISFUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:20:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52898 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaISFUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:20:22 -0400
Date: Thu, 18 Sep 2014 22:20:04 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-6997af72e6c1e9d8c1cc511dc9485e9ee69a5e20@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, kyle@mcmartin.ca,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, kyle@mcmartin.ca,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1408978552-17131-1-git-send-email-jolsa@kernel.org>
References: <1408978552-17131-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Allow to specify lib compile variable for spec usage
Git-Commit-ID: 6997af72e6c1e9d8c1cc511dc9485e9ee69a5e20
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

Commit-ID:  6997af72e6c1e9d8c1cc511dc9485e9ee69a5e20
Gitweb:     http://git.kernel.org/tip/6997af72e6c1e9d8c1cc511dc9485e9ee69a5e20
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 25 Aug 2014 16:55:52 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 17:08:08 -0300

perf tools: Allow to specify lib compile variable for spec usage

We need a way to specify $(lib) part of the installation path for
traceevent plugin libraries. Currently we use 'lib64' for x86_64 and
'lib' otherwise.

Instead of listing all possible values, this change allows the rpm spec
code to specify the correct $(lib) part based on processed architecture,
like

  $ make ... lib=%{_lib}

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Kyle McMartin <kyle@mcmartin.ca>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1408978552-17131-1-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 98c9fd1..58f6091 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -653,11 +653,13 @@ else
 sysconfdir = $(prefix)/etc
 ETC_PERFCONFIG = etc/perfconfig
 endif
+ifndef lib
 ifeq ($(IS_X86_64),1)
 lib = lib64
 else
 lib = lib
 endif
+endif # lib
 libdir = $(prefix)/$(lib)
 
 # Shell quote (do not use $(call) to accommodate ancient setups);
