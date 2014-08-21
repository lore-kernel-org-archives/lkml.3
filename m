Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaHUBP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 21:15:58 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55912 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaHUBP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 21:15:57 -0400
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
Subject: [PATCHSET 0/2] perf hists browser: Cleanup callchain routines (v2)
Date: Thu, 21 Aug 2014 10:15:44 +0900
Message-Id: <1408583746-5540-1-git-send-email-namhyung@kernel.org>
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


 * changes in v2)
  - drop patch 1-3 in v1 since it's already merged
  - update description  (Arnaldo)
  - remove stylish changes  (Arnaldo)
  - remove unnecessary 'has_single_node' check


You can get this from 'perf/callchain-fix-v2' branch on my tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks
Namhyung


Namhyung Kim (2):
  perf hists browser: Cleanup callchain print functions
  perf hists browser: Consolidate callchain print functions in TUI

 tools/perf/ui/browsers/hists.c | 302 +++++++++++++----------------------------
 1 file changed, 95 insertions(+), 207 deletions(-)

-- 
2.0.0

