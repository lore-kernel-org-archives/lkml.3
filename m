Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaJVPQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:16:00 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40408 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbaJVPP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:15:57 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: [PATCHSET 0/5] perf tools: option parsing improvement
Date: Thu, 23 Oct 2014 00:15:44 +0900
Message-Id: <1413990949-13953-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to enhance option parser a bit.  Patch 1-3 are to
reuse existing perf record options for other commands like perf kvm
stat record.  Patch 4-5 are to support exclusive options that cannot
be used at the same time.  The perf probe has such options and upcoming
sdt-cache command also.

You can get it from 'perf/option-share-v2' branch on my tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks
Namhyung


Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>


Namhyung Kim (5):
  perf tools: Add PARSE_OPT_DISABLED flag
  perf tools: Export usage string and option table of perf record
  perf kvm: Print kvm specific --help output
  perf tools: Add support for exclusive option
  perf probe: Use PARSE_OPT_EXCLUSIVE flag

 tools/perf/builtin-kvm.c        | 25 +++++++++++++
 tools/perf/builtin-probe.c      | 54 +++++-----------------------
 tools/perf/builtin-record.c     |  7 ++--
 tools/perf/builtin-script.c     |  1 -
 tools/perf/builtin-timechart.c  |  7 ++--
 tools/perf/perf.h               |  3 ++
 tools/perf/util/parse-options.c | 78 ++++++++++++++++++++++++++++++++++-------
 tools/perf/util/parse-options.h |  4 +++
 8 files changed, 116 insertions(+), 63 deletions(-)

-- 
2.0.0

