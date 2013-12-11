Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750873Ab3LKE5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 23:57:01 -0500
Received: from ozlabs.org ([203.10.76.45]:46395 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab3LKE44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 23:56:56 -0500
Date: Wed, 11 Dec 2013 15:56:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Dec 11
Message-Id: <20131211155648.4a6095e31dc96c38b2dcc1d5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Dec_2013_15_56_48_+1100_EqN2Xd+4SEqKk2FI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Dec_2013_15_56_48_+1100_EqN2Xd+4SEqKk2FI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20131210:

Removed tree: arm-v7-cache-opt (merged into the arm tree)

The powerpc tree still had its build failure for which I applied a
supplied patch.

The sound-asoc tree lost its build failure.

The usb-gadget tree still has its build failure so I used the version from
next-20131206.

The pinctrl tree lost its build failure.

Non-merge commits (relative to Linus' tree): 3141
 3634 files changed, 143080 insertions(+), 83685 deletions(-)

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

I am currently merging 209 trees (counting Linus' and 29 trees of patches
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
Merging origin/master (5e0af24cee56 Merge branch 'for-linus' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32)
Merging fixes/master (8ae516aa8b81 Merge tag 'trace-fixes-v3.13-rc1' of git=
://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging kbuild-current/rc-fixes (19514fc665ff arm, kbuild: make "make insta=
ll" not depend on vmlinux)
Merging arc-current/for-curr (da990a4f2d5a ARC: [perf] Fix a few thinkos)
Merging arm-current/fixes (b31459adeab0 ARM: 7917/1: cacheflush: correctly =
limit range of memory region being flushed)
Merging m68k-current/for-linus (77a42796786c m68k: Remove deprecated IRQF_D=
ISABLED)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (e641eb03ab2b powerpc: Fix up the kdump base ca=
p to 128M)
Merging sparc/master (1de425c7b271 sparc64: Fix build regression)
Merging net/master (e9c56f8d2f85 net: allwinner: emac: Add missing free_irq)
Merging ipsec/master (239c78db9c41 net: clear local_df when passing skb bet=
ween namespaces)
Merging sound-current/for-linus (ebb93c057dda ALSA: hda - Mute all aamix in=
puts as default)
Merging pci-current/for-linus (4fc9bbf98fd6 PCI: Disable Bus Master only on=
 kexec reboot)
Merging wireless/master (bbf807bc0697 ath9k: fix duration calculation for n=
on-aggregated packets)
Merging driver-core.current/driver-core-linus (a8b14744429f sysfs: give dif=
ferent locking key to regular and bin files)
Merging tty.current/tty-linus (39434abd942c n_tty: Fix missing newline echo)
Merging usb.current/usb-linus (8820784203ac phy: kconfig: add depends on "U=
SB_PHY" to OMAP_USB2 and TWL4030_USB)
Merging staging.current/staging-linus (55ef003e4ae6 Merge tag 'iio-fixes-fo=
r-3.13b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into st=
aging-linus)
Merging char-misc.current/char-misc-linus (76a9635979e5 mei: add 9 series P=
CH mei device ids)
Merging input-current/for-linus (241ecf1ce528 Input: adxl34x - Fix bug in d=
efinition of ADXL346_2D_ORIENT)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (389a5390583a crypto: scatterwalk - Use sg_ch=
ain_ptr on chain entries)
Merging ide/master (c2f7d1e103ef ide: pmac: remove unnecessary pci_set_drvd=
ata())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (44033109e99c SH: Convert out[bwl] ma=
cros to inline functions)
Merging devicetree-current/devicetree/merge (1931ee143b0a Revert "drivers: =
of: add initialization code for dma reserved memory")
Merging rr-fixes/fixes (3459f11a8b16 virtio_balloon: update_balloon_size():=
 update correct field)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (e453e7144f45 drm/i915: don't =
update the dri1 breadcrumb with modesetting)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (035a20627b46 ARC: [SMP] optimize IPI send and receive)
Merging arm/for-next (f464ce8ba7ef Merge branches 'amba', 'fixes', 'kees' a=
nd 'misc' into for-next)
Merging arm-perf/for-next/perf (6ce4eac1f600 Linux 3.13-rc1)
Merging arm-soc/for-next (aa87bbf97aea Merge branch 'next/soc' into for-nex=
t)
Merging bcm2835/for-next (5cc686267845 Merge branch 'for-3.14/defconfig' in=
to for-next)
Merging cortex-m/for-next (9c031a483646 ARM: v7-M: drop using mach/entry-ma=
cro.S)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (d8da618d5273 Merge branches 'imx/soc' and 'imx/dt=
' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (3054cde59b01 Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (6ce4eac1f600 Linux 3.13-rc1)
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
Merging powerpc/next (75eb3d9b60c2 powerpc/powernv: Get FSP memory errors a=
nd plumb into memory poison infrastructure.)
Applying: powerpc: Fix "attempt to move .org backwards" error
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
Merging ceph/master (9fb9d5b2ace4 ceph: implement readv/preadv for sync ope=
ration)
Merging cifs/for-next (7f07d4db6ad9 cifs: We do not drop reference to tlink=
 in CIFSCheckMFSymlink())
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (2000f5beabc9 eCryptfs: file->private_data is always =
valid)
Merging ext3/for_next (df4e7ac0bb70 ext2: Fix oops in ext2_get_block() call=
ed from ext2_quota_write())
Merging ext4/dev (c25625a1b6a5 ext4: enable punch hole for bigalloc)
Merging f2fs/dev (0491fe20cb11 f2fs: replace the debugfs_root with f2fs_deb=
ugfs_root)
Merging fscache/fscache (7c604e5d6e56 FS-Cache: Fix handling of an attempt =
to store a page that is now beyond EOF)
Merging fuse/for-next (ce128de6260f fuse: writepages: protect secondary req=
uests from fuse file release)
Merging gfs2/master (f46afaeb3a44 GFS2: Fix use-after-free race when callin=
g gfs2_remove_from_ail)
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
Merging xfs/for-next (df8052e7dae0 xfs: fix infinite loop by detaching the =
group/project hints from user dquot)
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
Merging v4l-dvb/master (c4f181f1efc5 Merge branch 'v4l_for_linus' into temp)
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
Merging dlm/next (af74ec9e4292 dlm: set zero linger time on sctp socket)
Merging swiotlb/linux-next (af51a9f1848f swiotlb: Do not export swiotlb_bou=
nce since there are no external consumers)
Merging slave-dma/next (3f8002139678 Merge branch 'topic/of' into next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx51.dtsi
Merging dmaengine/next (9e70a236fc69 dmaengine: fix enable for high order u=
nmap pools)
Merging net-next/master (4e34da4d4252 bgmac: start/stop PHY on netdev open/=
stop)
Merging ipsec-next/master (0e0d44ab4275 net: Remove FLOWI_FLAG_CAN_SLEEP)
Merging wireless-next/master (d6b5075d73ad ath9k: Apply tuning caps for AR9=
330 and AR9485)
Merging bluetooth/master (71fb419724fa Bluetooth: Fix handling of L2CAP Com=
mand Reject over LE)
Merging infiniband/for-next (b1819c455542 IB/usnic: Add Cisco VIC low-level=
 hardware driver)
Merging mtd/master (6ce4eac1f600 Linux 3.13-rc1)
Merging l2-mtd/master (13356e2c05c3 mtd: denali: remove DEFINE_PCI_DEVICE_T=
ABLE macro)
Merging crypto/master (e37b94ebffdd crypto: memneq - fix for archs without =
efficient unaligned access)
Merging drm/drm-next (a3483353ca4e drm: check for !kdev in drm_unplug_minor=
())
Merging drm-intel/for-linux-next (0f6660d72946 drm/i915: Record BB_ADDR for=
 every ring)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
Merging drm-tegra/drm/for-next (977386a04bae drm/tegra: Reserve syncpoint b=
ase for gr3d)
Merging sound/for-next (337bb336b95b ALSA: atmel_abdac: clk_round_rate() ca=
n return a zero upon error)
Merging sound-asoc/for-next (8a53608fe9d8 Merge remote-tracking branches 'a=
soc/topic/ad193x', 'asoc/topic/adav80x', 'asoc/topic/adsp', 'asoc/topic/ak4=
641', 'asoc/topic/ak4642', 'asoc/topic/arizona', 'asoc/topic/axi', 'asoc/to=
pic/bcm2835', 'asoc/topic/cs4271', 'asoc/topic/cs42l52', 'asoc/topic/da7210=
', 'asoc/topic/davinci', 'asoc/topic/ep93xx', 'asoc/topic/fsl', 'asoc/topic=
/hdmi', 'asoc/topic/jack', 'asoc/topic/jz4740', 'asoc/topic/max98090', 'aso=
c/topic/mxs', 'asoc/topic/omap', 'asoc/topic/rcar', 'asoc/topic/samsung', '=
asoc/topic/spear', 'asoc/topic/ssm2602', 'asoc/topic/tegra', 'asoc/topic/tl=
v320aic3x', 'asoc/topic/uda1380', 'asoc/topic/wm8510', 'asoc/topic/wm8523',=
 'asoc/topic/wm8580', 'asoc/topic/wm8711', 'asoc/topic/wm8728', 'asoc/topic=
/wm8731', 'asoc/topic/wm8741', 'asoc/topic/wm8750', 'asoc/topic/wm8753', 'a=
soc/topic/wm8776', 'asoc/topic/wm8804', 'asoc/topic/wm8900', 'asoc/topic/wm=
8901', 'asoc/topic/wm8940', 'asoc/topic/wm8962', 'asoc/topic/wm8974', 'asoc=
/topic/wm8985', 'asoc/topic/wm8988', 'asoc/topic/wm8990', 'asoc/topic/wm899=
1', 'asoc/topic/wm8994', 'asoc/topic/wm8995', 'asoc/topic/wm9081' and 'asoc=
/topic/x86' into asoc-next)
CONFLICT (content): Merge conflict in sound/soc/fsl/fsl_ssi.c
Merging modules/modules-next (74e22fac8858 module.h: Remove unnecessary sem=
icolon)
Merging virtio/virtio-next (7d2dddda5c92 virtio: pci: remove unnecessary pc=
i_set_drvdata())
Merging input/next (670d20725e4f Input: samsung-keypad - favor platform dat=
a if present)
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
Merging device-mapper/for-next (088448007bb9 dm cache: actually resize cach=
e)
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
Merging mfd-lj/for-mfd-next (15eb2cd74221 mfd: cros ec: spi: Depend on OF)
Merging battery/master (d36240d26025 power_supply: Add power_supply notifie=
r)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (46ac29568e63 video: vt8500: fix error handling =
in probe())
Merging regulator/for-next (3d8165b1cea0 Merge remote-tracking branches 're=
gulator/topic/ab8500', 'regulator/topic/arizona', 'regulator/topic/db8500',=
 'regulator/topic/gpio', 'regulator/topic/lp3971', 'regulator/topic/lp3972'=
, 'regulator/topic/pcf50633', 'regulator/topic/pfuze100', 'regulator/topic/=
stw481x-vmmc' and 'regulator/topic/tps51632' into regulator-next)
Merging security/next (217091dd7a7a ima: define '_ima' as a builtin 'truste=
d' keyring)
Merging selinux/master (5c6c26813a20 selinux: process labeled IPsec TCP SYN=
-ACK packets properly in selinux_ip_postroute())
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
Merging spi/for-next (633e9b8e9370 Merge remote-tracking branches 'spi/topi=
c/atmel', 'spi/topic/bcm63xx-hsspi', 'spi/topic/coldfire', 'spi/topic/davin=
ci', 'spi/topic/falcon', 'spi/topic/gpio', 'spi/topic/msiof', 'spi/topic/om=
ap', 'spi/topic/orion', 'spi/topic/pci', 'spi/topic/rcar', 'spi/topic/s3c64=
xx', 'spi/topic/sc18is602', 'spi/topic/tegra114', 'spi/topic/tegra20-sflash=
', 'spi/topic/tegra20-slink' and 'spi/topic/xcomm' into spi-next)
Merging tip/auto-latest (c4372b1b29f2 Merge branch 'x86/urgent')
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (c97986837cc6 Merge branch 'ras-fixes' into for-n=
ext)
Merging ftrace/for-next (3ccb01239201 tracing: Only run synchronize_sched()=
 at instance deletion time)
Merging rcu/rcu/next (5bf73c6001d8 Merge branches 'doc.2013.12.03a', 'fixes=
.2013.12.09a', 'rcutorture.2013.12.03a' and 'sparse.2013.12.09b' into HEAD)
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
Merging leds/for-next (5d36f2b9d4a9 leds: leds-mc13783: Remove unneeded mc1=
3xxx_{un}lock)
Merging driver-core/driver-core-next (bbc780f8bab5 driver core: fix device_=
create() error path)
CONFLICT (content): Merge conflict in fs/sysfs/file.c
Applying: This is v3.14 fix for the same issue that a8b14744429f ("sysfs: g=
ive
Merging tty/tty-next (acc0f67f307f tty: Halve flip buffer GFP_ATOMIC memory=
 consumption)
Merging usb/usb-next (40fcd88b8d49 USB: storage: fix compile warning)
Merging usb-gadget/next (c6d7641470fe usb: dwc3: omap: remove unnecessary l=
ock)
$ git reset --hard HEAD^
Merging next-20131206 version of usb-gadget
Merging staging/staging-next (99ec297ad6d2 staging: btmtk_usb: remove drive=
r)
CONFLICT (content): Merge conflict in include/linux/hid-sensor-ids.h
Merging char-misc/char-misc-next (4455d9fd4809 pcmcia: Remove superfluous n=
ame casts)
Merging scsi/for-next (ef5cb624a9b2 Merge branch 'fixes' into for-next)
Merging target-updates/for-next (86784c6bdeee iscsi-target: chap auth shoul=
dn't match username with trailing garbage)
Merging target-merge/for-next-merge (15c03dd4859a Linux 3.12-rc3)
Merging writeback/writeback-for-next (a8855990e382 writeback: Do not sort b=
_io list only because of block device inode)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (18334c8e18b2 pinctrl: make the MSM SoC driver dep=
end on OF)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (fdd6a5fe8988 gpiolib: update inline documentation of=
 gpiod_get_index())
Merging dma-mapping/dma-mapping-next (5e01dc7b26d9 Linux 3.12)
Merging pwm/for-next (6ca142ad0d1b pwm: sysfs: Convert to use ATTRIBUTE_GRO=
UPS macro)
Merging dma-buf/for-next (17b2112f332d Merge branch 'merge' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/benh/powerpc)
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
Merging akpm/master (3e7810b15578 mm: add strictlimit knob)

--Signature=_Wed__11_Dec_2013_15_56_48_+1100_EqN2Xd+4SEqKk2FI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSp/CUAAoJEMDTa8Ir7ZwVSyAP/R9TCWgU9dJ1pQz3nccV+k3O
evaPyPLc/cPEcadq1SUqUcoVGywRJU+2ZFiyBp2NbS6evYjG9ZcAwRMN6fSCX3rN
/i4MkHGfjDnP3sAmiVnG5DA4rKw2jQkDmWSzu3a+nBIFgJEykBOItoX30s15hRF7
bzICKoWzkKr6X/x2s/6GCYiQuz824NjBK8cRcidhqa66RA+5Ipx9FnqP+owhQ84W
h/2umxAMSkqYPMGWt4GllKNyA/y5cxWsv5moSo2oPw2y3Y5RJzItn2rajrP7DRpR
vnK6lKL+oXSFgQPpA4ekxJtqEp4r6AzYl6SapU7Rpa5g3she73b4JJNkPwc4UL93
DUlyIByC321ghbdGsjlJ+QFDEkWgDhy2qx1++9zoZ2LFPINpOjbHfJNRLrm87Uqv
BvweD9LZGpwMXWfjDKsQamqfTmbN6dP4QSK8G4B2WAuUdh3wQHIQLwjkOftzIkSP
SBzmwVFSLfjgqKchKlEZi8v5L1JGzHtmqS1CDm1eA8VLQzrvbVdf0kB3Cw6/ov8b
QgTWgdzf63ZQiQWUS4XnYfaTi734sNV0xx4spmhfGR7CehsTEZwUJhRkXn6dezjR
CmzI7MbrEBE8a5mUFRvA2q6zKGNDlJx3yuIyMJu7AUPA5y6SiWgLYeioXcgGrK5r
CyoPabuA0d6SRnJ9YPyJ
=xVQ3
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Dec_2013_15_56_48_+1100_EqN2Xd+4SEqKk2FI--
