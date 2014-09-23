Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaIWBBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 21:01:54 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59063 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaIWBBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 21:01:53 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Milian Wolff <mail@milianw.de>
Subject: [PATCHSET 0/5] perf tools: Add call-graph config options (v2)
Date: Tue, 23 Sep 2014 10:01:39 +0900
Message-Id: <1411434104-5307-1-git-send-email-namhyung@kernel.org>
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


Jiri and David, I kept your Acked-by and Reviewed-by in this version.
Please take a look at the patch 4/5 which splits parser functions that
it still looks okay to you.


changes in v2)
 * use sizeof("call-graph.") instead of hardcoding the length  (Jiri)
 * split parse functions so that only handle relavant options
 * add Acked/Reviewed-by tags from David and Jiri


You can also get this from 'perf/callchain-config-v2' branch on my tree

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

 tools/perf/builtin-record.c    | 119 ++++---------------------
 tools/perf/builtin-top.c       |   4 +-
 tools/perf/perf.h              |   3 -
 tools/perf/ui/browsers/hists.c |   3 -
 tools/perf/util/callchain.c    | 193 +++++++++++++++++++++++++++++++++++++----
 tools/perf/util/callchain.h    |   6 +-
 tools/perf/util/config.c       |   3 +
 tools/perf/util/evsel.c        |  11 ++-
 8 files changed, 203 insertions(+), 139 deletions(-)

-- 
2.1.0

