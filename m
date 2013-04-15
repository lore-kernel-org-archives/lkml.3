Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3DORVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:21:40 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:39739
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755311Ab3DORVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:21:39 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLB47X-01-4TA-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 0/2] perf, amd: support for AMD NB and L2I "uncore" counters.
Date: Mon, 15 Apr 2013 12:21:21 -0500
Message-ID: <1366046483-1765-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per Ingo and Peter Z's request:
  https://lkml.org/lkml/2013/4/10/267

This patchset removes the NB counter support from perf_event_amd.c and
creates a new PMU instead to add support for both AMD NB and L2I
counters.

Jacob Shin (2):
  perf, amd: remove NB counter support from perf_event_amd.c
  perf, amd: support for AMD NB and L2I "uncore" counters.

 arch/x86/include/asm/cpufeature.h           |    2 +
 arch/x86/include/uapi/asm/msr-index.h       |    4 +
 arch/x86/kernel/cpu/Makefile                |    2 +-
 arch/x86/kernel/cpu/perf_event_amd.c        |  138 +--------
 arch/x86/kernel/cpu/perf_event_amd_uncore.c |  442 +++++++++++++++++++++++++++
 5 files changed, 454 insertions(+), 134 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_uncore.c

-- 
1.7.9.5


