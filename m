Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaIPTIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:08:31 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:6623 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbaIPTI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:08:29 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 0/1] perf mem: improves DSO long names search speed with RB tree
Date: Tue, 16 Sep 2014 15:08:18 -0400
Message-Id: <1410894499-27609-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:
 - Rename DSO longname RBtree find function to segregate its two different
   uses of searching and linking DSO into RB tree.

This patch addes a RBtree to sort the DSO structures of the perf tool
by its long name so that searching for a match will be much quicker
especially if a large number of DSOs are beining profiled.

Waiman Long (1):
  perf mem: improves DSO long names search speed with RB tree

 tools/perf/util/dso.c |   87 ++++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/dso.h |    1 +
 2 files changed, 84 insertions(+), 4 deletions(-)

