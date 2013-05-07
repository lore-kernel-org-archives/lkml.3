Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab3EGKLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:11:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:33340 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab3EGKLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:11:02 -0400
Message-ID: <1367921451.25488.3.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 07 May 2013 20:10:51 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few more powerpc bits that I would like in 3.10. Mostly
remaining bolts & screw tightening of power8 support such as actually
exposing the new features via the previously added AT_HWCAP2, and a
few fixes, some of them for problems exposed recently like irqdomain
warnings or sysfs access permission issues, some exposed by power8
hardware.

The only change outside of arch/powerpc is a small one to irqdomain.c
to allow silent failure to fix a problem on Cell where we get a dozen
WARN_ON's tripping at boot for what is basically a normal case.

Grant Acked it but I forgot to put it in and didn't want to rebase.

Cheers,
Ben.

The following changes since commit 01227a889ed56ae53aeebb9f93be9d54dd8b2de8:

  Merge tag 'kvm-3.10-1' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2013-05-05 14:47:31 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git test

for you to fetch changes up to 5737789c8340620d7b542d1d4e9b197de8eb2801:

  powerpc: Make hard_irq_disable() do the right thing vs. irq tracing (2013-05-07 17:13:57 +1000)

----------------------------------------------------------------
Anton Blanchard (1):
      powerpc: Emulate non privileged DSCR read and write

Benjamin Herrenschmidt (9):
      powerpc/powerpnv: Properly handle failure starting CPUs
      powerpc/pci: Don't add bogus empty resources to PHBs
      powerpc/pnv: Fix "compatible" property for P8 PHB
      irqdomain: Allow quiet failure mode
      powerpc/cell/spufs: Fix status attribute permission
      powerpc/cell/iommu: Improve error message for missing node
      powerpc/pci: Support per-aperture memory offset
      powerpc/topology: Fix spurr attribute permission
      powerpc: Make hard_irq_disable() do the right thing vs. irq tracing

Brian King (1):
      powerpc/pseries: Force 32 bit MSIs for devices that require it

Jeremy Kerr (1):
      powerpc/powernv: Defer OPAL exception handler registration

Kleber Sacilotto de Souza (1):
      powerpc/pseries: Perform proper max_bus_speed detection

Michael Neuling (1):
      powerpc/tm: Fix null pointer deference in flush_hash_page

Nishanth Aravamudan (4):
      powerpc/cputable: Reserve bits in HWCAP2 for new features
      powerpc/cputable: Advertise DSCR support on P7/P7+
      powerpc/cputable: Advertise ISEL support on appropriate embedded processors
      powerpc/cputable: Advertise support for ISEL/HTM/DSCR/TAR on POWER8

 arch/powerpc/include/asm/cputable.h         |    2 +
 arch/powerpc/include/asm/hw_irq.h           |   16 ++---
 arch/powerpc/include/asm/machdep.h          |    3 +
 arch/powerpc/include/asm/pci-bridge.h       |    8 +--
 arch/powerpc/include/asm/ppc-opcode.h       |    4 ++
 arch/powerpc/include/uapi/asm/cputable.h    |    9 +++
 arch/powerpc/kernel/cputable.c              |   14 ++++
 arch/powerpc/kernel/pci-common.c            |  101 ++++++++++-----------------
 arch/powerpc/kernel/pci_32.c                |    2 +-
 arch/powerpc/kernel/pci_64.c                |    2 +-
 arch/powerpc/kernel/sysfs.c                 |    2 +-
 arch/powerpc/kernel/traps.c                 |   10 ++-
 arch/powerpc/mm/hash_utils_64.c             |    1 +
 arch/powerpc/platforms/cell/iommu.c         |    2 +-
 arch/powerpc/platforms/cell/spu_base.c      |    2 +-
 arch/powerpc/platforms/embedded6xx/mpc10x.h |   11 ---
 arch/powerpc/platforms/powermac/pci.c       |    2 +-
 arch/powerpc/platforms/powernv/opal.c       |   15 +++-
 arch/powerpc/platforms/powernv/pci-ioda.c   |   12 ++--
 arch/powerpc/platforms/powernv/smp.c        |    4 +-
 arch/powerpc/platforms/pseries/msi.c        |   21 +++++-
 arch/powerpc/platforms/pseries/pci.c        |   53 ++++++++++++++
 arch/powerpc/platforms/pseries/pseries.h    |    4 ++
 arch/powerpc/platforms/pseries/setup.c      |    2 +
 arch/powerpc/platforms/wsp/wsp_pci.c        |    2 +-
 arch/powerpc/sysdev/fsl_pci.c               |   11 +--
 arch/powerpc/sysdev/mpic.c                  |   14 +++-
 arch/powerpc/sysdev/ppc4xx_pci.c            |   15 ++--
 kernel/irq/irqdomain.c                      |   20 +++++-
 29 files changed, 236 insertions(+), 128 deletions(-)


