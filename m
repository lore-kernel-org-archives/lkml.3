Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaCGJK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:10:27 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52501 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaCGJJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:09:17 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [V5 0/4] perf: New conditional branch filter
Date: Fri,  7 Mar 2014 14:36:21 +0530
Message-Id: <1394183185-6219-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030709-0260-0000-0000-0000047ED089
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnaldo,

	I had posted the V5 version of PowerPC SW branch filter enablement
patchset last month. Please find the patchset here at

	https://lkml.org/lkml/2014/2/5/79

These following patches (2,4,5,6 patches from the original V5 version patchset)
are the ones which change code in the generic kernel, perf tool and X86 perf.
Basically this patchset adds one more branch filter for "conditional" branches.
In X86 code, this new filter has been implemented with the help of availble SW
filter X86_BR_JCC and LBR_JCC. We had some discussions in this regard before.
Please review these changes and if it's okay, please merge them. Other patches
in the series are powerpc specific and are being reviewed by Benjamin Herrenschmidt
and Michael Ellerman. Let me know if you need more information.

[1] https://lkml.org/lkml/2013/5/22/51
[2] https://lkml.org/lkml/2013/8/30/10
[3] https://lkml.org/lkml/2013/10/16/75
[4] https://lkml.org/lkml/2013/12/4/168
[5] https://lkml.org/lkml/2014/2/5/79

c: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

Anshuman Khandual (4):
  perf: Add PERF_SAMPLE_BRANCH_COND
  perf, tool: Conditional branch filter 'cond' added to perf record
  x86, perf: Add conditional branch filtering support
  perf, documentation: Description for conditional branch filter

 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 5 +++++
 include/uapi/linux/perf_event.h            | 3 ++-
 tools/perf/Documentation/perf-record.txt   | 3 ++-
 tools/perf/builtin-record.c                | 1 +
 4 files changed, 10 insertions(+), 2 deletions(-)

-- 
1.7.11.7

