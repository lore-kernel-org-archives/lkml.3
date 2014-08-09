Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990AbaHICFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 22:05:04 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:45930 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaHICE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 22:04:59 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>
Subject: [GIT PULL] ARc changes for 3.17
Thread-Topic: [GIT PULL] ARc changes for 3.17
Thread-Index: Ac+zdkyl0lSEi+lsRXyt2Wr79YPaCg==
Date: Sat, 9 Aug 2014 02:04:49 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230753C4B9AFA@IN01WEMBXA.internal.synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.21.30]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

ARC updates for 3.17-rc1. Please pull.

Thx,
-Vineet
---------------------->
The following changes since commit 4c834452aad01531db949414f94f817a86348d59:

  Linux 3.16-rc3 (2014-06-29 14:11:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/ tags/arc-v3.17-rc1

for you to fetch changes up to 2a5e95d4181c3f177a41b7c141a816859478c4d7:

  mm, arc: remove obsolete pagefault oom killer comment (2014-08-07 16:10:59 -0700)

----------------------------------------------------------------
ARC changes for 3.17

Mostly cleanup/refactoring in core intc, cache flush, IPI send...

----------------------------------------------------------------
David Rientjes (1):
      mm, arc: remove obsolete pagefault oom killer comment

Vineet Gupta (9):
      ARC: [SMP] unify cpu private IRQ requests (TIMER/IPI)
      ARC: update some comments
      ARC: prune extra header includes from smp.c
      ARC: [intc] don't mask all IRQ by default
      ARC: [plat-arcfpga] No need for init_irq hack
      ARC: [intc] mask/unmask can be hidden again
      ARC: cache boot reporting updates
      ARC: move common ops for line/full cache into helpers
      ARC: help gcc elide icache helper for !SMP

 arch/arc/include/asm/arcregs.h           |   2 +-
 arch/arc/include/asm/irq.h               |   4 +
 arch/arc/include/asm/irqflags.h          |  18 ----
 arch/arc/kernel/irq.c                    |  53 +++++++---
 arch/arc/kernel/smp.c                    |  23 +----
 arch/arc/kernel/time.c                   |  28 ++----
 arch/arc/mm/cache_arc700.c               | 168 ++++++++++++++++++-------------
 arch/arc/mm/fault.c                      |   1 -
 arch/arc/mm/tlbex.S                      |   4 +-
 arch/arc/plat-arcfpga/Makefile           |   2 +-
 arch/arc/plat-arcfpga/include/plat/irq.h |   2 -
 arch/arc/plat-arcfpga/irq.c              |  25 -----
 arch/arc/plat-arcfpga/platform.c         |   3 -
 13 files changed, 159 insertions(+), 174 deletions(-)
 delete mode 100644 arch/arc/plat-arcfpga/irq.c

