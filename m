Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881Ab3CLWty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:49:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964836Ab3CLWof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/21] 3.0.69-stable review
Date: Tue, 12 Mar 2013 15:44:02 -0700
Message-Id: <20130312223245.109098379@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.69 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Mar 14 22:32:21 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.69-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.69-rc1

Ben Hutchings <ben@decadent.org.uk>
    dmi_scan: fix missing check for _DMI_ signature in smbios_present()

Eric W. Biederman <ebiederm@xmission.com>
    decnet: Fix disappearing sysctl entries

Steven Rostedt <srostedt@redhat.com>
    ftrace: Update the kconfig for DYNAMIC_FTRACE

Tu, Xiaobing <xiaobing.tu@intel.com>
    Fix memory leak in cpufreq stats.

Al Viro <viro@ZenIV.linux.org.uk>
    vfs: fix pipe counter breakage

David Howells <dhowells@redhat.com>
    keys: fix race with concurrent install_user_keyrings()

Konstantin Khlebnikov <khlebnikov@openvz.org>
    e1000e: fix pci-device enable-counter balance

Takashi Iwai <tiwai@suse.de>
    ALSA: vmaster: Fix slave change notification

Sean Connor <sconnor004@allyinics.org>
    ALSA: ice1712: Initialize card->private_data properly

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add primary dac adj quirk for R200 board

Mark Brown <broonie@opensource.wolfsonmicro.com>
    hwmon: (sht15) Check return value of regulator_enable()

NeilBrown <neilb@suse.de>
    md: raid0: fix error return from create_stripe_zones.

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix RSSI dummy marker value

Rusty Russell <rusty@rustcorp.com.au>
    hw_random: make buffer usable in scatterlist.

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Don't start the retransmission timer when out of socket space

Jeff Layton <jlayton@redhat.com>
    cifs: ensure that cifs_get_root() only traverses directories

Thomas Gleixner <tglx@linutronix.de>
    btrfs: Init io_lock after cloning btrfs device struct

Asias He <asias@redhat.com>
    target/pscsi: Fix page increment

Dan Carpenter <dan.carpenter@oracle.com>
    SCSI: dc395x: uninitialized variable in device_alloc()

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: fix scheduling while atomic warning in alignment handling code

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: VFP: fix emulation of second VFP instruction


-------------

Diffstat:

 Makefile                                |  4 ++--
 arch/arm/mm/alignment.c                 | 11 ++++-------
 arch/arm/vfp/vfpmodule.c                |  2 +-
 drivers/char/hw_random/core.c           | 19 ++++++++++++++++---
 drivers/cpufreq/cpufreq_stats.c         |  1 +
 drivers/firmware/dmi_scan.c             |  5 ++---
 drivers/gpu/drm/radeon/radeon_combios.c |  9 +++++++++
 drivers/hwmon/sht15.c                   |  8 +++++++-
 drivers/md/raid0.c                      |  2 +-
 drivers/net/e1000e/netdev.c             |  2 +-
 drivers/net/wireless/ath/ath9k/common.h |  2 +-
 drivers/scsi/dc395x.c                   |  2 +-
 drivers/target/target_core_pscsi.c      |  1 -
 fs/btrfs/volumes.c                      |  1 +
 fs/cifs/cifsfs.c                        |  5 +++++
 fs/pipe.c                               |  3 +++
 kernel/trace/Kconfig                    | 24 ++++++++++++++----------
 net/decnet/af_decnet.c                  |  4 ++++
 net/decnet/sysctl_net_decnet.c          | 28 ++++++++++++++++++++++++++++
 net/sunrpc/xprt.c                       |  6 +++++-
 security/keys/process_keys.c            |  2 +-
 sound/core/vmaster.c                    |  5 ++++-
 sound/pci/ice1712/ice1712.c             |  2 ++
 23 files changed, 113 insertions(+), 35 deletions(-)


