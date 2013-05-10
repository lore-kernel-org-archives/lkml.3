Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3EJNez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:34:55 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:37961 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3EJNey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:34:54 -0400
Message-ID: <518CF771.5090202@synopsys.com>
Date: Fri, 10 May 2013 19:04:41 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Alexandre Courbot <gnurou@gmail.com>
Subject: [GIT PULL] arch/arc part 2 for 3.10
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 2nd part of ARC updates for 3.10-rc1

The aliasing dcache support looks solid enough - having gone thru battery of stress tests w/o a glitch.
There's also a GENERIC_GPIO fixlet which Alexandre mentioned earlier today.

Thanks,
Vineet

---------->
The following changes since commit eacd0e950dc2100af54f2a94ae29105bf48ab921:

  ARC: [mm] Lazy D-cache flush (non aliasing VIPT) (2013-05-07 19:08:15 +0530)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/ tags/arc-v3.10-rc1-part2

for you to fetch changes up to e7d5bab5efb94a82d80cab3ad68c357ce73ea596:

  ARC: [TB10x] Remove GENERIC_GPIO (2013-05-10 09:50:33 +0530)

----------------------------------------------------------------
Aliasing VIPT dcache support for ARC

I'm satisified with testing, specially with fuse which has historically given
grief to VIPT arches (ARM/PARISC...)

----------------------------------------------------------------
Vineet Gupta (7):
      ARC: [mm] serious bug in vaddr based icache flush
      ARC: [mm] refactor the core (i|d)cache line ops loops
      ARC: [mm] Aliasing VIPT dcache support 1/4
      ARC: [mm] Aliasing VIPT dcache support 2/4
      ARC: [mm] Aliasing VIPT dcache support 3/4
      ARC: [mm] Aliasing VIPT dcache support 4/4
      ARC: [TB10x] Remove GENERIC_GPIO

 arch/arc/Kconfig                  |    4 +
 arch/arc/include/asm/Kbuild       |    1 -
 arch/arc/include/asm/cache.h      |    3 -
 arch/arc/include/asm/cacheflush.h |   58 ++++++++--
 arch/arc/include/asm/page.h       |   16 ++-
 arch/arc/include/asm/pgtable.h    |    3 +
 arch/arc/include/asm/shmparam.h   |   18 +++
 arch/arc/include/asm/tlb.h        |   11 +-
 arch/arc/mm/Makefile              |    2 +-
 arch/arc/mm/cache_arc700.c        |  221 +++++++++++++++++++++++++++++--------
 arch/arc/mm/mmap.c                |   78 +++++++++++++
 arch/arc/mm/tlb.c                 |   29 +++--
 arch/arc/plat-tb10x/Kconfig       |    7 --
 13 files changed, 377 insertions(+), 74 deletions(-)
 create mode 100644 arch/arc/include/asm/shmparam.h
 create mode 100644 arch/arc/mm/mmap.c

