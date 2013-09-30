Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3I3V7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 17:59:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:32199 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab3I3V7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:59:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="367935969"
From: Andi Kleen <andi@firstfloor.org>
To: acma@infradead.org
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        jolsa@redhat.com
Subject: perf, x86: Add last TSX PMU code for Haswell v3
Date: Mon, 30 Sep 2013 14:58:57 -0700
Message-Id: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This has kernel and user parts.
Both sides have been reviewed now, so hopefully it's good
to merge.]
[v2: Address Peter's feedback for the kernel parts]
[v3: Rebased to current tip. Added Ack/Reviewed-by for user tools code]

Note this also needs the separately posted 
64bit comparison fix to correctly report abort codes.

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
- May want some shortcut options for
record --transaction --weight / report --sort symbol,transaction,weight

-Andi
