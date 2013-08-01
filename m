Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab3HAIkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:40:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:58879 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab3HAIkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:40:42 -0400
Message-ID: <1375346422.3743.67.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 01 Aug 2013 18:40:22 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here is not quite a handful of powerpc fixes for rc3. The windfarm fix is
a regression fix (though not a new one), the PMU interrupt rename is not
a fix per-se but has been submitted a long time ago and I kept forgetting
to put it in (it puts us back in sync with x86), the other perf bit is
just about putting an API/ABI bit definition in the right place for
userspace to consume, and finally, we have a fix for the VPHN (Virtual
Partition Home Node) feature (notification that the hypervisor is moving
nodes around) which could cause lockups so we may as well fix it now.

Thanks !

Cheers,
Ben.

The following changes since commit ff3d79dc12c2ed38483f6c1e0f26fde430f27c9d:

  powerpc/perf: BHRB filter configuration should follow the task (2013-07-24 14:42:34 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to fe956a1d4081ce1a959f87df397a15e252201f10:

  powerpc/windfarm: Fix noisy slots-fan on Xserve (rm31) (2013-08-01 13:11:47 +1000)

----------------------------------------------------------------
Aaro Koskinen (1):
      powerpc/windfarm: Fix noisy slots-fan on Xserve (rm31)

Michael Ellerman (2):
      powerpc: Rename PMU interrupts from CNT to PMI
      powerpc/perf: Export PERF_EVENT_CONFIG_EBB_SHIFT to userspace

Robert Jennings (1):
      powerpc: VPHN topology change updates all siblings

 arch/powerpc/include/asm/perf_event_server.h |  6 +--
 arch/powerpc/include/asm/smp.h               |  4 ++
 arch/powerpc/include/uapi/asm/Kbuild         |  1 +
 arch/powerpc/include/uapi/asm/perf_event.h   | 18 +++++++++
 arch/powerpc/kernel/irq.c                    |  2 +-
 arch/powerpc/mm/numa.c                       | 59 +++++++++++++++++++++-------
 arch/powerpc/perf/core-book3s.c              |  2 +-
 arch/powerpc/perf/power8-pmu.c               |  6 +--
 drivers/macintosh/windfarm_rm31.c            | 18 ++++-----
 9 files changed, 82 insertions(+), 34 deletions(-)
 create mode 100644 arch/powerpc/include/uapi/asm/perf_event.h


