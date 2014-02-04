Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaBDFHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 00:07:20 -0500
Received: from ozlabs.org ([203.10.76.45]:53685 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbaBDFHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 00:07:11 -0500
Date: Tue, 4 Feb 2014 16:07:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 4
Message-Id: <20140204160704.0cf4cb0ccf45f413056e7f34@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Feb_2014_16_07_04_+1100_8ZK6lMltmfBMzDV6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Feb_2014_16_07_04_+1100_8ZK6lMltmfBMzDV6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree fails (more than usual) the powerpc allyesconfig build.

Changes since 20140203:

Dropped tree: parisc-hd

Undropped tree: btrfs

The parisc-hd tree gained conflicts against its rebased version in Linus'
tree, so I dropped it for today.

The powerpc tree still had its build failure.

The btrfs tree lost its conflicts against Linus' tree so it is back.

The init tree lost a patch.

Non-merge commits (relative to Linus' tree): 1151
 1636 files changed, 25791 insertions(+), 10541 deletions(-)

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
Merging origin/master (38dbfb59d117 Linus 3.14-rc1)
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (19514fc665ff arm, kbuild: make "make insta=
ll" not depend on vmlinux)
Merging arc-current/for-curr (7e22e91102c6 Linux 3.13-rc8)
Merging arm-current/fixes (d326b65c57d6 ARM: fix building with gcc 4.6.4)
Merging m68k-current/for-linus (56931d73697c m68k/mac: Make SCC reset work =
more reliably)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (b3084f4db3ae powerpc/thp: Fix crash on mremap)
Merging sparc/master (9b0cd304f26b Merge branch 'drm-next' of git://people.=
freedesktop.org/~airlied/linux)
Merging net/master (b045d37bd68c ip_tunnel: fix panic in ip_tunnel_xmit())
Merging ipsec/master (965cdea82569 dccp: catch failed request_module call i=
n dccp_probe init)
Merging sound-current/for-linus (4fa71c1550a8 ALSA: usb-audio: Add missing =
kconfig dependecy)
Merging pci-current/for-linus (38dbfb59d117 Linus 3.14-rc1)
Merging wireless/master (53d8ab29f8f6 Merge branch 'for-3.14/drivers' of gi=
t://git.kernel.dk/linux-block)
Merging driver-core.current/driver-core-linus (90804ed61f24 Merge branch 'f=
or_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging tty.current/tty-linus (413541dd66d5 Linux 3.13-rc5)
Merging usb.current/usb-linus (90804ed61f24 Merge branch 'for_linus' of git=
://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging staging.current/staging-linus (77d143de7581 Merge branch 'for-linus=
' of git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml)
Merging char-misc.current/char-misc-linus (90804ed61f24 Merge branch 'for_l=
inus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
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
Merging drm-intel-fixes/for-linux-next-fixes (09f2344d0896 drm/i915/bdw: ma=
ke sure south port interrupts are enabled properly v2)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (36dd18037119 ARC: add uImage to .gitignore)
Merging arm/for-next (58b9ef24dc72 Merge branch 'cubox-i-init' into for-nex=
t)
Merging arm-perf/for-next/perf (6ce4eac1f600 Linux 3.13-rc1)
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
Merging mvebu/for-next (39efb8a90bac Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (88c499f14016 Merge branch 'heads/dt-fixes' into next)
Merging samsung/for-next (8109c477487a Merge branch 'v3.14-next/dt-exynos-3=
' into for-next)
Merging tegra/for-next (95e770a5ad96 Merge branch for-3.14/defconfig into f=
or-next)
Merging arm64/for-next/core (c2c93e5b7f3f arm64: mm: Introduce PTE_WRITE)
Merging blackfin/for-linus (58095fdaaf1c From: Eunbong Song <eunb.song@sams=
ung.com>)
Merging c6x/for-linux-next (546153d75a48 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (de44443a45e3 HEXAGON: Remove non existent refer=
ence to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (d52eefb47d4e ia64/xen: Remove Xen support for ia64)
Merging m68k/for-next (56931d73697c m68k/mac: Make SCC reset work more reli=
ably)
Merging m68knommu/for-next (a695b9c8911e m68k : Kill CONFIG_MTD_PARTITIONS)
Merging metag/for-next (e9a1d0165bbd metag/smp: Make boot_secondary() stati=
c)
Merging microblaze/next (2984128fc4f5 microblaze: Define readq and writeq I=
O helper function)
Merging mips/mips-for-linux-next (e7651b819e90 Merge branch 'for-linus' of =
git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (a0254d5f920c parisc: Make EWOULDBLOCK be equal =
to EAGAIN on parisc)
CONFLICT (content): Merge conflict in arch/parisc/include/asm/elf.h
$ git merge --abort
Merging powerpc/next (f878f84373ae powerpc: Wire up sched_setattr and sched=
_getattr syscalls)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (78191cf710b7 s390/uaccess: introduce 'uaccesspt' ker=
nel parameter)
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
Merging f2fs/dev (d891ea23d520 Merge branch 'for-linus' of git://git.kernel=
.org/pub/scm/linux/kernel/git/sage/ceph-client)
Merging fscache/fscache (7c604e5d6e56 FS-Cache: Fix handling of an attempt =
to store a page that is now beyond EOF)
Merging fuse/for-next (b2ec2778df9d fuse: Turn writeback cache on)
Merging gfs2/master (885bceca7ff1 GFS2: Plug on AIL flush)
Merging jfs/jfs-next (0439e091e3b1 jfs: fix xattr value size overflow in __=
jfs_setxattr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (88a78a912ee0 Merge branch 'acl_fixes' into linux-ne=
xt)
Merging nfsd/nfsd-next (ed47b062ce95 nfsd: consider CLAIM_FH when handing o=
ut delegation)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging ubifs/linux-next (c23e9b75ccd0 UBIFS: remove invalid warn msg with =
tst_recovery enabled)
Merging xfs/for-next (7c71ee78031c xfs: allow logical-sector sized O_DIRECT)
Merging file-private-locks/linux-next (1ed1950c412f locks: add new fcntl cm=
d values for handling file private locks)
Merging vfs/for-next (527d1511310a Merge branch 'next' of git://git.kernel.=
org/pub/scm/linux/kernel/git/benh/powerpc)
Merging pci/next (17f2d86f5d53 Merge branch 'pci/numa-cleanup' into next)
Merging hid/for-next (59b459e82f1e Merge branch 'for-3.15/sony' into for-ne=
xt)
Merging i2c/i2c/for-next (9b0cd304f26b Merge branch 'drm-next' of git://peo=
ple.freedesktop.org/~airlied/linux)
Merging jdelvare-hwmon/master (4fada9bfd39d hwmon: (lm80) Convert to use de=
vm_hwmon_device_register_with_groups)
Merging hwmon-staging/hwmon-next (d303b1b5fbb6 hwmon: (k10temp) Add support=
 for Kaveri CPUs)
Merging v4l-dvb/master (167f4555184b Merge branch fixes_for_upstream into t=
o_next)
Merging kbuild/for-next (853e265ed4aa Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (efb9e0f4f437 ata: enable quirk from jmicron JMB350=
 for JMB394)
Merging pm/linux-next (736c38c05cfb Merge branch 'acpi-pci-hotplug' into li=
nux-next)
Merging idle/next (3b4d5c7fec0a tools/power turbostat: introduce -s to dump=
 counters)
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
Merging bluetooth/master (d04261db142d Bluetooth: Add constants for LTK key=
 types)
Merging infiniband/for-next (fb1b5034e498 Merge branch 'ip-roce' into for-n=
ext)
Merging mtd/master (0e47c969c65e Merge tag 'for-linus-20140127' of git://gi=
t.infradead.org/linux-mtd)
Merging l2-mtd/master (0ff76a920e35 mtd: gpmi: add sanity check when mappin=
g DMA for read_buf/write_buf)
Merging crypto/master (79ba451d66ca crypto: aesni - fix build on x86 (32bit=
))
Merging drm/drm-next (ef64cf9d0604 Merge branch 'drm-nouveau-next' of git:/=
/anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next)
Merging drm-intel/for-linux-next (2cac613be8d4 drm/i915: vlv: fix DP PHY lo=
ckup due to invalid PP sequencer setup)
Merging drm-tegra/drm/for-next (13411ddd3190 drm/tegra: Obtain head number =
from DT)
Merging sound/for-next (3e887f379d8a ALSA: hda - Add mute LED support to Le=
novo Ideapad)
Merging sound-asoc/for-next (f6cd1d8dc2cc Merge remote-tracking branches 'a=
soc/topic/simple', 'asoc/topic/tlv320aic32x4' and 'asoc/topic/wm8962' into =
asoc-next)
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
Merging device-mapper/for-next (254068f1404c dm cache: do not add migration=
 to completed list before unhooking bio)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (945be38caa28 mmc: sdhci-pci: Fix possibility of chip-=
>fixes being null)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (26e4f2057516 slub: Fix possible format string bug.)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (7da9d450ab28 md/raid5: close recently introduced race =
in stripe_head management.)
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
Merging regulator/for-next (f8331d726b31 Merge remote-tracking branches 're=
gulator/topic/gpio', 'regulator/topic/max14577' and 'regulator/topic/ti-abb=
' into regulator-next)
Merging security/next (923b49ff69fc Merge branch 'master' of git://git.infr=
adead.org/users/pcmoore/selinux into next)
Merging selinux/next (41be702a542a Merge tag 'v3.13' into next)
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
Merging devicetree/devicetree/next (cf4c9eb5a451 of: make of_get_phy_mode p=
arse 'phy-connection-type')
Merging dt-rh/for-next (e48ca29d30a1 dt-bindings: add rockchip vendor prefi=
x)
Merging spi/for-next (05a3c122041e Merge remote-tracking branches 'spi/topi=
c/sirf', 'spi/topic/tegra114' and 'spi/topic/xfer' into spi-next)
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
Merging kvm-ppc/kvm-ppc-next (4068890931f6 KVM: PPC: Book3S PR: Cope with d=
oorbell interrupts)
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
Merging leds/for-next (3cb6f44aedf5 leds: s3c24xx: Remove hardware.h inclus=
ion)
Merging driver-core/driver-core-next (90804ed61f24 Merge branch 'for_linus'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging tty/tty-next (4fbd269f1f9f Merge branch 'fixes' into tty-next)
Merging usb/usb-next (90804ed61f24 Merge branch 'for_linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging usb-gadget/next (836a2164491b usb: phy: keystone: remove redundant =
return value check of platform_get_resource())
Merging staging/staging-next (d7216f8f02da staging: r8821ae: Enable build b=
y reverting BROKEN marking)
Merging char-misc/char-misc-next (90804ed61f24 Merge branch 'for_linus' of =
git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging scsi/for-next (3ce438df1068 [SCSI] hpsa: allow SCSI mid layer to ha=
ndle unit attention)
Merging target-updates/for-next (5259a06ef970 target: Fix percpu_ref_put ra=
ce in transport_lun_remove_cmd)
Merging target-merge/for-next-merge (374b105797c3 Linux 3.13-rc3)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (fa74d0d3e30c pinctrl: sirf: correct the pin index=
 of ac97_pins group)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (cffcc92e9669 gpio: xtensa: fix build when XCHAL_HAVE=
_CP is 0)
Merging dma-mapping/dma-mapping-next (5e01dc7b26d9 Linux 3.12)
Merging pwm/for-next (6691a19966f0 pwm: tiecap: Remove duplicate put_sync c=
all)
Merging dma-buf/for-next (0e47c969c65e Merge tag 'for-linus-20140127' of gi=
t://git.infradead.org/linux-mtd)
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
Merging akpm-current/current (0fc6f4e2e3d5 splice: fix unexpected size trun=
cation)
CONFLICT (content): Merge conflict in mm/slab_common.c
CONFLICT (content): Merge conflict in mm/rmap.c
CONFLICT (content): Merge conflict in mm/page_alloc.c
CONFLICT (content): Merge conflict in mm/oom_kill.c
CONFLICT (content): Merge conflict in mm/nobootmem.c
CONFLICT (content): Merge conflict in mm/mm_init.c
CONFLICT (content): Merge conflict in mm/mempolicy.c
CONFLICT (content): Merge conflict in mm/memcontrol.c
CONFLICT (content): Merge conflict in mm/memblock.c
CONFLICT (content): Merge conflict in lib/vsprintf.c
CONFLICT (content): Merge conflict in lib/swiotlb.c
CONFLICT (content): Merge conflict in lib/percpu_counter.c
CONFLICT (content): Merge conflict in lib/dma-debug.c
CONFLICT (content): Merge conflict in ipc/util.c
CONFLICT (content): Merge conflict in ipc/compat_mq.c
CONFLICT (content): Merge conflict in include/linux/vm_event_item.h
CONFLICT (content): Merge conflict in include/linux/posix_acl.h
CONFLICT (content): Merge conflict in include/linux/fsnotify_backend.h
CONFLICT (content): Merge conflict in include/linux/bootmem.h
CONFLICT (content): Merge conflict in fs/posix_acl.c
CONFLICT (content): Merge conflict in fs/notify/notification.c
CONFLICT (content): Merge conflict in fs/notify/inotify/inotify_fsnotify.c
CONFLICT (content): Merge conflict in fs/notify/fanotify/fanotify_user.c
CONFLICT (add/add): Merge conflict in fs/notify/fanotify/fanotify.h
CONFLICT (content): Merge conflict in fs/notify/fanotify/fanotify.c
CONFLICT (content): Merge conflict in fs/afs/proc.c
CONFLICT (content): Merge conflict in arch/x86/mm/srat.c
CONFLICT (content): Merge conflict in arch/arm/kernel/setup.c
CONFLICT (content): Merge conflict in Documentation/sysctl/kernel.txt
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/ven=
dor-prefixes.txt
Applying: nobootmem: fix mismerge
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: mm: add strictlimit knob
Merging akpm/master (3e254746c94b mm: add strictlimit knob)
$ git checkout -b init remotes/origin/init/master
Applying: init: delete the __cpuinit related stubs
Applying: mm: replace module_init usages with subsys_initcall in nommu.c
Applying: fs/notify: don't use module_init for non-modular inotify_user code
Applying: netfilter: don't use module_init/exit in core IPV4 code
Applying: x86: don't use module_init in non-modular intel_mid_vrtc.c
Applying: x86: don't use module_init for non-modular core bootflag code
Applying: x86: replace __init_or_module with __init in non-modular vsmp_64.c
Applying: x86: don't use module_init in non-modular devicetree.c code
Applying: drivers/tty/hvc: don't use module_init in non-modular hyp. consol=
e code
Applying: staging: don't use module_init in non-modular ion_dummy_driver.c
Applying: powerpc: use device_initcall for registering rtc devices
Applying: powerpc: use subsys_initcall for Freescale Local Bus
Applying: powerpc: don't use module_init for non-modular core hugetlb code
Applying: powerpc: don't use module_init in non-modular 83xx suspend code
Applying: arm: include module.h in drivers/bus/omap_l3_smx.c
Applying: arm: fix implicit module.h use in mach-at91 gpio.h
Applying: arm: fix implicit #include <linux/init.h> in entry asm.
Applying: arm: mach-s3c64xx mach-crag6410-module.c is not modular
Applying: arm: use subsys_initcall in non-modular pl320 IPC code
Applying: arm: don't use module_init in non-modular mach-vexpress/spc.c code
Applying: alpha: don't use module_init for non-modular core code
Applying: m68k: don't use module_init in non-modular mvme16x/rtc.c code
Applying: ia64: don't use module_init for non-modular core kernel/mca.c code
Applying: ia64: don't use module_init in non-modular sim/simscsi.c code
Applying: mips: make loongsoon serial driver explicitly modular
Applying: mips: don't use module_init in non-modular sead3-mtd.c code
Applying: cris: don't use module_init for non-modular core intmem.c code
Applying: parisc: don't use module_init for non-modular core pdc_cons code
Applying: parisc64: don't use module_init for non-modular core perf code
Applying: mn10300: don't use module_init in non-modular flash.c code
Applying: sh: don't use module_init in non-modular psw.c code
Applying: sh: mach-highlander/psw.c is tristate and should use module.h
Applying: xtensa: don't use module_init for non-modular core network.c code
Applying: drivers/clk: don't use module_init in clk-nomadik.c which is non-=
modular
Applying: cpuidle: don't use modular platform register in non-modular ARM d=
rivers
Applying: drivers/platform: don't use modular register in non-modular pdev_=
bus.c
Applying: module: relocate module_init from init.h to module.h
Applying: logo: emit "#include <linux/init.h> in autogenerated C file
Applying: arm: delete non-required instances of include <linux/init.h>
Applying: mips: restore init.h usage to arch/mips/ar7/time.c
Applying: s390: delete non-required instances of include <linux/init.h>
Applying: alpha: delete non-required instances of <linux/init.h>
Applying: powerpc: delete another unrequired instance of <linux/init.h>
Applying: arm64: delete non-required instances of <linux/init.h>
Applying: watchdog: delete non-required instances of include <linux/init.h>
Applying: video: delete non-required instances of include <linux/init.h>
Applying: rtc: delete non-required instances of include <linux/init.h>
Applying: scsi: delete non-required instances of include <linux/init.h>
Applying: acpi: delete non-required instances of include <linux/init.h>
Applying: drivers/power: delete non-required instances of include <linux/in=
it.h>
Applying: drivers/media: delete non-required instances of include <linux/in=
it.h>
Applying: drivers/ata: delete non-required instances of include <linux/init=
.h>
Applying: drivers/hwmon: delete non-required instances of include <linux/in=
it.h>
Applying: drivers/pinctrl: delete non-required instances of include <linux/=
init.h>
Applying: drivers/isdn: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/leds: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/pcmcia: delete non-required instances of include <linux/i=
nit.h>
Applying: drivers/char: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/infiniband: delete non-required instances of include <lin=
ux/init.h>
Applying: drivers/mfd: delete non-required instances of include <linux/init=
.h>
Applying: drivers/gpio: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/bluetooth: delete non-required instances of include <linu=
x/init.h>
Applying: drivers/mmc: delete non-required instances of include <linux/init=
.h>
Applying: drivers/crypto: delete non-required instances of include <linux/i=
nit.h>
Applying: drivers/platform: delete non-required instances of include <linux=
/init.h>
Applying: drivers/misc: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/edac: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/macintosh: delete non-required instances of include <linu=
x/init.h>
Applying: drivers/base: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/cpufreq: delete non-required instances of <linux/init.h>
Applying: drivers/pci: delete non-required instances of <linux/init.h>
Applying: drivers/dma: delete non-required instances of <linux/init.h>
Applying: drivers/gpu: delete non-required instances of <linux/init.h>
Applying: drivers: delete remaining non-required instances of <linux/init.h>
Applying: include: remove needless instances of <linux/init.h>
Merging init/master (5085d0405af0 include: remove needless instances of <li=
nux/init.h>)

--Signature=_Tue__4_Feb_2014_16_07_04_+1100_8ZK6lMltmfBMzDV6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS8HV8AAoJEMDTa8Ir7ZwVXEAP/34uFCs5OTcXFZRO+VJgtbT6
/Gx8qDETksnLclff9FKFvdSq6Ck4lhc/LsbWZ9nuKdKLLCjX2OJjXq3BRTLgg5QL
GDBeoLW38Syie29AaGJZTkRHmQbF4nqr7jwxLGT1G1+mHw3QiEPSCVX8TAdTVMoA
IUXcDYLD0BL1K5PZ0dOBzEo41I1egGxJ3X4bTD+z7F7YIf4BL4t+/a76BSqs8BPV
gaGm/A8A/kxDFQNsKX104MpQ+xt2X4Ma7IsoAN0l9S82/MM+ZboDq7UiLPw+wW8u
sVDmcral1QlkvVXOREmhdrIWyMtt4nZyFRf+mXW9sTKf6DAV1id1BXb87THhYU1H
jf7ruY+9MGCAgvBThVlO+KMziywCA5TpGTbBL+i5mC0HHfMZtK8am0vuVkOYygZQ
EeSlJcmtVIm8M2Cidr796MXw8ScQp4FkXf1Q3yx+vJ6F4XZfyNtUBTPf6mp3aMzu
lDIZ3OUTjQqeNCxqvKXAj7BbvAzHMS+rggcfSbBeo8vVJm3mjhm8YVQ02s5Rwdzs
w9sj/F4uh7B7qw0F6gtRDxNe9cQSYJlH/WM/63U7FaMezBPSmPNHrANP+MLkdSaj
Fz0q+rWOMFD9dI2+/SN2SY/af5EMuXUu7ISXosGZWlorgRpU0uSu3FgGyH9U6YZY
Wd7i7P2HGacV2SDm/Uw0
=9iK6
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Feb_2014_16_07_04_+1100_8ZK6lMltmfBMzDV6--
