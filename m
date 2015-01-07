Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360AbbAGCQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:16:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675AbbAGCQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:16:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.17 00/73] 3.17.8-stable review
Date: Tue,  6 Jan 2015 18:15:21 -0800
Message-Id: <20150107021557.521276020@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE, this is the LAST 3.17-stable kernel to be released, you should
move to 3.18 by now, as 3.17 is end-of-life after this release.



This is the start of the stable review cycle for the 3.17.8 release.
There are 73 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jan  9 02:15:36 UTC 2015.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.17.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.17.8-rc1

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix fs corruption on transaction abort if device supports discard

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: fix loop writing of async reclaim

Josef Bacik <jbacik@fb.com>
    Btrfs: make sure logged extents complete in the current transaction V3

Josef Bacik <jbacik@fb.com>
    Btrfs: do not move em to modified list when unpinning

David Sterba <dsterba@suse.cz>
    btrfs: fix wrong accounting of raid1 data profile in statfs

Josef Bacik <jbacik@fb.com>
    Btrfs: make sure we wait on logged extents when fsycning two subvols

Michael Halcrow <mhalcrow@google.com>
    eCryptfs: Remove buggy and unnecessary write in file name decode routine

Tyler Hicks <tyhicks@canonical.com>
    eCryptfs: Force RO mount when encrypted view is enabled

Jan Kara <jack@suse.cz>
    udf: Check component length before reading it

Jan Kara <jack@suse.cz>
    udf: Verify symlink size before loading it

Jan Kara <jack@suse.cz>
    udf: Verify i_size when loading inode

Jan Kara <jack@suse.cz>
    udf: Check path length when reading symlink

Oleg Nesterov <oleg@redhat.com>
    exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiting

Jan Kara <jack@suse.cz>
    ncpfs: return proper error from NCP_IOC_SETROOT ioctl

Rabin Vincent <rabin.vincent@axis.com>
    crypto: af_alg - fix backlog handling

Richard Guy Briggs <rgb@redhat.com>
    audit: restore AUDIT_LOGINUID unset ABI

Paul Moore <pmoore@redhat.com>
    audit: don't attempt to lookup PIDs when changing PID filtering audit rules

Richard Guy Briggs <rgb@redhat.com>
    audit: use supplied gfp_mask from audit_buffer in kauditd_send_multicast_skb

Eric W. Biederman <ebiederm@xmission.com>
    userns: Unbreak the unprivileged remount tests

Eric W. Biederman <ebiederm@xmission.com>
    userns: Allow setting gid_maps without privilege when setgroups is disabled

Eric W. Biederman <ebiederm@xmission.com>
    userns: Add a knob to disable setgroups on a per user namespace basis

Eric W. Biederman <ebiederm@xmission.com>
    userns: Rename id_map_mutex to userns_state_mutex

Eric W. Biederman <ebiederm@xmission.com>
    userns: Only allow the creator of the userns unprivileged mappings

Eric W. Biederman <ebiederm@xmission.com>
    userns: Check euid no fsuid when establishing an unprivileged uid mapping

Eric W. Biederman <ebiederm@xmission.com>
    userns: Don't allow unprivileged creation of gid mappings

Eric W. Biederman <ebiederm@xmission.com>
    userns: Don't allow setgroups until a gid mapping has been setablished

Eric W. Biederman <ebiederm@xmission.com>
    userns: Document what the invariant required for safe unprivileged mappings.

Eric W. Biederman <ebiederm@xmission.com>
    groups: Consolidate the setgroups permission checks

Eric W. Biederman <ebiederm@xmission.com>
    umount: Disallow unprivileged mount force

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Update unprivileged remount test

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Implicitly add MNT_NODEV on remount when it was implicitly added by mount

Luis Henriques <luis.henriques@canonical.com>
    thermal: Fix error path in thermal_init()

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Fix a memory stomp in umount

Johannes Berg <johannes.berg@intel.com>
    mac80211: free management frame keys when removing station

Andreas Müller <goo@stapelspeicher.org>
    mac80211: fix multicast LED blinking and counter

Takashi Iwai <tiwai@suse.de>
    KEYS: Fix stale key registration at error path

Jan Kara <jack@suse.cz>
    isofs: Fix unchecked printing of ER records

Andy Lutomirski <luto@amacapital.net>
    x86/tls: Don't validate lm in set_thread_area() after all

Andy Lutomirski <luto@amacapital.net>
    x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync_regs

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    ARM: mvebu: fix ordering in Armada 370 .dtsi

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: disable I/O coherency on non-SMP situations on Armada 370/375/38x/XP

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: make the coherency_ll.S functions work with no coherency fabric

Dmitry Osipenko <digetx@gmail.com>
    ARM: tegra: Re-add removed SoC id macro to tegra_resume()

Thierry Reding <treding@nvidia.com>
    drm/tegra: gem: dumb: pitch and size are outputs

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Add COMPAT_HWCAP_LPAE

Hante Meuleman <meuleman@broadcom.com>
    brcmfmac: Fix bitmap malloc bug in msgbuf.

Mikulas Patocka <mpatocka@redhat.com>
    dm thin: fix a race in thin_dtr

Joe Thornber <ejt@redhat.com>
    dm thin: fix missing out-of-data-space to write mode transition if blocks are released

Joe Thornber <ejt@redhat.com>
    dm thin: fix inability to discard blocks when in out-of-data-space mode

Dan Carpenter <dan.carpenter@oracle.com>
    dm space map metadata: fix sm_bootstrap_get_nr_blocks()

Joe Thornber <ejt@redhat.com>
    dm cache: fix spurious cell_defer when dealing with partial block at end of device

Joe Thornber <ejt@redhat.com>
    dm cache: dirty flag was mistakenly being cleared when promoting via overwrite

Joe Thornber <ejt@redhat.com>
    dm cache: only use overwrite optimisation for promotion when in writeback mode

Milan Broz <gmazyland@gmail.com>
    dm crypt: use memzero_explicit for on-stack buffer

Darrick J. Wong <darrick.wong@oracle.com>
    dm bufio: fix memleak when using a dm_buffer's inline bio

Mikulas Patocka <mpatocka@redhat.com>
    dcache: fix kmemcheck warning in switch_names

Peng Tao <tao.peng@primarydata.com>
    nfs41: fix nfs4_proc_layoutget error handling

Jan Kara <jack@suse.cz>
    f2fs: fix possible data corruption in f2fs_write_begin()

Hannes Reinecke <hare@suse.de>
    scsi: correct return values for .eh_abort_handler implementations

Markus Pargmann <mpa@pengutronix.de>
    regulator: anatop: Set default voltage selector for vddpu

Sumit.Saxena@avagotech.com <Sumit.Saxena@avagotech.com>
    megaraid_sas: corrected return of wait_event from abort frame path

Peter Guo <peter.guo@bayhubtech.com>
    mmc: sdhci-pci-o2micro: Fix Dell E5440 issue

Baruch Siach <baruch@tkos.co.il>
    mmc: block: add newline to sysfs display of force_ro

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: omap_hsmmc: Fix UHS card with DDR50 support

James Hogan <james.hogan@imgtec.com>
    mmc: dw_mmc: avoid write to CDTHRCTL on older versions

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
    mfd: tc6393xb: Fail ohci suspend if full state restore is required

Tony Lindgren <tony@atomide.com>
    mfd: twl4030-power: Fix regression with missing compatible flag

NeilBrown <neilb@suse.de>
    md/bitmap: always wait for writes on unplug.

Andy Lutomirski <luto@amacapital.net>
    x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit

Andy Lutomirski <luto@amacapital.net>
    x86_64, switch_to(): Load TLS descriptors before switching DS and ES

Andy Lutomirski <luto@amacapital.net>
    x86/tls: Disallow unusual TLS segments

Andy Lutomirski <luto@amacapital.net>
    x86/tls: Validate TLS entries to protect espfix

Jan Kara <jack@suse.cz>
    isofs: Fix infinite looping over CE entries


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/armada-370.dtsi                  |  10 +-
 arch/arm/mach-mvebu/coherency.c                    |  44 +++--
 arch/arm/mach-mvebu/coherency_ll.S                 |  21 ++-
 arch/arm/mach-tegra/reset-handler.S                |   1 +
 arch/arm64/include/asm/hwcap.h                     |   1 +
 arch/arm64/kernel/setup.c                          |   3 +-
 arch/s390/kernel/compat_linux.c                    |   2 +-
 arch/x86/include/uapi/asm/ldt.h                    |   7 +
 arch/x86/kernel/kvm.c                              |   9 +-
 arch/x86/kernel/kvmclock.c                         |   1 -
 arch/x86/kernel/process_64.c                       | 101 +++++++---
 arch/x86/kernel/tls.c                              |  39 ++++
 arch/x86/kernel/traps.c                            |   5 +-
 crypto/af_alg.c                                    |   3 +
 drivers/gpu/drm/tegra/gem.c                        |  10 +-
 drivers/md/bitmap.c                                |  16 +-
 drivers/md/dm-bufio.c                              |  20 +-
 drivers/md/dm-cache-target.c                       |  17 +-
 drivers/md/dm-crypt.c                              |   2 +-
 drivers/md/dm-thin.c                               |  30 ++-
 drivers/md/persistent-data/dm-space-map-metadata.c |   4 +-
 drivers/mfd/tc6393xb.c                             |  13 +-
 drivers/mfd/twl4030-power.c                        |   3 +
 drivers/mmc/card/block.c                           |   2 +-
 drivers/mmc/host/dw_mmc.c                          |   7 +
 drivers/mmc/host/omap_hsmmc.c                      |   4 +-
 drivers/mmc/host/sdhci-pci-o2micro.c               |   2 -
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |   1 +
 drivers/regulator/anatop-regulator.c               |   8 +
 drivers/scsi/NCR5380.c                             |  12 +-
 drivers/scsi/aha1740.c                             |   2 +-
 drivers/scsi/atari_NCR5380.c                       |   2 +-
 drivers/scsi/esas2r/esas2r_main.c                  |   2 +-
 drivers/scsi/megaraid.c                            |   8 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   2 +-
 drivers/scsi/sun3_NCR5380.c                        |  10 +-
 drivers/thermal/thermal_core.c                     |   4 +-
 fs/btrfs/disk-io.c                                 |  26 ++-
 fs/btrfs/extent-tree.c                             |  27 ++-
 fs/btrfs/extent_map.c                              |   2 -
 fs/btrfs/ordered-data.c                            |   9 +-
 fs/btrfs/ordered-data.h                            |   8 +-
 fs/btrfs/super.c                                   |   2 +-
 fs/btrfs/transaction.c                             |  33 ++++
 fs/btrfs/transaction.h                             |   2 +
 fs/btrfs/tree-log.c                                |   6 +-
 fs/dcache.c                                        |   2 +
 fs/ecryptfs/crypto.c                               |   1 -
 fs/ecryptfs/file.c                                 |  12 --
 fs/ecryptfs/main.c                                 |  16 +-
 fs/f2fs/data.c                                     |  24 ++-
 fs/isofs/rock.c                                    |   9 +
 fs/namespace.c                                     |  13 +-
 fs/ncpfs/ioctl.c                                   |   1 -
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/proc/base.c                                     |  53 ++++++
 fs/udf/dir.c                                       |   3 +-
 fs/udf/inode.c                                     |  14 ++
 fs/udf/namei.c                                     |   3 +-
 fs/udf/symlink.c                                   |  57 ++++--
 fs/udf/udfdecl.h                                   |   3 +-
 fs/udf/unicode.c                                   |  28 +--
 include/linux/audit.h                              |   4 +
 include/linux/cred.h                               |   1 +
 include/linux/user_namespace.h                     |  12 ++
 kernel/audit.c                                     |   8 +-
 kernel/auditfilter.c                               |  23 +--
 kernel/groups.c                                    |  11 +-
 kernel/pid.c                                       |   2 +
 kernel/uid16.c                                     |   2 +-
 kernel/user.c                                      |   1 +
 kernel/user_namespace.c                            | 122 +++++++++++-
 net/mac80211/key.c                                 |   2 +-
 net/mac80211/rx.c                                  |  11 +-
 security/keys/encrypted-keys/encrypted.c           |   5 +-
 .../selftests/mount/unprivileged-remount-test.c    | 204 +++++++++++++++++----
 77 files changed, 929 insertions(+), 271 deletions(-)


