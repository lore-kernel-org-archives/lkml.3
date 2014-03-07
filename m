Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbaCGFgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:36:46 -0500
Received: from ozlabs.org ([203.10.76.45]:42574 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaCGFgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:36:42 -0500
Date: Fri, 7 Mar 2014 16:36:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Mar 7
Message-Id: <20140307163635.042fe222dabd596d7e08c841@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Mar_2014_16_36_35_+1100_P0zmDa.w5mgPROTm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Mar_2014_16_36_35_+1100_P0zmDa.w5mgPROTm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I am on vacation for the next week.  Mark or Thierry may do some releases
during the week, otherwise the next linux-next will be next-20140317
(which will be about when -rc7 is released).

This tree fails (more than usual) the powerpc allyesconfig build.

Changes since 20140305:

New trees: arm-kvm-cpuresume, powernv-cpuidle

The powerpc tree still had its build failure.

The wireless-next tree lost one if its build failures so I reverted a
commit and disabled a staging driver.  It also gained a conflict against
the net-next tree.

The char-misc tree still had its 2 build failures for which I reverted 2
commits.

The akpm-current tree lost its build failure (a patch was supplied).

The akpm tree lost its build failures.

Non-merge commits (relative to Linus' tree): 6268
 6776 files changed, 585647 insertions(+), 447033 deletions(-)
(the shortstat with -M -C looks like this:
 6173 files changed, 260027 insertions(+), 142456 deletions(-)
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

I am currently merging 212 trees (counting Linus' and 28 trees of patches
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
Merging origin/master (c3bebc71c4bc Merge git://git.kernel.org/pub/scm/linu=
x/kernel/git/davem/net)
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
Merging sparc/master (e58e241c1788 sparc: serial: Clean up the locking for =
-rt)
Merging net/master (c88507fbad80 ipv6: don't set DST_NOCOUNT for remotely a=
dded routes)
Merging ipsec/master (3a9016f97fdc xfrm: Fix unlink race when policies are =
deleted.)
Merging sound-current/for-linus (e805ca8b0a9b ALSA: usb-audio: Add quirk fo=
r Logitech Webcam C500)
Merging pci-current/for-linus (fc40363b2140 ahci: Fix broken fallback to si=
ngle MSI mode)
Merging wireless/master (d51246481c7f mwifiex: save and copy AP's VHT capab=
ility info correctly)
Merging driver-core.current/driver-core-linus (0414855fdc4a Linux 3.14-rc5)
Merging tty.current/tty-linus (0414855fdc4a Linux 3.14-rc5)
Merging usb.current/usb-linus (0414855fdc4a Linux 3.14-rc5)
Merging staging.current/staging-linus (084b6e7765b9 staging/cxt1e1/linux.c:=
 Correct arbitrary memory write in c4_ioctl())
Merging char-misc.current/char-misc-linus (0414855fdc4a Linux 3.14-rc5)
Merging input-current/for-linus (70b0052425ff Input: da9052_onkey - use cor=
rect register bit for key status)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (ee97dc7db4cb crypto: s390 - fix des and des3=
_ede ctr concurrency issue)
Merging ide/master (a259d5320537 m68k/atari - ide: do not register interrup=
t if host->get_lock is set)
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
Merging arm-kvm-cpuresume/arm-kvm-cpuresume (fb195f2e59ff arm: kernel: slee=
p: restore HYP mode configuration in cpu_resume)
Merging arm-perf/for-next/perf (8e781f65423c ARM: perf: add support for the=
 Cortex-A12 PMU)
Merging arm-soc/for-next (55b8643f045c arm-soc: add description for bcm/dri=
vers branch)
Merging bcm2835/for-next (8ac06bb693ca Merge branch 'for-3.15/dt' into for-=
next)
CONFLICT (modify/delete): arch/arm/mach-bcm2835/Kconfig deleted in bcm2835/=
for-next and modified in HEAD. Version HEAD of arch/arm/mach-bcm2835/Kconfi=
g left in tree.
$ git rm -f arch/arm/mach-bcm2835/Kconfig
Applying: ARM: bcm2835: merge fix for movement to mach-bcm directory
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (454eefde1139 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (5c0426dcd386 Merge branch 'for_3.15/dts_2' into next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/keystone-clocks.dtsi
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (ec94690dfcef Merge branch 'mvebu/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/ven=
dor-prefixes.txt
Merging renesas/next (3ad15c3429ba Merge branches 'heads/soc-for-v3.15' and=
 'heads/clock-for-v3.15' into next)
Merging samsung/for-next (941e7012a3b9 Merge branch 'v3.15-next/clk-s3c24xx=
' into for-next)
Merging tegra/for-next (3e00824db87f Merge branch for-3.15/defconfig into f=
or-next)
Merging arm64/for-next/core (f6e763b93a6c arm64: topology: Implement basic =
CPU topology support)
Merging blackfin/for-linus (58095fdaaf1c From: Eunbong Song <eunb.song@sams=
ung.com>)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (44eb66c228fe Hexagon: update CR year for elf.h)
Merging ia64/next (d21114236d0e Fix warning in make defconfig)
Merging m68k/for-next (631b789a5795 scsi: atari_scsi: Fix sleep_on race)
Merging m68knommu/for-next (72a8ab3cb2a5 m68knommu: fix arg types for outs*=
 functions)
Merging metag/for-next (e9a1d0165bbd metag/smp: Make boot_secondary() stati=
c)
Merging microblaze/next (1cbe158dec8c microblaze: Drop architecture-specifi=
c declaration of early_printk)
Merging mips/mips-for-linux-next (5914ff7d9191 Merge branch '3.14-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging powerpc/next (e0cf95761497 powerpc/powernv: Fix indirect XSCOM unma=
ngling)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (d72d2bb5a6bc s390/checksum: remove memset() within c=
sum_partial_copy_from_user())
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (2e285458e62f tile: don't use __get_cpu_var() with stru=
cture-typed arguments)
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
Merging ext3/for_next (d6723257533b ext3: Speedup WB_SYNC_ALL pass)
Merging ext4/dev (137d7cea675f jbd2: don't write non-commit blocks synchron=
ously)
Merging f2fs/dev (c81bf1c84f69 f2fs: fix to write node pages with WRITE_SYN=
C)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (b2ec2778df9d fuse: Turn writeback cache on)
Merging gfs2/master (fc554ed3d89d GFS2: global conversion to pr_foo())
Merging jfs/jfs-next (844fa1b5f849 jfs: set i_ctime when setting ACL)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (755a48a7a4eb NFS: Fix a delegation callback race)
Merging nfsd/nfsd-next (1406b916f4a2 nfsd: fix lost nfserrno() call in nfsd=
_setattr())
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging ubifs/linux-next (8af871887fcb UBI: rename block device ioctls)
Merging xfs/for-next (14e637ca53fa Merge branch 'xfs-verifier-cleanup' into=
 for-next)
Merging file-private-locks/linux-next (8dd55089290b locks: require that flo=
ck->l_pid be set to 0 for file-private locks)
Merging vfs/for-next (527d1511310a Merge branch 'next' of git://git.kernel.=
org/pub/scm/linux/kernel/git/benh/powerpc)
Merging pci/next (89e5b5f8aaaa Merge branch 'pci/resource' into next)
CONFLICT (content): Merge conflict in drivers/ata/ahci.c
Merging hid/for-next (7d2fbfc92be3 Merge branch 'for-3.15/multitouch' into =
for-next)
CONFLICT (content): Merge conflict in drivers/hid/i2c-hid/i2c-hid.c
CONFLICT (content): Merge conflict in drivers/hid/hid-ids.h
CONFLICT (content): Merge conflict in drivers/hid/hid-core.c
Merging i2c/i2c/for-next (80c69915e5fb i2c: mv64xxx: fix circular Kconfig d=
ependency)
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
Merging libata/for-next (d3d9e0b3b01c Merge branch 'for-3.15' into for-next)
Merging pm/linux-next (09f4d0ae2be5 Merge branch 'pm-cpufreq')
Merging idle/next (62eec04c7fa3 Merge branch 'turbostat' into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (e79ca84d62d2 Merge branches 'soc-fix' and 'thermal-co=
re-fix' of .git into next)
Merging ieee1394/for-next (bf36be9dfa4b Merge branch 'workqueue' into for-n=
ext)
Merging dlm/next (075f01775f53 dlm: use INFO for recovery messages)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (53e92720e6d4 Merge branch 'for-linus' into next)
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (28f084cca35a bonding: fix const in options process=
ing)
Merging ipsec-next/master (e50287be7c00 be2net: dma_sync each RX frag befor=
e passing it to the stack)
Merging wireless-next/master (c7c361efc496 mwl8k: mwl8k_update_survey can b=
e static)
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath9k/recv.c
$ git am -3 ../patches/0001-Revert-Revert-Staging-rtl8812ae-remove-modules-=
field.patch
Applying: Revert "Revert "Staging: rtl8812ae: remove modules field of rate_=
control_ops""
Applying: staging: disable Prism2.5/3 USB driver
Merging bluetooth/master (ca58e594da24 Bluetooth: Add a new PID/VID 0cf3/e0=
05 for AR3012.)
Merging infiniband/for-next (7f3c1e1ba82e Merge branches 'cma', 'cxgb4', 'i=
ser', 'misc', 'mlx4', 'mlx5', 'nes', 'ocrdma', 'qib' and 'usnic' into for-n=
ext)
Merging mtd/master (bb38eefb6858 mtd: nand: omap: fix ecclayout->oobfree->l=
ength)
Merging l2-mtd/master (c8e7841316ec mtd: m25p80: add Macronix mx66l1g55g 1G=
bit SPI flash)
Merging crypto/master (c65a52f8360d crypto: ccp - Account for CCP backlog p=
rocessing)
Merging drm/drm-next (786a7828bc74 Merge branch 'drm-next-3.15' of git://pe=
ople.freedesktop.org/~deathsimple/linux into drm-next)
Merging drm-intel/for-linux-next (eb162c62dbeb drm/i915: Implement command =
buffer parsing logic)
Merging drm-tegra/drm/for-next (c1a68b4c29b8 drm/tegra: Add eDP support)
Merging sound/for-next (4913cd6964d9 ALSA: emu10k1: Fix possible NULL deref=
erence)
Merging sound-asoc/for-next (a186b8b35091 Merge remote-tracking branches 'a=
soc/topic/wm9081' and 'asoc/topic/wm9705' into asoc-next)
CONFLICT (content): Merge conflict in sound/soc/kirkwood/Kconfig
Merging modules/modules-next (917307b09ad5 module: remove MODULE_GENERIC_TA=
BLE)
Merging virtio/virtio-next (6f0317058f43 tools/virtio: add a missing ))
Merging input/next (7fb45edba8b5 Input: imx_keypad - Propagate the real err=
or code on platform_get_irq() failure)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (eddf40bd0d65 Merge branch 'for-3.15/core' into for-=
next)
Merging device-mapper/for-next (e3d87c35fed8 dm bitset: only flush the curr=
ent word if it has been dirtied)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (b42b9b12e9b7 mmc: sdhci-spear: use generic card detec=
tion gpio support)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (26e4f2057516 slub: Fix possible format string bug.)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (789b5e031528 md/raid5: Fix CPU hotplug callback regist=
ration)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (5a9dcea4cbb9 mfd: mc13xxx: Add missing spi_set=
up())
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (c5b9e4d745f8 Merge branch '3.15/fb-reorder' int=
o for-next)
Merging regulator/for-next (383136efcf5b Merge remote-tracking branches 're=
gulator/topic/tps65090', 'regulator/topic/tps65217', 'regulator/topic/tps65=
218', 'regulator/topic/tps6524x', 'regulator/topic/tps6586x', 'regulator/to=
pic/tps65910', 'regulator/topic/tps80031', 'regulator/topic/wm831x', 'regul=
ator/topic/wm8350' and 'regulator/topic/wm8994' into regulator-next)
Merging security/next (864f32a52b53 kernel: Mark function as static in kern=
el/seccomp.c)
Merging selinux/next (eee3094683fb selinux: correctly label /proc inodes in=
 use before the policy is loaded)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (db5dd336cb23 watchdog: orion: prepare new Dove DT =
Kconfig variable)
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
Merging trivial/for-next (80dd6eac0090 net-sysfs: fix comment typo 'CONFIG_=
SYFS')
Merging audit/master (f3411cb2b2e3 audit: whitespace fix in kernel-paramete=
rs.txt)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (a3dbeb5b45af Revert "of: fix of_update_=
property()")
CONFLICT (content): Merge conflict in drivers/of/of_net.c
Merging dt-rh/for-next (06b29e76a74b of: search the best compatible match f=
irst in __of_match_node())
Merging spi/for-next (2b67951da816 Merge remote-tracking branches 'spi/topi=
c/sunxi', 'spi/topic/tegra114', 'spi/topic/topcliff-pch', 'spi/topic/txx9',=
 'spi/topic/xcomm', 'spi/topic/xfer' and 'spi/topic/xilinx' into spi-next)
Merging tip/auto-latest (05c0f92abb17 Merge branch 'x86/x32')
CONFLICT (rename/delete): drivers/video/fbdev/sgivwfb.c deleted in tip/auto=
-latest and renamed in HEAD. Version HEAD of drivers/video/fbdev/sgivwfb.c =
left in tree.
CONFLICT (content): Merge conflict in drivers/video/Makefile
CONFLICT (content): Merge conflict in drivers/video/Kconfig
CONFLICT (content): Merge conflict in drivers/pci/Makefile
CONFLICT (modify/delete): arch/x86/pci/visws.c deleted in tip/auto-latest a=
nd modified in HEAD. Version HEAD of arch/x86/pci/visws.c left in tree.
CONFLICT (modify/delete): arch/x86/pci/numaq_32.c deleted in tip/auto-lates=
t and modified in HEAD. Version HEAD of arch/x86/pci/numaq_32.c left in tre=
e.
$ git rm -f arch/x86/pci/numaq_32.c arch/x86/pci/visws.c drivers/video/fbde=
v/sgivwfb.c
Applying: video: fbdev: fix up fro removal of SGI Visual Workstation
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
Merging xen-tip/linux-next (08ac54ab46ab Merge branch 'stable/for-linus-3.1=
4' into linux-next)
Merging percpu/for-next (d5f2deed588b Merge branch 'for-3.14' into for-next)
Merging workqueues/for-next (379e899a2c66 Merge branch 'for-3.15' into for-=
next)
Merging drivers-x86/linux-next (b4b0b4a9e039 ipc: add intel-mid's pci id ma=
cros)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (fe36b404d4dc Merge remote-tracking branches 'regma=
p/topic/irq', 'regmap/topic/nodev', 'regmap/topic/parse-val' and 'regmap/to=
pic/patch' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (aad0f292756c leds: clevo-mail: remove __initdata mar=
ker)
Merging driver-core/driver-core-next (13df7977431e Merge 3.14-rc5 into driv=
er-core-next)
Merging tty/tty-next (013daec9c19b Merge 3.14-rc5 into tty-next)
Merging usb/usb-next (3c1b2c3ecd31 USB: sisusb: Use static const, fix typo)
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/Kconfig
Merging usb-gadget/next (d95faaec4763 phy: omap-control: Update DT binding =
information)
Merging staging/staging-next (002de0ba878d staging: dgap: Simplify and clea=
nup dgap_init_module function)
CONFLICT (content): Merge conflict in drivers/staging/cxt1e1/linux.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53-qsb.dts
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53-mba53.dts
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx51-babbage.dts
Applying: ARM: dts: i.MX53: merge fix patch
Merging char-misc/char-misc-next (aa074c1c805a Merge 3.14-rc5 into char-mis=
c-next)
$ git am -3 ../patches/0001-Revert-mcb-Add-PCI-carrier-for-MEN-Chameleon-Bu=
s.patch
Applying: Revert "mcb: Add PCI carrier for MEN Chameleon Bus"
$ git am -3 ../patches/0001-Revert-iio-adc-Add-MEN-16z188-ADC-driver.patch
Applying: Revert "iio: adc: Add MEN 16z188 ADC driver"
Merging cgroup/for-next (392a65859327 Merge branch 'for-3.15' into for-next)
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
Merging pinctrl/for-next (7bd0df13646d Merge branch 'devel' into for-next)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (53286bd8a380 Merge branch 'devel' into for-next)
CONFLICT (content): Merge conflict in drivers/gpio/gpio-ich.c
Merging dma-mapping/dma-mapping-next (68efd7d2fb32 arm: dma-mapping: remove=
 order parameter from arm_iommu_create_mapping())
Merging pwm/for-next (8468949cddcd pwm: pxa: Use of_match_ptr())
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging dma-buf/for-next (960dfc4eb23a Merge branch 'drm-fixes' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging userns/for-next (f58437f1f916 MIPS: VPE: Remove vpe_getuid and vpe_=
getgid)
Merging ktest/for-next (62183dcac539 ktest: Set CLOSE_CONSOLE_SIGNAL in the=
 kvm.conf)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (5ba8dac012c3 Merge branch 'clk-fixes' into clk-next)
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
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging akpm-current/current (3e0a4e7463f8 ipc: use device_initcall)
CONFLICT (content): Merge conflict in mm/memcontrol.c
CONFLICT (content): Merge conflict in lib/radix-tree.c
CONFLICT (content): Merge conflict in include/linux/mm.h
CONFLICT (content): Merge conflict in drivers/block/zram/zram_drv.c
Applying: mm-per-thread-vma-caching-fix-3
$ git checkout -b akpm remotes/origin/akpm/master
Applying: Kconfig: rename HAS_IOPORT to HAS_IOPORT_MAP
Applying: kernel: use macros from compiler.h instead of __attribute__((...))
CONFLICT (content): Merge conflict in kernel/fork.c
Applying: asm/system.h: clean asm/system.h from docs
Applying: asm/system.h: um: arch_align_stack() moved to asm/exec.h
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: mm: add strictlimit knob
Merging akpm/master (6f33f6966276 mm: add strictlimit knob)

--Signature=_Fri__7_Mar_2014_16_36_35_+1100_P0zmDa.w5mgPROTm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTGVroAAoJEMDTa8Ir7ZwV2toQAJF+jGOatkQnwbefe/Tliv0t
NqPhpeiECLY+uzJT8Z0Q9IPtpOdN6uueJozWf0F/TQ5NQMsGCdNF023xQj8Kzw2g
0h98Y29amXQlZAx9XEeMTVTIVhfvZrYX9y2ysvr5GoqIg15gBqB1QPYI7S7S6wh5
aLFcKZvBM9azJNfORbl/ksYk51CcDIXIwnYOxRk+f3Sy7sVLhuPmxEhdNkW9e+YX
mJSgvL/+D3FT2mNnwZkTY7P2Gony+HYeWJyZpfE+oXX4agUUOghNQjDhFUTpN5ZB
D0s2CrNrqPKYfZMt5VRSjQSzo7FyOs23RL6/oVY5vSh8wMYb2OW9UbpbArO2hIBH
9KsMpSJipb291xA9wOQlWFDYU5K2Um9Grk9xgvBs0yN1mHCtu6D36Xw8hIGD1r1w
3p66zFb6BmW8QlcLhngktIu4Oa5kJtd6mzpoXp8sOddOG61eukq1Pgn0XlZLskFm
UBkn0kIU6K+7/j/eyGDUNxNZvowRBQSqEnpTMYdX+C5yIysXZAEUha39TelZj3ug
/bnnmCoGENl0Y7QTlSCS+7auxNF8a/KZVQ9NkttSdUSD/wP2d0cjlTOuQbVriQLr
qZXbUZM6Ku/iPf74Nq4v+PazX+cqclkWAM7uiHovi4qy2mTcyfYhmwcA66MWTOTV
Sz3fXwidpRo+5c5hDubn
=+4B9
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Mar_2014_16_36_35_+1100_P0zmDa.w5mgPROTm--
