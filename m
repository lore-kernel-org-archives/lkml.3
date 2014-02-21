Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaBUHkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 02:40:08 -0500
Received: from ozlabs.org ([203.10.76.45]:49151 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaBUHkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 02:40:02 -0500
Date: Fri, 21 Feb 2014 18:39:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 21
Message-Id: <20140221183955.631b45f93fdfe3d00116f526@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Feb_2014_18_39_55_+1100_1feD0O/IlV=9C2Bh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Feb_2014_18_39_55_+1100_1feD0O/IlV=9C2Bh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree fails (more than usual) the powerpc allyesconfig build.

Changes since 20140220:

Renamed tree: clang to llvmlinux

The arm-soc tree gained a conflict against the arm-perf tree.

The powerpc tree still had its build failure.

The mfd-lj tree still had its build failure so I used the version from
next-20140210.

The net-next tree gained conflicts against the wireless and net trees.

The sound-asoc tree lost its build failure.

The char-misc tree gained a build failure for which I applied a merge fix
patch.

The akpm-current tree gained a conflict against the sparc tree.

Non-merge commits (relative to Linus' tree): 3763
 3919 files changed, 133708 insertions(+), 71315 deletions(-)

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
Merging origin/master (d158fc7f36a2 Merge tag 'pci-v3.14-fixes-1' of git://=
git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci)
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (7e22e91102c6 Linux 3.13-rc8)
Merging arm-current/fixes (39544ac9df20 ARM: 7957/1: add DSB after icache f=
lush in __flush_icache_all())
Merging m68k-current/for-linus (7247f55381d5 m68k: Wire up sched_setattr an=
d sched_getattr)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (66f9af83e56b powerpc/eeh: Disable EEH on reboo=
t)
Merging sparc/master (967f038e491b Sparc: sparc_cpu_model isn't in asm/syst=
em.h any more [ver #2])
Merging net/master (7cce3b75682f net: sctp: Potentially-Failed state should=
 not be reached from unconfirmed state)
Merging ipsec/master (960dfc4eb23a Merge branch 'drm-fixes' of git://people=
.freedesktop.org/~airlied/linux)
Merging sound-current/for-linus (1de7ca5e8448 ALSA: hda - Enable front audi=
o jacks on one HP desktop model)
Merging pci-current/for-linus (fc40363b2140 ahci: Fix broken fallback to si=
ngle MSI mode)
Merging wireless/master (b3050248c167 ath9k: Fix ETSI compliance for AR9462=
 2.0)
Merging driver-core.current/driver-core-linus (6d0abeca3242 Linux 3.14-rc3)
Merging tty.current/tty-linus (6d0abeca3242 Linux 3.14-rc3)
Merging usb.current/usb-linus (0fd7a820675e Merge tag 'fixes-for-v3.14-rc4'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus)
Merging staging.current/staging-linus (6d0abeca3242 Linux 3.14-rc3)
Merging char-misc.current/char-misc-linus (accb884b32e8 mei: set client's r=
ead_cb to NULL when flow control fails)
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
Merging drm-intel-fixes/for-linux-next-fixes (f51a44b9a6c4 drm/i915/dp: add=
 native aux defer retry limit)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (67a2635aa64a ARC: [clockevent] simplify timer ISR)
Merging arm/for-next (41212aaf9432 Merge branches 'fixes', 'misc', 'mmci', =
'unstable/omap-dma' and 'unstable/sa11x0' into for-next)
Merging arm-perf/for-next/perf (c504fa17406d ARM: perf: add support for the=
 Cortex-A12 PMU)
Merging arm-soc/for-next (b4425cc587eb arm-soc: Document recent merges)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/qcom-msm8960-cdp.dts
Merging bcm2835/for-next (777202862f65 Merge branch 'for-3.15/dt' into for-=
next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (8cfdab14395c Merge branch 'imx/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-imx/common.h
CONFLICT (content): Merge conflict in arch/arm/mach-imx/Makefile
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (52eaa3d1e97f Merge branch 'for_3.15/dts' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (45b70ae22f7c Merge branch 'mvebu/dt-3xx' into for-n=
ext)
Merging renesas/next (2691b9531be2 Merge branches 'heads/defconfig-for-v3.1=
5', 'heads/intc-for-v3.15', 'heads/soc-for-v3.15', 'heads/boards-for-v3.15'=
 and 'heads/dt-for-v3.15' into next)
Merging samsung/for-next (403ead113c0c Merge branch 'v3.15-next/dt-samsung'=
 into for-next)
Merging tegra/for-next (1ea2965c2ddd Merge branch for-3.15/defconfig into f=
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
Merging microblaze/next (7e4d16e416fe microblaze: Drop architecture-specifi=
c declaration of early_printk)
Merging mips/mips-for-linux-next (597ec9b6ec4a Merge branch '3.14-fixes' in=
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
Merging s390/features (3e79a93fe888 s390/kvm: set guest page states to stab=
le on re-ipl)
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (5e01dc7b26d9 Linux 3.12)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (c0e50d41126e xtensa: fix fast_syscall_spill_regist=
ers)
Merging btrfs/next (cf93da7bcf45 Btrfs: fix spin_unlock in check_ref_cleanu=
p)
Merging ceph/master (bee26897097f libceph: a per-osdc crush scratch buffer)
Merging cifs/for-next (436cc412874c cifs: sanity check length of data to se=
nd before sending)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (1362f4ea20fa quota: Fix race between dqput() and dqu=
ot_scan_active())
Merging ext4/dev (37b0791e6a39 ext4: address a benign compiler warning)
Merging f2fs/dev (8288b113d490 f2fs: fix to do build_stat prior to the reco=
very procedure)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (b2ec2778df9d fuse: Turn writeback cache on)
Merging gfs2/master (ad781971d9b8 GFS2: add missing newline)
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
Merging xfs/for-next (027f185e66eb Merge remote-tracking branch 'xfs-async-=
aio-extend' into for-next)
Merging file-private-locks/linux-next (1ed1950c412f locks: add new fcntl cm=
d values for handling file private locks)
Merging vfs/for-next (527d1511310a Merge branch 'next' of git://git.kernel.=
org/pub/scm/linux/kernel/git/benh/powerpc)
Merging pci/next (86afe959b08e Merge branches 'pci/host-designware', 'pci/h=
ost-imx6' and 'pci/host-rcar' into next)
CONFLICT (content): Merge conflict in drivers/ata/ahci.c
Merging hid/for-next (873400fa32c2 Merge branch 'for-3.15/sony' into for-ne=
xt)
CONFLICT (content): Merge conflict in drivers/hid/i2c-hid/i2c-hid.c
CONFLICT (content): Merge conflict in drivers/hid/hid-ids.h
CONFLICT (content): Merge conflict in drivers/hid/hid-core.c
Merging i2c/i2c/for-next (6d0abeca3242 Linux 3.14-rc3)
Merging jdelvare-hwmon/master (c1d70b646dae hwmon: (lm90) Convert to use hw=
mon_device_register_with_groups)
Merging hwmon-staging/hwmon-next (75cf67231ea8 hwmon: (ltc4215) Convert to =
devm_hwmon_device_register_with_groups)
Merging v4l-dvb/master (b215621049bd Merge branch 'v4l_for_linus' into to_n=
ext)
Merging kbuild/for-next (ff6b9bdb6263 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (da82fd6e4226 Merge branch 'for-3.15' into for-next)
Merging pm/linux-next (8029cfa9b10b Merge branch 'acpi-dsm')
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
Merging net-next/master (61cc776fc1f5 Merge branch 'for-davem' of git://git=
.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next)
CONFLICT (content): Merge conflict in net/ipv6/sit.c
CONFLICT (content): Merge conflict in drivers/net/wireless/mwifiex/pcie.c
Merging ipsec-next/master (1a1ccc96abb2 xfrm: Remove caching of xfrm_policy=
_sk_bundles)
Merging wireless-next/master (35582ad9d342 Staging: rtl8812ae: remove modul=
es field of rate_control_ops)
Merging bluetooth/master (b1765e7afe87 Bluetooth: Fix channel check when bi=
nding RFCOMM sock)
Merging infiniband/for-next (7f3c1e1ba82e Merge branches 'cma', 'cxgb4', 'i=
ser', 'misc', 'mlx4', 'mlx5', 'nes', 'ocrdma', 'qib' and 'usnic' into for-n=
ext)
Merging mtd/master (28fa65e643ed mtd: nand: fix off-by-one read retry mode =
counting)
Merging l2-mtd/master (a67acac04061 mtd: gen_probe: Remove unnecessary OOM =
messages)
Merging crypto/master (883619a931e9 crypto: caam - fix ERA retrieval functi=
on)
Merging drm/drm-next (ef64cf9d0604 Merge branch 'drm-nouveau-next' of git:/=
/anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next)
Merging drm-intel/for-linux-next (4c0e55288211 drm/i915: fix NULL deref in =
the load detect code)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_dp.c
Merging drm-tegra/drm/for-next (a608d94a0b50 gpu: host1x: export host1x_syn=
cpt_incr_max() function)
Merging sound/for-next (b203dbab0838 ALSA: core: Fix missing card sysfs con=
tents)
Merging sound-asoc/for-next (8a7c3e379ee7 Merge remote-tracking branches 'a=
soc/topic/wm8988', 'asoc/topic/wm8990', 'asoc/topic/wm8991' and 'asoc/topic=
/wm8995' into asoc-next)
Merging modules/modules-next (917307b09ad5 module: remove MODULE_GENERIC_TA=
BLE)
Merging virtio/virtio-next (6f0317058f43 tools/virtio: add a missing ))
Merging input/next (7fb45edba8b5 Input: imx_keypad - Propagate the real err=
or code on platform_get_irq() failure)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (7aa1f8a5cd54 Merge branch 'for-3.15/drivers' into f=
or-next)
Merging device-mapper/for-next (a795bfe19920 dm thin: fix the error path fo=
r the thin device constructor)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (7536d3f83aa4 mmc: core: Enable MMC_CAP2_CACHE_CTRL as=
 default)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (26e4f2057516 slub: Fix possible format string bug.)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (789b5e031528 md/raid5: Fix CPU hotplug callback regist=
ration)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (90f473a72867 mfd: timberdale: Use pci_enable_m=
six_range() instead of pci_enable_msix())
$ git reset --hard HEAD^
Merging next-20140210 version of mfd-lj
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (c4a41bcc1726 video: xilinxfb: Move xilinxfb_pla=
tform_data directly to the driver)
Merging regulator/for-next (271a5ae31afd Merge remote-tracking branches 're=
gulator/topic/tps6524x', 'regulator/topic/tps6586x', 'regulator/topic/tps65=
910', 'regulator/topic/tps80031', 'regulator/topic/wm8350' and 'regulator/t=
opic/wm8994' into regulator-next)
Merging security/next (e0c2de2b15da security: cleanup Makefiles to use stan=
dard syntax for specifying sub-directories)
Merging selinux/next (81c94e76ce8e selinux: fix the output of ./scripts/get=
_maintainer.pl for SELinux)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (9badfe833fa1 watchdog: w83697hf_wdt: return ENODEV=
 if no device was found)
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
Merging devicetree/devicetree/next (b66548e2a9ba of: Increase MAX_PHANDLE_A=
RGS)
CONFLICT (content): Merge conflict in drivers/of/of_net.c
Applying: net: of: merges fix for a moved comment
Merging dt-rh/for-next (06b29e76a74b of: search the best compatible match f=
irst in __of_match_node())
Merging spi/for-next (420548863b9a Merge remote-tracking branches 'spi/topi=
c/sirf', 'spi/topic/sunxi', 'spi/topic/tegra114', 'spi/topic/topcliff-pch',=
 'spi/topic/txx9' and 'spi/topic/xfer' into spi-next)
Merging tip/auto-latest (47e0b4a158d4 Merge branch 'x86/x32')
CONFLICT (content): Merge conflict in arch/avr32/include/asm/Kbuild
Merging clockevents/clockevents/next (00e2bcd6d35f clocksource: Timer-sun5i=
: Switch to sched_clock_register())
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (9d6c7cbe3073 i5100_edac: Remove an unneeded cond=
ition in i5100_init_csrows())
Merging ftrace/for-next (3132e107d608 tracing: Check if tracing is enabled =
in trace_puts())
Merging rcu/rcu/next (a9b5bb435cce locktorture: Add kvm-recheck.sh plug-in =
for locktorture)
CONFLICT (content): Merge conflict in mm/slub.c
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (b73117c49364 Merge branch 'kvm-ppc-next' of git://g=
ithub.com/agraf/linux-2.6 into kvm-queue)
Merging kvm-arm/kvm-arm-next (b73117c49364 Merge branch 'kvm-ppc-next' of g=
it://github.com/agraf/linux-2.6 into kvm-queue)
Merging kvm-ppc/kvm-ppc-next (b73117c49364 Merge branch 'kvm-ppc-next' of g=
it://github.com/agraf/linux-2.6 into kvm-queue)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (b1f5d76c5d9b Merge branch 'devel/for-linus-3.15=
' into linux-next)
Merging percpu/for-next (d5f2deed588b Merge branch 'for-3.14' into for-next)
Merging workqueues/for-next (379e899a2c66 Merge branch 'for-3.15' into for-=
next)
Merging drivers-x86/linux-next (b4b0b4a9e039 ipc: add intel-mid's pci id ma=
cros)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (04eaaca01494 Merge remote-tracking branches 'regma=
p/topic/irq' and 'regmap/topic/nodev' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (59e35a9e5315 drivers/leds: delete non-required insta=
nces of include <linux/init.h>)
Merging driver-core/driver-core-next (6d8b3e1ad3d3 kernfs: remove duplicate=
 dir.c at the top dir)
Merging tty/tty-next (12f287878afc serial: fsl_lpuart: documented the clock=
 requirement.)
Merging usb/usb-next (f6723b569a67 usb: host: remove selects of USB_ARCH_HA=
S_?HCI)
Merging usb-gadget/next (40f099e32c2a usb: musb: dsps, debugfs files)
Merging staging/staging-next (a9f488831cb4 staging: et131x: fix allocation =
failures)
Merging char-misc/char-misc-next (0a191749ce19 Merge branch 'char-misc-linu=
s' into char-misc-next)
Applying: mei: txe: include irqreturn.h for irqreturn_t etc
Merging cgroup/for-next (3c0d1ccae0e5 Merge branch 'for-3.14-fixes' into fo=
r-next)
Merging scsi/for-next (960dfc4eb23a Merge branch 'drm-fixes' of git://peopl=
e.freedesktop.org/~airlied/linux)
Merging target-updates/for-next (9af6de4a22c5 target: silence GCC warning i=
n target_alua_state_check)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (97e00faaf16a pinctrl: sh-pfc: r8a7790: Break out =
USB0 OVC/VBUS)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (a3485d088516 gpio: consumer.h: Move forward declarat=
ions outside #ifdef)
Merging dma-mapping/dma-mapping-next (c091c71ad221 x86: dma-mapping: fix GF=
P_ATOMIC macro usage)
Merging pwm/for-next (6691a19966f0 pwm: tiecap: Remove duplicate put_sync c=
all)
Merging dma-buf/for-next (c0b00a525c12 dma-buf: update debugfs output)
Merging userns/for-next (f58437f1f916 MIPS: VPE: Remove vpe_getuid and vpe_=
getgid)
Merging ktest/for-next (961d9caceea2 ktest: Add BISECT_TRIES to bisect test)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (fd3fdaf09f26 clk: sort Makefile)
Merging random/dev (a9f069e38cc3 random: use the architectural HWRNG for th=
e SHA's IV in extract_buf())
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (4675348e78fa Merge tag 'stable/for-linus-3.14-rc2-tag' =
of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip)
Merging llvmlinux/for-next (f557840d8992 x86, acpi: LLVMLinux: Remove neste=
d functions from Thinkpad ACPI)
Merging akpm-current/current (79db0b2d0308 ipc: use device_initcall)
CONFLICT (content): Merge conflict in mm/memcontrol.c
CONFLICT (content): Merge conflict in drivers/sbus/char/jsflash.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: mm: add strictlimit knob
Merging akpm/master (810015e5f698 mm: add strictlimit knob)

--Signature=_Fri__21_Feb_2014_18_39_55_+1100_1feD0O/IlV=9C2Bh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTBwLPAAoJEMDTa8Ir7ZwVrQMP/0JQco3i5CzHrCiuuCRkD6El
x1Bsr9ZXlqvXiqURaTgwwayg9jpQP4jwUa522Nwy2Yh5FdXnyrABIgPHzPuUU6zH
AjallDUecboXFdyqnyel16aK/+eHRrvH53AoowXkV9efgLyqzwY16ZU5Wp+RQEXD
BTfIV4X/Q3/6FnYJ9zYOBlmZavwynfVvijWS4rOD7JzVP6Ov7oUwdsXm3h8AGMP+
2ZE3FL3ckzBB8VSTclLjXATkoVhYVdEYNO9Wx1aBFBvVrukxgAis1ZhSpYnq3NE3
D7UvCuFpwad49SY4ikF8WLb4Y2y6fbd5iW7sQZHFUJtVU/H4miVctG4ecb8BTCws
js0krZuAXEXrW1s7pOGKLSmpCDpkL6f0nsyrVFE4S1QCdZ2v6HLKtxP3kmmvFyE3
hM1GU0Q42FnM4/Ib6vgxD+Gn09WxbBmW++SKWafeUs1pPXMX4q246n7CKq0+7FlM
/FhJ7XUNHyaHJg/AAYBofFTc9itV6MIzWX5JtMhr285U6ILOa93LRVxgCJvepNue
8+zJkn16xN4tCzL4gXARJ138mUUaYdeO0ttkOkzBpI8V9KikRDU9BXgl5XIgVpiS
9+6Qt2qXlSw1VHrok980NNcRU7Uoma3q45qxSY30+x/JkOAhcb26b3Waqs3V+Vdw
7pYKaqXLn3DPuJzsTrbV
=Fd8X
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Feb_2014_18_39_55_+1100_1feD0O/IlV=9C2Bh--
