Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3JBQLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:11:24 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:53264
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970Ab3JBQLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:11:20 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzd2iz1de098h1de097h8275bhz2dh839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
X-WSS-ID: 0MU1U0X-07-58T-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <fweisbec@gmail.com>, <mingo@kernel.org>, <mingo@redhat.com>,
        <jacob.w.shin@gmail.com>
CC: <oleg@redhat.com>, <a.p.zijlstra@chello.nl>, <acme@ghostprotocols.net>,
        <hpa@zytor.com>, <tgl@domain.invalid>, <linux-kernel@vger.kernel.org>,
        <sherry.hurwitz@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH V5 0/3] perf/x86/amd: AMD Family 16h Data Breakpoint Extensions
Date: Wed, 2 Oct 2013 11:11:05 -0500
Message-ID: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Frederic, this is the rebase of the V4 patch onto the linux-3.12.0-rc3 (linux.git),
and retest.

The following patchset enables hardware breakpoint bp_len greater than
HW_BREAKPOINT_LEN_8 on AMD Family 16h and later.

  $ perf stat -e mem:0x1000/16:w a.out
                            ^^
                            bp_len

This will count writes to [0x1000 ~ 0x1010)

V5:
* Rebase onto 3.12.0-rc3.
* Modify the tools/perf/util/parse-events.y due to change in
  parse_events_add_breakpoint().

V4:
Even more per Oleg's suggestion:
* Further simplify info->len and info->mask setting switch statement

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

 arch/x86/include/asm/cpufeature.h        |  2 ++
 arch/x86/include/asm/debugreg.h          |  5 +++
 arch/x86/include/asm/hw_breakpoint.h     |  1 +
 arch/x86/include/uapi/asm/msr-index.h    |  4 +++
 arch/x86/kernel/cpu/amd.c                | 19 +++++++++++
 arch/x86/kernel/hw_breakpoint.c          | 47 +++++++++++----------------
 tools/perf/Documentation/perf-record.txt |  7 ++--
 tools/perf/tests/parse-events.c          | 55 ++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c           | 17 ++++------
 tools/perf/util/parse-events.h           |  2 +-
 tools/perf/util/parse-events.l           |  1 +
 tools/perf/util/parse-events.y           | 26 +++++++++++++--
 12 files changed, 142 insertions(+), 44 deletions(-)

-- 
1.8.1.2


