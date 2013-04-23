Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3DWH5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:57:20 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:25377
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755259Ab3DWH5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:57:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLP7F8-02-406-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V2 0/4] perf: Add support for hardware breakpoint address masks
Date: Tue, 23 Apr 2013 02:57:01 -0500
Message-ID: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset adds address masks to existing perf hardware
breakpoint mechanism to allow trapping on an address range (currently
only single address) on supported architectures.

perf uapi is updated, x86 AMD implementation (for AMD Family 16h and
beyond) is provided, and perf tool has been extended to do:

  $ perf stat -e mem:0x1000/0xf:w a.out
                            ^^^
                            "don't care" bit mask

  which will count writes to [0x1000 ~ 0x1010)

V2:
Per Oleg's suggestions:
* Moved testing of bp_addr_mask to validate_hw_breakpoint()
* Changed perf tool syntax to mem:<addr>[/addr_mask][:access]

Jacob Shin (2):
  perf: Add hardware breakpoint address mask
  perf/x86/amd: AMD implementation for hardware breakpoint address mask

Suravee Suthikulpanit (2):
  perf tools: Add hardware breakpoint address mask event parser
  perf tools: Add hardware breakpoint address mask test cases

 arch/x86/include/asm/cpufeature.h        |    2 ++
 arch/x86/include/asm/debugreg.h          |    5 ++++
 arch/x86/include/asm/hw_breakpoint.h     |    1 +
 arch/x86/include/uapi/asm/msr-index.h    |    6 ++++
 arch/x86/kernel/cpu/amd.c                |   19 +++++++++++++
 arch/x86/kernel/hw_breakpoint.c          |   16 +++++++++++
 include/uapi/linux/perf_event.h          |    5 +++-
 kernel/events/hw_breakpoint.c            |    9 ++++++
 tools/perf/Documentation/perf-record.txt |   14 +++++++---
 tools/perf/tests/parse-events.c          |   45 ++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c           |    5 ++--
 tools/perf/util/parse-events.h           |    2 +-
 tools/perf/util/parse-events.l           |    1 +
 tools/perf/util/parse-events.y           |   24 ++++++++++++++--
 14 files changed, 144 insertions(+), 10 deletions(-)

-- 
1.7.9.5


