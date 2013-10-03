Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3JCHyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:54:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:46286 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab3JCHyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:54:22 -0400
Message-ID: <1380786844.645.93.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-de@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 03 Oct 2013 17:54:04 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few powerpc fixes, all aimed at -stable, found in part thanks
to the ramping up of a major distro testing and in part thanks to the LE
guys hitting all sort interesting corner cases.

The most scary are probably the register clobber issues in
csum_partial_copy_generic(), especially since Anton even had a test case
for that thing, which didn't manage to hit the bugs :-)

Another highlight is that memory hotplug should work again with these
fixes.

Oh and the vio modalias one is worse than the cset implies as it upsets
distro installers, so I've been told at least, which is why I'm shooting
it to stable.

Cheers,
Ben.

The following changes since commit 4b97280675f45c1650ee4e388bd711ecbb18c4b4:

  Merge tag 'stable/for-linus-3.12-rc2-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip (2013-09-25 15:50:53 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to e9bdc3d6143d1c4b8d8ce5231fc958268331f983:

  powerpc/tm: Switch out userspace PPR and DSCR sooner (2013-10-03 17:25:51 +1000)

----------------------------------------------------------------
Madhavan Srinivasan (1):
      powerpc/sysfs: Disable writing to PURR in guest mode

Michael Ellerman (1):
      powerpc/perf: Fix handling of FAB events

Michael Neuling (2):
      powerpc/tm: Turn interrupts hard off in tm_reclaim()
      powerpc/tm: Switch out userspace PPR and DSCR sooner

Nathan Fontenot (1):
      powerpc: Fix memory hotplug with sparse vmemmap

Nishanth Aravamudan (1):
      powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_table()

Paul E. McKenney (2):
      powerpc: Fix parameter clobber in csum_partial_copy_generic()
      powerpc: Restore registers on error exit from csum_partial_copy_generic()

Prarit Bhargava (1):
      powerpc/vio: Fix modalias_show return values

 arch/powerpc/kernel/iommu.c    |  2 +-
 arch/powerpc/kernel/sysfs.c    | 18 +++++++-
 arch/powerpc/kernel/tm.S       | 95 ++++++++++++++++++++++++++++--------------
 arch/powerpc/kernel/vio.c      | 12 ++++--
 arch/powerpc/lib/checksum_64.S | 58 +++++++++++++++++++-------
 arch/powerpc/mm/init_64.c      |  4 ++
 arch/powerpc/mm/mem.c          |  9 ++++
 arch/powerpc/perf/power8-pmu.c |  5 ++-
 mm/Kconfig                     |  2 +-
 9 files changed, 148 insertions(+), 57 deletions(-)


