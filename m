Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaAPG4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:56:33 -0500
Received: from ozlabs.org ([203.10.76.45]:58764 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaAPG41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:56:27 -0500
Date: Thu, 16 Jan 2014 17:56:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jan 16
Message-Id: <20140116175620.cb814b39f2622b9cf3725a3d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Jan_2014_17_56_20_+1100_xR.gaaDZ6b/1fi8t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Jan_2014_17_56_20_+1100_xR.gaaDZ6b/1fi8t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree fails (more than usual) the powerpc allyesconfig build.

Changes since 20140115:

Dropped tree: sh (complex merge conflicts against very old commits)

New tree: uml

The powerpc tree still had its build failure.

The libata tree gained a conflict against the arm-soc tree.

The net-next tree gained a conflict against the uml tree.

The device-mapper tree lost its build failure.

The tip tree gained a build failure for which I reverted an idle tree commi=
t.

The kvm tree still had its build failure so I used the version from
next-20140109.

Non-merge commits (relative to Linus' tree): 9316
 8699 files changed, 446302 insertions(+), 232089 deletions(-)

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
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master (2e67c56248b7 Merge branch 'akpm' (incoming from Andr=
ew))
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (19514fc665ff arm, kbuild: make "make insta=
ll" not depend on vmlinux)
Merging arc-current/for-curr (1e01c7eb7c43 ARC: Allow conditional multiple =
inclusion of uapi/asm/unistd.h)
Merging arm-current/fixes (b25f3e1c3584 ARM: 7938/1: OMAP4/highbank: Flush =
L2 cache before disabling)
Merging m68k-current/for-linus (77a42796786c m68k: Remove deprecated IRQF_D=
ISABLED)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (b3084f4db3ae powerpc/thp: Fix crash on mremap)
Merging sparc/master (ef350bb7c5e0 Merge tag 'ext4_for_linus_stable' of git=
://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging net/master (51bb352f1559 qlge: Fix vlan netdev features.)
Merging ipsec/master (965cdea82569 dccp: catch failed request_module call i=
n dccp_probe init)
Merging sound-current/for-linus (150116bcfbd9 ALSA: hiface: Fix typo in 352=
800 rate definition)
Merging pci-current/for-linus (f0b75693cbb2 MAINTAINERS: Add DesignWare, i.=
MX6, Armada, R-Car PCI host maintainers)
Merging wireless/master (2eff7c791a18 Merge tag 'nfc-fixes-3.13-1' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes)
Merging driver-core.current/driver-core-linus (413541dd66d5 Linux 3.13-rc5)
Merging tty.current/tty-linus (413541dd66d5 Linux 3.13-rc5)
Merging usb.current/usb-linus (413541dd66d5 Linux 3.13-rc5)
Merging staging.current/staging-linus (413541dd66d5 Linux 3.13-rc5)
Merging char-misc.current/char-misc-linus (802eee95bde7 Linux 3.13-rc6)
Merging input-current/for-linus (8e2f2325b73f Input: xpad - add new USB IDs=
 for Logitech F310 and F710)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (efb753b8e013 crypto: ixp4xx - Fix kernel com=
pile error)
Merging ide/master (c2f7d1e103ef ide: pmac: remove unnecessary pci_set_drvd=
ata())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (44033109e99c SH: Convert out[bwl] ma=
cros to inline functions)
Merging devicetree-current/devicetree/merge (6f041e99fc7b of: Fix NULL dere=
ference in unflatten_and_copy())
Merging rr-fixes/fixes (7122c3e9154b scripts/link-vmlinux.sh: only filter k=
ernel symbols for arm)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (09f2344d0896 drm/i915/bdw: ma=
ke sure south port interrupts are enabled properly v2)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (d8e8c7dda11f ARC: [SMP] optimize IPI send and receive)
Merging arm/for-next (4a9fcd956bbc Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (6ce4eac1f600 Linux 3.13-rc1)
Merging arm-soc/for-next (fb54a12a810e Merge branch 'next/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
Merging bcm2835/for-next (413541dd66d5 Linux 3.13-rc5)
Merging cortex-m/for-next (f41bfc9423aa Merge tag 'ext4_for_linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (53749239e004 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (ec7d4be690a2 Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (2fb5c387800c Merge branch 'heads/soc-fixes-for-v3.14'=
 into next)
Merging samsung/for-next (8109c477487a Merge branch 'v3.14-next/dt-exynos-3=
' into for-next)
Merging tegra/for-next (95e770a5ad96 Merge branch for-3.14/defconfig into f=
or-next)
Merging arm64/for-next/core (65c021bb496a arm64: kernel: restore HW breakpo=
int registers in cpu_suspend)
Merging blackfin/for-linus (36855dcfc980 blackfin: fix build warning for un=
used variable)
Merging c6x/for-linux-next (546153d75a48 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (e269a869417c Drop code for CRISv10 CPU simulator)
Merging hexagon/linux-next (de44443a45e3 HEXAGON: Remove non existent refer=
ence to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (d52eefb47d4e ia64/xen: Remove Xen support for ia64)
Merging m68k/for-next (a0b7b242261c m68k/irq - Use polled IRQ flag for MFP =
timer cascaded interrupts)
Merging m68knommu/for-next (a695b9c8911e m68k : Kill CONFIG_MTD_PARTITIONS)
Merging metag/for-next (e9a1d0165bbd metag/smp: Make boot_secondary() stati=
c)
Merging microblaze/next (a23e64af1a9b microblaze: Simplify fcpu helper func=
tion)
Merging mips/mips-for-linux-next (e7fbcb6b0030 Merge branch 'mips-next-3.14=
' of git://git.linux-mips.org/pub/scm/john/linux-john into mips-for-linux-n=
ext)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (7d1c153ab373 Merge branch 'parisc-3.13' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux)
Merging powerpc/next (fac515db4520 Merge remote-tracking branch 'scott/next=
' into next)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (1c59a861d698 s390/qdio: bridgeport support - CHSC pa=
rt)
Merging sh/sh-latest (37284bd93103 Merge branches 'sh/hw-breakpoints' and '=
sh/serial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
$ git merge --abort
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (5e01dc7b26d9 Linux 3.12)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (9ed82c6866e2 xtensa: implement ndelay)
Merging btrfs/next (56817eda3c10 Btrfs: introduce the delayed inode ref del=
etion for the single link inode)
Merging ceph/master (8eb4efb091c8 ceph: implement readv/preadv for sync ope=
ration)
Merging cifs/for-next (a2e70b4d4e85 cifs: Fix memory leak in cifs_hardlink(=
))
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (4ea7772f828a udf: Fix lockdep warning from udf_symli=
nk())
Merging ext4/dev (27e25f8135e5 ext4: standardize error handling in ext4_da_=
write_inline_data_begin())
Merging f2fs/dev (3bac380c9012 f2fs: update documents and a MAINTAINERS ent=
ry)
Merging fscache/fscache (7c604e5d6e56 FS-Cache: Fix handling of an attempt =
to store a page that is now beyond EOF)
Merging fuse/for-next (ce128de6260f fuse: writepages: protect secondary req=
uests from fuse file release)
Merging gfs2/master (1e3d36206bd6 GFS2: Fix kbuild test robot reported warn=
ing)
Merging jfs/jfs-next (0439e091e3b1 jfs: fix xattr value size overflow in __=
jfs_setxattr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (a9ab5e840669 nfs: page cache invalidation for dio)
Merging nfsd/nfsd-next (3554116d3aae nfsd4: simplify xdr encoding of nfsv4 =
names)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (fb89b45cdfdc 9P: introduction of a new cache=3Dmmap =
model.)
Merging ubifs/linux-next (c23e9b75ccd0 UBIFS: remove invalid warn msg with =
tst_recovery enabled)
Merging xfs/for-next (bf3964c188d6 Merge branch 'xfs-extent-list-locking-fi=
xes' into for-next)
Merging vfs/for-next (27ac0ffeac80 locks: break delegations on any attribut=
e modification)
Merging pci/next (6e2d98dc1af4 Merge branch 'pci/reset' into next)
Merging hid/for-next (b18c2fbc3e1a Merge branch 'for-3.14/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (001cebf03f91 i2c-ismt: support I2C_SMBUS_I2C_BLOC=
K_DATA transaction type)
Merging jdelvare-hwmon/master (68d5516b35c7 hwmon: (it87) Print proper name=
s for the IT8771E and IT8772E)
Merging hwmon-staging/hwmon-next (d303b1b5fbb6 hwmon: (k10temp) Add support=
 for Kaveri CPUs)
Merging v4l-dvb/master (e26d710a8cdf Merge branch 'patchwork' into to_next)
CONFLICT (content): Merge conflict in drivers/staging/media/go7007/go7007-u=
sb.c
Merging kbuild/for-next (ddbfd0b07555 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (e752997672bc Merge branch 'for-3.14' into for-next)
CONFLICT (content): Merge conflict in drivers/ata/ahci.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/armada-370-xp.dtsi
Merging pm/linux-next (401ef25ce2f4 Merge branch 'pm-cpuidle')
Merging idle/next (4eda09c107d1 Merge branches 'turbostat' and 'bugzilla-60=
770-mwait-idle' into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (c698a4492f01 Merge branch 'misc' of .git into next)
CONFLICT (content): Merge conflict in drivers/cpufreq/Kconfig
Merging ieee1394/for-next (8bc588e0e585 firewire: ohci: Turn remote DMA sup=
port into a module parameter)
Merging dlm/next (ece35848c184 dlm: set zero linger time on sctp socket)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (7ae2c0ce15b0 Merge branch 'for-linus' into next)
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (42851e88a755 gianfar: Fix portabilty issues for et=
htool and ptp)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
CONFLICT (content): Merge conflict in arch/mips/bcm47xx/setup.c
Merging ipsec-next/master (ae237b3ede64 net: 3com: fix warning for incorrec=
t type in argument)
Merging wireless-next/master (608cfbe4abaf p54: clamp properly instead of j=
ust truncating)
Merging bluetooth/master (91eb476fb032 Bluetooth: Convert to use ATTRIBUTE_=
GROUPS macro)
Applying: net: 6lowpan: fixup for code movement
Merging infiniband/for-next (10e32f8f22ae Merge branch 'ip-roce' into for-n=
ext)
CONFLICT (content): Merge conflict in include/linux/mlx4/device.h
Merging mtd/master (802eee95bde7 Linux 3.13-rc6)
Merging l2-mtd/master (05f7835975da mtd: nand: don't use {read,write}_buf f=
or 8-bit transfers)
Merging crypto/master (79ba451d66ca crypto: aesni - fix build on x86 (32bit=
))
Merging drm/drm-next (c5416d661daa gpu: fix qxl missing crc32_le)
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-drm-core.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_stub.c
Merging drm-intel/for-linux-next (f1fcde49872f i915: send D1 opregion notif=
ication)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
Merging drm-tegra/drm/for-next (70bf6878a874 drm/panel: update EDID BLOB in=
 panel_simple_get_modes())
Merging sound/for-next (cdef2e5f358d sound: oss: remove last sleep_on users)
CONFLICT (content): Merge conflict in sound/soc/fsl/fsl_ssi.c
Merging sound-asoc/for-next (c66acefdf4c5 Merge remote-tracking branches 'a=
soc/topic/ad1836', 'asoc/topic/ad193x', 'asoc/topic/adav80x', 'asoc/topic/a=
dsp', 'asoc/topic/ak4641', 'asoc/topic/ak4642', 'asoc/topic/arizona', 'asoc=
/topic/atmel', 'asoc/topic/au1x', 'asoc/topic/bcm2835', 'asoc/topic/blackfi=
n', 'asoc/topic/cs4271', 'asoc/topic/cs42l52', 'asoc/topic/da7210', 'asoc/t=
opic/davinci', 'asoc/topic/docs', 'asoc/topic/ep93xx', 'asoc/topic/fsl', 'a=
soc/topic/fsl-mxs', 'asoc/topic/generic', 'asoc/topic/hdmi', 'asoc/topic/ja=
ck', 'asoc/topic/jz4740', 'asoc/topic/kirkwood', 'asoc/topic/max98090', 'as=
oc/topic/mc13783', 'asoc/topic/mxs', 'asoc/topic/nuc900', 'asoc/topic/omap'=
, 'asoc/topic/pxa', 'asoc/topic/rcar', 'asoc/topic/s6000', 'asoc/topic/sai'=
, 'asoc/topic/sgtl5000', 'asoc/topic/sh', 'asoc/topic/spear', 'asoc/topic/s=
sm2518', 'asoc/topic/ssm2602', 'asoc/topic/tegra', 'asoc/topic/tlv320aic3x'=
, 'asoc/topic/twl4030', 'asoc/topic/twl6040', 'asoc/topic/txx9', 'asoc/topi=
c/uda1380', 'asoc/topic/ux500', 'asoc/topic/width', 'asoc/topic/wm8510', 'a=
soc/topic/wm8523', 'asoc/topic/wm8580', 'asoc/topic/wm8711', 'asoc/topic/wm=
8728', 'asoc/topic/wm8731', 'asoc/topic/wm8741', 'asoc/topic/wm8750', 'asoc=
/topic/wm8753', 'asoc/topic/wm8776', 'asoc/topic/wm8804', 'asoc/topic/wm890=
0', 'asoc/topic/wm8901', 'asoc/topic/wm8940', 'asoc/topic/wm8962', 'asoc/to=
pic/wm8974', 'asoc/topic/wm8985', 'asoc/topic/wm8988', 'asoc/topic/wm8990',=
 'asoc/topic/wm8991', 'asoc/topic/wm8994', 'asoc/topic/wm8995', 'asoc/topic=
/wm9081' and 'asoc/topic/x86' into asoc-next)
CONFLICT (content): Merge conflict in sound/soc/fsl/fsl_ssi.c
Merging modules/modules-next (74e22fac8858 module.h: Remove unnecessary sem=
icolon)
CONFLICT (add/add): Merge conflict in Documentation/module-signing.txt
Merging virtio/virtio-next (7d2dddda5c92 virtio: pci: remove unnecessary pc=
i_set_drvdata())
Merging input/next (c3c4d99485ea Input: hyperv-keyboard - pass through 0xE1=
 prefix)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging cgroup/for-next (d0cb1a84439e Merge branch 'for-3.14' into for-next)
Merging block/for-next (454e2c4cbd66 Merge branch 'for-3.14/core' into for-=
next)
CONFLICT (content): Merge conflict in include/trace/events/f2fs.h
CONFLICT (content): Merge conflict in fs/f2fs/segment.c
CONFLICT (content): Merge conflict in fs/f2fs/data.c
CONFLICT (content): Merge conflict in fs/btrfs/extent_io.c
CONFLICT (content): Merge conflict in drivers/md/raid10.c
CONFLICT (content): Merge conflict in drivers/md/raid1.c
Merging device-mapper/for-next (2995fa78e423 dm sysfs: fix a module unload =
race)
CONFLICT (content): Merge conflict in drivers/md/dm-thin.c
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (85136b74dc7f mmc: dw_mmc: fix sparse non static symbo=
l warning)
CONFLICT (content): Merge conflict in MAINTAINERS
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
CONFLICT (content): Merge conflict in kernel/debug/debug_core.h
Merging slab/for-next (26e4f2057516 slub: Fix possible format string bug.)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (830778a180f2 md: ensure metadata is writen after raid =
level change.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (d6f06deb424e mfd: wm5110: Add register patch f=
or rev D chip)
Merging battery/master (26740dbb50f2 max17042_battery: Add IRQF_ONESHOT fla=
g to use default irq handler)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (07bda89b96e2 Merge branches '3.14/fbdev', '3.14=
/dss-misc' and '3.14/dss-fclk' into for-next)
Merging regulator/for-next (616f8a482a7c Merge remote-tracking branches 're=
gulator/topic/ab8500', 'regulator/topic/act8865', 'regulator/topic/anatop',=
 'regulator/topic/arizona', 'regulator/topic/as3722', 'regulator/topic/db85=
00', 'regulator/topic/gpio', 'regulator/topic/lp3971', 'regulator/topic/lp3=
972', 'regulator/topic/max14577', 'regulator/topic/max77693', 'regulator/to=
pic/mc13892', 'regulator/topic/pcf50633', 'regulator/topic/pfuze100', 'regu=
lator/topic/s2mps11', 'regulator/topic/s5m8767', 'regulator/topic/stw481x-v=
mmc', 'regulator/topic/tps51632', 'regulator/topic/tps62360', 'regulator/to=
pic/tps65910', 'regulator/topic/twl' and 'regulator/topic/wm831x' into regu=
lator-next)
Merging security/next (923b49ff69fc Merge branch 'master' of git://git.infr=
adead.org/users/pcmoore/selinux into next)
CONFLICT (content): Merge conflict in drivers/char/tpm/tpm_ppi.c
Merging selinux/master (8ed814602876 SELinux: Fix memory leak upon loading =
policy)
Merging lblnet/master (07bc9dc1b01b Merge branch 'merge' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (d63182e8c021 watchdog: mpc8xxx_wdt convert to watc=
hdog core)
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (dd1a175695ed Merge branches 'arm/smmu', 'core', 'x86/vt=
-d', 'arm/shmobile', 'x86/amd', 'ppc/pamu', 'iommu/fixes' and 'arm/msm' int=
o next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/msm/Kconfig
Merging vfio/next (3be3a074cf5b vfio-pci: Don't use device_lock around AER =
interrupt setup)
Merging osd/linux-next (ec15cd5a0b73 exofs: Print less in r4w)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (9c8f6820f0d7 doc: Fix typo in USB Gadget Document=
ation)
CONFLICT (content): Merge conflict in drivers/gpu/drm/qxl/Kconfig
Merging audit/master (06bdadd76345 audit: correct a type mismatch in audit_=
syscall_exit())
CONFLICT (content): Merge conflict in include/net/xfrm.h
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (355e62f5ad12 of/irq: Fix potential buff=
er overflow)
Merging dt-rh/for-next (1ca56e7dcadd of: irq: Ignore disabled intc's when s=
earching map)
Merging spi/for-next (d6fa5d7c08a8 Merge remote-tracking branches 'spi/topi=
c/altera', 'spi/topic/ath79', 'spi/topic/atmel', 'spi/topic/bcm2835', 'spi/=
topic/bcm63xx', 'spi/topic/bcm63xx-hsspi', 'spi/topic/bitbang', 'spi/topic/=
clps711x', 'spi/topic/coldfire', 'spi/topic/davinci', 'spi/topic/dw', 'spi/=
topic/falcon', 'spi/topic/fsl-espi', 'spi/topic/gpio', 'spi/topic/hspi', 's=
pi/topic/mpc512x', 'spi/topic/msiof', 'spi/topic/nuc900', 'spi/topic/oc-tin=
y', 'spi/topic/omap', 'spi/topic/orion', 'spi/topic/pci', 'spi/topic/qspi',=
 'spi/topic/rspi', 'spi/topic/s3c24xx', 'spi/topic/s3c64xx', 'spi/topic/sc1=
8is602', 'spi/topic/sh', 'spi/topic/tegra114', 'spi/topic/tegra20-sflash', =
'spi/topic/tegra20-slink', 'spi/topic/txx9' and 'spi/topic/xcomm' into spi-=
next)
CONFLICT (content): Merge conflict in drivers/spi/spi-mpc512x-psc.c
Merging tip/auto-latest (8723822a0fdf Merge branch 'x86/x32')
CONFLICT (content): Merge conflict in drivers/acpi/processor_idle.c
CONFLICT (content): Merge conflict in drivers/acpi/apei/einj.c
CONFLICT (content): Merge conflict in drivers/acpi/acpi_extlog.c
CONFLICT (content): Merge conflict in arch/xtensa/include/asm/barrier.h
CONFLICT (content): Merge conflict in arch/mips/netlogic/xlp/setup.c
CONFLICT (content): Merge conflict in arch/mips/Kconfig
[master 4673f2b89de4] Revert "x86 idle: restore mwait_idle()"
Merging clockevents/clockevents/next (36489c2b3e5b clocksource: arch_timer:=
 Set dynamic irq affinity on mmio clockevent)
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (881f0fcef999 EDAC: Don't try to cancel workqueue=
 when it's never setup)
Merging ftrace/for-next (a4c35ed24112 ftrace: Fix synchronization location =
disabling and freeing ftrace_ops)
Merging rcu/rcu/next (98cbc61863d3 Merge commit '0d3c55bc9fd58393bd3bd99749=
91ec1f815e1326' into HEAD)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (26a865f4aa8e KVM: VMX: fix use after free of vmx->l=
oaded_vmcs)
$ git reset --hard HEAD^
Merging next-20140109 version of kvm
Merging kvm-arm/kvm-arm-next (61466710de07 KVM: ARM: Remove duplicate inclu=
de)
Merging kvm-ppc/kvm-ppc-next (27025a602cb9 powerpc: kvm: optimize "sc 1" as=
 fast return)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (54d44eb3c7f6 xen/pvh: Use 'depend' instead of '=
select'.)
CONFLICT (content): Merge conflict in arch/arm/include/asm/xen/page.h
Merging percpu/for-next (3e7da78e081e percpu: use VMALLOC_TOTAL instead of =
VMALLOC_END - VMALLOC_START)
Merging workqueues/for-next (9af16df84f0c Merge branch 'for-3.14' into for-=
next)
CONFLICT (content): Merge conflict in kernel/workqueue.c
Merging drivers-x86/linux-next (a80e1053aaa3 x86, wmi fix modalias_show ret=
urn values)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (86776fc17497 Merge remote-tracking branch 'regmap/=
topic/ack' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (44f17fa9218b leds: s3c24xx: Remove hardware.h inclus=
ion)
Merging driver-core/driver-core-next (bb305947bdbb kernfs: fix get_active f=
ailure handling in kernfs_seq_*())
Merging tty/tty-next (8bc661bfc0c2 tty/serial: at91: disable uart timer at =
start of shutdown)
Merging usb/usb-next (2fc5a7dace3c usb: chipidea: udc: using MultO at TD as=
 real mult value for ISO-TX)
Merging usb-gadget/next (836a2164491b usb: phy: keystone: remove redundant =
return value check of platform_get_resource())
Merging staging/staging-next (aa3bee0daa38 lustre: delete linux/lustre_debu=
g.h)
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-drm-core.c
Merging char-misc/char-misc-next (6adb8efb024a mei: limit the number of con=
secutive resets)
Merging scsi/for-next (81286dea29d1 Merge branch 'fixes' into for-next)
Merging target-updates/for-next (b2ec6d36d271 IB/isert: pass scatterlist in=
stead of cmd to fast_reg_mr routine)
CONFLICT (content): Merge conflict in drivers/target/target_core_tpg.c
Merging target-merge/for-next-merge (374b105797c3 Linux 3.13-rc3)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (f8720e5ec752 pinctrl: as3722: Set pin to output m=
ode for some function)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (785acec3eecf ARM: S5P[v210|c100|64x0]: Fix build err=
or)
CONFLICT (content): Merge conflict in drivers/leds/leds-s3c24xx.c
CONFLICT (content): Merge conflict in arch/xtensa/Kconfig
Merging dma-mapping/dma-mapping-next (5e01dc7b26d9 Linux 3.12)
Merging pwm/for-next (82569e5b2236 pwm: tiehrpwm: use dev_err() instead of =
pr_err())
Merging dma-buf/for-next (17b2112f332d Merge branch 'merge' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging userns/for-next (41301ae78a99 vfs: Fix a regression in mounting pro=
c)
Merging ktest/for-next (c75d22d9c675 ktest: Add eval '=3D~' command to modi=
fy variables in config file)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (119754e57609 Merge branch 'clk-next-shmobile' into cl=
k-next)
CONFLICT (content): Merge conflict in drivers/clk/samsung/clk-exynos4.c
CONFLICT (content): Merge conflict in MAINTAINERS
Merging random/dev (a9f069e38cc3 random: use the architectural HWRNG for th=
e SHA's IV in extract_buf())
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (8e321fefb0e6 aio/migratepages: make aio migrate pages s=
ane)
Merging akpm-current/current (0fc6f4e2e3d5 splice: fix unexpected size trun=
cation)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: kernel/kexec.c: use vscnprintf() instead of vsnprintf() in vmcore=
info_append_str()
Applying: softirq: use ffs() in __do_softirq()
Applying: softirq: convert printks to pr_<level>
Applying: softirq: use const char * const for softirq_to_name, whitespace n=
eatening
Applying: mm/migrate.c: fix setting of cpupid on page migration twice again=
st normal page
Applying: zsmalloc: move it under mm
Applying: zram: promote zram from staging
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: drivers/video/backlight/lcd.c: call put_device if device_register=
 fails
Applying: drivers/net/phy/mdio_bus.c: call put_device on device_register() =
failure
Applying: checkpatch.pl: check for function declarations without arguments
Applying: zram: remove old private project comment
Applying: zram: add copyright
Applying: zsmalloc: add copyright
Applying: zram: add zram maintainers
Applying: zsmalloc: add maintainers
Applying: block/blk-mq-cpu.c: use hotcpu_notifier()
Applying: kernel: use lockless list for smp_call_function_single
Applying: kernel/smp.c: remove cpumask_ipi
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: zram: fix race between reset and flushing pending work
Applying: zram: delay pending free request in read path
Applying: zram: remove unnecessary free
Applying: zram: use atomic operation for stat
Applying: zram: introduce zram->tb_lock
Applying: zram: remove workqueue for freeing removed pending slot
Applying: zram: remove zram->lock in read path and change it with mutex
Applying: mm: add strictlimit knob
Merging akpm/master (7f8c1e382d68 mm: add strictlimit knob)

--Signature=_Thu__16_Jan_2014_17_56_20_+1100_xR.gaaDZ6b/1fi8t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS14KZAAoJEMDTa8Ir7ZwVIr8P/jwsukUpo3Gk7UiSEA1X8QeR
/pQ9SU8HNUVeP5Zy+yCb77AKbOafwU0gbB4n6GcRf3O3Sa9TfM0FgO2E/z/AolgE
NhCIwV/oFEmc5XlN5PFd+6R8vurnDFxzOGikXYnmVj+2YargWnGVjr/L2PQ552j2
7EE3B52bphMOYj42faN+kNtoGmhC7YM+uwkcPN33GTfHJSL4LYHkFRBn8fxGG8Kd
/ESy+3OHDYaAFaorQ34keikDlE0eDnwjRPTEJx0xWeWPyj1PrUwgPW16V2nI7SXN
+K8L5kT174BXG5fFXXDW5PUlnn5YyObRsvPqIsruqPAadJPYTY7P+6r8QQTx8x1Y
dXR2pGRL4kkWI9d+I60G7EkIck4gPEsHRmFzx5xbe07fNu4XOeUbnFahcVpWDeMO
kyB38FbPLj3MmHe/6ioG4Y1CZSgb7k7znOV9AHMd5PQuRSiyNxap//ZoMiKFVlnc
vQMvAQFDYE7pSoXkVIo1Bbpgntd6uZWu8A9EHjjsH7Ht+/APjSlTuiPoskR5FTOl
g0n1xW09X2SnVgTuY0Q9LzWBkbDP7CcdV9clfIGJMZx0noBKm0Ld+lIy4QU/cQ66
LGv239qdIdvW9fo8GKh3n1FnQ4iCqpaqnYNiVsTwkrgUA5p6t7Pe5lwwbZMHONM2
CI6vMyRqK6l2Rd6UGxqe
=ZJDf
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Jan_2014_17_56_20_+1100_xR.gaaDZ6b/1fi8t--
