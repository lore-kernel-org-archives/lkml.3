Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaGaRRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:17:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:9031 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbaGaRRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:17:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,773,1400050800"; 
   d="scan'208";a="463663348"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org
Subject: Implement lbr-as-callgraph v9
Date: Thu, 31 Jul 2014 10:17:00 -0700
Message-Id: <1406827029-7991-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Forward ported to latest tip/perf/core]
[Even more review feedback and some bugs addressed.]
[Only port to changes in perf/core. No other changes.]
[Rebase to latest perf/core]
[Another rebase. No changes]

This patchkit implements lbr-as-callgraphs in per freport,
as an alternative way to present LBR information.

Current perf report does a histogram over the branch edges,
which is useful to look at basic blocks, but doesn't tell
you anything about the larger control flow behaviour.

This patchkit adds a new option --branch-history that
adds the branch paths to the callgraph history instead.

This allows to reason about individual branch paths leading
to specific samples.

Also available at
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc perf/lbr-callgraph4

v2:
- rebased on perf/core
- fix various issues
- rename the option to --branch-history
- various fixes to display the information more concise
v3:
- White space changes
- Consolidate some patches
- Update some descriptions
v4:
- Fix various display problems
- Unknown srcline is now printed as symbol+offset
- Refactor some code to address review feedback
- Merge with latest tip
- Fix missing srcline display in stdio hist output.
v5:
- Rename functions
- Fix gtk build problem
- Fix crash without -g
- Improve error messages
- Improve srcline display in various ways
v6:
- Port to latest perf/core
v7:
- Really port to latest perf/core
v8:
- Rebased on 3.16-rc1
v9: 
- Forward ported to latest tip/perf/core

Example output:

    % perf record -b -g ./tsrc/tcall
    [ perf record: Woken up 1 times to write data ]
    [ perf record: Captured and wrote 0.044 MB perf.data (~1923 samples) ]
    % perf report --branch-history
    ...
        54.91%  tcall.c:6  [.] f2                      tcall
                |
                |--65.53%-- f2 tcall.c:5
                |          |
                |          |--70.83%-- f1 tcall.c:11
                |          |          f1 tcall.c:10
                |          |          main tcall.c:18
                |          |          main tcall.c:18
                |          |          main tcall.c:17
                |          |          main tcall.c:17
                |          |          f1 tcall.c:13
                |          |          f1 tcall.c:13
                |          |          f2 tcall.c:7
                |          |          f2 tcall.c:5
                |          |          f1 tcall.c:12
                |          |          f1 tcall.c:12
                |          |          f2 tcall.c:7
                |          |          f2 tcall.c:5
                |          |          f1 tcall.c:11


