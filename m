Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302Ab3EXJlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:41:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:53685 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760090Ab3EXJlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:41:51 -0400
Message-ID: <1369388490.30145.16.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 24 May 2013 19:41:30 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few more powerpc fixes for 3.10. Some more P8 related
bits, a bunch of fixes for our P7+/P8 HW crypto drivers, some added
workarounds for those radeons that don't do proper 64-bit MSIs and
a couple of other trivialities by myself.

Cheers,
Ben.

The following changes since commit 519fe2ecb755b875d9814cdda19778c2e88c6901:

  Merge branch 'leds-fixes-3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds (2013-05-21 11:41:07 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to f1dd153121dcb872ae6cba8d52bec97519eb7d97:

  powerpc/pseries: Make 32-bit MSI quirk work on systems lacking firmware support (2013-05-24 18:16:54 +1000)

----------------------------------------------------------------
Benjamin Herrenschmidt (5):
      powerpc: Fix TLB cleanup at boot on POWER8
      powerpc/pci: Fix bogus message at boot about empty memory resources
      powerpc/powernv: Fix condition for when to invalidate the TCE cache
      powerpc: Make radeon 32-bit MSI quirk work on powernv
      powerpc/powernv: Build a zImage.epapr

Brian King (1):
      powerpc/pseries: Make 32-bit MSI quirk work on systems lacking firmware support

Kent Yoder (1):
      drivers/crypto/nx: Fixes for multiple races and issues

Michael Ellerman (1):
      powerpc: Context switch more PMU related SPRs

 arch/powerpc/include/asm/pci-bridge.h     |    2 +
 arch/powerpc/include/asm/processor.h      |    6 +++
 arch/powerpc/kernel/asm-offsets.c         |    6 +++
 arch/powerpc/kernel/cpu_setup_power.S     |    8 ++-
 arch/powerpc/kernel/entry_64.S            |   28 +++++++++++
 arch/powerpc/kernel/pci-common.c          |    7 +--
 arch/powerpc/kernel/pci_64.c              |   10 ++++
 arch/powerpc/kernel/pci_dn.c              |    8 +++
 arch/powerpc/platforms/powernv/Kconfig    |    1 +
 arch/powerpc/platforms/powernv/pci-ioda.c |   27 +++++------
 arch/powerpc/platforms/powernv/pci.c      |    6 ++-
 arch/powerpc/platforms/pseries/msi.c      |   75 +++++++++++++++--------------
 drivers/crypto/nx/nx-aes-cbc.c            |    1 +
 drivers/crypto/nx/nx-aes-ecb.c            |    1 +
 drivers/crypto/nx/nx-aes-gcm.c            |    2 +-
 drivers/crypto/nx/nx-sha256.c             |    8 +--
 drivers/crypto/nx/nx-sha512.c             |    7 +--
 drivers/crypto/nx/nx.c                    |   38 +++------------
 18 files changed, 146 insertions(+), 95 deletions(-)


