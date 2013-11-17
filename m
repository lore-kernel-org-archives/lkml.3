Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3KQTrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 14:47:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab3KQTrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 14:47:17 -0500
Date: Sun, 17 Nov 2013 20:46:41 +0100
From: Borislav Petkov <bp@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [GIT PULL] EDAC updates for 3.13
Message-ID: <20131117194641.GN27323@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

following up on last week's discussion, here's my part of the EDAC pile,
highlights in the signed tag.

The last two patches have a date from just now because I've just applied
them to the tree after Johannes sent them to me earlier. I decided to
forward them now because they're trivial.

There's a third one for MPC85xx which adds PCIe error interrupt support
but since it is not so trivial and hasn't seen any linux-next time, I'm
deferring it to 3.14.

Please pull,
thanks.

The following changes since commit 959f58544b7f20c92d5eb43d1232c96c15c01bfb:

  Linux 3.12-rc7 (2013-10-27 16:12:03 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_for_3.13

for you to fetch changes up to 0f1741c74aa6794b1c7fbdd19f26a4f2377a11c6:

  edac/85xx: Remove mpc85xx_pci_err_remove (2013-11-17 20:05:50 +0100)

----------------------------------------------------------------
EDAC updates for 3.13

Highlights:

* Support for Calxeda ECX-2000 memory controller, from Robert Richter

* Misc Calxeda Highbank drivers and EDAC core cleanups, from Rob Herring
  and Robert Richter

* New maintainer for Freescale's MPC85xx EDAC driver: Johannes Thumshirn

----------------------------------------------------------------
Borislav Petkov (1):
      Merge tag 'edac_calxeda_for_3.13' into edac-for-3.13

Johannes Thumshirn (2):
      EDAC: Add edac-mpc85xx driver to MAINTAINERS
      edac/85xx: Remove mpc85xx_pci_err_remove

Rob Herring (1):
      ARM: dts: calxeda: move memory-controller node out of ecx-common.dtsi

Robert Richter (6):
      edac, highbank: Fix interrupt setup of mem and l2 controller
      edac, highbank: Add Calxeda ECX-2000 support
      edac, highbank: Improve and unify naming
      edac: Unify reporting of device info for device, mc and pci
      edac, highbank: Add MAINTAINERS entry
      edac, highbank: Moving error injection to sysfs for edac

 .../devicetree/bindings/arm/calxeda/mem-ctrlr.txt  |   4 +-
 MAINTAINERS                                        |  15 ++
 arch/arm/boot/dts/ecx-2000.dts                     |   6 +
 arch/arm/boot/dts/ecx-common.dtsi                  |   6 -
 arch/arm/boot/dts/highbank.dts                     |   6 +
 drivers/edac/edac_device.c                         |   9 +-
 drivers/edac/edac_mc.c                             |   6 +-
 drivers/edac/edac_pci.c                            |   8 +-
 drivers/edac/highbank_l2_edac.c                    |  33 ++--
 drivers/edac/highbank_mc_edac.c                    | 175 ++++++++++++---------
 drivers/edac/mpc85xx_edac.c                        |  22 ---
 11 files changed, 158 insertions(+), 132 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
