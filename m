Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaHFJhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 05:37:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbaHFJhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 05:37:10 -0400
Date: Wed, 6 Aug 2014 11:37:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] trivial for 3.17
Message-ID: <alpine.LNX.2.00.1408061125180.9718@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive

- summer edition of trivial tree updates



You are going to get two conflicts super-easy to resolve:

- arch/arm/mach-msm/Kconfig removal of unused MSM_SCM config value 
  conflicts with addition of MSM_TIMER to the same spot; resolution is to 
  keep MSM_TIMER and remove MSM_SCM
- Documentation/laptops/hpfall.c conflict easy to resolve by

	diff --cc Documentation/laptops/freefall.c
	index 67084321dab4,aab2ff09e868..000000000000
	--- a/Documentation/laptops/freefall.c
	+++ b/Documentation/laptops/freefall.c
	@@@ -27,8 -33,8 +33,9 @@@ static int set_unload_heads_path(char *
	  
		if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
			return -EINVAL;
	- 	strncpy(devname, device + 5, sizeof(devname));
	+ 	strncpy(devname, device + 5, sizeof(devname) - 1);
	 +	devname[sizeof(devname) - 1] = '\0';
	+ 	strncpy(device_path, device, sizeof(device_path) - 1);
	  
		snprintf(unload_heads_path, sizeof(unload_heads_path) - 1,
					"/sys/block/%s/device/unload_heads", devname);

If you want me to prepare a merge branch for you with the conflicts 
resolved, please let me know.

----------------------------------------------------------------
Antonio Ospite (3):
      cpuidle: fix comment
      mfd: fix comment
      drivers/usb/phy/phy.c: remove a leading space

Dan Carpenter (1):
      gma500: remove duplicate FB_REG09 define

Jeremiah Mahler (2):
      usb: doc: hotplug.txt code typos
      doc: replace "practise" with "practice" in Documentation

Olaf Hering (1):
      kbuild: fix comment in Makefile.modinst

Paul Bolle (4):
      ARM: msm: Remove MSM_SCM
      SH: add proper prompt to SH_MAGIC_PANEL_R2_VERSION
      scsi: doc: fix 'SCSI_NCR_SETUP_MASTER_PARITY'
      befs: remove check for CONFIG_BEFS_RW

Pranith Kumar (6):
      doc: RCU: update reference, kerneltrap.org no longer works
      doc: SubmittingPatches: remove dead link, kerneltrap.org no longer works
      doc: LSM: update reference, kerneltrap.org no longer works
      hexagon: update reference, kerneltrap.org no longer works
      media: update reference, kerneltrap.org no longer works
      doc: CN: remove dead link, kerneltrap.org no longer works

Richard Weinberger (1):
      crypto: Remove MPILIB_EXTRA

Rickard Strandqvist (2):
      doc: hpfall.c: fix missing null-terminate after strncpy call
      scsi: mvsas: mv_sas.c: Fix for possible null pointer dereference

Robert P. J. Day (1):
      MAINTAINERS: Add miscdevice.h to file list for char/misc drivers.

Sangjung Woo (1):
      doc: fix two typos in watchdog-api.txt

Sergei Shtylyov (1):
      irq-gic: remove file name from heading comment

 Documentation/PCI/MSI-HOWTO.txt         |  2 +-
 Documentation/RCU/RTFP.txt              |  4 ++--
 Documentation/SubmittingDrivers         |  4 ----
 Documentation/SubmittingPatches         |  4 ++--
 Documentation/laptops/hpfall.c          |  1 +
 Documentation/scsi/ncr53c8xx.txt        |  2 +-
 Documentation/security/LSM.txt          |  2 +-
 Documentation/usb/hotplug.txt           |  8 ++++----
 Documentation/watchdog/watchdog-api.txt |  2 +-
 Documentation/zh_CN/SubmittingDrivers   |  4 ----
 MAINTAINERS                             |  1 +
 arch/arm/mach-msm/Kconfig               |  3 ---
 arch/hexagon/include/asm/cache.h        |  2 +-
 arch/sh/boards/Kconfig                  |  2 +-
 crypto/asymmetric_keys/Kconfig          |  1 -
 drivers/cpuidle/governors/menu.c        |  2 +-
 drivers/gpu/drm/gma500/mid_bios.c       |  1 -
 drivers/irqchip/irq-gic.c               |  2 --
 drivers/media/radio/radio-mr800.c       |  2 +-
 drivers/mfd/intel_msic.c                |  2 +-
 drivers/scsi/mvsas/mv_sas.c             | 24 ++++++++++++++----------
 drivers/usb/phy/phy.c                   |  2 +-
 fs/befs/linuxvfs.c                      |  2 --
 scripts/Makefile.modinst                |  2 +-
 24 files changed, 35 insertions(+), 46 deletions(-)

-- 
Jiri Kosina
SUSE Labs
