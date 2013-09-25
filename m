Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3IYEju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 00:39:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:34264 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab3IYEjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 00:39:48 -0400
Message-ID: <1380083974.5443.91.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 25 Sep 2013 14:39:34 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few things for -rc2, this time it's all written by me so it
can only be perfect .... right ? :)

So we have the fix to call irq_enter/exit on the irq stack we've been
discussing, plus a cleanup on top to remove an unused (and broken)
stack limit tracking feature (well, make it 32-bit only in fact where
it is used and works properly).

Then we have two things that I wrote over the last couple of days and
made the executive decision to include just because I can (and I'm sure
you won't object .... right ?).

They fix a couple of annoying and long standing "issues":

 - We had separate zImages for when booting via Open Firmware vs.
booting via a flat device-tree, while it's trivial to make one that
deals with both

 - We wasted a ton of cycles spinning secondary CPUs uselessly at boot
instead of starting them when needed on pseries, thus contributing
significantly to global warming.

Cheers,
Ben.

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to dbe78b40118636f2d5d276144239dd4bfd5f04f9:

  powerpc/pseries: Do not start secondaries in Open Firmware (2013-09-25 14:19:00 +1000)

----------------------------------------------------------------
Benjamin Herrenschmidt (4):
      powerpc/irq: Run softirqs off the top of the irq stack
      powerpc: Remove ksp_limit on ppc64
      powerpc/zImage: make the "OF" wrapper support ePAPR boot
      powerpc/pseries: Do not start secondaries in Open Firmware

 arch/powerpc/boot/Makefile           |   4 +-
 arch/powerpc/boot/epapr-wrapper.c    |   9 ++++
 arch/powerpc/boot/epapr.c            |   4 +-
 arch/powerpc/boot/of.c               |  16 +++++-
 arch/powerpc/boot/wrapper            |   9 ++--
 arch/powerpc/include/asm/irq.h       |   4 +-
 arch/powerpc/include/asm/processor.h |   4 +-
 arch/powerpc/kernel/asm-offsets.c    |   3 +-
 arch/powerpc/kernel/irq.c            | 100 +++++++++++++++--------------------
 arch/powerpc/kernel/misc_32.S        |  25 +++++++--
 arch/powerpc/kernel/misc_64.S        |  10 ++--
 arch/powerpc/kernel/process.c        |   3 +-
 arch/powerpc/kernel/prom_init.c      |  21 ++++++++
 arch/powerpc/lib/sstep.c             |   3 +-
 arch/powerpc/platforms/pseries/smp.c |  26 +++++----
 15 files changed, 147 insertions(+), 94 deletions(-)
 create mode 100644 arch/powerpc/boot/epapr-wrapper.c

	

