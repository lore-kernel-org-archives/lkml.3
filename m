Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaBMFiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 00:38:50 -0500
Received: from ozlabs.org ([203.10.76.45]:56132 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaBMFip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 00:38:45 -0500
Date: Thu, 13 Feb 2014 16:38:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 13
Message-Id: <20140213163838.bdca61bbd82ba509e2a3b7fd@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Feb_2014_16_38_38_+1100_7q4473PTP1uPUQa4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Feb_2014_16_38_38_+1100_7q4473PTP1uPUQa4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

If you see failures in building this tree due to missing declarations of
k..alloc/free, then it may be caused by commit 2bd59d48ebfb ("cgroup:
convert to kernfs").  Please send Tejun Heo <tj@kernel.org> a patch
adding an inclusion of linux/slab.h to the appropriate file(s).

This tree fails (more than usual) the powerpc allyesconfig build.

Changes since 20140212:

The powerpc tree still had its build failure.

The mfd-lj tree still had its build failure so I used the version from
next-20140210.

The wireless-next tree gained a build failure for which I applied a patch.

The tip tree lost its build failure.

Non-merge commits (relative to Linus' tree): 2188
 2457 files changed, 80774 insertions(+), 41385 deletions(-)

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
Merging origin/master (9398a10cd964 Merge tag 'regulator-v3.14-rc2' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator)
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
Merging net/master (738b52bb9845 Merge tag 'microblaze-3.14-rc3' of git://g=
it.monstr.eu/linux-2.6-microblaze)
Merging ipsec/master (738b52bb9845 Merge tag 'microblaze-3.14-rc3' of git:/=
/git.monstr.eu/linux-2.6-microblaze)
Merging sound-current/for-linus (0d7b520c9770 ALSA: hda - Better fix for in=
valid COEF setup on Acer AO725)
Merging pci-current/for-linus (322a8e91844f PCI: mvebu: Use Device ID and r=
evision from underlying endpoint)
Merging wireless/master (348f7d4adee9 rtl8180: Add error check for pci_map_=
single return value in TX path)
Merging driver-core.current/driver-core-linus (9e1ccb4a7700 drivers/base: f=
ix devres handling for master device)
Merging tty.current/tty-linus (d8a5dc3033af tty: Set correct tty name in 'a=
ctive' sysfs attribute)
Merging usb.current/usb-linus (3635c7e2d59f usb: option: blacklist ZTE MF66=
7 net interface)
Merging staging.current/staging-linus (ddf5eb564d97 staging/rtl8821ae: fix =
build, depends on MAC80211)
Merging char-misc.current/char-misc-linus (3b1cc9b9622a misc: mic: fix poss=
ible signed underflow (undefined behavior) in userspace API)
Merging input-current/for-linus (55df811f2066 Merge branch 'next' into for-=
linus)
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
Merging drm-intel-fixes/for-linux-next-fixes (f66fab8e1cd6 drm/i915: Preven=
t MI_DISPLAY_FLIP straddling two cachelines on IVB)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (c61e2aee0c55 ARC: Remove ARC_HAS_COH_RTSC)
Merging arm/for-next (41212aaf9432 Merge branches 'fixes', 'misc', 'mmci', =
'unstable/omap-dma' and 'unstable/sa11x0' into for-next)
Merging arm-perf/for-next/perf (a1d711938959 ARM: dts: msm: Add krait-pmu t=
o platforms with Krait CPUs)
Merging arm-soc/for-next (22694f45fd8f Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (c06213a754f5 Merge branch 'for-3.15/dt' into for-=
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
Merging renesas/next (9554b6651c23 Merge branches 'heads/soc-for-v3.15' and=
 'heads/boards-for-v3.15' into devel)
Merging samsung/for-next (38dbfb59d117 Linus 3.14-rc1)
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
Merging mips/mips-for-linux-next (d1119994038f Merge branch '3.14-fixes' in=
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
Merging ceph/master (125d725c9235 ceph: cast PAGE_SIZE to size_t in ceph_sy=
nc_write())
Merging cifs/for-next (4a5c80d7b561 [CIFS] clean up page array when uncache=
d write send fails)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (4ea7772f828a udf: Fix lockdep warning from udf_symli=
nk())
Merging ext4/dev (2d21448cf500 jbd2: mark file-local functions as static)
Merging f2fs/dev (c86f36c6458c f2fs: introduce ra_meta_pages to readahead C=
P/NAT/SIT pages)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (b2ec2778df9d fuse: Turn writeback cache on)
Merging gfs2/master (c2b0b30eddf6 GFS2: Mark functions as static in gfs2/rg=
rp.c)
Merging jfs/jfs-next (c18f7b51200c jfs: fix generic posix ACL regression)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (a699d65ec4ff SUNRPC: Don't create a gss auth cache =
unless rpc.gssd is running)
Merging nfsd/nfsd-next (243424ba8778 lockd: send correct lock when granting=
 a delayed lock.)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging ubifs/linux-next (5547fec74a56 UBI: fix some use after free bugs)
Merging xfs/for-next (39f30ca7eaa4 Merge branch 'xfs-async-aio-extend' into=
 for-next)
Merging file-private-locks/linux-next (1ed1950c412f locks: add new fcntl cm=
d values for handling file private locks)
Merging vfs/for-next (527d1511310a Merge branch 'next' of git://git.kernel.=
org/pub/scm/linux/kernel/git/benh/powerpc)
Merging pci/next (17f2d86f5d53 Merge branch 'pci/numa-cleanup' into next)
Merging hid/for-next (f1523dbb7e90 Merge branch 'for-3.15/sony' into for-ne=
xt)
Merging i2c/i2c/for-next (9b0cd304f26b Merge branch 'drm-next' of git://peo=
ple.freedesktop.org/~airlied/linux)
Merging jdelvare-hwmon/master (f1cf5deb331c hwmon: Avoid initializing the s=
ame field twice)
Merging hwmon-staging/hwmon-next (72f13a7e1328 hwmon: (lm95245) Avoid initi=
alizing the same field twice)
Merging v4l-dvb/master (b215621049bd Merge branch 'v4l_for_linus' into to_n=
ext)
Merging kbuild/for-next (ff6b9bdb6263 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (efb9e0f4f437 ata: enable quirk from jmicron JMB350=
 for JMB394)
Merging pm/linux-next (484021085864 Merge branch 'pm-qos' into linux-next)
Merging idle/next (2d6e532279dd tools/power turbostat: simplify output, add=
 Avg_MHz)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (262afa97587b Merge branches 'soc-eduardo', 'soc', 'mi=
sc' and 'int3404-thermal' of .git into next)
CONFLICT (content): Merge conflict in drivers/thermal/Kconfig
Merging ieee1394/for-next (fcd46b34425d firewire: Enable remote DMA above 4=
 GB)
Merging dlm/next (ece35848c184 dlm: set zero linger time on sctp socket)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (24066813d55b dma: dw: add a PCI ID for Intel Haswel=
l SoC)
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (0e4767aaf499 Merge branch 'sfc')
Merging ipsec-next/master (5826bdd1816f flowcache: Bring net/core/flow.c un=
der IPsec maintain scope)
Merging wireless-next/master (e57f1734d87a mwifiex: add key material v2 sup=
port)
Applying: Staging: rtl8812ae: remove modules field of rate_control_ops
Merging bluetooth/master (e3719086ff57 Bluetooth: Use connection parameters=
 if any)
Merging infiniband/for-next (fb1b5034e498 Merge branch 'ip-roce' into for-n=
ext)
Merging mtd/master (0e47c969c65e Merge tag 'for-linus-20140127' of git://gi=
t.infradead.org/linux-mtd)
Merging l2-mtd/master (a67acac04061 mtd: gen_probe: Remove unnecessary OOM =
messages)
Merging crypto/master (883619a931e9 crypto: caam - fix ERA retrieval functi=
on)
Merging drm/drm-next (ef64cf9d0604 Merge branch 'drm-nouveau-next' of git:/=
/anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next)
Merging drm-intel/for-linux-next (4d10cc0f861e drm/i915: delay master/sarea=
 deref for legacy ioctls)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_dp.c
Merging drm-tegra/drm/for-next (13411ddd3190 drm/tegra: Obtain head number =
from DT)
Merging sound/for-next (c4d1489390aa Merge branch 'for-linus' into for-next)
Merging sound-asoc/for-next (1ec751bc181a Merge remote-tracking branches 'a=
soc/topic/wm8991' and 'asoc/topic/wm8995' into asoc-next)
Merging modules/modules-next (22e669568d51 module: Add missing newline in p=
rintk call.)
Merging virtio/virtio-next (05c54de8c88c drivers: virtio: Mark function vir=
tballoon_migratepage() as static in virtio_balloon.c)
Merging input/next (50fe03da82b4 Input: uinput - add UI_GET_SYSNAME ioctl t=
o retrieve the sysfs path)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (2a53fee6859b Merge branch 'for-3.14/core' into for-=
next)
Merging device-mapper/for-next (d3cd022521ed dm thin: avoid metadata commit=
 if a pool's thin devices haven't changed)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (38dbfb59d117 Linus 3.14-rc1)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (26e4f2057516 slub: Fix possible format string bug.)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (1877db75589a md/raid1: restore ability for check and r=
epair to fix read errors.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (86351d035461 mfd: Delete non-required instance=
s of include <linux/init.h>)
$ git reset --hard HEAD^
Merging next-20140210 version of mfd-lj
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (c4a41bcc1726 video: xilinxfb: Move xilinxfb_pla=
tform_data directly to the driver)
Merging regulator/for-next (a003b74a6ae6 Revert "regulator: gpio-regulator:=
 do not open-code counting and access of dt array elements")
Merging security/next (e0238b4ced90 selinux: fix the output of ./scripts/ge=
t_maintainer.pl for SELinux)
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
Merging dt-rh/for-next (860a445c25aa DT: Add vendor prefix for Spansion Inc=
.)
Merging spi/for-next (2f0da63a145a Merge remote-tracking branches 'spi/topi=
c/sunxi', 'spi/topic/tegra114', 'spi/topic/txx9' and 'spi/topic/xfer' into =
spi-next)
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
Merging workqueues/for-next (84604340d034 workqueue: Fix workqueue lockdep =
name)
Merging drivers-x86/linux-next (b4b0b4a9e039 ipc: add intel-mid's pci id ma=
cros)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (e6e5c7bb7c6b Merge remote-tracking branch 'regmap/=
topic/irq' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (59e35a9e5315 drivers/leds: delete non-required insta=
nces of include <linux/init.h>)
Merging driver-core/driver-core-next (a8fa94e0f2ab Merge branch 'master' in=
to driver-core-next-test-merge-rc2)
Merging tty/tty-next (f7e54d7ad743 msm_serial: Add support for poll_{get,pu=
t}_char())
Merging usb/usb-next (e8fcbb614059 usb/misc/usbled: Add Riso Kagaku Webmail=
 Notifier)
Merging usb-gadget/next (836a2164491b usb: phy: keystone: remove redundant =
return value check of platform_get_resource())
Merging staging/staging-next (861d2ac1db41 staging: rtl8821ae: Remove dupli=
cate include)
Merging char-misc/char-misc-next (7841b647b9c1 Revert ds1wm.c from "w1: hol=
d bus_mutex in netlink and search")
Merging cgroup/for-next (a755180bab81 sun4M: add include of slab.h for kzal=
loc)
Merging scsi/for-next (3ce438df1068 [SCSI] hpsa: allow SCSI mid layer to ha=
ndle unit attention)
Merging target-updates/for-next (5259a06ef970 target: Fix percpu_ref_put ra=
ce in transport_lun_remove_cmd)
Merging target-merge/for-next-merge (374b105797c3 Linux 3.13-rc3)
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
Merging dma-buf/for-next (f546ca46faa1 dma-buf: update debugfs output)
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
Merging aio/master (8e321fefb0e6 aio/migratepages: make aio migrate pages s=
ane)
Merging akpm-current/current (1fc69fa0b91f drivers/misc/sgi-gru/grukdump.c:=
 cleanup gru_dump_context() a little)
CONFLICT (content): Merge conflict in fs/ocfs2/namei.c
CONFLICT (content): Merge conflict in drivers/misc/sgi-gru/grukdump.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: fs/udf/super.c: add __init to init_inodecache()
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: mm: add strictlimit knob
Merging akpm/master (2746a6e680c9 mm: add strictlimit knob)

--Signature=_Thu__13_Feb_2014_16_38_38_+1100_7q4473PTP1uPUQa4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS/FpjAAoJEMDTa8Ir7ZwVjvkP/jlBxS7wk+MnHgXyVv0OUNSG
BQaHiCMuHeqjHTy0JpF/aR1Nc0D/fG8teZBsUztWMi3CDoRYe3snkeWO4tWTZRd1
YoJu1Y3lQQ+mvI8LdWx4OC/J7AqOFGx1bKvJOES4Any/meTORljYXPVeWCqHXvx6
gWIJ0l3i/NPRfIMp0vDU1pOdgPSWvViXqS1DrMunWg8KVl0dTIA6YOIrTD4tQUxY
VSCGraiN6JrEzyjdPJM8tNOTnUDoFGXjrNH7twfEGemFDjnacBqSFYdGAUYb0AH1
p5aKDbxa9Jp3nEWWqmhBSRTQryJJc4b0tp260c1oCpcOQbOZxgwzMDiKrftc5aVl
mD8L2scO1TOFLQiLG3FLc5abzBhosZb6KZzJLcweFJcyhCV2cPOglEXICP0U9XnU
RjxphabeBW9WmFSdHdZt/hi3YY0fY3T2sIc1jomHAe9SsfC4LPtIchQ2oK7e7Ksk
w5larJvoWO5DbGd2bZmLlG6P6hCCT4Ip+X/FAtA6xxAJY381xVk1xlSZCWHZpnLJ
VhFeMAwo9deflsCuOIsLufnOXXYWokOGVNBDl7IuDW0uXGILgVXZ9taeavn9ZiUQ
ZbKLSMpwDAXPWX8F01ovG27Iup2c69KWAqQQUCCWGnXYT+eQs/xziEstnliAZ8Cw
km1D52BqX0wbmBpoDKts
=0GVY
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Feb_2014_16_38_38_+1100_7q4473PTP1uPUQa4--
