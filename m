Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbaH0GKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 02:10:39 -0400
Received: from ozlabs.org ([103.22.144.67]:59950 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735AbaH0GKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 02:10:35 -0400
Date: Wed, 27 Aug 2014 16:10:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Aug 27
Message-ID: <20140827161021.298aede6@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ZDEDm5V=5X3MIXvToc0wvZw"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZDEDm5V=5X3MIXvToc0wvZw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20140826:

The net tree lost its build failure.

The usb.current tree gained a build failure for which I reverted a commit.

The mfd tree lost its build failure.

The percpu tree gained a build failure so I used the version from
next-20140826.

The staging tree still had its build failure for which I applied a
fix patch.

The akpm-current tree lost its build failure.

The akpm tree lost its build failure and a patch that turned up elsewhere.

Non-merge commits (relative to Linus' tree): 2028
 2105 files changed, 56310 insertions(+), 35111 deletions(-)

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" and checkout or reset to the new
master.

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
multi_v7_defconfig for arm. After the final fixups (if any), it is also
built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
defconfig.

Below is a summary of the state of the merge.

I am currently merging 220 trees (counting Linus' and 30 trees of patches
pending for Linus' tree).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
Gortmaker for triage and bug fixes.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master (68e370289c29 Merge branch 'for-linus' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/s390/linux)
Merging fixes/master (23cf8d3ca0fd powerpc: Fix "attempt to move .org backw=
ards" error)
Merging kbuild-current/rc-fixes (7d1311b93e58 Linux 3.17-rc1)
Merging arc-current/for-curr (89ca3b881987 Linux 3.15-rc4)
Merging arm-current/fixes (e57e41931134 ARM: wire up memfd_create syscall)
Merging m68k-current/for-linus (9117710a5997 m68k/sun3: Remove define state=
ment no longer needed)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (396a34340cdf powerpc: Fix endianness of flash_=
block_list in rtas_flash)
Merging sparc/master (451fd72219dd Merge tag 'pwm/for-3.17-rc2' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm)
Merging net/master (2d39d120781a mvneta: Add missing if_vlan.h include.)
Merging ipsec/master (21009686662f net: phy: smsc: move smsc_phy_config_ini=
t reset part in a soft_reset function)
Merging sound-current/for-linus (94a988a8ab91 ALSA: pcm: Fix the silence da=
ta for DSD formats)
Merging pci-current/for-linus (8d7004a6904c PCI: spear: Remove module optio=
n)
Merging wireless/master (c66517165610 rtlwifi: rtl8192cu: Add new ID)
Merging driver-core.current/driver-core-linus (52addcf9d666 Linux 3.17-rc2)
Merging tty.current/tty-linus (52addcf9d666 Linux 3.17-rc2)
Merging usb.current/usb-linus (039368901ad0 usb: ehci/ohci-exynos: Fix PHY =
getting sequence)
[master e4fe9423adda] Revert "usb: hub: Prevent hub autosuspend if usbcore.=
autosuspend is -1"
Merging usb-gadget-fixes/fixes (5d19703822da usb: gadget: remove $(PWD) in =
ccflags-y)
Merging usb-serial-fixes/usb-linus (646907f5bfb0 USB: ftdi_sio: Added PID f=
or new ekey device)
Merging staging.current/staging-linus (a2fa6721c723 staging: r8188eu: Add n=
ew USB ID)
Merging char-misc.current/char-misc-linus (72ad366f687d thunderbolt: Clear =
hops before overwriting)
Merging input-current/for-linus (a2418fc4a13b Input: elantech - add support=
 for trackpoint found on some v3 models)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (ce5481d01f67 crypto: drbg - fix failure of g=
enerating multiple of 2**16 bytes)
Merging ide/master (a53dae49b2fe ide: use module_platform_driver())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (5a12a597a862 arm: Add devicetr=
ee fixup machine function)
Merging rr-fixes/fixes (ff7e0055bb5d module: Clean up ro/nx after early mod=
ule load failures)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (a4bf214ffc72 drm/i915: Move i=
ntel_ddi_set_vc_payload_alloc(false) to haswell_crtc_disable())
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (2a5e95d4181c mm, arc: remove obsolete pagefault oom k=
iller comment)
Merging arm/for-next (e57e41931134 ARM: wire up memfd_create syscall)
Merging arm-perf/for-next/perf (7d1311b93e58 Linux 3.17-rc1)
Merging arm-soc/for-next (9ae0c5635088 Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (7d1311b93e58 Linux 3.17-rc1)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (db8ddc19e438 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (74328d67b001 Merge branch 'mvebu/defconfig' into mv=
ebu/for-next)
Merging renesas/next (c73ba4b7033b Merge branch 'heads/r8a7740-ccf-and-time=
rs-for-v3.18' into next)
Merging samsung/for-next (213e1f6f5f0b Merge branch 'v3.18-next/dt-samsung'=
 into for-next)
Merging sunxi/sunxi/for-next (779b646c8102 Merge branch 'sunxi/dt-for-3.18'=
 into sunxi/for-next)
Merging tegra/for-next (11bb91508965 Merge branch for-3.18/defconfig into f=
or-next)
Merging arm64/for-next/core (ea1719672f59 arm64: add newline to I-cache pol=
icy string)
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (6b15075c2c36 [IA64] sn: Do not needlessly convert betwee=
n pointers and integers)
Merging m68k/for-next (9117710a5997 m68k/sun3: Remove define statement no l=
onger needed)
Merging m68knommu/for-next (8ab25ce231d5 m68k: fix crufty 68000 and 68360 i=
ntro comments)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (83c43c498a0a microblaze: Wire-up memfd_create sysc=
all)
Merging mips/mips-for-linux-next (de7e76446283 Merge branch '3.17-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (64aa90f26c06 Linux 3.16-rc7)
Merging powerpc/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging fsl/next (78eb9094ca08 powerpc/t2080rdb: Add T2080RDB board support)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (b8a2bbdf02b8 s390/sclp: remove unnecessary XTABS fla=
g)
Merging sparc-next/master (451fd72219dd Merge tag 'pwm/for-3.17-rc2' of git=
://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm)
Merging tile/master (ed93567c6fbc tile: Remove tile-specific _sinitdata and=
 _einitdata)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (e792290be763 Merge tag 'xtensa-for-next-20140815' =
into for_next)
Merging btrfs/next (8d875f95da43 btrfs: disable strict file flushes for ren=
ames and truncates)
Merging ceph/master (5f740d7e1531 libceph: set last_piece in ceph_msg_data_=
pages_cursor_init() correctly)
Merging cifs/for-next (ca5d13fc33cc Clarify Kconfig help text for CIFS and =
SMB2/SMB3)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (04ec5f5c0022 ecryptfs: remove unnecessary break afte=
r goto)
Merging ext3/for_next (e6d8fb340f20 ext3: Count internal journal as bsddf o=
verhead in ext3_statfs)
Merging ext4/dev (4d3b917ff59f ext4: fix same-dir rename when inline data d=
irectory overflows)
Merging f2fs/dev (c2e69583a478 f2fs: truncate stale block for inline_data)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (2ddfbdd6848d GFS2: Request demote when a "try" flock f=
ails)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (f568cc1f0bb4 SUNRPC: Fix memory reclaim deadlocks i=
n rpciod)
Merging nfsd/nfsd-next (e40ee075fa7f SUNRPC: current_task should be current)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (25601a3c9737 UBIFS: Add log overlap assertions)
Merging xfs/for-next (645f98572134 Merge branch 'xfs-misc-fixes-3.17-2' int=
o for-next)
Merging file-locks/linux-next (24b496fa31b8 locks: remove lock_may_read and=
 lock_may_write)
Merging vfs/for-next (ef115d4d3296 fs: Fix theoretical division by 0 in sup=
er_cache_scan().)
Applying: vfs: initialize m_list to fix crash in mnt_set_mountpoint
Merging pci/next (981c191778a4 Merge branches 'pci/host-designware', 'pci/h=
ost-mvebu' and 'pci/host-tegra' into next)
Merging hid/for-next (176ef2bd5938 Merge branch 'for-3.18/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (4560d6772281 MAINTAINERS: add maintainer for ACPI=
 parts of I2C)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (123ce11c850c MAINTAINERS: add entry for t=
he PWM fan driver)
Merging v4l-dvb/master (d1352f268415 Merge two fixes from branch 'patchwork=
' into to_next)
Merging kbuild/for-next (a16f7ed72bb9 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (863bdd0f25a3 Merge branch 'for-3.17-fixes' into fo=
r-next)
Merging pm/linux-next (9a249096a15a Merge branches 'acpi-scan', 'acpi-osl',=
 'acpi-ec', 'acpi-lpss' and 'acpi-video')
Merging idle/next (e7c95ff32d00 tools/power turbostat: tweak whitespace in =
output format)
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (47d104ba5879 Merge branches 'exynos-fix', 'for-rc', '=
int3403-fix', 'misc', 'rcar-thermal' and 'sti-thermal' of .git into next)
Merging ieee1394/for-next (d584a6627994 firewire: ohci: disable MSI for VIA=
 VT6315 again)
Merging dlm/next (883854c5457a dlm: keep listening connection alive with sc=
tp mode)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (f6f9d109cc0e Merge branch 'for-linus' into next)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (a3d1214688d5 neigh: document gc_thresh2)
Merging ipsec-next/master (c9d26423e56c Merge tag 'pm+acpi-3.17-rc1-2' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm)
Merging wireless-next/master (7bb75da17172 orinoco_usb: use USB API functio=
ns rather than constants)
Merging bluetooth/master (cf0ba860a91e Bluetooth: Move clock offset reading=
 into hci_disconnect())
CONFLICT (content): Merge conflict in net/bluetooth/hci_event.c
CONFLICT (content): Merge conflict in net/bluetooth/hci_core.c
CONFLICT (content): Merge conflict in net/bluetooth/hci_conn.c
Merging infiniband/for-next (d087f6ad724d Merge branches 'core', 'cxgb4', '=
ipoib', 'iser', 'iwcm', 'mad', 'misc', 'mlx4', 'mlx5', 'ocrdma' and 'srp' i=
nto for-next)
Merging mtd/master (b25046b1e5e3 mtd: nand: fix DocBook warnings on nand_sd=
r_timings doc)
Merging l2-mtd/master (5b49ab3e03f6 Merge l2-mtd/next into l2-mtd/master)
Merging crypto/master (b9347aff91ce crypto: drbg - fix maximum value checks=
 on 32 bit systems)
Merging drm/drm-next (484048db6b48 Merge branch 'drm-next-3.18' of git://pe=
ople.freedesktop.org/~agd5f/linux into drm-next)
Merging drm-panel/drm/panel/for-next (9746c61960b6 drm/panel: simple: Use d=
evm_gpiod_get_optional())
Merging drm-intel/for-linux-next (be71eabebaf9 Revert "drm/i915: Enable sem=
aphores on BDW")
Merging drm-tegra/drm/tegra/for-next (ef70728c7a65 drm/tegra: add MODULE_DE=
VICE_TABLEs)
Merging sound/for-next (62afa853cb91 ALSA: ctxfi: fix broken user-visible s=
tring)
Merging sound-asoc/for-next (fdb2d394d578 Merge remote-tracking branch 'aso=
c/topic/wm8994' into asoc-next)
Merging modules/modules-next (480cadc2b7e0 scsi: Fix qemu boot hang problem)
Merging virtio/virtio-next (480cadc2b7e0 scsi: Fix qemu boot hang problem)
Merging input/next (6ba694560cae Input: drv260x - fix binding document)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (30e996ae7593 Merge branch 'for-linus' into for-next)
Merging device-mapper/for-next (465a3d61c229 dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (f2ce5ee41e8c mmc: atmel-mci: add 0x600 IP version)
Merging kgdb/kgdb-next (662bfa325be1 kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (90c25a429b62 md/raid5: fix init_stripe() inconsistenci=
es)
Merging mfd/for-mfd-next (6b84006621ac mfd: max77693: Improve support for t=
he flash cell)
Merging backlight/for-backlight-next (87464cdba2ae backlight: ipaq_micro: F=
ix sparse non static symbol warning)
Merging battery/master (5e37195f30cc ipaq_micro_battery: fix sparse non sta=
tic symbol warning)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (be92abea827b Merge branch '3.17/hdmi-infoframe'=
 into for-next)
Merging regulator/for-next (8745459daf38 Merge remote-tracking branches 're=
gulator/topic/rk808', 'regulator/topic/samsung', 'regulator/topic/sky81452'=
 and 'regulator/topic/tps65910' into regulator-next)
Merging security/next (478d085524c5 Merge tag 'keys-next-20140805' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs into next)
Merging integrity/next (e27319cdf468 ima: provide double buffering for hash=
 calculation)
CONFLICT (content): Merge conflict in include/linux/key.h
CONFLICT (content): Merge conflict in crypto/asymmetric_keys/x509_public_ke=
y.c
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
Merging selinux/next (aa9e0de81b5b Merge tag 'v3.16' into next)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (8083baba5e9c wdt: sunxi: Move restart code to the =
watchdog driver)
Merging iommu/next (0fdb6739098d Merge branches 'iommu/fixes', 'arm/exynos'=
 and 'x86/vt-d' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (9b936c960f22 drivers/vfio: Enable VFIO if EEH is not sup=
ported)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (55688377b19b MIPS: fix comment spelling)
Merging audit/master (451fd72219dd Merge tag 'pwm/for-3.17-rc2' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (a9ecdc0fdc54 of/irq: Fix lookup to use =
'interrupts-extended' property first)
Merging dt-rh/for-next (99de64984c3a OF: fix of_find_node_by_path() assumpt=
ion that of_allnodes is root)
Merging spi/for-next (b6ce87799e33 Merge remote-tracking branches 'spi/topi=
c/pxa2xx', 'spi/topic/rspi' and 'spi/topic/xilinx' into spi-next)
Merging tip/auto-latest (a7653f5e0570 Merge branch 'x86/uv')
Merging clockevents/clockevents/next (3252a646aa2c clocksource: exynos_mct:=
 Only use 32-bits where possible)
Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell base=
d systems)
Merging edac-amd/for-next (eba4bfb34d45 EDAC, MCE, AMD: Add MCE decoding fo=
r F15h M60h)
Merging irqchip/irqchip/for-next (289eb96601f3 Merge branch 'irqchip/core' =
into irqchip/for-next)
Merging ftrace/for-next (4ce97dbf5024 trace: Fix epoll hang when we race wi=
th new entries)
Merging rcu/rcu/next (1c91efb24799 rcutorture: Specify CONFIG_CPUMASK_OFFST=
ACK=3Dy for TREE07)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (54ad89b05ec4 kvm: x86: fix tracing for 32-bit)
Merging kvm-arm/next (7b46268d2954 KVM: trace kvm_ple_window grow/shrink)
Merging kvm-ppc/kvm-ppc-next (c77dcacb3975 KVM: Move more code under CONFIG=
_HAVE_KVM_IRQFD)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (e38230eb3789 xen/pciback: Remove tons of derefe=
rences)
Merging percpu/for-next (99ec1ca6ca0a Merge branch 'for-3.18-consistent-ops=
' into for-next)
$ git reset --hard HEAD^
Merging next-20140826 version of percpu
Merging workqueues/for-next (ebb48ccd98d1 Merge branch 'for-3.17' into for-=
next)
Merging drivers-x86/linux-next (770235f68ab6 platform/x86: Enable build sup=
port for toshiba_haps)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (2afb1fed5d50 Merge remote-tracking branch 'regmap/=
topic/dt-endian' into regmap-next)
Merging hsi/for-next (3fd276e9c0d7 HSI: omap_ssi: Fix return value check in=
 ssi_debug_add_ctrl())
Merging leds/for-next (3f6815f711ef leds: lp3944: fix sparse warning)
Merging driver-core/driver-core-next (52addcf9d666 Linux 3.17-rc2)
Merging tty/tty-next (52addcf9d666 Linux 3.17-rc2)
Merging usb/usb-next (7d1311b93e58 Linux 3.17-rc1)
Merging usb-gadget/next (8913dc0bb913 usb: gadget: document a usb_ep_dequeu=
e() requirement)
CONFLICT (content): Merge conflict in drivers/usb/phy/phy-samsung-usb.h
Merging usb-serial/usb-next (7d1311b93e58 Linux 3.17-rc1)
Merging staging/staging-next (e4a73e9c6198 drivers/staging/unisys: fix buil=
d)
Applying: staging: rtl8188eu: using unique names is good
Merging char-misc/char-misc-next (7d1311b93e58 Linux 3.17-rc1)
Merging cgroup/for-next (549cb2747e0f Merge branch 'for-3.18' into for-next)
Merging scsi/for-next (0d409610d597 Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.18' into for-next)
Merging target-updates/for-next (4ca7ea3ceeb9 iscsi-target: Ignore ICF_GOT_=
LAST_DATAOUT during Data-Out ITT lookup)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (0252d6a2ac2a pinctrl: qcom: apq8064: Correct inte=
rrupts in example)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (24f5796e7881 Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (b4bbb107d73b dma-mapping: Provide wri=
te-combine allocations)
Merging pwm/for-next (137fd45ffec1 pwm: imx: Avoid sample FIFO overflow for=
 i.MX PWM version2)
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
Merging userns/for-next (a1998908ba46 nfs: fix kernel warning when removing=
 proc entry)
Merging ktest/for-next (4c16b1d6d5e0 ktest: Update documentation on config_=
bisect)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (b11a6face1b6 clk: Add missing of_clk_set_defaults exp=
ort)
Merging random/dev (e02b87659777 hwrng: Pass entropy to add_hwgenerator_ran=
domness() in bits, not bytes)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (7be141d05549 Merge branch 'x86-urgent-for-linus' of git=
://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging llvmlinux/for-next (7380100aa7ce arm64: LLVMLinux: Use current_stac=
k_pointer in kernel/traps.c)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (81820f32ffaf v4l2-pci-skeleton: Only build if PCI i=
s available)
Merging signal-cleanup/signal_v4 (b9f0fb2d4a7a powerpc: Use sigsp())
Merging akpm-current/current (1b16511b9035 scripts/headers_install.sh: fix =
error handling)
Applying: headers: prctl.h -- Add missing linux/types.h
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: x86, vdso: fix vdso2c's special_pages error checking
Applying: include/linux: remove strict_strto* definitions
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: fat: add i_disksize to represent uninitialized size
Applying: fat: add fat_fallocate operation
Applying: fat: zero out seek range on _fat_get_block
Applying: fat: fallback to buffered write in case of fallocated region on d=
irect IO
Applying: fat: permit to return phy block number by fibmap in fallocated re=
gion
Applying: Documentation/filesystems/vfat.txt: update the limitation for fat=
 fallocate
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: softlockup: make detector be aware of task switch of processes ho=
gging cpu
Applying: kernel/watchdog.c: control hard lockup detection default
Applying: watchdog-control-hard-lockup-detection-default-fix
Applying: watchdog, nmi: Fix compile issues on sparc
Applying: kvm: ensure hard lockup detection is disabled by default
Applying: mm: add strictlimit knob
Merging akpm/master (cf0636c5f6df mm: add strictlimit knob)

--Sig_/ZDEDm5V=5X3MIXvToc0wvZw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT/XZYAAoJEMDTa8Ir7ZwV5RUP/iPf/ZL4yCiu3pAOU8jWdiJy
hdnx7Nszj/M9Dgpo656IdBCbUKw1ufjB9dh1Kjm/bbAhVd8/2d1yW+6WxSNwMvkR
HzRsZ/lLMapvsIGyiD6QpxaMepMFFW5T+lavf9iT5lY1E01W8CClDCPL3LjHrDvJ
NMlCtO7sVT2qp4Kk5PQyDSxRxZAwAA7TKl9If+Vp3HdPXXdxvGY46f0FzSHrvZKQ
CrW5qqPYm4hFj5TOb5xZReOFHDKUP2l7llWLwyuYlny7gWgYhkjfiEvOENvVsPKH
Y91kC59r/n7g7WLwRabQd4xNJ0llwsjWAFc9s4PLbnmw3X49X3QXqsSX9bdFwb0G
5CTMCwDrveTrKoFb373leSvQXBelHfzeCe4LiNi1UpcVVcPWxsU+i4HNhwMV5HaY
XgHNca+YZ4lqJlQKv0zqC2o+DUaYtpR2RuSvpyjgkNfW+xu7OYVw1d9hcWO/B3qF
jSiuT3HjTx8vOavYAazg4q3ycEFxaRzF7uDAJPsryBhjNtRmLL1+On4fcqgXqLF/
d5pPiaPpqCsXtijsPYXA7X68YSS9kllnC3N7sZs5Jj/8aMOVG7bnKLRVJnhN/nfH
V5FeyeBzvbSXTIRoAV48ofAuaeFdJ4D6HZ1cu8E7mQB8L0NZ6zAe6rmXOxXIa51W
oT3lvmuxgsRS0TJW0vT0
=avD8
-----END PGP SIGNATURE-----

--Sig_/ZDEDm5V=5X3MIXvToc0wvZw--
