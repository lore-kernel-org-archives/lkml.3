Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaKGFbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:31:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57887 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaKGFbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:31:46 -0500
Date: Thu, 6 Nov 2014 21:31:28 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-96d78059d6d9da45d77078a219924304860497f2@git.kernel.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        adrian.hunter@intel.com, dsahern@gmail.com, eranian@google.com,
        paulus@samba.org, namhyung@kernel.org, hpa@zytor.com,
        namhyung.kim@lge.com, acme@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl
Reply-To: adrian.hunter@intel.com, eranian@google.com, dsahern@gmail.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        hpa@zytor.com, namhyung.kim@lge.com, mingo@kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, namhyung@kernel.org
In-Reply-To: <1415063674-17206-9-git-send-email-namhyung@kernel.org>
References: <1415063674-17206-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Make vmlinux short name more like kallsyms short name
Git-Commit-ID: 96d78059d6d9da45d77078a219924304860497f2
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

Commit-ID:  96d78059d6d9da45d77078a219924304860497f2
Gitweb:     http://git.kernel.org/tip/96d78059d6d9da45d77078a219924304860497f2
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 4 Nov 2014 10:14:34 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Nov 2014 10:14:09 -0300

perf tools: Make vmlinux short name more like kallsyms short name

The previous patch changed kernel dso name from '[kernel.kallsyms]' to
vmlinux.  However it might add confusion to old users accustomed to the
old name.  So change the short name to '[kernel.vmlinux]' to reduce such
confusion.

Before:
  # Overhead  Command         Shared Object            Symbol
  # ........  ..............  .......................  ...............................
  #
       9.83%  swapper         vmlinux                  [k] intel_idle
       4.10%  awk             libc-2.20.so             [.] __strcmp_sse2
       1.86%  sed             libc-2.20.so             [.] __strcmp_sse2
       1.78%  netctl-auto     libc-2.20.so             [.] __strcmp_sse2
       1.23%  netctl-auto     libc-2.20.so             [.] __mbrtowc
       1.21%  firefox         libxul.so                [.] 0x00000000024b62bd
       1.20%  swapper         vmlinux                  [k] cpuidle_enter_state
       1.03%  sleep           vmlinux                  [k] copy_user_generic_unrolled

After:
  # Overhead  Command         Shared Object            Symbol
  # ........  ..............  .......................  ...............................
  #
       9.83%  swapper         [kernel.vmlinux]         [k] intel_idle
       4.10%  awk             libc-2.20.so             [.] __strcmp_sse2
       1.86%  sed             libc-2.20.so             [.] __strcmp_sse2
       1.78%  netctl-auto     libc-2.20.so             [.] __strcmp_sse2
       1.23%  netctl-auto     libc-2.20.so             [.] __mbrtowc
       1.21%  firefox         libxul.so                [.] 0x00000000024b62bd
       1.20%  swapper         [kernel.vmlinux]         [k] cpuidle_enter_state
       1.03%  sleep           [kernel.vmlinux]         [k] copy_user_generic_unrolled

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415063674-17206-9-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 53f90e9..52e9490 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1106,6 +1106,9 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 		if (__machine__create_kernel_maps(machine, kernel) < 0)
 			goto out_problem;
 
+		if (strstr(dso->long_name, "vmlinux"))
+			dso__set_short_name(dso, "[kernel.vmlinux]", false);
+
 		machine__set_kernel_mmap_len(machine, event);
 
 		/*
