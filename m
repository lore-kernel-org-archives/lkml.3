Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934973Ab3DIPYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:24:02 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58566 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761860Ab3DIPYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:24:00 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z551bizzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKZURW-01-EVW-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH RESEND 0/3] perf, amd: Support for Family 16h L2I Performance Counters
Date: Tue, 9 Apr 2013 10:23:51 -0500
Message-ID: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upcoming AMD Family 16h Processors provide 4 new performance counters
to count L2 related events. Similar to northbridge counters, these new
counters are shared across multiple CPUs that share the same L2 cache.
This patchset adds support for these new counters and enforces sharing
by leveraging the existing sharing logic used for the northbridge
counters.

Jacob Shin (3):
  perf, amd: Further generalize NB event constraints handling logic
  perf, x86: Allow for multiple kfree_on_online pointers
  perf, amd: Enable L2I performance counters on AMD Family 16h

 arch/x86/include/asm/cpufeature.h      |    2 +
 arch/x86/include/asm/perf_event.h      |    4 +
 arch/x86/include/uapi/asm/msr-index.h  |    4 +
 arch/x86/kernel/cpu/perf_event.c       |    7 +-
 arch/x86/kernel/cpu/perf_event.h       |   11 +-
 arch/x86/kernel/cpu/perf_event_amd.c   |  235 +++++++++++++++++++++++++-------
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 7 files changed, 207 insertions(+), 58 deletions(-)

-- 
1.7.9.5


