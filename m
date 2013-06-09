Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3FIH5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 03:57:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:35870 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab3FIH5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 03:57:23 -0400
Message-ID: <1370764616.14883.28.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Jun 2013 17:56:56 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few more powerpc changes for 3.10. I've merged your
tree in at some point (which I generally avoid) in order to get
the compat network fixes as soon as possible.

Mostly regressions, and stuff I judged could/should still go in at
this stage.

I'm still waiting on some more fixes to the signal handling
vs. transactional memory (this is really ugly btw) which are
hopefully coming next week.

Cheers,
Ben.

The following changes since commit 1612e111e4e565422242727efb59499cce8738e4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-06-06 18:09:05 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 227331303afdca06e44dcda41d27b72015153827:

  powerpc: Print instruction when logging unhandled exceptions (2013-06-09 17:29:16 +1000)

----------------------------------------------------------------
Anton Blanchard (1):
      powerpc: Print instruction when logging unhandled exceptions

Benjamin Herrenschmidt (1):
      Merge remote-tracking branch 'origin/master' into merge

Gavin Shan (1):
      powerpc/eeh: Don't check RTAS token to get PE addr

Kevin Hao (1):
      powerpc/pci: Check the bus address instead of resource address in pcibios_fixup_resources

Michael Ellerman (3):
      powerpc: Rename PMU interrupts from CNT to PMI
      powerpc/perf: Fix deadlock caused by calling printk() in PMU exception
      powerpc: Partial revert of "Context switch more PMU related SPRs"

Michael Neuling (4):
      powerpc/power8: Fix oprofile and perf
      powerpc/pseries: Simplify denormalization handler
      powerpc/power8: Update denormalization handler
      powerpc/hw_breakpoints: Add DABRX cpu feature to fix 32-bit regression

 arch/powerpc/include/asm/cputable.h          |   17 +++--
 arch/powerpc/kernel/cputable.c               |    8 +--
 arch/powerpc/kernel/entry_64.S               |   28 --------
 arch/powerpc/kernel/exceptions-64s.S         |   90 ++++++++------------------
 arch/powerpc/kernel/irq.c                    |    2 +-
 arch/powerpc/kernel/pci-common.c             |    4 +-
 arch/powerpc/kernel/process.c                |    3 +-
 arch/powerpc/kernel/traps.c                  |   11 +++-
 arch/powerpc/perf/core-book3s.c              |    2 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c |   12 ++--
 10 files changed, 60 insertions(+), 117 deletions(-)


