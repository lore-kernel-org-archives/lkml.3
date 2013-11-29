Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab3K2Rb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:31:59 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53202 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752692Ab3K2Rb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:31:56 -0500
Date: Fri, 29 Nov 2013 17:31:17 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 fixes for 3.13-rc
Message-ID: <20131129173112.GA16546@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fixes below. Thanks.

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-stable

for you to fetch changes up to 3676f9ef5481d614f8c5c857f5319755be248268:

  arm64: Move PTE_PROT_NONE higher up (2013-11-29 15:22:59 +0000)

----------------------------------------------------------------
Fixes:
- Remove preempt_count modifications in the arm64 IRQ handling code
  since that's already dealt with in generic irq_enter/irq_exit
- PTE_PROT_NONE bit moved higher up to avoid overlapping with the
  hardware bits (for PROT_NONE mappings which are pte_present)
- Big-endian fixes for ptrace support
- Asynchronous aborts unmasking while in the kernel
- pgprot_writecombine() change to create Normal NonCacheable memory
  rather than Device GRE

----------------------------------------------------------------
Catalin Marinas (4):
      arm64: dts: Reserve the memory used for secondary CPU release address
      arm64: Unmask asynchronous aborts when in kernel mode
      arm64: Use Normal NonCacheable memory for writecombine
      arm64: Move PTE_PROT_NONE higher up

Marc Zyngier (1):
      arm64: let the core code deal with preempt_count

Matthew Leach (2):
      arm64: ptrace: fix compat registes get/set to be endian clean
      arm64: debug: make aarch32 bkpt checking endian clean

 arch/arm64/boot/dts/foundation-v8.dts |  2 ++
 arch/arm64/include/asm/irqflags.h     |  3 +++
 arch/arm64/include/asm/pgtable.h      | 33 ++++++++++++++++-------------
 arch/arm64/kernel/debug-monitors.c    | 20 +++++++++++-------
 arch/arm64/kernel/entry.S             | 29 ++++++-------------------
 arch/arm64/kernel/ptrace.c            | 40 +++++++++++++++++------------------
 arch/arm64/kernel/setup.c             |  5 +++++
 arch/arm64/kernel/smp.c               |  1 +
 8 files changed, 67 insertions(+), 66 deletions(-)

-- 
Catalin
