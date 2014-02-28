Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaB1GrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:47:11 -0500
Received: from ozlabs.org ([203.10.76.45]:38897 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaB1GrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:47:06 -0500
Date: Fri, 28 Feb 2014 17:46:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 28
Message-Id: <20140228174658.1e8a323c07f47496279dc19b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Feb_2014_17_46_58_+1100_5xycrBL.+8OudW6g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Feb_2014_17_46_58_+1100_5xycrBL.+8OudW6g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree fails (more than usual) the powerpc allyesconfig build.

Changes since 20140227:

The powerpc tree still had its build failure.

The mfd-lj tree still had its build failure so I used the version from
next-20140210.

The drm-tegra tree lost its build failure.

The wireless-next tree still had its build failure so I used the version
from next-20140224.

I added another supplied patches to the akpm-current tree to address its
build failure.

Non-merge commits (relative to Linus' tree): 5052
 4920 files changed, 190674 insertions(+), 104499 deletions(-)

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

I am currently merging 210 trees (counting Linus' and 28 trees of patches
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
Merging origin/master (86c7654f4a0a Merge tag 'metag-fixes-v3.14' of git://=
git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag)
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (7e22e91102c6 Linux 3.13-rc8)
Merging arm-current/fixes (b36345759308 ARM: 7980/1: kernel: improve error =
message when LPAE config doesn't match CPU)
Merging m68k-current/for-linus (7247f55381d5 m68k: Wire up sched_setattr an=
d sched_getattr)
Merging metag-fixes/fixes (f229006ec6be irq-metag*: stop set_affinity vecto=
ring to offline cpus)
Merging powerpc-merge/merge (66f9af83e56b powerpc/eeh: Disable EEH on reboo=
t)
Merging sparc/master (10527106abec Merge tag 'dt-for-linus' of git://git.se=
cretlab.ca/git/linux)
Merging net/master (352063c839ba Merge branch 'for-davem' of git://git.kern=
el.org/pub/scm/linux/kernel/git/linville/wireless)
Merging ipsec/master (3a9016f97fdc xfrm: Fix unlink race when policies are =
deleted.)
Merging sound-current/for-linus (997e7547ab53 Merge tag 'asoc-v3.14-rc4-2' =
of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-lin=
us)
Merging pci-current/for-linus (fc40363b2140 ahci: Fix broken fallback to si=
ngle MSI mode)
Merging wireless/master (b7b146c9c9a0 ath9k: fix invalid descriptor discard=
ing)
Merging driver-core.current/driver-core-linus (fed95bab8d29 sysfs: fix name=
space refcnt leak)
Merging tty.current/tty-linus (cfbf8d4857c2 Linux 3.14-rc4)
Merging usb.current/usb-linus (a1227f3c1030 usb: ehci: fix deadlock when th=
readirqs option is used)
Merging staging.current/staging-linus (260ea9c2e2d3 staging: r8188eu: Add n=
ew device ID)
Merging char-misc.current/char-misc-linus (58e868be77bd Merge 3.14-rc4 into=
 char-misc-linus)
Merging input-current/for-linus (70b0052425ff Input: da9052_onkey - use cor=
rect register bit for key status)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (ee97dc7db4cb crypto: s390 - fix des and des3=
_ede ctr concurrency issue)
Merging ide/master (738b52bb9845 Merge tag 'microblaze-3.14-rc3' of git://g=
it.monstr.eu/linux-2.6-microblaze)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (1f42e5dd5065 of: Add self test=
 for of_match_node())
Merging rr-fixes/fixes (7122c3e9154b scripts/link-vmlinux.sh: only filter k=
ernel symbols for arm)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (2e4a42e348f4 drm/i915: Resolv=
ing the memory region conflict for Stolen area)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (67a2635aa64a ARC: [clockevent] simplify timer ISR)
Merging arm/for-next (93c95d4353c6 Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (8e781f65423c ARM: perf: add support for the=
 Cortex-A12 PMU)
Merging arm-soc/for-next (56ac6184e6b4 Merge branch 'next/boards' into for-=
next)
Merging bcm2835/for-next (8ac06bb693ca Merge branch 'for-3.15/dt' into for-=
next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (df5ec17e8ab9 Merge branch 'imx/soc' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (5c0426dcd386 Merge branch 'for_3.15/dts_2' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (98d20a74bd4f Merge branch 'mvebu/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/ven=
dor-prefixes.txt
Merging renesas/next (3952e65ec9ed Merge branches 'heads/cleanup-for-v3.15'=
, 'heads/defconfig-for-v3.15', 'heads/intc-for-v3.15', 'heads/soc-for-v3.15=
', 'heads/clock-for-v3.15', 'heads/boards-for-v3.15' and 'heads/dt-for-v3.1=
5' into next)
Merging samsung/for-next (941e7012a3b9 Merge branch 'v3.15-next/clk-s3c24xx=
' into for-next)
Merging tegra/for-next (7bed533771d7 Merge branch for-3.15/defconfig into f=
or-next)
Merging arm64/for-next/core (38dbfb59d117 Linus 3.14-rc1)
Merging blackfin/for-linus (58095fdaaf1c From: Eunbong Song <eunb.song@sams=
ung.com>)
Merging c6x/for-linux-next (546153d75a48 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (44eb66c228fe Hexagon: update CR year for elf.h)
Merging ia64/next (d52eefb47d4e ia64/xen: Remove Xen support for ia64)
Merging m68k/for-next (7247f55381d5 m68k: Wire up sched_setattr and sched_g=
etattr)
Merging m68knommu/for-next (72a8ab3cb2a5 m68knommu: fix arg types for outs*=
 functions)
Merging metag/for-next (e9a1d0165bbd metag/smp: Make boot_secondary() stati=
c)
Merging microblaze/next (1cbe158dec8c microblaze: Drop architecture-specifi=
c declaration of early_printk)
Merging mips/mips-for-linux-next (7d3f1a59e7e5 Merge branch '3.14-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging powerpc/next (f878f84373ae powerpc: Wire up sched_setattr and sched=
_getattr syscalls)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (d72d2bb5a6bc s390/checksum: remove memset() within c=
sum_partial_copy_from_user())
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (5e01dc7b26d9 Linux 3.12)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (b3fdfc1b4b64 Merge tag 'xtensa-for-next-20140221-1=
' into for_next)
Merging btrfs/next (cf93da7bcf45 Btrfs: fix spin_unlock in check_ref_cleanu=
p)
Merging ceph/master (bee26897097f libceph: a per-osdc crush scratch buffer)
Merging cifs/for-next (bfa85c96429d cifs: mask off top byte in get_rfc1002_=
length())
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (ff57cd5863cf fsnotify: Allocate overflow events with=
 proper type)
Merging ext4/dev (442ed22745a0 ext4: merge uninitialized extents)
Merging f2fs/dev (695fd1ed3bca f2fs: use existing macro to clean up some co=
des)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (b2ec2778df9d fuse: Turn writeback cache on)
Merging gfs2/master (fcf10d38afd2 GFS2: replace kmalloc - __vmalloc / memse=
t 0)
Merging jfs/jfs-next (844fa1b5f849 jfs: set i_ctime when setting ACL)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (146d70caaa1b NFS fix error return in nfs4_select_rw=
_stateid)
Merging nfsd/nfsd-next (1406b916f4a2 nfsd: fix lost nfserrno() call in nfsd=
_setattr())
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging ubifs/linux-next (5547fec74a56 UBI: fix some use after free bugs)
Merging xfs/for-next (14e637ca53fa Merge branch 'xfs-verifier-cleanup' into=
 for-next)
Merging file-private-locks/linux-next (1ed1950c412f locks: add new fcntl cm=
d values for handling file private locks)
Merging vfs/for-next (527d1511310a Merge branch 'next' of git://git.kernel.=
org/pub/scm/linux/kernel/git/benh/powerpc)
Merging pci/next (2c0503f202f5 Merge branches 'pci/host-designware', 'pci/h=
ost-imx6' and 'pci/host-rcar' into next)
CONFLICT (content): Merge conflict in drivers/ata/ahci.c
Merging hid/for-next (afbe1c7e1a53 Merge branch 'for-3.15/sony' into for-ne=
xt)
CONFLICT (content): Merge conflict in drivers/hid/i2c-hid/i2c-hid.c
CONFLICT (content): Merge conflict in drivers/hid/hid-ids.h
CONFLICT (content): Merge conflict in drivers/hid/hid-core.c
Merging i2c/i2c/for-next (e89364556824 i2c: rcar: add compatible entry for =
r8a7791)
Merging jdelvare-hwmon/master (c1d70b646dae hwmon: (lm90) Convert to use hw=
mon_device_register_with_groups)
Merging hwmon-staging/hwmon-next (10056e55982a hwmon: (max6639) Convert to =
use devm_hwmon_device_register_with_groups)
Merging v4l-dvb/master (b215621049bd Merge branch 'v4l_for_linus' into to_n=
ext)
Merging kbuild/for-next (ff6b9bdb6263 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (2932b40efa4d Merge branch 'for-3.15' into for-next)
Merging pm/linux-next (c208b7bbf7df Merge branch 'acpi-processor' into linu=
x-next)
Merging idle/next (62eec04c7fa3 Merge branch 'turbostat' into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (6d0abeca3242 Linux 3.14-rc3)
Merging ieee1394/for-next (fcd46b34425d firewire: Enable remote DMA above 4=
 GB)
Merging dlm/next (075f01775f53 dlm: use INFO for recovery messages)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (3c79200df630 Merge branch 'fixes' into next)
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (bc861959103c ipv6: addrconf: silence sparse endian=
ness warnings)
CONFLICT (content): Merge conflict in net/ipv6/sit.c
CONFLICT (content): Merge conflict in drivers/net/wireless/mwifiex/pcie.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath9k/recv.c
Merging ipsec-next/master (895de9a3488a vti4: Enable namespace changing)
Merging wireless-next/master (ef1b4141d043 ath5k: set SURVEY_INFO_IN_USE on=
 get_survey)
$ git reset --hard HEAD^
Merging next-20140224 version of wireless-next
Merging bluetooth/master (a1f4c3188bb4 Bluetooth: Add hci_copy_identity_add=
ress convenience function)
Merging infiniband/for-next (7f3c1e1ba82e Merge branches 'cma', 'cxgb4', 'i=
ser', 'misc', 'mlx4', 'mlx5', 'nes', 'ocrdma', 'qib' and 'usnic' into for-n=
ext)
Merging mtd/master (bb38eefb6858 mtd: nand: omap: fix ecclayout->oobfree->l=
ength)
Merging l2-mtd/master (b9d3ea0eccce jffs2: Fix crash due to truncation of c=
size)
Merging crypto/master (c65a52f8360d crypto: ccp - Account for CCP backlog p=
rocessing)
Merging drm/drm-next (4d538b791979 Merge branch 'drm-next-3.15' of git://pe=
ople.freedesktop.org/~deathsimple/linux into drm-next)
Merging drm-intel/for-linux-next (4c0e55288211 drm/i915: fix NULL deref in =
the load detect code)
Merging drm-tegra/drm/for-next (c1a68b4c29b8 drm/tegra: Add eDP support)
Merging sound/for-next (6776a5d712a1 ALSA: Move EXPORT_SYMBOL() in appropri=
ate places)
Merging sound-asoc/for-next (8efb5638ca59 Merge remote-tracking branches 'a=
soc/topic/wm8988', 'asoc/topic/wm8990', 'asoc/topic/wm8991', 'asoc/topic/wm=
8993', 'asoc/topic/wm8994', 'asoc/topic/wm8995', 'asoc/topic/wm8996', 'asoc=
/topic/wm9081' and 'asoc/topic/wm9705' into asoc-next)
CONFLICT (content): Merge conflict in sound/soc/kirkwood/Kconfig
Merging modules/modules-next (917307b09ad5 module: remove MODULE_GENERIC_TA=
BLE)
Merging virtio/virtio-next (6f0317058f43 tools/virtio: add a missing ))
Merging input/next (7fb45edba8b5 Input: imx_keypad - Propagate the real err=
or code on platform_get_irq() failure)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (a9f4f164c036 Merge branch 'for-3.15/drivers' into f=
or-next)
Merging device-mapper/for-next (7d48935eff40 dm thin: allow metadata space =
larger than supported to go unused)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (d9c3f5df539a dts: socfpga: Add support for SD/MMC on =
the SOCFPGA platform)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (26e4f2057516 slub: Fix possible format string bug.)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (789b5e031528 md/raid5: Fix CPU hotplug callback regist=
ration)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (88a31c8daa3f mfd: twl6040: Check for error whe=
n reading revision register)
$ git reset --hard HEAD^
Merging next-20140210 version of mfd-lj
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (c4a41bcc1726 video: xilinxfb: Move xilinxfb_pla=
tform_data directly to the driver)
Merging regulator/for-next (d6d04b0d5d4e Merge remote-tracking branches 're=
gulator/topic/tps65218', 'regulator/topic/tps6524x', 'regulator/topic/tps65=
86x', 'regulator/topic/tps65910', 'regulator/topic/tps80031', 'regulator/to=
pic/wm831x', 'regulator/topic/wm8350' and 'regulator/topic/wm8994' into reg=
ulator-next)
Merging security/next (f5645d3575fe capability: Use current logging styles)
Merging selinux/next (81c94e76ce8e selinux: fix the output of ./scripts/get=
_maintainer.pl for SELinux)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (3b8b0d45f703 watchdog: xilinx: Remove no_timeout v=
ariable)
CONFLICT (content): Merge conflict in drivers/watchdog/orion_wdt.c
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (972157cac528 arm/smmu: Use irqsafe spinlock for domain =
lock)
Merging vfio/next (3be3a074cf5b vfio-pci: Don't use device_lock around AER =
interrupt setup)
Merging osd/linux-next (19350e7627a6 exofs: Print less in r4w)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (80dd6eac0090 net-sysfs: fix comment typo 'CONFIG_=
SYFS')
Merging audit/master (f3411cb2b2e3 audit: whitespace fix in kernel-paramete=
rs.txt)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (f4d4ffc03efc kbuild: dtbs_install: new =
make target)
CONFLICT (content): Merge conflict in drivers/of/of_net.c
Merging dt-rh/for-next (06b29e76a74b of: search the best compatible match f=
irst in __of_match_node())
Merging spi/for-next (db5e2d47377c Merge remote-tracking branches 'spi/topi=
c/txx9', 'spi/topic/xfer' and 'spi/topic/xilinx' into spi-next)
Merging tip/auto-latest (63027486e987 Merge branch 'x86/x32')
Merging clockevents/clockevents/next (00e2bcd6d35f clocksource: Timer-sun5i=
: Switch to sched_clock_register())
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (c045ebdf6079 Merge branch 'edac-for-3.15' into f=
or-next)
Merging ftrace/for-next (1fcc155351f1 ftrace: Have static function trace cl=
ear ENABLED flag on unregister)
Merging rcu/rcu/next (ef31d5033101 Merge branch 'timers.2014.02.25a' into H=
EAD)
CONFLICT (content): Merge conflict in kernel/rcu/rcutorture.c
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (d3714010c307 KVM: x86: emulator_cmpxchg_emulated sh=
ould mark_page_dirty)
Merging kvm-arm/kvm-arm-next (b73117c49364 Merge branch 'kvm-ppc-next' of g=
it://github.com/agraf/linux-2.6 into kvm-queue)
Merging kvm-ppc/kvm-ppc-next (b73117c49364 Merge branch 'kvm-ppc-next' of g=
it://github.com/agraf/linux-2.6 into kvm-queue)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (d8491c62480a Revert "x86/xen: allow privcmd hyp=
ercalls to be preempted")
Merging percpu/for-next (d5f2deed588b Merge branch 'for-3.14' into for-next)
Merging workqueues/for-next (379e899a2c66 Merge branch 'for-3.15' into for-=
next)
Merging drivers-x86/linux-next (b4b0b4a9e039 ipc: add intel-mid's pci id ma=
cros)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (036812ec0c8e Merge remote-tracking branches 'regma=
p/topic/irq', 'regmap/topic/nodev' and 'regmap/topic/patch' into regmap-nex=
t)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (cbaa93d5228b leds: blinkm: remove unnecessary spaces)
Merging driver-core/driver-core-next (6d8b3e1ad3d3 kernfs: remove duplicate=
 dir.c at the top dir)
Merging tty/tty-next (8301bb240d0f Merge 3.14-rc4 into tty-next)
Merging usb/usb-next (f080a51bef2c USB: complain if userspace resets an act=
ive endpoint)
Merging usb-gadget/next (bb0202d1a5a2 usb: dwc3: gadget: always enable IOC =
on bulk/interrupt transfers)
Merging staging/staging-next (a1ccf4f865a4 Staging : rts5208: Fix code inde=
nt issue)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53-qsb.dts
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53-mba53.dts
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx51-babbage.dts
Applying: ARM: dts: i.MX53: merge fix patch
Merging char-misc/char-misc-next (90eedf0cbe4b vmbus: use resource for hype=
rv mmio region)
Applying: mei: txe: include irqreturn.h for irqreturn_t etc
Merging cgroup/for-next (fa70f8d6fc5c Merge branch 'for-3.14-fixes' into fo=
r-next)
CONFLICT (content): Merge conflict in mm/memcontrol.c
Applying: cgroup: fix up for kernfs_mount API change
Merging scsi/for-next (960dfc4eb23a Merge branch 'drm-fixes' of git://peopl=
e.freedesktop.org/~airlied/linux)
Merging target-updates/for-next (9af6de4a22c5 target: silence GCC warning i=
n target_alua_state_check)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (02b947a79bd9 Merge branch 'devel' into for-next)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (41c761a0c892 Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (cfbf8d4857c2 Linux 3.14-rc4)
Merging pwm/for-next (8468949cddcd pwm: pxa: Use of_match_ptr())
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging dma-buf/for-next (c0b00a525c12 dma-buf: update debugfs output)
Merging userns/for-next (f58437f1f916 MIPS: VPE: Remove vpe_getuid and vpe_=
getgid)
Merging ktest/for-next (62183dcac539 ktest: Set CLOSE_CONSOLE_SIGNAL in the=
 kvm.conf)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (5ba8dac012c3 Merge branch 'clk-fixes' into clk-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/keystone-clocks.dtsi
Merging random/dev (a9f069e38cc3 random: use the architectural HWRNG for th=
e SHA's IV in extract_buf())
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (168a3eb76a7f aio, memory-hotplug: Fix confliction when =
migrating and accessing ring pages.)
Merging llvmlinux/for-next (f557840d8992 x86, acpi: LLVMLinux: Remove neste=
d functions from Thinkpad ACPI)
Merging akpm-current/current (9ace8e1e408f ipc: use device_initcall)
CONFLICT (content): Merge conflict in mm/memory.c
CONFLICT (content): Merge conflict in mm/memcontrol.c
CONFLICT (content): Merge conflict in fs/notify/fanotify/fanotify_user.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Kconfig
Applying: ppc: Make PPC_BOOK3S_64 select IRQ_WORK
Applying: ia64: select CONFIG_TTY for use of tty_write_message in unaligned
Applying: s390: select CONFIG_TTY for use of tty in unconditional keyboard =
driver
Applying: cris: Make ETRAX_ARCH_V10 select TTY for use in debugport
$ git checkout -b akpm remotes/origin/akpm/master
Applying: kernel: use macros from compiler.h instead of __attribute__((...))
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: mm: add strictlimit knob
Merging akpm/master (8fa5e75ac231 mm: add strictlimit knob)

--Signature=_Fri__28_Feb_2014_17_46_58_+1100_5xycrBL.+8OudW6g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTEDDnAAoJEMDTa8Ir7ZwV5m0QAICVe2kCzCfcKU8zve31dFkF
wGjBvTQ8N9/dO3qHIGSfMYDHaDSlOYuzPjol0XyYYszyAcFTc9/klg9PcFY4EZf2
JMlXQrY28ZJ/IEGrmla32t9czKrSlbz26KxayUpb6Dx61TaAPGXm5LTq/919lRbZ
zt9hRygc188cEAy5I745bkZERh3+XLmUxz0i0Gt2mvZhCn0fU0c93cEwJOpyCkv5
pgFwoPSy22698MFEwQtW8lWHnF3j9mTpjDLfMTPrjUVROQnKDzrXFHoMVRsZnep8
ICjgdjyYFIsYN93AheseAa34c/cmcq5VbNor5gwgyMAs6dtqw2fyBI+EumFi2chM
mBtktSHzCsWWv9LW7TbjiCWidjcF2dwaD7YfbAeMcad8oPGsX/FVo7Zd6CRmhews
hw7wmQ4G5HwF/zNjDf1Mwi+tuF4FkGgOVc46Yz4PMSfHsnVn5iYQJ9KWXioLkGmY
Yzy8VYCDxV13RoRyasjAgcPLa2enT/JVPWpwGDH0hoSlkEwJK9iyIfnUiXu9Wr1U
5GEhzU/U9JObQfLQe3G5NLqk63+3W43kDjywFQp9kW7gcr5YIaDxquyJgSIf4fi+
EwQ4Gd28xv8rqQEBn+dV6tKTM45+eXXTSck4a6cM44iI29bVK8ZacrLGrIjQBzyv
pzEHq8+UFq5cghgr2Nvk
=1uuO
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Feb_2014_17_46_58_+1100_5xycrBL.+8OudW6g--
