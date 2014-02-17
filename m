Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaBQGXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:23:48 -0500
Received: from ozlabs.org ([203.10.76.45]:37765 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbaBQGXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:23:43 -0500
Date: Mon, 17 Feb 2014 17:23:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 17
Message-Id: <20140217172329.2c61499f57842ec2ed177bc5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Feb_2014_17_23_29_+1100_ds7T9a7RBj=axlnZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Feb_2014_17_23_29_+1100_ds7T9a7RBj=axlnZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

If you see failures in building this tree due to missing declarations of
k..alloc/free, then it may be caused by commit 2bd59d48ebfb ("cgroup:
convert to kernfs").  Please send Tejun Heo <tj@kernel.org> a patch
adding an inclusion of linux/slab.h to the appropriate file(s).

This tree fails (more than usual) the powerpc allyesconfig build.

Changes since 20140214:

The powerpc tree still had its build failure.

The libata tree gained a conflict aaginst Linus' tree.

The mfd-lj tree still had its build failure so I used the version from
next-20140210.

Non-merge commits (relative to Linus' tree): 2845
 3245 files changed, 101137 insertions(+), 51870 deletions(-)

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

I am currently merging 208 trees (counting Linus' and 28 trees of patches
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
Merging origin/master (6d0abeca3242 Linux 3.14-rc3)
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (7e22e91102c6 Linux 3.13-rc8)
Merging arm-current/fixes (b027df048500 ARM: 7957/1: add DSB after icache f=
lush in __flush_icache_all())
Merging m68k-current/for-linus (7247f55381d5 m68k: Wire up sched_setattr an=
d sched_getattr)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (cd15b048445d powerpc/powernv: Add iommu DMA by=
pass support for IODA2)
Merging sparc/master (738b52bb9845 Merge tag 'microblaze-3.14-rc3' of git:/=
/git.monstr.eu/linux-2.6-microblaze)
Merging net/master (eb2d4c64879c net,bonding: fix bond_options.c direct rwl=
ock.h include)
Merging ipsec/master (738b52bb9845 Merge tag 'microblaze-3.14-rc3' of git:/=
/git.monstr.eu/linux-2.6-microblaze)
Merging sound-current/for-linus (2078600b1f8f ALSA: Revert "ALSA: hda/realt=
ek - Avoid invalid COEFs for ALC271X")
Merging pci-current/for-linus (fc40363b2140 ahci: Fix broken fallback to si=
ngle MSI mode)
Merging wireless/master (4885c8731a34 hostap: fix "hostap: proc: Use remove=
_proc_subtree()")
Merging driver-core.current/driver-core-linus (9e1ccb4a7700 drivers/base: f=
ix devres handling for master device)
Merging tty.current/tty-linus (0930b0950a89 vt: Fix secure clear screen)
Merging usb.current/usb-linus (3635c7e2d59f usb: option: blacklist ZTE MF66=
7 net interface)
Merging staging.current/staging-linus (ddf5eb564d97 staging/rtl8821ae: fix =
build, depends on MAC80211)
Merging char-misc.current/char-misc-linus (bf7471038840 Revert "misc: eepro=
m: sunxi: Add new compatibles")
Merging input-current/for-linus (910a9f5636f5 Input: adp5588-keys - get val=
ue from data out when dir is out)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (ee97dc7db4cb crypto: s390 - fix des and des3=
_ede ctr concurrency issue)
Merging ide/master (738b52bb9845 Merge tag 'microblaze-3.14-rc3' of git://g=
it.monstr.eu/linux-2.6-microblaze)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (6f041e99fc7b of: Fix NULL dere=
ference in unflatten_and_copy())
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
Merging arc/for-next (c61e2aee0c55 ARC: Remove ARC_HAS_COH_RTSC)
Merging arm/for-next (41212aaf9432 Merge branches 'fixes', 'misc', 'mmci', =
'unstable/omap-dma' and 'unstable/sa11x0' into for-next)
Merging arm-perf/for-next/perf (72db08319d9e ARM: perf: hook up perf_sample=
_event_took around pmu irq handling)
Merging arm-soc/for-next (0ef783f632e3 Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (777202862f65 Merge branch 'for-3.15/dt' into for-=
next)
Merging cortex-m/for-next (f41bfc9423aa Merge tag 'ext4_for_linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (6e5dad1f97b2 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (cebfcb84217e Merge branch 'old/mvebu/irqchip' into =
for-next)
Merging renesas/next (2a42ac1c36b8 Merge branches 'heads/defconfig-for-v3.1=
5', 'heads/soc-for-v3.15', 'heads/boards-for-v3.15' and 'heads/dt-for-v3.15=
' into devel)
Merging samsung/for-next (403ead113c0c Merge branch 'v3.15-next/dt-samsung'=
 into for-next)
Merging tegra/for-next (c3a8d073b74a Merge branch for-3.15/defconfig into f=
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
Merging microblaze/next (45f7fdc2ffb9 Merge branch 'merge' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging mips/mips-for-linux-next (447cebefe88a Merge branch '3.14-fixes' in=
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
Merging ceph/master (82728afa81a9 libceph: a per-osdc crush scratch buffer)
Merging cifs/for-next (41386ebcb6e0 cifs: sanity check length of data to se=
nd before sending)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (4ea7772f828a udf: Fix lockdep warning from udf_symli=
nk())
Merging ext4/dev (2d21448cf500 jbd2: mark file-local functions as static)
Merging f2fs/dev (3dfc9086cb1d f2fs: show counts of checkpoint in status)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (b2ec2778df9d fuse: Turn writeback cache on)
Merging gfs2/master (c2b0b30eddf6 GFS2: Mark functions as static in gfs2/rg=
rp.c)
Merging jfs/jfs-next (844fa1b5f849 jfs: set i_ctime when setting ACL)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (a699d65ec4ff SUNRPC: Don't create a gss auth cache =
unless rpc.gssd is running)
Merging nfsd/nfsd-next (2ec197db1a56 lockd: send correct lock when granting=
 a delayed lock.)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging ubifs/linux-next (5547fec74a56 UBI: fix some use after free bugs)
Merging xfs/for-next (a64b760771e8 Merge branch 'xfs-async-aio-extend' into=
 for-next)
Merging file-private-locks/linux-next (1ed1950c412f locks: add new fcntl cm=
d values for handling file private locks)
Merging vfs/for-next (527d1511310a Merge branch 'next' of git://git.kernel.=
org/pub/scm/linux/kernel/git/benh/powerpc)
Merging pci/next (c128856b48b1 Merge branch 'pci/msi' into next)
CONFLICT (content): Merge conflict in drivers/ata/ahci.c
Merging hid/for-next (f1523dbb7e90 Merge branch 'for-3.15/sony' into for-ne=
xt)
Merging i2c/i2c/for-next (6d0abeca3242 Linux 3.14-rc3)
Merging jdelvare-hwmon/master (f1cf5deb331c hwmon: Avoid initializing the s=
ame field twice)
Merging hwmon-staging/hwmon-next (99fcd9655910 hwmon: Sort Kconfig entries =
alphabetically)
Merging v4l-dvb/master (b215621049bd Merge branch 'v4l_for_linus' into to_n=
ext)
Merging kbuild/for-next (ff6b9bdb6263 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (6a9bacaf5e8e Merge branch 'for-3.14-fixes' into fo=
r-next)
CONFLICT (content): Merge conflict in drivers/ata/sata_mv.c
Merging pm/linux-next (6e2e88788612 Merge branch 'acpi-dock-next' into linu=
x-next)
Merging idle/next (62eec04c7fa3 Merge branch 'turbostat' into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (262afa97587b Merge branches 'soc-eduardo', 'soc', 'mi=
sc' and 'int3404-thermal' of .git into next)
CONFLICT (content): Merge conflict in drivers/thermal/Kconfig
Merging ieee1394/for-next (fcd46b34425d firewire: Enable remote DMA above 4=
 GB)
Merging dlm/next (075f01775f53 dlm: use INFO for recovery messages)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (24066813d55b dma: dw: add a PCI ID for Intel Haswel=
l SoC)
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (df9d9fdf8fda openvswitch: rename ->sync to ->syncp)
Merging ipsec-next/master (0f24558e9156 xfrm: avoid creating temporary SA w=
hen there are no listeners)
Merging wireless-next/master (35582ad9d342 Staging: rtl8812ae: remove modul=
es field of rate_control_ops)
Merging bluetooth/master (9113bfd82dc8 Bluetooth: btusb: Add IMC Networks (=
Broadcom based))
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
Merging drm-tegra/drm/for-next (13411ddd3190 drm/tegra: Obtain head number =
from DT)
Merging sound/for-next (115b94d51a3e ALSA: ak4117: Do not free priv until t=
imer handler hasn't actually stopped using it)
Merging sound-asoc/for-next (db1ac999519d Merge remote-tracking branches 'a=
soc/topic/wm8962', 'asoc/topic/wm8988', 'asoc/topic/wm8991' and 'asoc/topic=
/wm8995' into asoc-next)
Merging modules/modules-next (917307b09ad5 module: remove MODULE_GENERIC_TA=
BLE)
Merging virtio/virtio-next (6f0317058f43 tools/virtio: add a missing ))
Merging input/next (a9728f9730c9 Input: sirfsoc-onkey - update copyright ye=
ars to 2014)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (2a53fee6859b Merge branch 'for-3.14/core' into for-=
next)
CONFLICT (content): Merge conflict in block/blk-flush.c
Merging device-mapper/for-next (a17e5c12cde0 dm io: fix I/O to multiple des=
tinations)
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
Merging mfd-lj/for-mfd-next (2fc7e7d25bee mfd: max665x: Differentiate betwe=
en MAX665X devices)
$ git reset --hard HEAD^
Merging next-20140210 version of mfd-lj
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (c4a41bcc1726 video: xilinxfb: Move xilinxfb_pla=
tform_data directly to the driver)
Merging regulator/for-next (24a549133084 Merge remote-tracking branches 're=
gulator/topic/pfuze100', 'regulator/topic/rc5t583', 'regulator/topic/s5m876=
7', 'regulator/topic/ti-abb', 'regulator/topic/tps6507x', 'regulator/topic/=
tps65217' and 'regulator/topic/tps65218' into regulator-next)
Merging security/next (e0c2de2b15da security: cleanup Makefiles to use stan=
dard syntax for specifying sub-directories)
Merging selinux/next (81c94e76ce8e selinux: fix the output of ./scripts/get=
_maintainer.pl for SELinux)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (41c91d637e86 watchdog: w83697hf_wdt: return ENODEV=
 if no device was found)
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (dd1a175695ed Merge branches 'arm/smmu', 'core', 'x86/vt=
-d', 'arm/shmobile', 'x86/amd', 'ppc/pamu', 'iommu/fixes' and 'arm/msm' int=
o next)
Merging vfio/next (3be3a074cf5b vfio-pci: Don't use device_lock around AER =
interrupt setup)
Merging osd/linux-next (19350e7627a6 exofs: Print less in r4w)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (8cc7212a0361 idr: remove unused prototype of idr_=
free())
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
Merging spi/for-next (8a7dbc2dd48b Merge remote-tracking branches 'spi/topi=
c/sunxi', 'spi/topic/tegra114', 'spi/topic/topcliff-pch', 'spi/topic/txx9' =
and 'spi/topic/xfer' into spi-next)
Merging tip/auto-latest (47e0b4a158d4 Merge branch 'x86/x32')
Merging clockevents/clockevents/next (00e2bcd6d35f clocksource: Timer-sun5i=
: Switch to sched_clock_register())
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (9d0e8d8348d5 amd64_edac: Fix logic to determine =
channel for F15 M30h processors)
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
Merging workqueues/for-next (fada94ee64e6 workqueue: add args to workqueue =
lockdep name)
Merging drivers-x86/linux-next (b4b0b4a9e039 ipc: add intel-mid's pci id ma=
cros)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (fd9f175f06f7 Merge remote-tracking branches 'regma=
p/topic/irq' and 'regmap/topic/nodev' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (59e35a9e5315 drivers/leds: delete non-required insta=
nces of include <linux/init.h>)
Merging driver-core/driver-core-next (aabaf4c2050d sysfs: create bin_attrib=
utes under the requested group)
Merging tty/tty-next (c600558668e4 serial: max310x: Fix devicetree document=
ation for clock name)
Merging usb/usb-next (6d36b6f31373 phy-core: Don't allow building phy-core =
as a module)
Merging usb-gadget/next (836a2164491b usb: phy: keystone: remove redundant =
return value check of platform_get_resource())
Merging staging/staging-next (e6bed035ca65 Staging: comedi: kcomedilib: rep=
lace deprecated simple_strtoul() with kstrtouint())
Merging char-misc/char-misc-next (5dba4c56dfa6 Drivers: hv: Ballon: Make pr=
essure posting thread sleep interruptibly)
Merging cgroup/for-next (2220f5edf5f4 Merge branch 'for-3.15' into for-next)
Merging scsi/for-next (3ce438df1068 [SCSI] hpsa: allow SCSI mid layer to ha=
ndle unit attention)
Merging target-updates/for-next (b28a960c42fc Linux 3.14-rc2)
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
Merging dma-mapping/dma-mapping-next (d8ec26d7f828 Linux 3.13)
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
Merging akpm-current/current (c28515337902 drivers/misc/sgi-gru/grukdump.c:=
 cleanup gru_dump_context() a little)
CONFLICT (content): Merge conflict in mm/memcontrol.c
CONFLICT (content): Merge conflict in kernel/cpuset.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/spi/spi.c: fix max() warning
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: mm: add strictlimit knob
Merging akpm/master (35451dc8fd69 mm: add strictlimit knob)

--Signature=_Mon__17_Feb_2014_17_23_29_+1100_ds7T9a7RBj=axlnZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTAarlAAoJEMDTa8Ir7ZwVzegP/3VGO43bUqVoABJYX5aoOJJ3
dqL1/B+a2OQPe6/yI1e+UzvOilZN4baTD+LoNi03XJz0Ai1FHxXaXMLfcEOKyIVP
8Pi1fD6zT3Wml72pkxUp74aVq1ql4s+JELns5ssTgLe3DoUjJz2rGeW+bBMcRUXG
qAyY+vnAcrGUUbDQcrUCTkg4KcbBF2Kc28XeO0PSkIyYOlNVpAfYDtBj5e5d80tE
vpqbfE1fLS9UbyzkMuajQSUyM6e7K1wqww9nEaSSJFUmmEZIK/pKSJwBg0Lt4S40
oYNkmD1/6H11H1clhysPFlEW2kQo7CmeA8ekGlpN4bakjNZXU0I1i2e+qSr7mPzV
6NjX2/0ddz7SP9T+AdU2XRj2o+Ks5P67ke/xYSNoIr3mrt0PqPtPjVQOjz+mj3zg
sBVhD66tOy+KQdRUhSEp9EDXT/pw5O/VZmdC6zUQrGl1jdDWyAtmige8nSuZBgLl
D5sWt91d5Nh6lQKSwnJ01PYLhWpUq+envnIM6sjjxT/WwTUJRxSt8c/rHycL45wZ
Jlzotu6vwuALN9ZRCZhIzOeOzURNEMWDDb5eImzMgzPV7fLBz6mIPH9CeDo/FhJD
7SCcac9VH60kbQnMNj99pdq2bcy0ybodHwrFR4UXC0Irbx9/bvWtE/RKNSWZpTD/
9BH1yMp9JzKsVsjBdZC4
=u0ip
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Feb_2014_17_23_29_+1100_ds7T9a7RBj=axlnZ--
