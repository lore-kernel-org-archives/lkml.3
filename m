Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaITQSb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:18:31 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53069 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaITQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:18:30 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Milian Wolff <mail@milianw.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHSET 0/5] perf tools: Add call-graph config options
Date: Sun, 21 Sep 2014 01:18:01 +0900
Message-Id: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is patchset to add new callchain related config options so that
users don't need to pass their preference to the cmdline everytime.

Following config options will be added, and users can set appropriate
values to ~/.perfconfig file.  Note that the dump-size option is
meaningful only if record-mode = dwarf.

  $ cat ~/.perfconfig
  [call-graph]
    record-mode = dwarf
    dump-size = 4096
    print-type = graph
    order = callee
    threshold = 0.5
    print-limit = 128
    sort-key = function

  $ perf record -vg sleep 1
  callchain: type DWARF
  callchain: stack dump size 4096
  mmap size 528384B
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.054 MB perf.data (~2378 samples) ]
  Looking at the vmlinux_path (7 entries long)
  Using /lib/modules/3.16.3-1-ARCH/build/vmlinux for symbols


You can also get this from 'perf/callchain-config-v1' branch on my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcomed, thanks
Namhyung


Namhyung Kim (5):
  perf hists browser: Fix callchain print bug on TUI
  perf tools: Move callchain config from record_opts to callchain_param
  perf tools: Move some callchain parser functions to callchain.c
  perf tools: Introduce perf_callchain_config()
  perf tools: Convert {record,top}.call-graph option to
    call-graph.record-mode

 tools/perf/builtin-record.c    | 119 ++++++-----------------------------------
 tools/perf/builtin-top.c       |   4 +-
 tools/perf/perf.h              |   3 --
 tools/perf/ui/browsers/hists.c |   3 --
 tools/perf/util/callchain.c    | 117 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h    |   6 ++-
 tools/perf/util/config.c       |   3 ++
 tools/perf/util/evsel.c        |  11 ++--
 8 files changed, 146 insertions(+), 120 deletions(-)

-- 
2.1.0

