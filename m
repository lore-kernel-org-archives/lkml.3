Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaANBEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:04:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:60168 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136AbaANBEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 20:04:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,656,1384329600"; 
   d="scan'208";a="466147298"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: jolsa@redhat.com, namhyung@kernel.org, mingo@kernel.org, dsahern@gmail.com,
        fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org
Subject: Implement lbr-as-callgraph v3
Date: Mon, 13 Jan 2014 17:04:15 -0800
Message-Id: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchkit implements lbr-as-callgraphs in per freport,
as an alternative way to present LBR information.

Current perf report does a histogram over the branch edges,
which is useful to look at basic blocks, but doesn't tell
you anything about the larger control flow behaviour.

This patchkit adds a new option --branch-history that
adds the branch paths to the callgraph history instead.

This allows to reason about individual branch paths leading
to specific samples.

Updates to v1:
- rebased on perf/core
- fix various issues
- rename the option to --branch-history
- various fixes to display the information more concise

Updates to v3:
- White space changes
- Consolidate some patches
- Update some descriptions

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


