Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbaCUH0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 03:26:43 -0400
Received: from ozlabs.org ([203.10.76.45]:58335 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbaCUH0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 03:26:39 -0400
Date: Fri, 21 Mar 2014 18:26:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Mar 21
Message-Id: <20140321182631.9382a691db34e4c84065e5c1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Mar_2014_18_26_31_+1100_ipPI5rN25_Ef2PRw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Mar_2014_18_26_31_+1100_ipPI5rN25_Ef2PRw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree still fails (more than usual) the powerpc allyesconfig build.

Changes since 20140320:

The powerpc tree still had its build failure.

The omap_dss2 tree gained a conflict the pm tree.

The tip tree gained a conflict against Linus' tree.

The akpm tree gained a conflict the tip tree.

Non-merge commits (relative to Linus' tree): 9784
 9231 files changed, 743192 insertions(+), 512178 deletions(-)
(the shortstat with -M -C looks like this:
 8612 files changed, 409985 insertions(+), 205863 deletions(-)
so there is a bit of movement of files going on.)

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
allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
defconfig.

Below is a summary of the state of the merge.

I am currently merging 213 trees (counting Linus' and 28 trees of patches
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
Merging origin/master (3fb725c48b93 Merge branch 'upstream' of git://git.li=
nux-mips.org/pub/scm/ralf/upstream-linus)
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (7e22e91102c6 Linux 3.13-rc8)
Merging arm-current/fixes (95c52fe06335 ARM: 8007/1: Remove extraneous kcmp=
 syscall ignore)
Merging m68k-current/for-linus (7247f55381d5 m68k: Wire up sched_setattr an=
d sched_getattr)
Merging metag-fixes/fixes (0414855fdc4a Linux 3.14-rc5)
Merging powerpc-merge/merge (a5b2cf5b1af4 powerpc: Align p_dyn, p_rela and =
p_st symbols)
Merging sparc/master (151b628f1045 sparc64:tsb.c:use array size macro rathe=
r than number)
Merging net/master (b74d3feccc3f Merge branch 'fixes' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/jesse/openvswitch)
Merging ipsec/master (3e3d35402140 ATHEROS-ATL1E: Convert iounmap to pci_io=
unmap)
Merging sound-current/for-linus (749d32237bf3 ALSA: compress: Pass through =
return value of open ops callback)
Merging pci-current/for-linus (707d4eefbdb3 Revert "[PATCH] Insert GART reg=
ion into resource map")
Merging wireless/master (584221918925 Revert "rt2x00: rt2800lib: Update BBP=
 register initialization for RT53xx")
Merging driver-core.current/driver-core-linus (0414855fdc4a Linux 3.14-rc5)
Merging tty.current/tty-linus (0414855fdc4a Linux 3.14-rc5)
Merging usb.current/usb-linus (fa389e220254 Linux 3.14-rc6)
Merging staging.current/staging-linus (dcb99fd9b08c Linux 3.14-rc7)
Merging char-misc.current/char-misc-linus (0414855fdc4a Linux 3.14-rc5)
Merging input-current/for-linus (70b0052425ff Input: da9052_onkey - use cor=
rect register bit for key status)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (ee97dc7db4cb crypto: s390 - fix des and des3=
_ede ctr concurrency issue)
Merging ide/master (5b40dd30bbfa ide: Fix SC1200 dependencies)
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
Merging drm-intel-fixes/for-linux-next-fixes (24bd9bf54d45 drm/i915: Fix PS=
R programming)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (fef289567354 ARC: [clockevent] simplify timer ISR)
Merging arm/for-next (54740e1ee0fe Merge branch 'devel-stable' into for-nex=
t)
Merging arm-kvm-cpuresume/arm-kvm-cpuresume (91a3f6af430d arm: kernel: slee=
p: restore HYP mode configuration in cpu_resume)
Merging arm-perf/for-next/perf (6d0abeca3242 Linux 3.14-rc3)
Merging arm-soc/for-next (0a3ce8b9f611 arm-soc list new merges)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/keystone-clocks.dtsi
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (9d18d1dc7b14 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (5c0426dcd386 Merge branch 'for_3.15/dts_2' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (97623e934388 Merge branch 'mvebu/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging renesas/next (68d1f3aad83a Merge branch 'heads/clock-for-v3.15' int=
o next)
Merging samsung/for-next (82cd4473bde8 Merge branch 'v3.15-next/cleanup-exy=
nos' into for-next)
Merging tegra/for-next (3e00824db87f Merge branch for-3.15/defconfig into f=
or-next)
Merging arm64/for-next/core (9c7e535fcc17 arm64: mm: Route pmd thp function=
s through pte equivalents)
Merging blackfin/for-linus (58095fdaaf1c From: Eunbong Song <eunb.song@sams=
ung.com>)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (44eb66c228fe Hexagon: update CR year for elf.h)
Merging ia64/next (e8e98a566c71 Merge branch 'pstore' into next)
Merging m68k/for-next (eff9cf8d6e8b [SCSI] atari_scsi: Fix sleep_on race)
Merging m68knommu/for-next (4dc5aa217237 m68knommu: fix arg types for outs*=
 functions)
Merging metag/for-next (2aca46ce1b5c sched: remove unused SCHED_INIT_NODE)
Merging microblaze/next (cff2ee046e06 microblaze: Wire-up new system calls =
sched_setattr/getattr)
Merging mips/mips-for-linux-next (edb778195a07 Merge branch '3.14-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging powerpc/next (c7e64b9ce04a powerpc/powernv Platform dump interface)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (454bb787bfab remove unecessary parameter from pgste_=
ipte_notify)
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (620830b69549 perf tools: Allow building for tile)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (b3fdfc1b4b64 Merge tag 'xtensa-for-next-20140221-1=
' into for_next)
Merging btrfs/next (cf93da7bcf45 Btrfs: fix spin_unlock in check_ref_cleanu=
p)
Merging ceph/master (bee26897097f libceph: a per-osdc crush scratch buffer)
Merging cifs/for-next (33807f4f0dae Merge branch 'for-next' of git://git.sa=
mba.org/sfrench/cifs-2.6)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (f294d3e7be28 ext3: explicitly remove inode from orph=
an list after failed direct io)
Merging ext4/dev (2c74cd642a46 ext4: each filesystem creates and uses its o=
wn mb_cache)
Merging f2fs/dev (d0482c047eb7 f2fs: change reclaim rate in percentage)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (b2ec2778df9d fuse: Turn writeback cache on)
Merging gfs2/master (733dbc1b21dc GFS2: inline function gfs2_set_mode)
Merging jfs/jfs-next (844fa1b5f849 jfs: set i_ctime when setting ACL)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (494314c415e2 SUNRPC: rpc_restart_call/rpc_restart_c=
all_prepare should clear task->tk_status)
Merging nfsd/nfsd-next (1406b916f4a2 nfsd: fix lost nfserrno() call in nfsd=
_setattr())
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging ubifs/linux-next (463c5eedb4a1 UBI: make UBI_IOCVOLCRBLK take a par=
ameter for future usage)
Merging xfs/for-next (fe986f9d88ab Merge branch 'xfs-O_TMPFILE-support' int=
o for-next)
Merging file-private-locks/linux-next (bef6f44d4e51 locks: make locks_manda=
tory_area check for file-private locks)
Merging vfs/for-next (527d1511310a Merge branch 'next' of git://git.kernel.=
org/pub/scm/linux/kernel/git/benh/powerpc)
Merging pci/next (30723cbf6f7a Merge branch 'pci/resource' into next)
CONFLICT (content): Merge conflict in drivers/ata/ahci.c
Merging hid/for-next (df31872aa93e Merge branch 'for-3.15/multitouch' into =
for-next)
CONFLICT (content): Merge conflict in drivers/hid/i2c-hid/i2c-hid.c
CONFLICT (content): Merge conflict in drivers/hid/hid-sony.c
CONFLICT (content): Merge conflict in drivers/hid/hid-ids.h
CONFLICT (content): Merge conflict in drivers/hid/hid-core.c
Merging i2c/i2c/for-next (0ff83d2cad1a i2c: exynos5: remove unnecessary cas=
t of void pointer)
Merging jdelvare-hwmon/master (c1d70b646dae hwmon: (lm90) Convert to use hw=
mon_device_register_with_groups)
Merging hwmon-staging/hwmon-next (a2e151074366 hwmon: (pmbus/ltc2978) Add n=
ew chip ID for LTC2974)
Merging v4l-dvb/master (e4b7327bd03b Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (8f2f9b9f06da Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (3d374c09daac Merge branch 'for-3.15' into for-next)
Merging pm/linux-next (916f2dfbf369 Merge branch 'cpu-hotplug' into linux-n=
ext)
Merging idle/next (62eec04c7fa3 Merge branch 'turbostat' into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (e79ca84d62d2 Merge branches 'soc-fix' and 'thermal-co=
re-fix' of .git into next)
Merging ieee1394/for-next (0ca49345b6f4 firewire: ohci: fix probe failure w=
ith Agere/LSI controllers)
Merging dlm/next (075f01775f53 dlm: use INFO for recovery messages)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (598b2856862d Merge branch 'for-linus' into next)
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (a85ae0e97879 Merge branch 'bcmgenet-next')
Merging ipsec-next/master (3ab428a4c5ad netfilter: Add missing vmalloc.h in=
clude to nft_hash.c)
Merging wireless-next/master (67b3bd4e65f0 brcmfmac: fallback to mimo_bw_ca=
p for older firmwares)
Merging bluetooth/master (61b1a7fbda6f Bluetooth: Fix address value for ear=
ly disconnection events)
Merging infiniband/for-next (e51ec8b4b041 Merge branches 'core', 'cxgb4', '=
iser', 'misc', 'mlx4', 'nes', 'ocrdma', 'qib' and 'usnic' into for-next)
Merging mtd/master (fa389e220254 Linux 3.14-rc6)
Merging l2-mtd/master (d9ba46d32c0e mtd: st_spi_fsm: Succinctly reorganise =
.remove())
Merging crypto/master (26a05489ee0e crypto: omap-sham - Map SG pages if the=
y are HIGHMEM before accessing)
Merging drm/drm-next (e84c20aff1ce drm/radeon/kms: merge conflicted badly)
Merging drm-intel/for-linux-next (4726e0b045b8 drm/i915: Enabling 128x128 a=
nd 256x256 ARGB Cursor Support)
Merging drm-tegra/drm/for-next (c1a68b4c29b8 drm/tegra: Add eDP support)
Merging sound/for-next (2df6742f6138 ALSA: hda - verify pin:cvt connection =
on preparing a stream for Intel HDMI codec)
CONFLICT (content): Merge conflict in sound/soc/kirkwood/Kconfig
Merging sound-asoc/for-next (bb4d25576fcc Merge remote-tracking branches 'a=
soc/topic/simple' and 'asoc/topic/sirf' into asoc-next)
Merging modules/modules-next (c6bda7c988a5 kallsyms: fix percpu vars on x86=
-64 with relocation.)
Merging virtio/virtio-next (70670444c20a virtio: fail adding buffer on brok=
en queues.)
Merging input/next (7fb45edba8b5 Input: imx_keypad - Propagate the real err=
or code on platform_get_irq() failure)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (75e14e1b3ba7 Merge branch 'for-3.15/core' into for-=
next)
CONFLICT (content): Merge conflict in fs/bio-integrity.c
CONFLICT (content): Merge conflict in block/blk-mq.c
Merging device-mapper/for-next (2ef30d539ae4 Merge branch 'for-linus' into =
for-next)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (655bca7616bf mmc: sdhci: Allow for irq being shared)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (26e4f2057516 slub: Fix possible format string bug.)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (789b5e031528 md/raid5: Fix CPU hotplug callback regist=
ration)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (204747c970c0 mfd: kempld-core: Fix potential h=
ang-up during boot)
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (d754589d8044 OMAPDSS: add missing __init for ds=
s_init_ports)
CONFLICT (content): Merge conflict in drivers/video/Makefile
Merging regulator/for-next (df5e84401a7f Merge remote-tracking branches 're=
gulator/topic/tps65910', 'regulator/topic/tps80031', 'regulator/topic/wm831=
x', 'regulator/topic/wm8350' and 'regulator/topic/wm8994' into regulator-ne=
xt)
Merging security/next (f64410ec6654 selinux: correctly label /proc inodes i=
n use before the policy is loaded)
Merging selinux/next (eee3094683fb selinux: correctly label /proc inodes in=
 use before the policy is loaded)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (fa62c102a75e watchdog: Fix Elan SC520 dependencies)
CONFLICT (content): Merge conflict in drivers/watchdog/orion_wdt.c
CONFLICT (content): Merge conflict in drivers/watchdog/Kconfig
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (db6659a7ad28 Merge branches 'iommu/fixes', 'arm/smmu', =
'x86/amd', 'arm/omap', 'arm/shmobile' and 'x86/vt-d' into next)
Merging vfio/next (9d830d47c7a7 kvm/vfio: Support for DMA coherent IOMMUs)
Merging osd/linux-next (19350e7627a6 exofs: Print less in r4w)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (2509671dcf63 isdn: capi: fix "CAPI_VERSION" comme=
nt)
Merging audit/master (80e0b6e8a001 sched: declare pid_alive as inline)
CONFLICT (content): Merge conflict in kernel/audit.c
CONFLICT (content): Merge conflict in init/Kconfig
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/mips/include/asm/syscall.h
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (ca3992bc0c12 Merge branch 'devicetree/n=
ext-reserved-mem' into devicetree/next)
CONFLICT (content): Merge conflict in include/asm-generic/vmlinux.lds.h
CONFLICT (content): Merge conflict in drivers/of/of_net.c
Merging dt-rh/for-next (6f976267da0e of: add missing major vendors)
Merging spi/for-next (a5c9bf7d831e Merge remote-tracking branches 'spi/topi=
c/topcliff-pch', 'spi/topic/txx9', 'spi/topic/xcomm', 'spi/topic/xfer', 'sp=
i/topic/xilinx' and 'spi/topic/xtfpga' into spi-next)
Merging tip/auto-latest (e2c479cc9dca Merge branch 'x86/x32')
CONFLICT (rename/delete): drivers/video/fbdev/sgivwfb.c deleted in tip/auto=
-latest and renamed in HEAD. Version HEAD of drivers/video/fbdev/sgivwfb.c =
left in tree.
CONFLICT (content): Merge conflict in drivers/video/Makefile
CONFLICT (content): Merge conflict in drivers/video/Kconfig
CONFLICT (content): Merge conflict in drivers/pci/Makefile
CONFLICT (content): Merge conflict in drivers/clocksource/Kconfig
CONFLICT (modify/delete): arch/x86/pci/visws.c deleted in tip/auto-latest a=
nd modified in HEAD. Version HEAD of arch/x86/pci/visws.c left in tree.
CONFLICT (modify/delete): arch/x86/pci/numaq_32.c deleted in tip/auto-lates=
t and modified in HEAD. Version HEAD of arch/x86/pci/numaq_32.c left in tre=
e.
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/perf_event_intel_=
uncore.c
CONFLICT (content): Merge conflict in arch/x86/include/asm/topology.h
CONFLICT (content): Merge conflict in arch/arm/mach-zynq/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Kconfig
CONFLICT (modify/delete): arch/arm/mach-imx/pm-imx6q.c deleted in HEAD and =
modified in tip/auto-latest. Version tip/auto-latest of arch/arm/mach-imx/p=
m-imx6q.c left in tree.
$ git rm -f arch/x86/pci/numaq_32.c arch/x86/pci/visws.c drivers/video/fbde=
v/sgivwfb.c arch/arm/mach-imx/pm-imx6q.c
Applying: video: fbdev: fix up fro removal of SGI Visual Workstation
Applying: arm: Replace various irq_desc accesses fix for file move
Merging clockevents/clockevents/next (09e15176ded1 clocksource: exynos_mct:=
 silence a static checker warning)
Merging edac/linux_next (49856dc973cd sb_edac: mark MCE messages as KERN_DE=
BUG)
Merging edac-amd/for-next (c045ebdf6079 Merge branch 'edac-for-3.15' into f=
or-next)
Merging ftrace/for-next (cb1deb5fc1fd Merge branch 'trace/ftrace/core' into=
 trace/for-next)
Merging rcu/rcu/next (f5604f67fe8c Merge branch 'torture.2014.02.23a' into =
HEAD)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (94b3ffcd41a9 Merge tag 'kvm-s390-20140317' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD)
CONFLICT (content): Merge conflict in arch/s390/include/asm/kvm_host.h
Merging kvm-arm/kvm-arm-next (b73117c49364 Merge branch 'kvm-ppc-next' of g=
it://github.com/agraf/linux-2.6 into kvm-queue)
Merging kvm-ppc/kvm-ppc-next (b73117c49364 Merge branch 'kvm-ppc-next' of g=
it://github.com/agraf/linux-2.6 into kvm-queue)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (d511ede4c7bb Merge branch 'devel/for-linus-3.15=
' into linux-next)
CONFLICT (content): Merge conflict in drivers/xen/events/events_base.c
Merging percpu/for-next (2f69fa829cb4 percpu: allocation size should be eve=
n)
Merging workqueues/for-next (a54b24be0cf1 Merge branch 'for-3.15' into for-=
next)
Merging drivers-x86/linux-next (b4b0b4a9e039 ipc: add intel-mid's pci id ma=
cros)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (f18efdf2f70e Merge remote-tracking branches 'regma=
p/topic/cache', 'regmap/topic/irq', 'regmap/topic/lock', 'regmap/topic/node=
v', 'regmap/topic/parse-val' and 'regmap/topic/patch' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (0016db26c093 leds: clevo-mail: Make probe function _=
_init)
Merging driver-core/driver-core-next (b7ce40cff0b9 kernfs: cache atomic_wri=
te_len in kernfs_open_file)
CONFLICT (content): Merge conflict in arch/x86/Kconfig
$ git am -3 ../patches/0001-Revert-sysfs-driver-core-remove-unused-sysfs-de=
vice-.patch
Applying: Revert "sysfs, driver-core: remove unused {sysfs|device}_schedule=
_callback_owner()"
Merging tty/tty-next (3a13884abea0 tty/serial: omap: empty the RX FIFO at t=
he end of half-duplex TX)
Merging usb/usb-next (1d10255c1c49 USB: disable reset-resume when USB_QUIRK=
_RESET is set)
CONFLICT (content): Merge conflict in drivers/usb/core/hub.c
CONFLICT (content): Merge conflict in drivers/phy/Kconfig
CONFLICT (content): Merge conflict in arch/sh/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Kconfig
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/phy=
/samsung-phy.txt
Merging usb-gadget/next (4b76e14d95f7 phy: ti-pipe3: Add SATA compatible to=
 Documentation binding)
Merging staging/staging-next (b6512cfcd279 staging: comedi: poc: remove obs=
olete driver)
CONFLICT (content): Merge conflict in drivers/usb/core/devio.c
CONFLICT (content): Merge conflict in drivers/staging/wlan-ng/cfg80211.c
CONFLICT (content): Merge conflict in drivers/staging/media/msi3101/sdr-msi=
3101.c
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/parallel-disp=
lay.c
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-tve.c
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-ldb.c
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-hdmi.c
CONFLICT (content): Merge conflict in drivers/media/v4l2-core/v4l2-of.c
CONFLICT (content): Merge conflict in drivers/media/platform/exynos4-is/fim=
c-is.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53-qsb.dts
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/iio=
/adc/at91_adc.txt
Applying: ARM: dts: i.MX53: merge fix patch
Merging char-misc/char-misc-next (1b3fa22e0234 Merge tag 'extcon-next-for-3=
.15' of git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon into c=
har-misc-next)
Merging cgroup/for-next (7a7fc4540679 Merge branch 'for-3.15' into for-next)
CONFLICT (content): Merge conflict in mm/memcontrol.c
Applying: cgroup: fix up for kernfs_mount API change
Merging scsi/for-next (1de14f4f2984 [SCSI] ses: Use vpd information from sc=
si_device)
Merging target-updates/for-next (7c934004b64f Target/iser: Fail SCSI WRITE =
command if device detected integrity error)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (43f23a0660fa pinctrl: tegra: add some missing Teg=
ra114 entries)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (2ba933eddc3b Merge branch 'devel' into for-next)
CONFLICT (content): Merge conflict in drivers/gpio/gpio-ich.c
Merging dma-mapping/dma-mapping-next (68efd7d2fb32 arm: dma-mapping: remove=
 order parameter from arm_iommu_create_mapping())
Merging pwm/for-next (7eb3f6ffb5c3 pwm: Add CLPS711X PWM support)
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging dma-buf/for-next (dcb99fd9b08c Linux 3.14-rc7)
Merging userns/for-next (d211f177b28e audit: Update kdoc for audit_send_rep=
ly and audit_list_rules_send)
Merging ktest/for-next (62183dcac539 ktest: Set CLOSE_CONSOLE_SIGNAL in the=
 kvm.conf)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (35c1983ef79f MAINTAINERS: use LKML for common clk fra=
mework)
Merging random/dev (91a60dc7aa88 random: Add arch_has_random[_seed]())
CONFLICT (content): Merge conflict in arch/x86/include/asm/archrandom.h
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (e0f5e0add36d aio, mem-hotplug: Add memory barrier to ai=
o ring page migration.)
Merging llvmlinux/for-next (bd01eebf365a x86, acpi: LLVMLinux: Remove neste=
d functions from Thinkpad ACPI)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
CONFLICT (content): Merge conflict in arch/powerpc/platforms/powernv/opal-w=
rappers.S
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/opal.h
Merging compat/compat (f5b972e9fbd2 compat: include linux/unistd.h within l=
inux/compat.h)
CONFLICT (content): Merge conflict in ipc/compat_mq.c
CONFLICT (content): Merge conflict in fs/compat.c
Merging akpm-current/current (3611f0abb13d ipc: use device_initcall)
CONFLICT (content): Merge conflict in fs/fs-writeback.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: Kconfig: rename HAS_IOPORT to HAS_IOPORT_MAP
Applying: kernel: use macros from compiler.h instead of __attribute__((...))
Applying: asm/system.h: clean asm/system.h from docs
Applying: asm/system.h: um: arch_align_stack() moved to asm/exec.h
Applying: memcg, slab: never try to merge memcg caches
Applying: memcg, slab: cleanup memcg cache creation
Applying: memcg, slab: separate memcg vs root cache creation paths
Applying: memcg, slab: unregister cache from memcg before starting to destr=
oy it
Applying: memcg, slab: do not destroy children caches if parent has aliases
Applying: slub: adjust memcg caches when creating cache alias
Applying: slub: rework sysfs layout for memcg caches
Applying: slub: fix leak of 'name' in sysfs_slab_add
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: percpu: add raw_cpu_ops
Applying: mm: use raw_cpu ops for determining current NUMA node
Applying: modules: use raw_cpu_write for initialization of per cpu refcount.
Applying: net: replace __this_cpu_inc in route.c with raw_cpu_inc
Applying: percpu: add preemption checks to __this_cpu ops
Applying: preemption_checks: avoid snprintf before checking error conditions
Applying: percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fix=
es
Applying: lglock: map to spinlock when !CONFIG_SMP
Applying: x86/mm: sparse warning fix for early_memremap
Applying: mm: create generic early_ioremap() support
Applying: x86: use generic early_ioremap
CONFLICT (content): Merge conflict in arch/x86/include/asm/Kbuild
Applying: arm64: initialize pgprot info earlier in boot
Applying: arm64: add early_ioremap support
Applying: doc/kernel-parameters.txt: add early_ioremap_debug
Applying: fs/ufs/super.c: add __init to init_inodecache()
Applying: fs/ufs: remove unused ufs_super_block_first pointer
Applying: fs/ufs: remove unused ufs_super_block_second pointer
Applying: fs/ufs: remove unused ufs_super_block_third pointer
Applying: ufs: sb mutex merge + mutex_destroy
Applying: mm: add strictlimit knob
Merging akpm/master (9dd3774eed43 mm: add strictlimit knob)

--Signature=_Fri__21_Mar_2014_18_26_31_+1100_ipPI5rN25_Ef2PRw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTK+mrAAoJEMDTa8Ir7ZwVYe8QAIy9H+utEOwfcQSqwgGxovtd
MK7YHUHtwTFuh7BT1Zf2OQUBX7vzByx6MPWuRBpzLge/fkvYjRmzxHGEzOUz6++M
sUjlKhBExrEN5vJH5rYOT5CBpbKX+vl3vdGVQzOKOeD3uMmz1LOFcXhMhUONN1Rb
RTGc3KgOpisc8tAKRU1oGks62PVDU9fC6r26DAEhtW4KFKDXY3rzWNrZW8wDPMNB
9KqetlS7AaVcDn4txSx5DyU0lNEmFQHOoy3gWhx67MZz8L2IvMWPmiq/ExI2Uxe6
CcXIRuNQsMAzvrwuDloGgqQWoWN5kDGOgoQWRp0fdR+PJtRQbXW5NP+JfTlabLgL
05DrhB1U+ovipVjfRkCStAf2/OmeVRhXCAUfD27u+e15BSGVOO7VBRr+FydvL55y
7npIvr6RZp+c2xfjFqMydngdk4hXAHWRm04WwzBNixmjm4uoXSIitzL+lmKJfq6s
3URN6/+u14pTa+cZdXTZA/vR85xy3Io1THjyJagEV9YRDS/UDd4hoQuDLMMucGlq
ae33oVWSM/vwu7dvODSUIi+QzWSXwwMp+efR/N+hfdbaBwJ6fAtJMINOCh/c257C
65xZnGU59LyjphobILr9Drk40UA3VMi9qtpC8m4KbldKt3t636GKfmeIedlDgLmF
V4xX7m8+Dlz1BEHn2S5h
=xO1D
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Mar_2014_18_26_31_+1100_ipPI5rN25_Ef2PRw--
