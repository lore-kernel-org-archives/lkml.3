Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab3EaXdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 19:33:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:38697 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab3EaXdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 19:33:00 -0400
Message-ID: <1370043169.3928.165.camel@pasglop>
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 01 Jun 2013 09:32:49 +1000
In-Reply-To: <1370042526.3928.162.camel@pasglop>
References: <1370042526.3928.162.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-01 at 09:22 +1000, Benjamin Herrenschmidt wrote:
> Hi Linus !
> 
> Here are a few more fixes for powerpc 3.10. It's a bit more than I would
> have liked this late in the game but I suppose that's what happens with
> a brand new chip generation coming out.
>
> A few regression fixes, some last minute fixes for new P8 features such
> as transactional memory,...
> 
> There's also one powerpc KVM patch that I requested that adds two
> missing functions to our in-kernel interrupt controller support which
> is itself a new 3.10 feature. These are defined by the base hypervisor
> specification. We didn't implement them originally because Linux doesn't
> use them but they are simple and I'm not comfortable having a
> half-implemented interface in 3.10 and having to deal with versionning
> etc... later when something starts needing those calls. They cannot be
> emulated in qemu when using in-kernel interrupt controller (not enough
> shared state).

Just added a last minute patch to fix a typo introducing a breakage
in our cputable for Power7+ processors, sorry about that, but the
regression it fixes just hurt me :-)

Sorry about that..

Cheers,
Ben.

The following changes since commit 58f8bbd2e39c3732c55698494338ee19a92c53a0:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2013-05-28 10:11:34 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to badec11b645e21acbc2411d7759e3efa559af443:

  powerpc/cputable: Fix typo on P7+ cputable entry (2013-06-01 09:30:03 +1000)

----------------------------------------------------------------
Aneesh Kumar K.V (1):
      powerpc/mm: Always invalidate tlb on hpte invalidate and update

Kevin Hao (2):
      powerpc/pci: Remove the stale comments of pci_process_bridge_OF_ranges
      powerpc/pci: Remove the unused variables in pci_process_bridge_OF_ranges

Michael Ellerman (2):
      powerpc/perf: Revert to original NO_SIPR logic
      powerpc/perf: Add missing SIER support

Michael Neuling (7):
      powerpc/tm: Make room for hypervisor in abort cause codes
      powerpc/tm: Update cause codes documentation
      powerpc/tm: Abort on emulation and alignment faults
      powerpc/tm: Move TM abort cause codes to uapi
      powerpc/tm: Fix userspace stack corruption on signal delivery for active transactions
      powerpc/pseries: Kill all prefetch streams on context switch
      powerpc/pseries: Improve stream generation comments in copypage/user

Nishanth Aravamudan (1):
      powerpc/cputable: Fix oprofile_cpu_type on power8

Paul Mackerras (1):
      powerpc/kvm/book3s: Add support for H_IPOLL and H_XIRR_X in XICS emulation

Priyanka Jain (1):
      powerpc/32bit:Store temporary result in r0 instead of r8

Srivatsa S. Bhat (1):
      powerpc/pseries: Always enable CONFIG_HOTPLUG_CPU on PSERIES SMP

Will Schmidt (1):
      powerpc/cputable: Fix typo on P7+ cputable entry

chenhui zhao (1):
      powerpc/mpic: Fix irq distribution problem when MPIC_SINGLE_DEST_CPU

 Documentation/powerpc/transactional_memory.txt |   27 +++++++++-
 arch/powerpc/include/asm/hvcall.h              |    1 +
 arch/powerpc/include/asm/ppc_asm.h             |   11 ++++
 arch/powerpc/include/asm/processor.h           |   13 ++---
 arch/powerpc/include/asm/reg.h                 |   11 ----
 arch/powerpc/include/asm/signal.h              |    3 ++
 arch/powerpc/include/asm/tm.h                  |    2 +
 arch/powerpc/include/uapi/asm/Kbuild           |    1 +
 arch/powerpc/include/uapi/asm/tm.h             |   18 +++++++
 arch/powerpc/kernel/cputable.c                 |    6 +--
 arch/powerpc/kernel/entry_32.S                 |    2 +-
 arch/powerpc/kernel/entry_64.S                 |    7 +++
 arch/powerpc/kernel/pci-common.c               |   14 +----
 arch/powerpc/kernel/signal.c                   |   40 +++++++++++++-
 arch/powerpc/kernel/signal.h                   |    2 +-
 arch/powerpc/kernel/signal_32.c                |   10 +---
 arch/powerpc/kernel/signal_64.c                |   23 +++-----
 arch/powerpc/kernel/traps.c                    |   29 ++++++++++
 arch/powerpc/kvm/book3s_hv.c                   |    2 +
 arch/powerpc/kvm/book3s_pr_papr.c              |    2 +
 arch/powerpc/kvm/book3s_xics.c                 |   29 ++++++++++
 arch/powerpc/lib/copypage_power7.S             |   19 ++++---
 arch/powerpc/lib/copyuser_power7.S             |   12 +++--
 arch/powerpc/mm/hash_native_64.c               |   30 ++++++++---
 arch/powerpc/perf/core-book3s.c                |   67 +++++++++++-------------
 arch/powerpc/platforms/pseries/Kconfig         |    2 +
 arch/powerpc/sysdev/mpic.c                     |    4 +-
 27 files changed, 262 insertions(+), 125 deletions(-)
 create mode 100644 arch/powerpc/include/uapi/asm/tm.h


