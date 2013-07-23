Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab3GWHrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:47:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56219 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3GWHro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:47:44 -0400
Date: Tue, 23 Jul 2013 00:47:19 -0700
From: "tip-bot for Kirill A. Shutemov" <tipbot@zytor.com>
Message-ID: <tip-575bf1d04e908469d26da424b52fc1b12a1db9d8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, kirill@shutemov.name
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, kirill@shutemov.name
In-Reply-To: <1372063394-20126-1-git-send-email-kirill@shutemov.name>
References: <1372063394-20126-1-git-send-email-kirill@shutemov.name>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix build with perl 5.18
Git-Commit-ID: 575bf1d04e908469d26da424b52fc1b12a1db9d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 00:47:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  575bf1d04e908469d26da424b52fc1b12a1db9d8
Gitweb:     http://git.kernel.org/tip/575bf1d04e908469d26da424b52fc1b12a1db9d8
Author:     Kirill A. Shutemov <kirill@shutemov.name>
AuthorDate: Mon, 24 Jun 2013 11:43:14 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 22 Jul 2013 12:55:20 -0300

perf tools: Fix build with perl 5.18

perl.h from new Perl release doesn't like -Wundef and -Wswitch-default:

/usr/lib/perl5/core_perl/CORE/perl.h:548:5: error: "SILENT_NO_TAINT_SUPPORT" is not defined [-Werror=undef]
 #if SILENT_NO_TAINT_SUPPORT && !defined(NO_TAINT_SUPPORT)
     ^
/usr/lib/perl5/core_perl/CORE/perl.h:556:5: error: "NO_TAINT_SUPPORT" is not defined [-Werror=undef]
 #if NO_TAINT_SUPPORT
     ^
In file included from /usr/lib/perl5/core_perl/CORE/perl.h:3471:0,
                 from util/scripting-engines/trace-event-perl.c:30:
/usr/lib/perl5/core_perl/CORE/sv.h:1455:5: error: "NO_TAINT_SUPPORT" is not defined [-Werror=undef]
 #if NO_TAINT_SUPPORT
     ^
In file included from /usr/lib/perl5/core_perl/CORE/perl.h:3472:0,
                 from util/scripting-engines/trace-event-perl.c:30:
/usr/lib/perl5/core_perl/CORE/regexp.h:436:5: error: "NO_TAINT_SUPPORT" is not defined [-Werror=undef]
 #if NO_TAINT_SUPPORT
     ^
In file included from /usr/lib/perl5/core_perl/CORE/hv.h:592:0,
                 from /usr/lib/perl5/core_perl/CORE/perl.h:3480,
                 from util/scripting-engines/trace-event-perl.c:30:
/usr/lib/perl5/core_perl/CORE/hv_func.h: In function ‘S_perl_hash_siphash_2_4’:
/usr/lib/perl5/core_perl/CORE/hv_func.h:222:3: error: switch missing default case [-Werror=switch-default]
   switch( left )
   ^
/usr/lib/perl5/core_perl/CORE/hv_func.h: In function ‘S_perl_hash_superfast’:
/usr/lib/perl5/core_perl/CORE/hv_func.h:274:5: error: switch missing default case [-Werror=switch-default]
     switch (rem) { \
     ^
/usr/lib/perl5/core_perl/CORE/hv_func.h: In function ‘S_perl_hash_murmur3’:
/usr/lib/perl5/core_perl/CORE/hv_func.h:398:5: error: switch missing default case [-Werror=switch-default]
     switch(bytes_in_carry) { /* how many bytes in carry */
     ^

Let's disable the warnings for code which uses perl.h.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1372063394-20126-1-git-send-email-kirill@shutemov.name
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2a69026..024680b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -631,10 +631,10 @@ $(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-redundant-decls $<
 
 $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow -Wno-undef -Wno-switch-default $<
 
 $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs -Wno-undef -Wno-switch-default $<
 
 $(OUTPUT)util/scripting-engines/trace-event-python.o: util/scripting-engines/trace-event-python.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
