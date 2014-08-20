Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaHTIIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:08:09 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60564 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaHTIID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:08:03 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCHSET 0/5] perf hists browser: Cleanup callchain routines
Date: Wed, 20 Aug 2014 17:07:55 +0900
Message-Id: <1408522080-26556-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch fixes and cleans up TUI callchain routines.  I tried to
consolidate similar functions but not to break the current output with
this change.  Hope that it makes code more readable and maintainable.

It should not change any behavior and outputs.  I verified it with
expanding by 'E' key + dumping by 'P' key on TUI and then running
"diff -u" results before and after the patchset.

Actually I have more changes that would change (or improve) some
behavior and output.  I'll post them after this patchset is merged.

You can get this from 'perf/callchain-fix-v1' branch on my tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks
Namhyung


Namhyung Kim (5):
  perf hists browser: Fix children overhead dump
  perf hists browser: Factor out hist_browser__show_callchain_entry()
  perf hists browser: Get rid of unused 'remaining' variable
  perf hists browser: Cleanup callchain print functions
  perf hists browser: Consolidate callchain print functions in TUI

 tools/perf/ui/browsers/hists.c | 349 ++++++++++++++---------------------------
 tools/perf/ui/hist.c           |   2 +-
 2 files changed, 117 insertions(+), 234 deletions(-)

-- 
2.0.0

