Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaEAGch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:32:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaEAGce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:32:34 -0400
Date: Wed, 30 Apr 2014 23:32:17 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-611ec127165b572f02823e152d6774e2145305a3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1398760413-7574-1-git-send-email-jolsa@kernel.org>
References: <1398760413-7574-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add static build make test
Git-Commit-ID: 611ec127165b572f02823e152d6774e2145305a3
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

Commit-ID:  611ec127165b572f02823e152d6774e2145305a3
Gitweb:     http://git.kernel.org/tip/611ec127165b572f02823e152d6774e2145305a3
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Tue, 29 Apr 2014 09:53:40 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 30 Apr 2014 16:48:57 +0200

perf tests: Add static build make test

Adding test for building static perf build into the automated
suite. Also available via following commands:

  $ make -f tests/make make_static
  - make_static: cd . && make -f Makefile DESTDIR=/tmp/tmp.7u5MlB4njo LDFLAGS=-static
  $ make -f tests/make make_static_O
  - make_static_O: cd . && make -f Makefile O=/tmp/tmp.Ay6r3wEmtX DESTDIR=/tmp/tmp.vK0KQwO0Vi LDFLAGS=-static

Acked-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1398760413-7574-1-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/tests/make | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 5daeae1..2f92d6e 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -46,6 +46,7 @@ make_install_man    := install-man
 make_install_html   := install-html
 make_install_info   := install-info
 make_install_pdf    := install-pdf
+make_static         := LDFLAGS=-static
 
 # all the NO_* variable combined
 make_minimal        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1
@@ -87,6 +88,7 @@ run += make_install_bin
 # run += make_install_info
 # run += make_install_pdf
 run += make_minimal
+run += make_static
 
 ifneq ($(call has,ctags),)
 run += make_tags
