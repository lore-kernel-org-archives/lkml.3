Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbbAHWMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:12:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbbAHWMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:12:18 -0500
Date: Thu, 8 Jan 2015 14:12:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.28
Message-ID: <20150108221217.GA335@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.28 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                                  |    2=20
 arch/arm/boot/dts/armada-370.dtsi                         |   10=20
 arch/arm/mach-tegra/reset-handler.S                       |    1=20
 arch/arm64/include/asm/hwcap.h                            |    1=20
 arch/arm64/kernel/setup.c                                 |    3=20
 arch/s390/kernel/compat_linux.c                           |    2=20
 arch/x86/include/uapi/asm/ldt.h                           |    7=20
 arch/x86/kernel/kvm.c                                     |    9=20
 arch/x86/kernel/kvmclock.c                                |    1=20
 arch/x86/kernel/process_64.c                              |  101 +++++-
 arch/x86/kernel/tls.c                                     |   39 ++
 crypto/af_alg.c                                           |    3=20
 drivers/md/bitmap.c                                       |   16 -
 drivers/md/dm-bufio.c                                     |   20 +
 drivers/md/dm-cache-target.c                              |   13=20
 drivers/md/dm-crypt.c                                     |    2=20
 drivers/md/dm-thin.c                                      |   24 +
 drivers/md/persistent-data/dm-space-map-metadata.c        |    4=20
 drivers/mfd/tc6393xb.c                                    |   13=20
 drivers/mmc/card/block.c                                  |    2=20
 drivers/mmc/host/dw_mmc.c                                 |    7=20
 drivers/mmc/host/sdhci-pci-o2micro.c                      |    2=20
 drivers/scsi/NCR5380.c                                    |   12=20
 drivers/scsi/aha1740.c                                    |    2=20
 drivers/scsi/atari_NCR5380.c                              |    2=20
 drivers/scsi/esas2r/esas2r_main.c                         |    2=20
 drivers/scsi/megaraid.c                                   |    8=20
 drivers/scsi/megaraid/megaraid_sas_base.c                 |    2=20
 drivers/scsi/sun3_NCR5380.c                               |   10=20
 drivers/thermal/thermal_core.c                            |    4=20
 fs/btrfs/disk-io.c                                        |    6=20
 fs/btrfs/extent-tree.c                                    |   10=20
 fs/btrfs/extent_map.c                                     |    2=20
 fs/ecryptfs/crypto.c                                      |    1=20
 fs/ecryptfs/file.c                                        |   12=20
 fs/ecryptfs/main.c                                        |   16 -
 fs/isofs/rock.c                                           |    9=20
 fs/namespace.c                                            |   13=20
 fs/ncpfs/ioctl.c                                          |    1=20
 fs/nfs/nfs4proc.c                                         |    6=20
 fs/proc/base.c                                            |   53 +++
 fs/udf/symlink.c                                          |   17 -
 include/linux/audit.h                                     |    4=20
 include/linux/cred.h                                      |    1=20
 include/linux/user_namespace.h                            |   12=20
 kernel/auditfilter.c                                      |   10=20
 kernel/groups.c                                           |   11=20
 kernel/pid.c                                              |    2=20
 kernel/uid16.c                                            |    2=20
 kernel/user.c                                             |    1=20
 kernel/user_namespace.c                                   |  125 +++++++-
 net/mac80211/key.c                                        |    2=20
 net/mac80211/rx.c                                         |   11=20
 security/keys/encrypted-keys/encrypted.c                  |    5=20
 tools/testing/selftests/mount/unprivileged-remount-test.c |  204 +++++++++=
++---
 55 files changed, 681 insertions(+), 179 deletions(-)

Andreas M=FCller (1):
      mac80211: fix multicast LED blinking and counter

Andy Lutomirski (5):
      x86/tls: Validate TLS entries to protect espfix
      x86/tls: Disallow unusual TLS segments
      x86_64, switch_to(): Load TLS descriptors before switching DS and ES
      x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit
      x86/tls: Don't validate lm in set_thread_area() after all

Baruch Siach (1):
      mmc: block: add newline to sysfs display of force_ro

Catalin Marinas (1):
      arm64: Add COMPAT_HWCAP_LPAE

Dan Carpenter (1):
      dm space map metadata: fix sm_bootstrap_get_nr_blocks()

Darrick J. Wong (1):
      dm bufio: fix memleak when using a dm_buffer's inline bio

Dmitry Eremin-Solenikov (1):
      mfd: tc6393xb: Fail ohci suspend if full state restore is required

Dmitry Osipenko (1):
      ARM: tegra: Re-add removed SoC id macro to tegra_resume()

Eric W. Biederman (14):
      mnt: Fix a memory stomp in umount
      mnt: Implicitly add MNT_NODEV on remount when it was implicitly added=
 by mount
      mnt: Update unprivileged remount test
      umount: Disallow unprivileged mount force
      groups: Consolidate the setgroups permission checks
      userns: Document what the invariant required for safe unprivileged ma=
ppings.
      userns: Don't allow setgroups until a gid mapping has been setablished
      userns: Don't allow unprivileged creation of gid mappings
      userns: Check euid no fsuid when establishing an unprivileged uid map=
ping
      userns: Only allow the creator of the userns unprivileged mappings
      userns: Rename id_map_mutex to userns_state_mutex
      userns: Add a knob to disable setgroups on a per user namespace basis
      userns: Allow setting gid_maps without privilege when setgroups is di=
sabled
      userns: Unbreak the unprivileged remount tests

Filipe Manana (1):
      Btrfs: fix fs corruption on transaction abort if device supports disc=
ard

Greg Kroah-Hartman (1):
      Linux 3.14.28

Hannes Reinecke (1):
      scsi: correct return values for .eh_abort_handler implementations

James Hogan (1):
      mmc: dw_mmc: avoid write to CDTHRCTL on older versions

Jan Kara (4):
      isofs: Fix infinite looping over CE entries
      isofs: Fix unchecked printing of ER records
      ncpfs: return proper error from NCP_IOC_SETROOT ioctl
      udf: Verify symlink size before loading it

Joe Thornber (4):
      dm cache: only use overwrite optimisation for promotion when in write=
back mode
      dm cache: dirty flag was mistakenly being cleared when promoting via =
overwrite
      dm thin: fix inability to discard blocks when in out-of-data-space mo=
de
      dm thin: fix missing out-of-data-space to write mode transition if bl=
ocks are released

Johannes Berg (1):
      mac80211: free management frame keys when removing station

Josef Bacik (1):
      Btrfs: do not move em to modified list when unpinning

Luis Henriques (1):
      thermal: Fix error path in thermal_init()

Michael Halcrow (1):
      eCryptfs: Remove buggy and unnecessary write in file name decode rout=
ine

Milan Broz (1):
      dm crypt: use memzero_explicit for on-stack buffer

NeilBrown (1):
      md/bitmap: always wait for writes on unplug.

Oleg Nesterov (1):
      exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiti=
ng

Peng Tao (1):
      nfs41: fix nfs4_proc_layoutget error handling

Peter Guo (1):
      mmc: sdhci-pci-o2micro: Fix Dell E5440 issue

Rabin Vincent (1):
      crypto: af_alg - fix backlog handling

Richard Guy Briggs (1):
      audit: restore AUDIT_LOGINUID unset ABI

Sumit.Saxena@avagotech.com (1):
      megaraid_sas: corrected return of wait_event from abort frame path

Takashi Iwai (1):
      KEYS: Fix stale key registration at error path

Tyler Hicks (1):
      eCryptfs: Force RO mount when encrypted view is enabled

Uwe Kleine-K=F6nig (1):
      ARM: mvebu: fix ordering in Armada 370 .dtsi


--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUrwDBAAoJEDjbvchgkmk+iq0P/3S4l+FD03CfegtM+jONY7VN
HrIbMOcALUIieaU5qmIiGrtfqKI7F6i6QPzbqjxeR9Oof0l5UptdSrghvT0JX6jS
4sQ2KNjyT7CPantlKINNqtkgDld+nEMv3czePcN7AhXQ7AY+6zjq3H4KdEq0eZb9
ACJNeX34nYwbIqfGHh3DbmMSdRLKKRP7mItaB8J32G4ZUxFF9s7B6kFCh9crh13Y
4IuUJXFyrpCiWxUJjLHkxKXlaCqcbQ1Bxasa9MgWfFCQggPzU0AI5AVSshPgE1/6
wWZ1tl3Ac7fzceFsMT2kPfln9CyPWxQEJ6wSaX0wHrLYA2TSCjPc8WYeZSvnwpr6
fNVXof0KCpyHzSLCfnsbZdh2cBEhfFSDBUtbRBaMomwV6ERv6otsJqqmV8H/ovO0
N/4kK8pxMXvAMLdrl15v/C++p74Pjv6tbZjhDS9iFKVwPrX2fN8In/1RDbypeTCT
rHVC3i9GW7c+L5SUBYBX3iTpgfioZGvXtSPCXpUyULThs41pycf7XiXGiJt0/L8M
WMUJa/qcXrDkT8vqs3ROVhIfUjcgJio9CUeRa7FHRNJJOFMb5b4QJcKFpP64FUYW
IchTp52ynSL9NdLAUE5hZVUuHnEcB+duBTyZTDzFpO0BmtKYq9i+lxFMzfmKLbVN
EI0U4EyRTPwMK3KHrwB3
=c2LZ
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
