Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab3DZS6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 14:58:33 -0400
Received: from [216.32.180.187] ([216.32.180.187]:54563 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753754Ab3DZS6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 14:58:31 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1155h)
X-WSS-ID: 0MLVM0C-01-IRF-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 0/3] perf/x86/amd: AMD Family 16h Data Breakpoint Extensions
Date: Fri, 26 Apr 2013 13:57:43 -0500
Message-ID: <1367002666-6910-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg, Ingo, this is my final push for 3.10. I understand that it might
be too late for that .. if so I'll try again later for 3.11.

The following patchset enables hardware breakpoint bp_len greater than
HW_BREAKPOINT_LEN_8 on AMD Family 16h and later.

  $ perf stat -e mem:0x1000/16:w a.out
                            ^^
                            bp_len

Will count writes to [0x1000 ~ 0x1010)

V3:
More per Oleg's suggestion:
* Use already existing bp_len instead of changing userland API and
  in kernel turn bp_len into proper AMD hardware breakpoint address
  mask.

V2:
Per Oleg's suggestions:
* Moved testing of bp_addr_mask to validate_hw_breakpoint()
* Changed perf tool syntax to mem:<addr>[/addr_mask][:access]

Jacob Shin (3):
  perf/x86/amd: AMD support for bp_len > HW_BREAKPOINT_LEN_8
  perf tools: allow user to specify hardware breakpoint bp_len
  perf tools: add hardware breakpoint bp_len test cases

 arch/x86/include/asm/cpufeature.h        |    2 ++
 arch/x86/include/asm/debugreg.h          |    5 +++
 arch/x86/include/asm/hw_breakpoint.h     |    1 +
 arch/x86/include/uapi/asm/msr-index.h    |    4 +++
 arch/x86/kernel/cpu/amd.c                |   19 +++++++++++
 arch/x86/kernel/hw_breakpoint.c          |   47 ++++++++++---------------
 tools/perf/Documentation/perf-record.txt |    7 ++--
 tools/perf/tests/parse-events.c          |   55 ++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c           |   10 +++---
 tools/perf/util/parse-events.h           |    2 +-
 tools/perf/util/parse-events.l           |    1 +
 tools/perf/util/parse-events.y           |   24 +++++++++++--
 12 files changed, 137 insertions(+), 40 deletions(-)

-- 
1.7.9.5


