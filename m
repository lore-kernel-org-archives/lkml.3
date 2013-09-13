Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3IMSIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:08:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:37767 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3IMSIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:08:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,899,1371106800"; 
   d="scan'208";a="401290550"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: peterz@infradead.org, acme@infradead.org, linux-kernel@vger.kernel.org,
        eranian@google.com
Subject: perf, x86: Add last TSX PMU code for Haswell
Date: Fri, 13 Sep 2013 11:08:30 -0700
Message-Id: <1379095716-4705-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This has kernel and user parts, so will need
review/ack/merges from both perf kernel and user land maintainers]

This is currently the last part of the TSX PMU code,
just adding the left over bits:

This adds some changes to the user interfaces.
I'll send patches for the manpage separately.

- Report the transaction abort flags to user space
using a new field, and add the code to display them.
This is used to classify abort types, also fairly
important for tuning as it guides the tuning process,
together with the abort weight that was added earleir.

[3 patches, generic, x86, user tools]

- Add support for reporting the two new TSX LBR flags: in_tx
and abort_tx. The code to handle the LBRs was already
added earlier, this just adds the code to report,
filter and display them.

- Add a workaround for a Haswell issue that it reports
an extra LBR record for every abort. We just filter
those out in the kernel.

Open perf TSX issues left:
- Revisit automatic enabling of precise for tx/el-abort
- Need to fix the sort handling in the user tools
to actually sort on other fields
- The aggregated LBR display in the user tools is not 
very useful for transactions, need a way to report them 
in a histogram like backtraces.
- May want some short cut options for
record --transaction --weight / report --sort symbol,transaction,weight

-Andi
