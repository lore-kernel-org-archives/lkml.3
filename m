Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaCCJHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:07:40 -0500
Received: from ozlabs.org ([203.10.76.45]:37188 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbaCCJH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:07:29 -0500
Date: Mon, 3 Mar 2014 20:07:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Mar 3
Message-Id: <20140303200722.a76a4ee80153cd4912b5243f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_20_07_22_+1100_RZGKMHxzy2vGX8Os"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_20_07_22_+1100_RZGKMHxzy2vGX8Os
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree fails (more than usual) the powerpc allyesconfig build.

Changes since 20140228:

The bcm2835 tree gained a conflict against the arm-soc tree.

The imx-mxs tree gained a conflict against the arm-soc tree.

The powerpc tree still had its build failure.

The mfd-lj tree still had its build failure so I used the version from
next-20140210.

The wireless-next tree still had its build failure so I used the version
from next-20140224.

The watchdog tree gained a conflict against the arm-soc tree.

The tip tree gained conflicts against the pci tree.

The usb tree gained a conflict against the arm-soc tree.

The char-misc tree gained 2 build failures for which I reverted 2 commits.

The akpm-current tree gained conflicts against the arm-soc tree.
I added another supplied patch to the akpm-current tree to address its
build failure.

Non-merge commits (relative to Linus' tree): 5359
 5190 files changed, 204838 insertions(+), 129459 deletions(-)

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
Merging origin/master (c59224d1326e Merge branch 'drm-fixes' of git://peopl=
e.freedesktop.org/~airlied/linux)
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
Merging powerpc-merge/merge (e0cf95761497 powerpc/powernv: Fix indirect XSC=
OM unmangling)
Merging sparc/master (10527106abec Merge tag 'dt-for-linus' of git://git.se=
cretlab.ca/git/linux)
Merging net/master (1d3f41ea0e95 b44: always set duplex mode why phy change=
s)
Merging ipsec/master (3a9016f97fdc xfrm: Fix unlink race when policies are =
deleted.)
Merging sound-current/for-linus (997e7547ab53 Merge tag 'asoc-v3.14-rc4-2' =
of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-lin=
us)
Merging pci-current/for-linus (fc40363b2140 ahci: Fix broken fallback to si=
ngle MSI mode)
Merging wireless/master (adb07df1e039 mwifiex: do not advertise usb autosus=
pend support)
Merging driver-core.current/driver-core-linus (fed95bab8d29 sysfs: fix name=
space refcnt leak)
Merging tty.current/tty-linus (cfbf8d4857c2 Linux 3.14-rc4)
Merging usb.current/usb-linus (a1227f3c1030 usb: ehci: fix deadlock when th=
readirqs option is used)
Merging staging.current/staging-linus (9f4a9b83f135 Merge iio fixes into st=
aging-linus)
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
Merging drm-intel-fixes/for-linux-next-fixes (e20ec540c779 drm/i915: fix as=
sert_cursor on BDW)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (67a2635aa64a ARC: [clockevent] simplify timer ISR)
Merging arm/for-next (93c95d4353c6 Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (8e781f65423c ARM: perf: add support for the=
 Cortex-A12 PMU)
Merging arm-soc/for-next (403172d8553f arm-soc: select CLKSRC_OF as an inte=
rmediate fixup)
Merging bcm2835/for-next (8ac06bb693ca Merge branch 'for-3.15/dt' into for-=
next)
CONFLICT (modify/delete): arch/arm/mach-bcm2835/Kconfig deleted in bcm2835/=
for-next and modified in HEAD. Version HEAD of arch/arm/mach-bcm2835/Kconfi=
g left in tree.
Applying: ARM: bcm2835: merge fix for movement to mach-bcm directory
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (df5ec17e8ab9 Merge branch 'imx/soc' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-imx/Kconfig
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (5c0426dcd386 Merge branch 'for_3.15/dts_2' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (79e8e9df3918 Merge branch 'mvebu/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/ven=
dor-prefixes.txt
Merging renesas/next (3952e65ec9ed Merge branches 'heads/cleanup-for-v3.15'=
, 'heads/defconfig-for-v3.15', 'heads/intc-for-v3.15', 'heads/soc-for-v3.15=
', 'heads/clock-for-v3.15', 'heads/boards-for-v3.15' and 'heads/dt-for-v3.1=
5' into next)
Merging samsung/for-next (941e7012a3b9 Merge branch 'v3.15-next/clk-s3c24xx=
' into for-next)
Merging tegra/for-next (04aa4c87bfb8 Merge branch for-3.15/defconfig into f=
or-next)
Merging arm64/for-next/core (addea9ef055b cpufreq: enable ARM drivers on ar=
m64)
Merging blackfin/for-linus (58095fdaaf1c From: Eunbong Song <eunb.song@sams=
ung.com>)
Merging c6x/for-linux-next (546153d75a48 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (44eb66c228fe Hexagon: update CR year for elf.h)
Merging ia64/next (d21114236d0e Fix warning in make defconfig)
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
Merging powerpc/next (66f9af83e56b powerpc/eeh: Disable EEH on reboot)
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
Merging cifs/for-next (dca1c8d17a2f cifs: mask off top byte in get_rfc1002_=
length())
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (ff57cd5863cf fsnotify: Allocate overflow events with=
 proper type)
Merging ext4/dev (442ed22745a0 ext4: merge uninitialized extents)
Merging f2fs/dev (9cf3c3898a27 f2fs: fix dirty page accounting when redirty)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (b2ec2778df9d fuse: Turn writeback cache on)
Merging gfs2/master (fcf10d38afd2 GFS2: replace kmalloc - __vmalloc / memse=
t 0)
Merging jfs/jfs-next (844fa1b5f849 jfs: set i_ctime when setting ACL)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (b7e63a1079b2 NFSv4: Fix another nfs4_sequence corru=
ptor)
Merging nfsd/nfsd-next (1406b916f4a2 nfsd: fix lost nfserrno() call in nfsd=
_setattr())
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging ubifs/linux-next (9d54c8a33eec UBI: R/O block driver on top of UBI =
volumes)
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
Merging hwmon-staging/hwmon-next (d44cdded6ab3 hwmon: (max6639) Use SIMPLE_=
DEV_PM_OPS macro)
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
Merging ieee1394/for-next (8987583366ae firewire: net: fix use after free)
Merging dlm/next (075f01775f53 dlm: use INFO for recovery messages)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (3c79200df630 Merge branch 'fixes' into next)
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (285727600fa3 bonding: send arp requests even if th=
ere's no route to them)
CONFLICT (content): Merge conflict in net/ipv6/sit.c
CONFLICT (content): Merge conflict in drivers/net/wireless/mwifiex/pcie.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath9k/recv.c
Merging ipsec-next/master (bc861959103c ipv6: addrconf: silence sparse endi=
anness warnings)
Merging wireless-next/master (3e3831c4fdc5 brcmfmac: reset suspend flag upo=
n sdio suspend failure)
$ git reset --hard HEAD^
Merging next-20140224 version of wireless-next
Merging bluetooth/master (81ad6fd9698f Bluetooth: Remove unnecessary stop_s=
can_complete function)
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
Merging drm-intel/for-linux-next (b5ea642a76ee drm/i915: sprinkle static)
Merging drm-tegra/drm/for-next (c1a68b4c29b8 drm/tegra: Add eDP support)
Merging sound/for-next (78e34f34ac27 ALSA: hda - remove PCI dependency in K=
config)
Merging sound-asoc/for-next (ff885b90afcc Merge remote-tracking branches 'a=
soc/topic/wm8988', 'asoc/topic/wm8990', 'asoc/topic/wm8991', 'asoc/topic/wm=
8993', 'asoc/topic/wm8994', 'asoc/topic/wm8996', 'asoc/topic/wm9081' and 'a=
soc/topic/wm9705' into asoc-next)
CONFLICT (content): Merge conflict in sound/soc/kirkwood/Kconfig
Merging modules/modules-next (917307b09ad5 module: remove MODULE_GENERIC_TA=
BLE)
Merging virtio/virtio-next (6f0317058f43 tools/virtio: add a missing ))
Merging input/next (7fb45edba8b5 Input: imx_keypad - Propagate the real err=
or code on platform_get_irq() failure)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (a9f4f164c036 Merge branch 'for-3.15/drivers' into f=
or-next)
Merging device-mapper/for-next (14f398ca2f26 dm cache mq: fix memory alloca=
tion failure for large cache devices)
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
Merging mfd-lj/for-mfd-next (30b44d76fd90 mfd: sec: Add support for S2MPS14)
$ git reset --hard HEAD^
Merging next-20140210 version of mfd-lj
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (eba358435b21 OMAPDSS: Remove unused get_context=
_loss_count support)
Merging regulator/for-next (d6d04b0d5d4e Merge remote-tracking branches 're=
gulator/topic/tps65218', 'regulator/topic/tps6524x', 'regulator/topic/tps65=
86x', 'regulator/topic/tps65910', 'regulator/topic/tps80031', 'regulator/to=
pic/wm831x', 'regulator/topic/wm8350' and 'regulator/topic/wm8994' into reg=
ulator-next)
Merging security/next (864f32a52b53 kernel: Mark function as static in kern=
el/seccomp.c)
Merging selinux/next (0909c0ae999c selinux: put the mmap() DAC controls bef=
ore the MAC controls)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (db5dd336cb23 watchdog: orion: prepare new Dove DT =
Kconfig variable)
CONFLICT (content): Merge conflict in drivers/watchdog/orion_wdt.c
CONFLICT (content): Merge conflict in drivers/watchdog/Kconfig
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (972157cac528 arm/smmu: Use irqsafe spinlock for domain =
lock)
Merging vfio/next (9d830d47c7a7 kvm/vfio: Support for DMA coherent IOMMUs)
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
Merging spi/for-next (db795f97b2cc Merge remote-tracking branches 'spi/topi=
c/txx9', 'spi/topic/xfer' and 'spi/topic/xilinx' into spi-next)
Merging tip/auto-latest (b38f2661b490 Merge branch 'x86/x32')
CONFLICT (content): Merge conflict in drivers/pci/Makefile
CONFLICT (modify/delete): arch/x86/pci/visws.c deleted in tip/auto-latest a=
nd modified in HEAD. Version HEAD of arch/x86/pci/visws.c left in tree.
CONFLICT (modify/delete): arch/x86/pci/numaq_32.c deleted in tip/auto-lates=
t and modified in HEAD. Version HEAD of arch/x86/pci/numaq_32.c left in tre=
e.
$ git rm -f arch/x86/pci/numaq_32.c arch/x86/pci/visws.c
Merging clockevents/clockevents/next (00e2bcd6d35f clocksource: Timer-sun5i=
: Switch to sched_clock_register())
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (c045ebdf6079 Merge branch 'edac-for-3.15' into f=
or-next)
Merging ftrace/for-next (1fcc155351f1 ftrace: Have static function trace cl=
ear ENABLED flag on unregister)
Merging rcu/rcu/next (f5604f67fe8c Merge branch 'torture.2014.02.23a' into =
HEAD)
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
Merging leds/for-next (aad0f292756c leds: clevo-mail: remove __initdata mar=
ker)
Merging driver-core/driver-core-next (6d8b3e1ad3d3 kernfs: remove duplicate=
 dir.c at the top dir)
Merging tty/tty-next (bf13c9a89416 serial: sh-sci: Add missing call to uart=
_remove_one_port() in failure path)
Merging usb/usb-next (927c4dac34cf usb: wusbcore: fix compile warnings)
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/Kconfig
Merging usb-gadget/next (bb0202d1a5a2 usb: dwc3: gadget: always enable IOC =
on bulk/interrupt transfers)
Merging staging/staging-next (9cd02bd876d3 staging: tidspbridge: fixed spac=
e coding style)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53-qsb.dts
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53-mba53.dts
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx51-babbage.dts
Applying: ARM: dts: i.MX53: merge fix patch
Merging char-misc/char-misc-next (7a962a4b6e86 memory: ti-aemif: add bindin=
gs for AEMIF driver)
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
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-prima2/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-picoxcell/Kconfig
Applying: ppc: Make PPC_BOOK3S_64 select IRQ_WORK
Applying: ia64: select CONFIG_TTY for use of tty_write_message in unaligned
Applying: s390: select CONFIG_TTY for use of tty in unconditional keyboard =
driver
Applying: cris: Make ETRAX_ARCH_V10 select TTY for use in debugport
Applying: cris: cpuinfo_op should depend on CONFIG_PROC_FS
$ git checkout -b akpm remotes/origin/akpm/master
Applying: kernel: use macros from compiler.h instead of __attribute__((...))
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: mm: add strictlimit knob
Merging akpm/master (4ae100b8c3d7 mm: add strictlimit knob)
[master 454706ecb810] Revert "mcb: Add PCI carrier for MEN Chameleon Bus"
[master 07bcb176c89f] Revert "iio: adc: Add MEN 16z188 ADC driver"

--Signature=_Mon__3_Mar_2014_20_07_22_+1100_RZGKMHxzy2vGX8Os
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFEZOAAoJEMDTa8Ir7ZwVCm0QAJcFbngMz+tGs0jPrN6KxeDW
+Hotk7GfuCmTT0pXWfP8FQbIpw2snE9KnfUP8montssI9sITLMtaUKzA2qr1ncdg
AfixNd/FdZDndm5lkrK+kExTK0sKC18PNtoPRiNDd0Cokdn89f1ItZvFGOGE7/z1
L1eLiBnuMobvTCimKQuE0qPxHgZG1paeX5Zus1s8Zmf+03Md6NP4GtWHC9/fea/p
U/OOoOGfg9FvHafZfEsECchV+vv4X5OsXkvqnQhz5mSE2npFgzIKPBgtMnq0iko9
H3UDVebWsOLtGvKmQMDQF0wSwBc8E6YzOpUDSB0/2cdAipvD3p6ZrcaTvV0jP5Ew
ZLdCN91J6MQF7ltfIeXE9wpp6YWhPPWNQl8p/9CfOw3u8aBkSoz8Zzumjy0eaCDj
VlZXQsmcE1tbIWCv0OHgYLa8xygNqPqDOgNKpkNryH3lSD6iPD0jJtzXOvrET5WX
bA1HJNseqG97TAWsUwGjaEvwsDulNMEbEqyaw3pzcHymi6eMnNGVJ5MGoIbHSdj4
P7YExYO6FkYwnYp+NZXe5N9Os9W/JVRcRkpPm3pqDTxxBq1O2Z5UuYoVNU968Ced
zBq0UKBMK0ovxNMF1ofzKbg4jUvw65NHfa09DYf3XNTzXnTEImpEMcmsafNx3s5t
vUpN/KAVHbrXizVem2lo
=c1Dd
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_20_07_22_+1100_RZGKMHxzy2vGX8Os--
