Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaBGC7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 21:59:36 -0500
Received: from ozlabs.org ([203.10.76.45]:40971 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaBGC7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 21:59:31 -0500
Date: Fri, 7 Feb 2014 13:59:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 7
Message-Id: <20140207135924.54844322034e35d8deaa97db@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Feb_2014_13_59_24_+1100_l4GBr6E1M5.EMG2a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Feb_2014_13_59_24_+1100_l4GBr6E1M5.EMG2a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree fails (more than usual) the powerpc allyesconfig build.

Changes since 20140206:

The powerpc tree still had its build failure.

The fscache tree lost its build failure.

Non-merge commits (relative to Linus' tree): 1282
 1074 files changed, 39290 insertions(+), 14175 deletions(-)

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
Merging origin/master (9343224bfd4b Merge branch 'akpm' (patches from Andre=
w Morton))
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (7e22e91102c6 Linux 3.13-rc8)
Merging arm-current/fixes (d326b65c57d6 ARM: fix building with gcc 4.6.4)
Merging m68k-current/for-linus (56931d73697c m68k/mac: Make SCC reset work =
more reliably)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (b3084f4db3ae powerpc/thp: Fix crash on mremap)
Merging sparc/master (9b0cd304f26b Merge branch 'drm-next' of git://people.=
freedesktop.org/~airlied/linux)
Merging net/master (028b86b7671d Merge branch 'fixes' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/jesse/openvswitch)
Merging ipsec/master (965cdea82569 dccp: catch failed request_module call i=
n dccp_probe init)
Merging sound-current/for-linus (276ab336b4c6 ALSA: hda - Improve loopback =
path lookups for AD1983)
Merging pci-current/for-linus (38dbfb59d117 Linus 3.14-rc1)
Merging wireless/master (348f7d4adee9 rtl8180: Add error check for pci_map_=
single return value in TX path)
Merging driver-core.current/driver-core-linus (da9846ae1518 kernfs: make ke=
rnfs_deactivate() honor KERNFS_LOCKDEP flag)
Merging tty.current/tty-linus (38dbfb59d117 Linus 3.14-rc1)
Merging usb.current/usb-linus (7f196caffbf2 usb: core: Fix potential memory=
 leak adding dyn USBdevice IDs)
Merging staging.current/staging-linus (5a819ed6d4bb staging: imx-drm: Fix b=
uild error)
Merging char-misc.current/char-misc-linus (38dbfb59d117 Linus 3.14-rc1)
Merging input-current/for-linus (55df811f2066 Merge branch 'next' into for-=
linus)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (ee97dc7db4cb crypto: s390 - fix des and des3=
_ede ctr concurrency issue)
Merging ide/master (9b0cd304f26b Merge branch 'drm-next' of git://people.fr=
eedesktop.org/~airlied/linux)
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
Merging drm-intel-fixes/for-linux-next-fixes (bdde5c6a258a drm/i915: demote=
 opregion excessive timeout WARN_ONCE to DRM_INFO_ONCE)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (36dd18037119 ARC: add uImage to .gitignore)
Merging arm/for-next (58b9ef24dc72 Merge branch 'cubox-i-init' into for-nex=
t)
Merging arm-perf/for-next/perf (38dbfb59d117 Linus 3.14-rc1)
Merging arm-soc/for-next (034b5c9ffc37 Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (413541dd66d5 Linux 3.13-rc5)
Merging cortex-m/for-next (f41bfc9423aa Merge tag 'ext4_for_linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (059c95a47b13 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (bc25862ad270 Merge branch 'old/mvebu/irqchip' into =
for-next)
Merging renesas/next (0bd47d940e3d Merge branches 'heads/defconfig-for-v3.1=
5', 'heads/soc-for-v3.15', 'heads/boards-for-v3.15' and 'heads/dt-for-v3.15=
' into devel)
Merging samsung/for-next (8109c477487a Merge branch 'v3.14-next/dt-exynos-3=
' into for-next)
Merging tegra/for-next (02a2aa6f9a90 Merge branch for-3.15/defconfig into f=
or-next)
Merging arm64/for-next/core (38dbfb59d117 Linus 3.14-rc1)
Merging blackfin/for-linus (58095fdaaf1c From: Eunbong Song <eunb.song@sams=
ung.com>)
Merging c6x/for-linux-next (546153d75a48 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (44eb66c228fe Hexagon: update CR year for elf.h)
Merging ia64/next (d52eefb47d4e ia64/xen: Remove Xen support for ia64)
Merging m68k/for-next (56931d73697c m68k/mac: Make SCC reset work more reli=
ably)
Merging m68knommu/for-next (72a8ab3cb2a5 m68knommu: fix arg types for outs*=
 functions)
Merging metag/for-next (e9a1d0165bbd metag/smp: Make boot_secondary() stati=
c)
Merging microblaze/next (2984128fc4f5 microblaze: Define readq and writeq I=
O helper function)
Merging mips/mips-for-linux-next (22146fb03c00 Merge branch '3.14-fixes' in=
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
Merging s390/features (05bb2956f28f s390/kvm: set guest page states to stab=
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
Merging cifs/for-next (04a50c7a79ab [CIFS] retrieving CIFS ACLs when mounte=
d with SMB2 fails  dropping session)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (4ea7772f828a udf: Fix lockdep warning from udf_symli=
nk())
Merging ext4/dev (d7092ae2973f ext4: delete "set but not used" variables)
Merging f2fs/dev (e964751c67f1 f2fs: fix f2fs_write_meta_page at no checkpo=
int status)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (b2ec2778df9d fuse: Turn writeback cache on)
Merging gfs2/master (a0846a534c5f GFS2: Lock i_mutex and use a local gfs2_h=
older for fallocate)
Merging jfs/jfs-next (0439e091e3b1 jfs: fix xattr value size overflow in __=
jfs_setxattr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (ef42c58a5b4b Merge branch 'irq-core-for-linus' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging nfsd/nfsd-next (ed47b062ce95 nfsd: consider CLAIM_FH when handing o=
ut delegation)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging ubifs/linux-next (5547fec74a56 UBI: fix some use after free bugs)
Merging xfs/for-next (7c71ee78031c xfs: allow logical-sector sized O_DIRECT)
Merging file-private-locks/linux-next (1ed1950c412f locks: add new fcntl cm=
d values for handling file private locks)
Merging vfs/for-next (527d1511310a Merge branch 'next' of git://git.kernel.=
org/pub/scm/linux/kernel/git/benh/powerpc)
Merging pci/next (17f2d86f5d53 Merge branch 'pci/numa-cleanup' into next)
Merging hid/for-next (f1523dbb7e90 Merge branch 'for-3.15/sony' into for-ne=
xt)
Merging i2c/i2c/for-next (9b0cd304f26b Merge branch 'drm-next' of git://peo=
ple.freedesktop.org/~airlied/linux)
Merging jdelvare-hwmon/master (4fada9bfd39d hwmon: (lm80) Convert to use de=
vm_hwmon_device_register_with_groups)
Merging hwmon-staging/hwmon-next (c9e6f67cddae hwmon: Driver for Linear Tec=
hnologies LTC2945)
Merging v4l-dvb/master (b215621049bd Merge branch 'v4l_for_linus' into to_n=
ext)
Merging kbuild/for-next (ff6b9bdb6263 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (efb9e0f4f437 ata: enable quirk from jmicron JMB350=
 for JMB394)
Merging pm/linux-next (642a859e8c2e Merge branch 'acpi-pci-hotplug-next' in=
to linux-next)
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
Merging slave-dma/next (38dbfb59d117 Linus 3.14-rc1)
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (77d143de7581 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/rw/uml)
Merging ipsec-next/master (abfce3ef58b6 sctp: remove the unnecessary assign=
ment)
Merging wireless-next/master (38dbfb59d117 Linus 3.14-rc1)
Merging bluetooth/master (e3719086ff57 Bluetooth: Use connection parameters=
 if any)
Merging infiniband/for-next (fb1b5034e498 Merge branch 'ip-roce' into for-n=
ext)
Merging mtd/master (0e47c969c65e Merge tag 'for-linus-20140127' of git://gi=
t.infradead.org/linux-mtd)
Merging l2-mtd/master (87a8b7ea1e3f mtd: nand: don't use read_buf for 8-bit=
 ONFI transfers)
Merging crypto/master (79ba451d66ca crypto: aesni - fix build on x86 (32bit=
))
Merging drm/drm-next (ef64cf9d0604 Merge branch 'drm-nouveau-next' of git:/=
/anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next)
Merging drm-intel/for-linux-next (1f70999f9052 drm/i915: Prevent recursion =
by retiring requests when the ring is full)
Merging drm-tegra/drm/for-next (13411ddd3190 drm/tegra: Obtain head number =
from DT)
Merging sound/for-next (3e887f379d8a ALSA: hda - Add mute LED support to Le=
novo Ideapad)
Merging sound-asoc/for-next (cd0409a8d21e Merge remote-tracking branches 'a=
soc/topic/rcar', 'asoc/topic/samsung', 'asoc/topic/simple', 'asoc/topic/tlv=
320aic32x4' and 'asoc/topic/wm8962' into asoc-next)
Merging modules/modules-next (22e669568d51 module: Add missing newline in p=
rintk call.)
Merging virtio/virtio-next (05c54de8c88c drivers: virtio: Mark function vir=
tballoon_migratepage() as static in virtio_balloon.c)
Merging input/next (50fe03da82b4 Input: uinput - add UI_GET_SYSNAME ioctl t=
o retrieve the sysfs path)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging cgroup/for-next (0a6be6555302 nfs: include xattr.h from fs/nfs/nfs3=
proc.c)
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
Merging mfd-lj/for-mfd-next (4d0621451ff2 mfd: wm5110: Make additional DSP =
registers available to the user)
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (cb1fbad7ec25 Merge branches '3.14/fbdev', '3.14=
/dss-misc' and '3.14/dss-fclk' into for-next)
Merging regulator/for-next (6a7c3c7acac9 Merge remote-tracking branches 're=
gulator/topic/gpio', 'regulator/topic/max14577', 'regulator/topic/ti-abb' a=
nd 'regulator/topic/tps6507x' into regulator-next)
Merging security/next (29707b206c51 security: replace strict_strto*() with =
kstrto*())
Merging selinux/next (81c94e76ce8e selinux: fix the output of ./scripts/get=
_maintainer.pl for SELinux)
Merging lblnet/master (07bc9dc1b01b Merge branch 'merge' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (135d65c3b5d3 watchdog: dw_wdt: Add dependency on H=
AS_IOMEM)
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
Merging spi/for-next (fb1295f7c9f3 Merge remote-tracking branches 'spi/topi=
c/pl022', 'spi/topic/rspi', 'spi/topic/samsung', 'spi/topic/sc18is602', 'sp=
i/topic/sirf', 'spi/topic/sunxi', 'spi/topic/tegra114' and 'spi/topic/xfer'=
 into spi-next)
Merging tip/auto-latest (96c7b29d3cf6 Merge branch 'x86/x32')
Merging clockevents/clockevents/next (00e2bcd6d35f clocksource: Timer-sun5i=
: Switch to sched_clock_register())
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (881f0fcef999 EDAC: Don't try to cancel workqueue=
 when it's never setup)
Merging ftrace/for-next (3132e107d608 tracing: Check if tracing is enabled =
in trace_puts())
Merging rcu/rcu/next (98cbc61863d3 Merge commit '0d3c55bc9fd58393bd3bd99749=
91ec1f815e1326' into HEAD)
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
Merging xen-tip/linux-next (afca50132cfa xen/pvh: set CR4 flags for APs)
Merging percpu/for-next (d5f2deed588b Merge branch 'for-3.14' into for-next)
Merging workqueues/for-next (9af16df84f0c Merge branch 'for-3.14' into for-=
next)
Merging drivers-x86/linux-next (b4b0b4a9e039 ipc: add intel-mid's pci id ma=
cros)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (f37d0b3b106a Merge remote-tracking branch 'regmap/=
topic/irq' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (59e35a9e5315 drivers/leds: delete non-required insta=
nces of include <linux/init.h>)
Merging driver-core/driver-core-next (38dbfb59d117 Linus 3.14-rc1)
Merging tty/tty-next (38dbfb59d117 Linus 3.14-rc1)
Merging usb/usb-next (823d12c95c66 usb-storage: enable multi-LUN scanning w=
hen needed)
Merging usb-gadget/next (836a2164491b usb: phy: keystone: remove redundant =
return value check of platform_get_resource())
Merging staging/staging-next (38dbfb59d117 Linus 3.14-rc1)
Merging char-misc/char-misc-next (38dbfb59d117 Linus 3.14-rc1)
Merging scsi/for-next (3ce438df1068 [SCSI] hpsa: allow SCSI mid layer to ha=
ndle unit attention)
Merging target-updates/for-next (5259a06ef970 target: Fix percpu_ref_put ra=
ce in transport_lun_remove_cmd)
Merging target-merge/for-next-merge (374b105797c3 Linux 3.13-rc3)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (5b232c5addc0 pinctrl: tegra: return correct error=
 type)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (a3485d088516 gpio: consumer.h: Move forward declarat=
ions outside #ifdef)
Merging dma-mapping/dma-mapping-next (5e01dc7b26d9 Linux 3.12)
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
$ git checkout -b akpm remotes/origin/akpm/master
Applying: fs/udf/super.c: add __init to init_inodecache()
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: mm: add strictlimit knob
Merging akpm/master (04bf9c82343f mm: add strictlimit knob)

--Signature=_Fri__7_Feb_2014_13_59_24_+1100_l4GBr6E1M5.EMG2a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS9EwRAAoJEMDTa8Ir7ZwVfpwP/iw/aTDsS9SmwQ2AyWcGrVc4
h4jh3Z51aaWbTlosSHCa5WSI+YmYzP2uPANLJn8VdrOix8qLVGU1X/kOA0oC5KU2
wzu9wpEyGpCOpyNP/W2JcNvDU+Fwk2LtitIoUdomHF6s1DwSVbwbxoEQMV9LEU2n
4VBySMAxy96xt3Zs7/g+uwD1W7mKJxawVY2JGW0mmMPEC4xLKivM1trWAAumU6mm
W+wNnMFWnJJq8c7SsBCFeqDu727/NMfRlk6UTSR7cu/DmOQvMd+OSMS9gfihC+Ux
2CYwCymzfFSi4M19jUyAOSB79mZRRG0/qohQ8LvpT0DxTZe6Nny/qZOecthl5sA6
wR7DxO1EKEXEQa4CO0L1MrxXDBDyvlpujNkNkQrTRpQLdik+fR3VnvauqNAMSlnW
Tz27fYPAublTBHOnCeeaYzEa9Wys4y/Hq4NV2hS/+dnNXHkrRSWZzU0DK3JfHxDN
Y3N3J+Iy+8RottxAGB2p+pOAnSW2ExSAwcZsKFuM6ZrC9HVWBPi1sx/rm/UYUg2r
Hqbpa6Ifeo8ILbNHeyu9TIWjbkLXLCxGAAyxihCshg6tT9srwB/CPUmKNzmfFvbO
a9Xv/I66AbEeJQ6MWLEpXuJJnn/llLZnL5Ise0Uy7Au0GTIa/vNP2rwwGWeRnt/Y
Rxqw4BntyZ12Pqipf69f
=8SAY
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Feb_2014_13_59_24_+1100_l4GBr6E1M5.EMG2a--
