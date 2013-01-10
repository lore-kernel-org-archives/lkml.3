Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3AJTv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:51:57 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:48618
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755890Ab3AJTvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:51:10 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z551bizd6eahzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
X-WSS-ID: 0MGFDSZ-01-9WG-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH RESEND V5 0/6] perf, amd: Enable AMD family 15h northbridge counters
Date: Thu, 10 Jan 2013 13:50:36 -0600
Message-ID: <1357847443-3878-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset enables 4 additional performance counters in
AMD family 15h processors that count northbridge events -- such as
number of DRAM accesses.

This patchset is based on previous work done by Robert Richter
<rric@kernel.org> :

https://lkml.org/lkml/2012/6/19/324

The main differences are:

* The northbridge counters are indexed contiguously right above the
  core performance counters.

* MSR address offset calculations are moved to architecture specific
  files.

* Interrups are set up to be delivered only to a single core.

V5:
Rebased against latest tip

V4:
* Moved interrupt core select set up back to event constraints
  function, sicne during ->hw_config time we do not yet know on which
  CPU the the event will run on.
* Tested on and made minor revisions to make sure that the patchset is
  compatible with upcoming AMD Family 16h processors, and will support
  core and NB counters without any further patches.

V3:
Addressed the following feedback/comments from Robert's review
* https://lkml.org/lkml/2012/11/16/484
* https://lkml.org/lkml/2012/11/26/162

V2:
Separate out Robert's patches, and add properly ordered certificate of
origins.

Jacob Shin (4):
  perf, amd: Use proper naming scheme for AMD bit field definitions
  perf, x86: Move MSR address offset calculation to architecture
    specific files
  perf, x86: Allow for architecture specific RDPMC indexes
  perf, amd: Enable northbridge performance counters on AMD family 15h

Robert Richter (2):
  perf, amd: Rework northbridge event constraints handler
  perf, amd: Generalize northbridge constraints code for family 15h

 arch/x86/include/asm/cpufeature.h     |    2 +
 arch/x86/include/asm/perf_event.h     |   13 +-
 arch/x86/include/uapi/asm/msr-index.h |    2 +
 arch/x86/kernel/cpu/perf_event.c      |    2 +-
 arch/x86/kernel/cpu/perf_event.h      |   25 ++-
 arch/x86/kernel/cpu/perf_event_amd.c  |  318 +++++++++++++++++++++++++--------
 6 files changed, 268 insertions(+), 94 deletions(-)

-- 
1.7.9.5


