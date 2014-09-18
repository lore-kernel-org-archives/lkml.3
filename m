Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbaIRNaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:30:35 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:35605 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbaIRNad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:30:33 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v3 0/2] perf tool: improves DSO long names search speed with RB tree
Date: Thu, 18 Sep 2014 09:30:19 -0400
Message-Id: <1411047021-38823-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2->v3:
  - Move the rbtree linking operation from dso__set_long_name() to
    dsos__add(), where the list_add() operation was done.
  - Add a second patch to remove the linked list and iterates the
    DSO structures by going through them in the rbtree. This requires
    changes in quite a number of files, but it makes for neater code.
  - Rebased to the 3.17-rc5 kernel.

v1->v2:
 - Rename DSO longname RBtree find function to segregate its two
   different uses of searching and linking DSO into RB tree.

This patch set replaces the list that is linking the DSO structures
of the perf tool by rbtree sorted by its long name. This can
significantly speed up DSO processing when a large number of DSOs
are beining profiled.

Waiman Long (2):
  perf tool: improves DSO long names search speed with RB     tree
  perf tool: iterate DSOs with rbtree instead of list

 tools/perf/util/dso.c         |  118 +++++++++++++++++++++++++++++++++--------
 tools/perf/util/dso.h         |   25 ++++++---
 tools/perf/util/header.c      |   36 ++++++------
 tools/perf/util/machine.c     |   14 ++---
 tools/perf/util/machine.h     |    4 +-
 tools/perf/util/probe-event.c |    4 +-
 tools/perf/util/symbol-elf.c  |    2 +-
 7 files changed, 142 insertions(+), 61 deletions(-)

