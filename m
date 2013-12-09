Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579Ab3LIGkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 01:40:22 -0500
Received: from ozlabs.org ([203.10.76.45]:57382 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab3LIGkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 01:40:18 -0500
Date: Mon, 9 Dec 2013 17:40:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Dec 9
Message-Id: <20131209174012.4eb91c57f0466f04a21adff5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Dec_2013_17_40_12_+1100_Xo9uNjgPXlZW8NT+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Dec_2013_17_40_12_+1100_Xo9uNjgPXlZW8NT+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20131206:

The powerpc tree gained a build failure for which I reverted some commits.

The crypto tree still had its build failure so I used the version from
next-20131205.

The driver-core tree gained a conflict against the driver-core.current
tree.

The usb-gadget tree gained a build failure so I used the version from
next-20131206.

The pinctrl tree gained a build failure so I used the version from
next-20131206.

Non-merge commits (relative to Linus' tree): 2894
 3313 files changed, 117925 insertions(+), 76643 deletions(-)

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
(see below).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
multi_v7_defconfig for arm. After the final fixups (if any), it is also
built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
allyesconfig (minus CONFIG_PROFILE_ALL_BRANCHES - this fails its final
link) and i386, sparc, sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

I am currently merging 210 trees (counting Linus' and 29 trees of patches
pending for Linus' tree).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
Gortmaker for triage and bug fixes.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

$ git checkout master
$ git reset --hard stable
Merging origin/master (374b105797c3 Linux 3.13-rc3)
Merging fixes/master (8ae516aa8b81 Merge tag 'trace-fixes-v3.13-rc1' of git=
://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging kbuild-current/rc-fixes (19514fc665ff arm, kbuild: make "make insta=
ll" not depend on vmlinux)
Merging arc-current/for-curr (da990a4f2d5a ARC: [perf] Fix a few thinkos)
Merging arm-current/fixes (11d4bb1bd067 ARM: 7907/1: lib: delay-loop: Add a=
lign directive to fix BogoMIPS calculation)
Merging m68k-current/for-linus (77a42796786c m68k: Remove deprecated IRQF_D=
ISABLED)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (721cb59e9d95 powerpc/windfarm: Fix XServe G5 f=
an control Makefile issue)
Merging sparc/master (1de425c7b271 sparc64: Fix build regression)
Merging net/master (98bfd23cdb30 virtio-net: free bufs correctly on invalid=
 packet length)
Merging ipsec/master (239c78db9c41 net: clear local_df when passing skb bet=
ween namespaces)
Merging sound-current/for-linus (31660e9084df ALSA: hda - Remove quirk for =
Dell Vostro 131)
Merging pci-current/for-linus (4bff6749905d PCI: Move device_del() from pci=
_stop_dev() to pci_destroy_dev())
Merging wireless/master (a59b40b30f3f Merge branch 'for-john' of git://git.=
kernel.org/pub/scm/linux/kernel/git/jberg/mac80211)
Merging driver-core.current/driver-core-linus (a8b14744429f sysfs: give dif=
ferent locking key to regular and bin files)
Merging tty.current/tty-linus (39434abd942c n_tty: Fix missing newline echo)
Merging usb.current/usb-linus (ea4215893884 Revert "usb: xhci: Link TRB mus=
t not occur within a USB payload burst")
Merging staging.current/staging-linus (55ef003e4ae6 Merge tag 'iio-fixes-fo=
r-3.13b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into st=
aging-linus)
Merging char-misc.current/char-misc-linus (76a9635979e5 mei: add 9 series P=
CH mei device ids)
Merging input-current/for-linus (95f75e91588a Input: ALPS - add support for=
 DualPoint device on Dell XT2 model)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (8ec25c512916 crypto: testmgr - fix sglen in =
test_aead for case 'dst !=3D src')
Merging ide/master (c2f7d1e103ef ide: pmac: remove unnecessary pci_set_drvd=
ata())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (44033109e99c SH: Convert out[bwl] ma=
cros to inline functions)
Merging devicetree-current/devicetree/merge (1931ee143b0a Revert "drivers: =
of: add initialization code for dma reserved memory")
Merging rr-fixes/fixes (3459f11a8b16 virtio_balloon: update_balloon_size():=
 update correct field)
Merging mfd-fixes/master (88ec6a4d8369 Merge tag 'mfd-lee-3.13-fixes-1' of =
git://git.linaro.org/people/ljones/mfd)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (acc240d41ea1 drm/i915: Fix us=
e-after-free in do_switch)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (035a20627b46 ARC: [SMP] optimize IPI send and receive)
Merging arm/for-next (7c66fe34193f Merge branches 'kees' and 'misc' into fo=
r-next)
Merging arm-perf/for-next/perf (6ce4eac1f600 Linux 3.13-rc1)
Merging arm-soc/for-next (2e3b55132560 Merge branch 'fixes' into for-next)
Merging arm-v7-cache-opt/v7-cache-opt (e11d68fee368 arm: mm: refactor v7 ca=
che cleaning ops to use way/index sequence)
Merging bcm2835/for-next (5cc686267845 Merge branch 'for-3.14/defconfig' in=
to for-next)
Merging cortex-m/for-next (9c031a483646 ARM: v7-M: drop using mach/entry-ma=
cro.S)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (5d49e797de3a Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (02d93eb266e3 Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (e715696ab1b7 Merge branch 'heads/usb-r8a66597-hcd' in=
to next)
Merging samsung/for-next (8465d57097ce Merge branch 'v3.14-next/samsung-def=
config' into for-next)
Merging tegra/for-next (850500ad1edd Merge branch for-3.14/dt into for-next)
Merging arm64/upstream (db4ed53cfe9f arm64: mm: Fix PMD_SECT_PROT_NONE defi=
nition)
Merging blackfin/for-linus (36855dcfc980 blackfin: fix build warning for un=
used variable)
Merging c6x/for-linux-next (546153d75a48 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (be8cb7f42ab9 CRIS: drop unused Kconfig symbols)
Merging hexagon/linux-next (de44443a45e3 HEXAGON: Remove non existent refer=
ence to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (959f58544b7f Linux 3.12-rc7)
Merging m68k/for-next (27d632d27c4f m68k/atari: Hide RTC_PORT() macro from =
rtc-cmos)
Merging m68knommu/for-next (d4d80b54a862 m68k : Kill CONFIG_MTD_PARTITIONS)
Merging metag/for-next (1d61cf121d7d smp, metag: kill SMP single function c=
all interrupt)
Merging microblaze/next (a1dd107fcafa microblaze: Remove duplicate declarat=
ions of _stext[] and _etext[])
Merging mips/mips-for-linux-next (6ca0bf323c14 Merge branch '3.13-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (60a9dd5a10a1 openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (dc1ccc48159d Linux 3.13-rc2)
Merging powerpc/next (2c49195b6aed powernv: Remove get/set_rtc_time when th=
ey are not present)
Merging mpc5xxx/next (17a76e3ca7c9 clk: mpc512x: remove migration support w=
orkarounds)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (c9b851905dba s390/blacklist: Perform subchannel scan=
 only when needed)
Merging sh/sh-latest (37284bd93103 Merge branches 'sh/hw-breakpoints' and '=
sh/serial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (5e01dc7b26d9 Linux 3.12)
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (3bf4c10bb2e3 xtensa: implement CPU hotplug)
Merging btrfs/next (91aef86f3b8a Btrfs: rename btrfs_start_all_delalloc_ino=
des)
Merging ceph/master (ff638b7df5a9 ceph: allocate non-zero page to fscache i=
n readpage())
Merging cifs/for-next (dea4f48a0a30 Merge branch 'leds-fixes-for-3.13' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (2000f5beabc9 eCryptfs: file->private_data is always =
valid)
Merging ext3/for_next (df4e7ac0bb70 ext2: Fix oops in ext2_get_block() call=
ed from ext2_quota_write())
Merging ext4/dev (0826a7e1ffac ext4: check for overlapping extents in ext4_=
valid_extent_entries())
Merging f2fs/dev (0491fe20cb11 f2fs: replace the debugfs_root with f2fs_deb=
ugfs_root)
Merging fscache/fscache (7c604e5d6e56 FS-Cache: Fix handling of an attempt =
to store a page that is now beyond EOF)
Merging fuse/for-next (ce128de6260f fuse: writepages: protect secondary req=
uests from fuse file release)
Merging gfs2/master (3ecb91bd8fac GFS2: Use only a single address space for=
 rgrps)
Merging jfs/jfs-next (8660998608cf jfs: fix error path in ialloc)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (e2f0c83a9de3 sunrpc: add an "info" file for the dum=
my gssd pipe)
Merging nfsd/nfsd-next (d2c2ad54c485 Merge git://git.kernel.org/pub/scm/lin=
ux/kernel/git/davem/net)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f94741fd2832 net/9p: remove virtio default hack and =
set appropriate bits instead)
Merging ubifs/linux-next (58a4e23703b2 UBIFS: correct data corruption range)
Merging xfs/for-next (c91c46c12768 xfs: add xfs_setattr_time)
Merging vfs/for-next (27ac0ffeac80 locks: break delegations on any attribut=
e modification)
Merging pci/next (6ce4eac1f600 Linux 3.13-rc1)
Merging hid/for-next (074fb898390b Merge branch 'for-3.14/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (af91706d5dde ima: store address of template_fmt_c=
opy in a pointer before calling strsep)
Merging jdelvare-hwmon/master (024cd034d0e6 hwmon: (it87) Print proper name=
s for the IT8771E and IT8772E)
Merging hwmon-staging/hwmon-next (7f438058ec86 hwmon: remove DEFINE_PCI_DEV=
ICE_TABLE macro)
Merging v4l-dvb/master (258a9e5cbc63 Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (e6483a58eca6 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (4eae518d4b01 localmodconfig: Fix localyesconfig t=
o set to 'y' not 'm')
Merging libata/for-next (c5fd0781fbae Merge branch 'for-3.14' into for-next)
Merging pstore/master (bd08ec33b5c2 pstore/ram: Restore ecc information blo=
ck)
Merging pm/linux-next (efef6dba5277 Merge branch 'master' into linux-next)
Merging idle/next (1ae2a8af4228 tools/power turbostat: run on HSX)
Merging apm/for-next (fb9d78aca709 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (86e0a0bdf81c Merge branches 'intel_powerclamp', 'tmon=
' and 'misc' of .git into next)
Merging ieee1394/for-next (db9ae8fec7b1 firewire: ohci: Fix deadlock at bus=
 reset)
Merging ubi/linux-next (ae0d14695566 UBI: Add some asserts to ubi_attach_fa=
stmap())
Merging dlm/next (a97f4a66d8ee dlm: Avoid that dlm_release_lockspace() inco=
rrectly returns -EBUSY)
Merging swiotlb/linux-next (af51a9f1848f swiotlb: Do not export swiotlb_bou=
nce since there are no external consumers)
Merging slave-dma/next (29732357a296 Merge branch 'for-linus' into next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx51.dtsi
Merging dmaengine/next (6ce4eac1f600 Linux 3.13-rc1)
Merging net-next/master (0d74c42f788c ether_addr_equal: Optimize implementa=
tion, remove unused compare_ether_addr)
Merging ipsec-next/master (d70f2cf520cf macvlan: Support creating macvtaps =
from macvlans)
Merging wireless-next/master (e08fd975bf26 Merge branch 'master' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/linville/wireless)
Merging bluetooth/master (53b834d2333a Bluetooth: Use macros for connection=
less slave broadcast features)
Merging infiniband/for-next (b4fdf52b3fc8 Merge branches 'cma', 'cxgb4', 'f=
lowsteer', 'ipoib', 'misc', 'mlx4', 'mlx5', 'nes', 'ocrdma', 'qib' and 'srp=
' into for-next)
Merging mtd/master (6ce4eac1f600 Linux 3.13-rc1)
Merging l2-mtd/master (1947664f29db mtd: tests: mtd_nandecctest: Use IS_ENA=
BLED() macro)
Merging crypto/master (f7b2b5dd6a62 crypto: omap-aes - add error check for =
pm_runtime_get_sync)
$ git reset --hard HEAD^
Merging next-20131205 version of crypto
Merging drm/drm-next (a3483353ca4e drm: check for !kdev in drm_unplug_minor=
())
Merging drm-intel/for-linux-next (798183c54799 drm/i915: change CRTC assert=
ion on LCPLL disable)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
Merging drm-tegra/drm/for-next (977386a04bae drm/tegra: Reserve syncpoint b=
ase for gr3d)
Merging sound/for-next (e8648e5e33e4 ALSA: hda - Ignore small negative LPIB=
 delay correction)
Merging sound-asoc/for-next (04a1c49aa897 Merge remote-tracking branches 'a=
soc/topic/ad193x', 'asoc/topic/adav80x', 'asoc/topic/adsp', 'asoc/topic/ak4=
641', 'asoc/topic/ak4642', 'asoc/topic/arizona', 'asoc/topic/bcm2835', 'aso=
c/topic/cs4271', 'asoc/topic/cs42l52', 'asoc/topic/da7210', 'asoc/topic/ep9=
3xx', 'asoc/topic/fsl', 'asoc/topic/hdmi', 'asoc/topic/jack', 'asoc/topic/j=
z4740', 'asoc/topic/max98090', 'asoc/topic/mxs', 'asoc/topic/omap', 'asoc/t=
opic/rcar', 'asoc/topic/samsung', 'asoc/topic/spear', 'asoc/topic/ssm2602',=
 'asoc/topic/tegra', 'asoc/topic/uda1380', 'asoc/topic/wm8510', 'asoc/topic=
/wm8523', 'asoc/topic/wm8580', 'asoc/topic/wm8711', 'asoc/topic/wm8728', 'a=
soc/topic/wm8731', 'asoc/topic/wm8741', 'asoc/topic/wm8750', 'asoc/topic/wm=
8753', 'asoc/topic/wm8776', 'asoc/topic/wm8804', 'asoc/topic/wm8900', 'asoc=
/topic/wm8901', 'asoc/topic/wm8940', 'asoc/topic/wm8962', 'asoc/topic/wm897=
4', 'asoc/topic/wm8985', 'asoc/topic/wm8988', 'asoc/topic/wm8990', 'asoc/to=
pic/wm8991', 'asoc/topic/wm8994', 'asoc/topic/wm8995', 'asoc/topic/wm9081' =
and 'asoc/topic/x86' into asoc-next)
CONFLICT (content): Merge conflict in sound/soc/fsl/fsl_ssi.c
Merging modules/modules-next (74e22fac8858 module.h: Remove unnecessary sem=
icolon)
Merging virtio/virtio-next (7d2dddda5c92 virtio: pci: remove unnecessary pc=
i_set_drvdata())
Merging input/next (c838cb3d477f Input: use dev_get_platdata())
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging cgroup/for-next (4d75ee4f3e9c Merge branch 'for-3.14' into for-next)
Merging block/for-next (391b7a7bfb52 Merge branch 'for-3.14/drivers' into f=
or-next)
CONFLICT (content): Merge conflict in include/trace/events/f2fs.h
CONFLICT (content): Merge conflict in fs/logfs/dev_bdev.c
CONFLICT (content): Merge conflict in fs/f2fs/segment.c
CONFLICT (content): Merge conflict in fs/f2fs/data.c
CONFLICT (content): Merge conflict in fs/btrfs/scrub.c
CONFLICT (content): Merge conflict in fs/btrfs/extent_io.c
CONFLICT (content): Merge conflict in fs/btrfs/check-integrity.c
CONFLICT (content): Merge conflict in block/blk-flush.c
Merging device-mapper/for-next (27cafc612c3b dm snapshot: avoid snapshot sp=
ace leak on crash)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (e395c4387c74 mmc: wbsd: Silence compiler warning)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
CONFLICT (content): Merge conflict in kernel/debug/debug_core.h
Merging slab/for-next (a8c0b0837359 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (6d183de40771 md/raid5: fix newly-broken locking in get=
_active_stripe.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (f6249d48f842 regulator: tps6586x: Add and use =
correct voltage table)
Merging battery/master (d36240d26025 power_supply: Add power_supply notifie=
r)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (46ac29568e63 video: vt8500: fix error handling =
in probe())
Merging regulator/for-next (6680ccfec496 Merge remote-tracking branches 're=
gulator/topic/ab8500', 'regulator/topic/arizona', 'regulator/topic/gpio', '=
regulator/topic/lp3971', 'regulator/topic/lp3972', 'regulator/topic/pcf5063=
3' and 'regulator/topic/tps51632' into regulator-next)
Merging security/next (217091dd7a7a ima: define '_ima' as a builtin 'truste=
d' keyring)
Merging selinux/master (0b1f24e6db9a selinux: pull address family directly =
from the request_sock struct)
Merging lblnet/master (07bc9dc1b01b Merge branch 'merge' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (0a9cc5eca904 sc1200_wdt: Fix oops)
CONFLICT (add/add): Merge conflict in drivers/watchdog/rt2880_wdt.c
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (e6ca48d995e4 Merge branches 'iommu/fixes', 'tracing', '=
core', 'arm/tegra' and 'x86/vt-d' into next)
Merging vfio/next (15c03dd4859a Linux 3.12-rc3)
Merging osd/linux-next (861d66601acd exofs: don't leak io_state and pages o=
n read error)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (6bbdc3984efb vio: remove dangly makefile bits)
Merging audit/master (fc582aef7dcc Merge tag 'v3.12')
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (355e62f5ad12 of/irq: Fix potential buff=
er overflow)
Merging dt-rh/for-next (1b50b0c3330e Merge branch 'for-3.14' into for-next)
Merging spi/for-next (6099087e62df Merge remote-tracking branches 'spi/topi=
c/atmel', 'spi/topic/bcm63xx-hsspi', 'spi/topic/coldfire', 'spi/topic/davin=
ci', 'spi/topic/falcon', 'spi/topic/gpio', 'spi/topic/msiof', 'spi/topic/om=
ap', 'spi/topic/pci', 'spi/topic/rcar', 'spi/topic/sc18is602' and 'spi/topi=
c/xcomm' into spi-next)
Merging tip/auto-latest (c4372b1b29f2 Merge branch 'x86/urgent')
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (c97986837cc6 Merge branch 'ras-fixes' into for-n=
ext)
Merging ftrace/for-next (3ccb01239201 tracing: Only run synchronize_sched()=
 at instance deletion time)
Merging rcu/rcu/next (9dd97744fb2f Merge branches 'doc.2013.12.03a', 'fixes=
.2013.12.03a', 'rcutorture.2013.12.03a' and 'sparse.2013.12.03a' into HEAD)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (d6d63b51fe3b Merge tag 'kvm-s390-20131128' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-next)
Merging kvm-arm/kvm-arm-next (ede582224231 Merge tag 'kvm-arm64/for-3.13-1'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms into kv=
m-next)
Merging kvm-ppc/kvm-ppc-next (27025a602cb9 powerpc: kvm: optimize "sc 1" as=
 fast return)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (7c2a5cd7ee0e Merge remote-tracking branch 'xent=
ip/stable/for-linus-3.13' into linux-next)
Merging percpu/for-next (b1a0fbfdde65 percpu: fix spurious sparse warnings =
from DEFINE_PER_CPU())
Merging workqueues/for-next (4e8b22bd1a37 workqueue: fix pool ID allocation=
 leakage and remove BUILD_BUG_ON() in init_workqueues)
Merging drivers-x86/linux-next (a80e1053aaa3 x86, wmi fix modalias_show ret=
urn values)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (d929555edfba Merge remote-tracking branch 'regmap/=
topic/core' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (4a87d107bfc3 leds: lp5521/5523: Remove duplicate mut=
ex)
Merging driver-core/driver-core-next (35a5fe695b07 kobject: remove kset fro=
m sysfs immediately in kset_unregister())
CONFLICT (content): Merge conflict in fs/sysfs/file.c
Merging tty/tty-next (dc1ccc48159d Linux 3.13-rc2)
Merging usb/usb-next (2e30d14f1242 USB: fix coccinelle warnings)
Merging usb-gadget/next (9ba96ae5074c usb: omap1: Tahvo USB transceiver dri=
ver)
$ git reset --hard HEAD^
Merging next-20131206 version of usb-gadget
Merging staging/staging-next (bf4063e6f4a3 staging: comedi: pcmuio: tidy up=
 pcmuio_start_intr())
CONFLICT (content): Merge conflict in include/linux/hid-sensor-ids.h
Merging char-misc/char-misc-next (b0abd6ee9e4f misc: bmp085: devicetree irq=
 update.)
Merging scsi/for-next (ef5cb624a9b2 Merge branch 'fixes' into for-next)
Merging target-updates/for-next (86784c6bdeee iscsi-target: chap auth shoul=
dn't match username with trailing garbage)
Merging target-merge/for-next-merge (15c03dd4859a Linux 3.12-rc3)
Merging writeback/writeback-for-next (a8855990e382 writeback: Do not sort b=
_io list only because of block device inode)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (d1130f116ce3 Merge branch 'devel' into for-next)
$ git reset --hard HEAD^
Merging next-20131206 version of pinctrl
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (40e3b642538b Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (5e01dc7b26d9 Linux 3.12)
Merging pwm/for-next (6ca142ad0d1b pwm: sysfs: Convert to use ATTRIBUTE_GRO=
UPS macro)
Merging dma-buf/for-next (19e8697ba45e dma-buf: Expose buffer size to users=
pace (v2))
Merging userns/for-next (41301ae78a99 vfs: Fix a regression in mounting pro=
c)
Merging ktest/for-next (298a0d1d5750 ktest: Add documentation of CLOSE_CONS=
OLE_SIGNAL)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (cdf64eeeb0d7 clk: exynos5420: fix cpll clock register=
 offsets)
Merging random/dev (8ea43ef26598 random: clarify bits/bytes in wakeup thres=
holds)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (374b105797c3 Linux 3.13-rc3)
Merging akpm-current/current (6e7ebeb1cb49 lib/decompress_unlz4.c: always s=
et an error return code on failures)
CONFLICT (content): Merge conflict in kernel/params.c
CONFLICT (content): Merge conflict in arch/um/kernel/sysrq.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: mm: add strictlimit knob
Merging akpm/master (a78073fc717c mm: add strictlimit knob)
[master e6336672e575] Revert "powerpc/powernv: Machine check exception hand=
ling."
[master 4989b18ad99d] Revert "powerpc/powernv: Remove machine check handlin=
g in OPAL."
[master 4a301210109e] Revert "powerpc/book3s: Queue up and process delayed =
MCE events."
[master fa544e01d69e] Revert "powerpc/book3s: Decode and save machine check=
 event."
[master 6708544821a8] Revert "powerpc/book3s: Flush SLB/TLBs if we get SLB/=
TLB machine check errors on power8."
[master ff32ad3b14a0] Revert "powerpc/book3s: Flush SLB/TLBs if we get SLB/=
TLB machine check errors on power7."
[master 9e8c73d8981a] Revert "powerpc/book3s: Add flush_tlb operation in cp=
u_spec."
[master b245ba32317a] Revert "powerpc/book3s: Introduce a early machine che=
ck hook in cpu_spec."
[master 49dadc0c6156] Revert "powerpc/book3s: Return from interrupt if comi=
ng from evil context."
[master 7252486597c0] Revert "powerpc/book3s: handle machine check in Linux=
 host."

--Signature=_Mon__9_Dec_2013_17_40_12_+1100_Xo9uNjgPXlZW8NT+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSpWXQAAoJEMDTa8Ir7ZwV3zsP/3PIlLA2gVBmhLmbxlRIdZSA
fh3o17aGH8XcEyIheszcjKJ+cemQIxldHxn36/VHrgQsc12tFpdz86RiZiQjRnuu
x73gLJiqwNv+elRYoVEvS+Zz2oeIZ5RAel8qedk7cyaujCrizv+bbQeeIjFHfRed
UZLtgYsUuVOZn7jbArsHe+PsEetMigAORiQq6WMkynpoDYgNu9eLYiin4JSyLuKN
Pht8KgOrY20ii+AIiiyMcrdzarYihVUqSYl/hw0lLFWoBuW6GNbU3tzh1H0V/wbE
UjRoCWsx0vdBZd2MtyI7z6qO6K8N/qOUAll8+4eW2HIOI9LixUzWQ2NEOVawZd/J
gHKJBW5m3N65vNTOiqsrak16CFAH6+DPOBrVv3Yn6NWIp2VvQ7DZN1DE9pyf3yu4
vChlYZ3BWZoS371chzmnFc8vEAuo2ErDILl6qAzSPRy2DyXciVl1bO4WdazlwRaq
4e1q1wGTbLxON5NIHamTKbRYW4jvNUQ8jRiRdJK6XsOhSxvX9MMPYdGdW5dpmYU6
sgcQMnDOd5GP4RvJyqk3F9/9gine9yKwaXRp+r3RCnvBYC/xz11SGAJBnd3ZVEmB
sNkEBlO5I72CdIAkGoqMR0tdsioshrnXyd2pXcD5U8rnuk8QXvjEiaDYbVjoHXHn
my4tvneGVICHyRLdMTKR
=92Pl
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Dec_2013_17_40_12_+1100_Xo9uNjgPXlZW8NT+--
