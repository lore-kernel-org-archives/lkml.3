Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaB1EWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 23:22:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:31551 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaB1EWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 23:22:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="483314716"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com
Subject: perf: Implement lbr-as-callgraph v4
Date: Thu, 27 Feb 2014 20:22:24 -0800
Message-Id: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[All review feedback addressed.]

This patchkit implements lbr-as-callgraphs in per freport,
as an alternative way to present LBR information.

Current perf report does a histogram over the branch edges,
which is useful to look at basic blocks, but doesn't tell
you anything about the larger control flow behaviour.

This patchkit adds a new option --branch-history that
adds the branch paths to the callgraph history instead.

This allows to reason about individual branch paths leading
to specific samples.

Also improves srcline display in various ways to make
branches better understandable.

Also available at
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc perf/lbr-callgraph4

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


