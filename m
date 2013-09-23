Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3IWHhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:37:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54316 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3IWHhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:37:39 -0400
Date: Mon, 23 Sep 2013 17:37:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Sep 23
Message-Id: <20130923173732.c7c46576b63965b0f4e56504@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Sep_2013_17_37_32_+1000_UqJ_6hJzReh38JUq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Sep_2013_17_37_32_+1000_UqJ_6hJzReh38JUq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Heads up: I will be having a 3 week break leading up to the kernel
summit.  This means that next-20130927 (next Friday) will be the last
linux-next release until next-20131028 (or maybe 29).  I presume that
Linus will be up to v3.12-rc7 by then and -rc7 is often the last before
a release ... Please plan accordingly.

Changes since 20130920:

Removed trees: ocfs2 (at Andrew Morton's request)
	ibft and tmem (finished with)

The omap_dss2 tree gained a conflict against the fbdev tree.

The staging tree gained conflicts against the staging.current tree.

The pinctrl tree still had its build failure.

The random tree gained a conflict against Linus' tree, a sightly
concerning warning and a build failure for which I reverted a commit.

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
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups (if any), it is also built with powerpc allnoconfig (32 and
64 bit), ppc44x_defconfig and allyesconfig (minus
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc,
sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 215 trees (counting Linus' and 30 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

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
Merging origin/master (68cf8d0 Merge branch 'for-3.12/core' of git://git.ke=
rnel.dk/linux-block)
Merging fixes/master (fa8218d Merge tag 'regmap-v3.11-rc7' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/broonie/regmap)
Merging kbuild-current/rc-fixes (ad81f05 Linux 3.11-rc1)
Merging arc-current/for-curr (272b98c Linux 3.12-rc1)
Merging arm-current/fixes (46ec667 ARM: 7839/1: entry: fix tracing of ARM-p=
rivate syscalls)
Merging m68k-current/for-linus (21e884b m68k/m68knommu: Implement __get_use=
r_unaligned/__put_user_unaligned())
Merging metag-fixes/fixes (3b2f64d Linux 3.11-rc2)
Merging powerpc-merge/merge (363edbe powerpc: Default arch idle could cede =
processor on pseries)
Merging sparc/master (4de9ad9 Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/cmetcalf/linux-tile)
Merging net/master (da7add3 Merge branch 'sfc-3.12' of git://git.kernel.org=
/pub/scm/linux/kernel/git/bwh/sfc)
Merging ipsec/master (33fce60 xfrm: Guard IPsec anti replay window against =
replay bitmap)
Merging sound-current/for-linus (4028b6c ALSA: compress: Fix compress devic=
e unregister.)
Merging pci-current/for-linus (a923874 Merge tag 'pci-v3.12-changes' of git=
://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci)
Merging wireless/master (f4e1a4d rt2800: change initialization sequence to =
fix system freeze)
Merging driver-core.current/driver-core-linus (272b98c Linux 3.12-rc1)
Merging tty.current/tty-linus (93a8d41 n_tty: Fix EOF push index when termi=
os changes)
Merging usb.current/usb-linus (42f4891 Merge tag 'fixes-for-v3.12-rc2' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus)
Merging staging.current/staging-linus (6174081 Merge tag 'iio-fixes-for-3.1=
2a' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging=
-linus)
Merging char-misc.current/char-misc-linus (272b98c Linux 3.12-rc1)
Merging input-current/for-linus (2f0d260 Input: i8042 - i8042_flush fix for=
 a full 8042 buffer)
Merging md-current/for-linus (f94c0b6 md/raid5: fix interaction of 'replace=
' and 'recovery'.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (26052f9 crypto: crct10dif - Add fallback for=
 broken initrds)
Merging ide/master (64110c1 ide: sgiioc4: Staticize ioc4_ide_attach_one())
Merging dwmw2/master (5950f08 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging devicetree-current/devicetree/merge (cf9e236 of/irq: init struct re=
source to 0 in of_irq_to_resource())
Merging rr-fixes/fixes (6c2580c Merge branch 'for-linus' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32)
Merging mfd-fixes/master (5649d8f mfd: ab8500-sysctrl: Let sysctrl driver w=
ork without pdata)
Merging vfio-fixes/for-linus (d24cdbf vfio-pci: Avoid deadlock on remove)
Merging drm-intel-fixes/for-linux-next-fixes (9c46bd7 drm/i915: Use a tempo=
rary va_list for two-pass string handling)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (d8dfad3 Linux 3.11-rc7)
Merging arm/for-next (6a16730 Merge branches 'devel-stable', 'fixes', 'misc=
' and 'mmci' into for-next)
Merging arm-perf/for-next/perf (e65c630 Merge branch 'for-arm-soc/cci-pmu-v=
2' into for-next/perf)
Merging arm64/upstream (25804e6 arm64: Widen hwcap to be 64 bit)
Merging blackfin/for-linus (08b67fa blackfin: Ignore generated uImages)
Merging c6x/for-linux-next (1a81b94 c6x: remove unused parameter in Kconfig)
Merging cris/for-next (be8cb7f CRIS: drop unused Kconfig symbols)
Merging h8300-remove/h8300-remove (e9783b0 Revert "drivers: parport: Kconfi=
g: exclude h8300 for PARPORT_PC")
Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference =
to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (d37bbb3 Merge branch 'pstore' into next)
Merging m68k/for-next (21e884b m68k/m68knommu: Implement __get_user_unalign=
ed/__put_user_unaligned())
Merging m68knommu/for-next (c065edd m68k: remove 16 unused boards in Kconfi=
g.machine)
Merging metag/for-next (b6ef916 irq-imgpdc: add ImgTec PDC irqchip driver)
Merging microblaze/next (d5d04bb Bye, bye, WfW flag)
Merging mips/mips-for-linux-next (e285039 Merge branch '3.12-fixes' into mi=
ps-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (9f0f4fb parisc: add generic 32- and 64-bit defc=
onfigs)
Merging powerpc/next (8d7551e Merge tag 'cris-for-3.12' of git://jni.nu/cri=
s)
Merging mpc5xxx/next (f2110cb dts: mpc512x: prepare for preprocessor suppor=
t)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (044aa01 s390/krobes: allow kprobes only on known ins=
tructions)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (e823acc tile: remove stray blank space)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (8872366 xtensa: Fix broken allmodconfig build)
Merging aio-direct/for-next (85f8fb7 tmpfs: add support for read_iter and w=
rite_iter)
Merging btrfs/next (d7396f0 Btrfs: optimize key searches in btrfs_search_sl=
ot)
Merging ceph/master (9c89d62 fscache: check consistency does not decrement =
refcount)
Merging cifs/for-next (74d290d [CIFS] Provide sane values for nlink)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (3cc69b6 Merge tag 'fixes-for-linus' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging ext3/for_next (97a2847 Merge branch 'for-3.12' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jeffm/linux-reiserfs into for_next_testing)
Merging ext4/dev (ad4eec6 ext4: allow specifying external journal by pathna=
me mount option)
Merging f2fs/dev (26b0332 Merge tag 'dmaengine-3.12' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/djbw/dmaengine)
Merging fscache/fscache (19ce0a7 CIFS: FS-Cache: Uncache unread pages in ci=
fs_readpages() before freeing them)
Merging fuse/for-next (c8ffe72 cuse: add fix minor number to /dev/cuse)
Merging gfs2/master (149ed7f GFS2: new function gfs2_rbm_incr)
Merging jfs/jfs-next (8660998 jfs: fix error path in ialloc)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (c43a385 Merge tag 'nfs-for-3.12-3' of git://git.lin=
ux-nfs.org/projects/trondmy/linux-nfs)
Merging nfsd/nfsd-next (d4a5165 rpc: let xdr layer allocate gssproxy receie=
ve pages)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (9e01242 Squashfs: add corruption check for type in=
 squashfs_readdir())
Merging v9fs/for-next (50192ab fs/9p: avoid accessing utsname after namespa=
ce has been torn down)
Merging ubifs/linux-next (c23e9b7 UBIFS: remove invalid warn msg with tst_r=
ecovery enabled)
Merging xfs/for-next (272b98c Linux 3.12-rc1)
Merging vfs/for-next (dc03a60 do_remount(): pull touch_mnt_namespace() up)
CONFLICT (content): Merge conflict in fs/nfs/file.c
CONFLICT (content): Merge conflict in fs/nfs/direct.c
Merging pci/next (a923874 Merge tag 'pci-v3.12-changes' of git://git.kernel=
.org/pub/scm/linux/kernel/git/helgaas/pci)
Merging hid/for-next (2f39579 Merge branch 'for-3.12/upstream' into for-nex=
t)
Merging i2c/i2c/for-next (b720423 i2c: rcar: add rcar-H2 support)
Merging jdelvare-hwmon/master (e5c832d vfs: fix dentry RCU to refcounting p=
ossibly sleeping dput())
Merging hwmon-staging/hwmon-next (bf7ae49 hwmon: (jc42) fix coccinelle warn=
ings)
Merging v4l-dvb/master (d6cd75e Merge branch 'patchwork' into to_next)
CONFLICT (content): Merge conflict in drivers/media/platform/s5p-mfc/s5p_mf=
c_dec.c
Merging kbuild/for-next (1e1a5f4 Merge branch 'kbuild/kconfig' into kbuild/=
for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (5748aea pata_isapnp: Don't use invalid I/O ports)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (d831a00 Merge branch 'pm-cpufreq')
Merging idle/next (d7b0a1b intel_idle: Support Intel Atom Processor C2000 P=
roduct Family)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (50e66c7 drivers: thermal: add check when unregisterin=
g cpu cooling)
Merging ieee1394/for-next (db9ae8f firewire: ohci: Fix deadlock at bus rese=
t)
Merging ubi/linux-next (8930fa5 UBI: Fix invalidate_fastmap())
Merging dlm/next (c6ca7bc dlm: remove signal blocking)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging slave-dma/next (9be1d5a Merge branch 'for-linus' into next)
Merging dmaengine/next (4a43f39 dmaengine: dma_sync_wait and dma_find_chann=
el undefined)
Merging net-next/master (e4cb29f tg3: Update version to 3.134)
Merging ipsec-next/master (aba8269 {ipv4,xfrm}: Introduce xfrm_tunnel_notif=
ier for xfrm tunnel mode callback)
CONFLICT (content): Merge conflict in include/net/xfrm.h
Merging wireless-next/master (f212781 net: ipv6: mld: document force_mld_ve=
rsion in ip-sysctl.txt)
Merging bluetooth/master (941247f Bluetooth: Fix assignment of 0/1 to bool =
variables)
Merging infiniband/for-next (82af24a Merge branches 'cxgb4', 'flowsteer', '=
ipoib', 'iser', 'mlx4', 'ocrdma' and 'qib' into for-next)
Merging mtd/master (ef9a61b Merge tag 'for-linus-20130909' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (8126f4e mtd: atmel_nand: use minimum ecc requirement=
s of nand: ecc_{strength,step}_ds)
Merging crypto/master (1005bcc crypto: caam - enable instantiation of all R=
NG4 state handles)
Merging drm/drm-next (86a7e12 Merge branch 'exynos-drm-next' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos into drm-next)
Merging drm-intel/for-linux-next (1c87288 drm/i915: Drop explicit plane res=
toration during resume)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_drv.h
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem.c
Merging drm-tegra/drm/for-next (03da0e7 drm/tegra: Parse device tree earlie=
r)
Merging sound/for-next (43cdd08 Merge branch 'for-linus' into for-next)
Merging sound-asoc/for-next (1ee9213 Merge remote-tracking branch 'asoc/top=
ic/wm8400' into asoc-next)
Merging modules/modules-next (942e443 module: Fix mod->mkobj.kobj potential=
ly freed too early)
Merging virtio/virtio-next (9e266ec virtio_pci: pm: Use CONFIG_PM_SLEEP ins=
tead of CONFIG_PM)
Merging input/next (9a35c41 Input: wacom - add support for three new Intuos=
 Pro devices)
Merging input-mt/for-next (ad81f05 Linux 3.11-rc1)
Merging cgroup/for-next (58b79a9 cgroup: fix cgroup post-order descendant w=
alk of empty subtree)
Merging block/for-next (808854a Merge branch 'for-3.12/core' into for-next)
Merging device-mapper/for-next (b210a3e dm: add reserved_bio_based_ios modu=
le parameter)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (272b98c Linux 3.12-rc1)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (23774a2 slab: Use correct GFP_DMA constant)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (bfc90cb raid5: only wakeup necessary threads)
Merging mfd/master (9c31e88 Merge tag 'mfd-lee-3.12-2' of git://git.linaro.=
org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (9989253 mfd: wm5110: Update noise gate default=
 to match the patch file)
Merging battery/master (db15e63 rx51_battery: Fix channel number when readi=
ng adc value)
Merging fbdev/for-next (5e8be02 video: atmel_lcdfb: add device tree suport)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (da22fd5 Merge branches '3.13/fbdev-misc' and '3=
.13/hdmi-regs' into for-next)
CONFLICT (content): Merge conflict in drivers/video/atmel_lcdfb.c
Merging regulator/for-next (96b49e4 Merge remote-tracking branch 'regulator=
/topic/tps6524x' into regulator-next)
Merging security/next (7320336 Merge branch 'smack-for-3.12' of git://git.g=
itorious.org/smack-next/kernel into ra-next)
Merging selinux/master (7a36283 selinux: add Paul Moore as a SELinux mainta=
iner)
Merging lblnet/master (07bc9dc Merge branch 'merge' of git://git.kernel.org=
/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (272b98c Linux 3.12-rc1)
Merging dwmw2-iommu/master (e5d0c87 Merge tag 'iommu-updates-v3.12' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (d6a60fc Merge branches 'arm/exynos', 'ppc/pamu', 'arm/s=
mmu', 'x86/amd' and 'iommu/fixes' into next)
Merging vfio/next (dac09b5 vfio: fix documentation)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (2e515bf Merge branch 'for-linus' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/jikos/trivial)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging devicetree/devicetree/next (2bc552d of/platform: add error reportin=
g to of_amba_device_create())
Merging dt-rh/for-next (8851b9f include: dt-binding: input: create a DT hea=
der defining key codes.)
Merging spi/for-next (d8c363d Merge remote-tracking branch 'spi/topic/tegra=
' into spi-next)
Merging tip/auto-latest (3ef354f Merge branch 'x86/urgent')
CONFLICT (modify/delete): include/linux/time-armada-370-xp.h deleted in HEA=
D and modified in tip/auto-latest. Version tip/auto-latest of include/linux=
/time-armada-370-xp.h left in tree.
$ git rm -f include/linux/time-armada-370-xp.h
Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescen=
ce of IMC_DDRIO device)
Merging edac-amd/for-next (75a9551 cpc925_edac: Use proper array terminatio=
n)
Merging ftrace/for-next (a0a5a05 ftrace/rcu: Do not trace debug_lockdep_rcu=
_enabled())
Merging rcu/rcu/next (25f27ce Merge branches 'doc.2013.08.19a', 'fixes.2013=
.08.20a', 'sysidle.2013.08.31a' and 'torture.2013.08.20a' into HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (272b98c Linux 3.12-rc1)
Merging kvm-arm/kvm-arm-next (1fe40f6 ARM: KVM: Add newlines to panic strin=
gs)
Merging kvm-ppc/kvm-ppc-next (6b9e4fa Merge tag 'kvm-arm-for-3.12' of git:/=
/git.linaro.org/people/cdall/linux-kvm-arm into queue)
Merging oprofile/for-next (f722406 Linux 3.10-rc1)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen-tip/linux-next (5582c05 Merge remote branch 'xentip/stable/for-=
linus-3.12' into linux-next)
Merging percpu/for-next (abec1a8 percpu: Make __verify_pcu_ptr handle per c=
pu pointers to arrays)
Merging workqueues/for-next (016564d workqueue: fix pool ID allocation leak=
age and remove BUILD_BUG_ON() in init_workqueues)
Merging drivers-x86/linux-next (5c07eae platform/x86: panasonic-laptop: reu=
se module_acpi_driver)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (dfa6f4c Merge remote-tracking branch 'regmap/topic=
/range' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (271c111 leds: dac124s085: Remove redundant spi_set_d=
rvdata)
Merging driver-core/driver-core-next (272b98c Linux 3.12-rc1)
Merging tty/tty-next (272b98c Linux 3.12-rc1)
Merging usb/usb-next (c8f2efc usbcore: fix read of usbdevfs_ctrltransfer fi=
elds in proc_control())
Merging usb-gadget/next (272b98c Linux 3.12-rc1)
Merging staging/staging-next (3ffdea3 Merge tag 'iio-for-3.13a' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-next)
CONFLICT (content): Merge conflict in drivers/iio/industrialio-event.c
CONFLICT (content): Merge conflict in drivers/iio/industrialio-buffer.c
Merging char-misc/char-misc-next (272b98c Linux 3.12-rc1)
Merging scsi/for-next (fc85799 [SCSI] fnic: fnic Driver Tuneables Exposed t=
hrough CLI)
Merging target-updates/for-next (2999ee7 target/iscsi: Bump versions to v4.=
1.0)
Merging target-merge/for-next-merge (d4e4ab8 Linux 3.11-rc5)
Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging writeback/writeback-for-next (a885599 writeback: Do not sort b_io l=
ist only because of block device inode)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (99917a1 Merge branch 'devel' into for-next)
$ git reset --hard HEAD^
Merging next-20130919 version of pinctrl
Merging vhost/linux-next (d3d665a vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging gpio/for-next (1dc9427 gpio: bcm-kona: only use set_irq_flags() on =
ARM)
Merging arm-soc/for-next (55a9e7c Merge tag 'davinci-fixes-for-v3.12-rc2-v2=
' of git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci in=
to fixes)
Merging bcm2835/for-next (7d13205 Linux 3.10-rc6)
Merging cortex/for-next (3ad87ac ARM: ARMv7-M: Fix name of NVIC handler fun=
ction)
Merging ep93xx/ep93xx-for-next (6868a89 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging imx-mxs/for-next (b736164 Merge branches 'imx/fixes', 'imx/soc' and=
 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (8fb0bf1 Merge branch 'for-3.12/msm-cleanup2' into for=
-next)
Merging mvebu/for-next (67f6928 Merge branch 'mvebu/dove_pcie-mbus-dt' into=
 for-next)
Merging renesas/next (b5f3bed Merge branches 'heads/clocksource-fixes-for-v=
3.12', 'heads/fixes-for-v3.12', 'heads/defconfig', 'heads/smp', 'heads/dt' =
and 'heads/boards' into devel)
Merging samsung/for-next (28ca23d Merge branch 'v3.13-next/dt-s3c64xx' into=
 for-next)
Merging tegra/for-next (2b6d21a Merge branch for-3.13/maintainers into for-=
next)
Merging dma-mapping/dma-mapping-next (d5d04bb Bye, bye, WfW flag)
Merging pwm/for-next (ceb12f9 pwm: atmel-tcb: fix max time computation for =
slow clk source)
Merging dma-buf/for-next (19e8697 dma-buf: Expose buffer size to userspace =
(v2))
Merging userns/for-next (c7b96ac userns:  Kill nsown_capable it makes the w=
rong thing easy)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (12d29886 clk: only call get_parent if there is one)
Merging random/dev (0c14243 random: adjust the generator polynomials in the=
 mixing function slightly)
CONFLICT (content): Merge conflict in init/main.c
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484 ARM64: mm: THP support.)
Merging aio/master (d9b2c87 aio: rcu_read_lock protection for new rcu_deref=
erence calls)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (736b0d3 ipc/util.c: remove unnecessary work p=
ending test)
CONFLICT (content): Merge conflict in kernel/reboot.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: nouveau: fix build eror when VGA_SWITCHEROO is not enabled
Applying: mm: drop actor argument of do_generic_file_read()
Applying: mm-drop-actor-argument-of-do_generic_file_read-fix
Merging akpm/master (e068c56 mm-drop-actor-argument-of-do_generic_file_read=
-fix)
[master e06476f] Revert "random: allow architectures to optionally define r=
andom_get_entropy()"

--Signature=_Mon__23_Sep_2013_17_37_32_+1000_UqJ_6hJzReh38JUq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSP+/BAAoJEECxmPOUX5FE5aAP/1Bj4LuF4hAZujUebPY3Xk3C
Fic3M/zSc8xdBjBTNG4b5Ls9vSfm5y+pn5l/CF5ipLEDibNYuW+zbxjRxOng0z0k
+FeL8XIF/331dwDbedClEYAYmC0trrsny4131PIPHkI5/8thOTeUa27MN/NCFroK
o2JdlNyJycUe2/LNjax/WQLQk86buB+tWyC/lndJ9SdFQdHW7dB5U4tQBOHWPl81
joSCpsEji1hqoJ85gXkAQd5yL+PmIM59gI2A1k0k9ucTin68pvspzANDQa6L5erW
MD4x1wRS78crKKpemKtGn2e4Jol17UoUag3m2NEkgJoNPfcuiK5CmTZSfacjqmJK
dvMxblsi82WABgd6BMRQLvyQSCl04CcyAh4mPicCYPiCubgTS3nXjO16QC4hned/
ezS9aphxL22Aq5C9Nm/Ym1sYBZ000/+lLsN4c3BnTAe+0IoHJQ3BE60GlnoOhku9
K3j1n+zttfL7Lw39cgkeWqXxrM3dU5janm2WYmPyyPhaDhRFtrB0h8S/+Z5DOLjA
GMQkJnrVrMe2fGa4vq/mWAOo3XuxUOJfGRaYFw9B6Yva/z+fpzsA3KrF9LiycnR0
GSr02nPSO64c5TJ4quWItXFuhM/Wmvu6nyEo9y+ev266+DpGkrWLUwv6tY+c3P3M
GC++8ZbVUI/HAMsXLMEc
=OeAU
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Sep_2013_17_37_32_+1000_UqJ_6hJzReh38JUq--
