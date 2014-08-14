Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaHNF2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:28:01 -0400
Received: from ozlabs.org ([103.22.144.67]:59269 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaHNF15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:27:57 -0400
Date: Thu, 14 Aug 2014 15:27:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Aug 14
Message-ID: <20140814152749.24d43663@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ZI3wKlJ/typf/IypW.gJMyo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZI3wKlJ/typf/IypW.gJMyo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Please do not add code intended for v3.18 until after v3.17-rc1 is
released.

Changes since 20140813:

The tip tree gained a conflict against the pci-current tree.

Non-merge commits (relative to Linus' tree): 1233
 1229 files changed, 34781 insertions(+), 18188 deletions(-)

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
Merging origin/master (dc1cc8513312 Merge tag 'xfs-for-linus-3.17-rc1' of g=
it://oss.sgi.com/xfs/xfs)
Merging fixes/master (23cf8d3ca0fd powerpc: Fix "attempt to move .org backw=
ards" error)
Merging kbuild-current/rc-fixes (dd5a6752ae7d firmware: Create directories =
for external firmware)
Merging arc-current/for-curr (89ca3b881987 Linux 3.15-rc4)
Merging arm-current/fixes (e57e41931134 ARM: wire up memfd_create syscall)
Merging m68k-current/for-linus (9117710a5997 m68k/sun3: Remove define state=
ment no longer needed)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (08a9c3c9afcf MIPS: OCTEON: make get_system_t=
ype() thread-safe)
Merging powerpc-merge/merge (396a34340cdf powerpc: Fix endianness of flash_=
block_list in rtas_flash)
Merging sparc/master (8bccf5b31318 sparc64: Fix pcr_ops initialization and =
usage bugs.)
Merging net/master (61dac43ee6be Merge branch 'bcmgenet')
Merging ipsec/master (a0e5ef53aac8 xfrm: Fix installation of AH IPsec SAs)
Merging sound-current/for-linus (e24aa0a4c5ac ALSA: hda/ca0132 - Don't try =
loading firmware at resume when already failed)
Merging pci-current/for-linus (9baa3c34ac4e PCI: Remove DEFINE_PCI_DEVICE_T=
ABLE macro use)
Merging wireless/master (2da2c5854ed7 net: wireless: ipw2x00: ipw2200.c: Cl=
eaning up missing null-terminate after strncpy call)
Merging driver-core.current/driver-core-linus (c489d98c8c81 Merge branch 'f=
or-linus' of git://ftp.arm.linux.org.uk/~rmk/linux-arm)
Merging tty.current/tty-linus (c489d98c8c81 Merge branch 'for-linus' of git=
://ftp.arm.linux.org.uk/~rmk/linux-arm)
Merging usb.current/usb-linus (c489d98c8c81 Merge branch 'for-linus' of git=
://ftp.arm.linux.org.uk/~rmk/linux-arm)
Merging usb-gadget-fixes/fixes (a8a85b01d185 usb: musb/cppi41: call musb_ep=
_select() before accessing an endpoint's CSR)
CONFLICT (content): Merge conflict in drivers/usb/musb/musb_host.c
Merging usb-serial-fixes/usb-linus (19583ca584d6 Linux 3.16)
Merging staging.current/staging-linus (c309bfa9b481 Merge tag 'for-linus-20=
140808' of git://git.infradead.org/linux-mtd)
Merging char-misc.current/char-misc-linus (c489d98c8c81 Merge branch 'for-l=
inus' of git://ftp.arm.linux.org.uk/~rmk/linux-arm)
Merging input-current/for-linus (a6b48699ae50 Input: joystick - use get_cyc=
les on ARMv8)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (ce5481d01f67 crypto: drbg - fix failure of g=
enerating multiple of 2**16 bytes)
Merging ide/master (a53dae49b2fe ide: use module_platform_driver())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (5a12a597a862 arm: Add devicetr=
ee fixup machine function)
Merging rr-fixes/fixes (79465d2fd48e module: remove warning about waiting m=
odule removal.)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (7613ec9e6b40 drm/i915: Skip l=
oad detect when intel_crtc->new_enable=3D=3Dtrue)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (2a5e95d4181c mm, arc: remove obsolete pagefault oom k=
iller comment)
Merging arm/for-next (e57e41931134 ARM: wire up memfd_create syscall)
Merging arm-perf/for-next/perf (4c834452aad0 Linux 3.16-rc3)
Merging arm-soc/for-next (74f9f3185b80 Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (251f72d06c59 Merge branch 'berlin/soc' into=
 berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (c917f0911378 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (2e11b0361fb0 Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (883e289aed3a Merge branch 'heads/dt-timers-for-v3.17'=
 into next)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r7s72100=
.c
Merging samsung/for-next (d5e49aabb545 Merge branch 'v3.17-next/dt-samsung-=
2' into for-next)
Merging sunxi/sunxi/for-next (44b61dc11c6d Merge branch 'sunxi/dt-for-3.17'=
 into sunxi/for-next)
Merging tegra/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging arm64/for-next/core (ea1719672f59 arm64: add newline to I-cache pol=
icy string)
Merging blackfin/for-linus (b76f98236a23 blackfin: vmlinux.lds.S: reserve 3=
2 bytes space at the end of data section for XIP kernel)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (6b15075c2c36 [IA64] sn: Do not needlessly convert betwee=
n pointers and integers)
Merging m68k/for-next (9117710a5997 m68k/sun3: Remove define statement no l=
onger needed)
Merging m68knommu/for-next (9a1a1aea7572 m68knommu: Remove unnecessary prot=
otype for kobjsize())
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (5676d5bfb93b microblaze: Wire-up getrandom syscall)
Merging mips/mips-for-linux-next (475d5928b79b Merge branch '3.16-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (64aa90f26c06 Linux 3.16-rc7)
Merging powerpc/next (537e5400a0a0 powerpc/eeh: Export eeh_iommu_group_to_p=
e())
Merging fsl/next (78eb9094ca08 powerpc/t2080rdb: Add T2080RDB board support)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (7bb1cdbfe2b0 s390: wire up memfd_create syscall)
Merging sparc-next/master (85417aef44fc Merge git://git.kernel.org/pub/scm/=
linux/kernel/git/davem/ide)
Merging tile/master (ed93567c6fbc tile: Remove tile-specific _sinitdata and=
 _einitdata)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (4ed2ad38b3b4 Merge tag 'xtensa-for-next-20140715' =
of git://github.com/jcmvbkbc/linux-xtensa into for_next)
Merging btrfs/next (dfdb1cb7ca13 btrfs: disable strict file flushes for ren=
ames and truncates)
Merging ceph/master (5f740d7e1531 libceph: set last_piece in ceph_msg_data_=
pages_cursor_init() correctly)
Merging cifs/for-next (5d3248362ea2 Workaround MacOS server problem with pa=
rsing write response)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (04ec5f5c0022 ecryptfs: remove unnecessary break afte=
r goto)
Merging ext3/for_next (01777836c870 reiserfs: Fix use after free in journal=
 teardown)
Merging ext4/dev (86f0afd46321 ext4: fix ext4_discard_allocated_blocks() if=
 we can't allocate the pa struct)
Merging f2fs/dev (7f0d32e0c1a7 Merge tag 'microblaze-3.17-rc1' of git://git=
.monstr.eu/linux-2.6-microblaze)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (9a464443aec5 GFS2: Change maxlen variables to size_t)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (71a6ec8ac587 nfs: reject changes to resvport and sh=
arecache during remount)
CONFLICT (content): Merge conflict in fs/nfs/pagelist.c
Merging nfsd/nfsd-next (c8d6637d0497 Merge tag 'modules-next-for-linus' of =
git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (25601a3c9737 UBIFS: Add log overlap assertions)
Merging xfs/for-next (645f98572134 Merge branch 'xfs-misc-fixes-3.17-2' int=
o for-next)
Merging file-locks/linux-next (862cac0dfea0 locks: update Locking documenta=
tion to clarify fl_release_private behavior)
Merging vfs/for-next (c7f3888ad7f0 switch iov_iter_get_pages() to passing m=
aximal number of pages)
Merging pci/next (981c191778a4 Merge branches 'pci/host-designware', 'pci/h=
ost-mvebu' and 'pci/host-tegra' into next)
Merging hid/for-next (71095593b5d8 Merge branch 'for-3.17/hyperv' into for-=
next)
CONFLICT (add/add): Merge conflict in drivers/hid/hid-gt683r.c
Merging i2c/i2c/for-next (88a469fec24c Merge branch 'i2c/for-3.17' into i2c=
/for-next)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (6ddd855c13bc hwmon: (tmp103) Remove dupli=
cate test for I2C_FUNC_SMBUS_BYTE_DATA functionality)
Merging v4l-dvb/master (d1352f268415 Merge two fixes from branch 'patchwork=
' into to_next)
Merging kbuild/for-next (0eaeb361a894 Merge branches 'kbuild/kbuild' and 'k=
build/misc' into kbuild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (1824be15f7a4 Merge branch 'for-3.17' into for-next)
Merging pm/linux-next (af5b7e84d022 Merge branch 'pm-tools')
Merging idle/next (5f08abf265fe intel_idle: Disable Baytrail Core and Modul=
e C6 auto-demotion)
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
Merging slave-dma/next (a0bbe990c161 dmaengine: sun6i: depends on RESET_CON=
TROLLER)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (33caee39925b Merge branch 'akpm' (patchbomb from A=
ndrew Morton))
Merging ipsec-next/master (1759389e8af4 xfrm4: Remove duplicate semicolon)
Merging wireless-next/master (33caee39925b Merge branch 'akpm' (patchbomb f=
rom Andrew Morton))
Merging bluetooth/master (c365ff3991fd Bluetooth: Improve data packing in S=
AR mode)
Merging infiniband/for-next (1332bc88edf6 Merge branches 'core', 'cxgb4', '=
ipoib', 'iser', 'iwcm', 'mad', 'misc', 'mlx4', 'mlx5', 'ocrdma' and 'srp' i=
nto for-next)
CONFLICT (content): Merge conflict in include/linux/mlx4/device.h
Merging mtd/master (2a500afe1e0e mtd: gpmi: make blockmark swapping optiona=
l)
Merging l2-mtd/master (2a500afe1e0e mtd: gpmi: make blockmark swapping opti=
onal)
Merging crypto/master (ce5481d01f67 crypto: drbg - fix failure of generatin=
g multiple of 2**16 bytes)
Merging drm/drm-next (7963e9db1b1f Revert "drm: drop redundant drm_file->is=
_master")
Merging drm-panel/drm/panel/for-next (9746c61960b6 drm/panel: simple: Use d=
evm_gpiod_get_optional())
Merging drm-intel/for-linux-next (be71eabebaf9 Revert "drm/i915: Enable sem=
aphores on BDW")
Merging drm-tegra/drm/tegra/for-next (ef70728c7a65 drm/tegra: add MODULE_DE=
VICE_TABLEs)
Merging sound/for-next (e24aa0a4c5ac ALSA: hda/ca0132 - Don't try loading f=
irmware at resume when already failed)
Merging sound-asoc/for-next (c2848cc024cc Merge remote-tracking branches 'a=
soc/fix/arizona', 'asoc/fix/fsl', 'asoc/fix/fsl-esai', 'asoc/fix/intel', 'a=
soc/fix/mcasp' and 'asoc/fix/pxa' into asoc-linus)
Merging modules/modules-next (76215b04fd29 arch/powerpc/platforms/powernv/o=
pal-dump.c: fix world-writable sysfs files)
Merging virtio/virtio-next (eeec626366ff Revert "hwrng: virtio - ensure rea=
ds happen after successful probe")
Merging input/next (3361a97601f2 Input: edt-ft5x06 - remove superfluous ass=
ignment)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (69c04606d985 Merge branch 'for-3.17/core' into for-=
next)
CONFLICT (content): Merge conflict in include/scsi/sg.h
Merging device-mapper/for-next (465a3d61c229 dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (c83c8737e3ed mmc: dw_mmc: modify the dt-binding for re=
moving slot-node and supports-highspeed)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (d66b1b395a59 md: don't allow bitmap file to be added t=
o raid0/linear.)
Merging mfd/for-mfd-next (7caa79917ad4 MAINTAINERS: Update MFD repo locatio=
n)
Merging backlight/for-backlight-next (87464cdba2ae backlight: ipaq_micro: F=
ix sparse non static symbol warning)
Merging battery/master (5e37195f30cc ipaq_micro_battery: fix sparse non sta=
tic symbol warning)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (be92abea827b Merge branch '3.17/hdmi-infoframe'=
 into for-next)
Merging regulator/for-next (6d2a396099aa Merge remote-tracking branches 're=
gulator/fix/tps65023' and 'regulator/fix/tps65090' into regulator-linus)
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
Merging iommu/next (4c5e9d9f0ddf Merge branches 'x86/vt-d', 'x86/amd', 'arm=
/omap', 'ppc/pamu', 'arm/smmu', 'arm/exynos' and 'core' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (9b936c960f22 drivers/vfio: Enable VFIO if EEH is not sup=
ported)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (51a7097426f2 doc: fix two typos in watchdog-api.t=
xt)
Merging audit/master (3efe33f5d2da audit: x86: drop arch from __audit_sysca=
ll_entry() interface)
CONFLICT (content): Merge conflict in kernel/audit.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/mips/include/asm/syscall.h
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (663d3f7c2e5e Merge branch 'devicetree/n=
ext-overlay' into devicetree/next)
Merging dt-rh/for-next (99de64984c3a OF: fix of_find_node_by_path() assumpt=
ion that of_allnodes is root)
Merging spi/for-next (e2d807741bda Merge remote-tracking branches 'spi/fix/=
doc', 'spi/fix/omap-mcspi' and 'spi/fix/rspi' into spi-linus)
Merging tip/auto-latest (cff0fb9d9840 Merge branch 'x86/xsave')
CONFLICT (content): Merge conflict in kernel/trace/trace.c
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/perf_event_intel_=
uncore.c
Applying: perf/x86/uncore: fix for DEFINE_PCI_DEVICE_TABLE removal
Merging clockevents/clockevents/next (3252a646aa2c clocksource: exynos_mct:=
 Only use 32-bits where possible)
Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell base=
d systems)
Merging edac-amd/for-next (eba4bfb34d45 EDAC, MCE, AMD: Add MCE decoding fo=
r F15h M60h)
Merging irqchip/irqchip/for-next (c115d15552c0 Merge branch 'irqchip/atmel-=
aic' into irqchip/for-next)
CONFLICT (content): Merge conflict in drivers/irqchip/irq-gic.c
CONFLICT (content): Merge conflict in arch/arm64/Kconfig
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/arm=
/gic.txt
Merging ftrace/for-next (45ed695ac10a ARM64: add IPI tracepoints)
Merging rcu/rcu/next (1c91efb24799 rcutorture: Specify CONFIG_CPUMASK_OFFST=
ACK=3Dy for TREE07)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (c77dcacb3975 KVM: Move more code under CONFIG_HAVE_=
KVM_IRQFD)
Merging kvm-arm/next (dedf97e8ff2c arm64: KVM: fix 64bit CP15 VM access for=
 32bit guests)
Merging kvm-ppc/kvm-ppc-next (c77dcacb3975 KVM: Move more code under CONFIG=
_HAVE_KVM_IRQFD)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (e38230eb3789 xen/pciback: Remove tons of derefe=
rences)
Merging percpu/for-next (a46e532a9145 Merge branch 'for-3.16-fixes' into fo=
r-next)
Merging workqueues/for-next (ebb48ccd98d1 Merge branch 'for-3.17' into for-=
next)
Merging drivers-x86/linux-next (1166199dd9c9 asus-nb-wmi: Add wapf4 quirk f=
or the U32U)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (19583ca584d6 Linux 3.16)
Merging hsi/for-next (3fd276e9c0d7 HSI: omap_ssi: Fix return value check in=
 ssi_debug_add_ctrl())
Merging leds/for-next (45384ea0add3 leds: lp3944: fix sparse warning)
Merging driver-core/driver-core-next (c489d98c8c81 Merge branch 'for-linus'=
 of git://ftp.arm.linux.org.uk/~rmk/linux-arm)
Merging tty/tty-next (c489d98c8c81 Merge branch 'for-linus' of git://ftp.ar=
m.linux.org.uk/~rmk/linux-arm)
Merging usb/usb-next (c489d98c8c81 Merge branch 'for-linus' of git://ftp.ar=
m.linux.org.uk/~rmk/linux-arm)
Merging usb-gadget/next (8346b33fad01 Documentation: DocBook: elieminate do=
c build break)
Merging usb-serial/usb-next (5bc9e5933a41 USB: kl5kusb105: Remove klsi_105_=
tiocmset function)
Merging staging/staging-next (c309bfa9b481 Merge tag 'for-linus-20140808' o=
f git://git.infradead.org/linux-mtd)
Merging char-misc/char-misc-next (c489d98c8c81 Merge branch 'for-linus' of =
git://ftp.arm.linux.org.uk/~rmk/linux-arm)
Merging cgroup/for-next (abdfd21809f2 Merge branch 'for-3.17' into for-next)
Merging scsi/for-next (ae87e8b212ed Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.17' into for-next)
Merging target-updates/for-next (4ca7ea3ceeb9 iscsi-target: Ignore ICF_GOT_=
LAST_DATAOUT during Data-Out ITT lookup)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (2182d43467cd pinctrl: pinctrl-at91.c: fix decimal=
 printf format specifiers prefixed with 0x)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (d8aebf1197cd gpio: delete unneeded test before of_no=
de_put)
Merging dma-mapping/dma-mapping-next (f70e3c4f8b6a CMA: correct unlock targ=
et)
Merging pwm/for-next (f6306299080b pwm: rockchip: Added to support for RK32=
88 SoC)
Merging dma-buf/for-next (b23b35445ec8 Documentation: devres: Add devm_kmal=
loc() et al)
Merging userns/for-next (87b47932f40a mnt: Implicitly add MNT_NODEV on remo=
unt as we do on mount)
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
Merging aio/master (00fefb9cf2b5 aio: use iovec array rather than the singl=
e one)
Merging llvmlinux/for-next (7380100aa7ce arm64: LLVMLinux: Use current_stac=
k_pointer in kernel/traps.c)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (a14f5a7404c5 Documentation: DocBook: Rename drm_stu=
b.c to drm_drv.c cause 'make xmldocs' failed)
Merging signal-cleanup/signal_v4 (b9f0fb2d4a7a powerpc: Use sigsp())
Merging akpm-current/current (a7d66c114cee ipc: always handle a new value o=
f auto_msgmni)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: x86, vdso: fix vdso2c's special_pages error checking
Applying: drivers/net/irda/donauboe.c: convert to module_pci_driver
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
Applying: mm: add strictlimit knob
Merging akpm/master (1059e8b65a5b mm: add strictlimit knob)

--Sig_/ZI3wKlJ/typf/IypW.gJMyo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT7EjaAAoJEMDTa8Ir7ZwVJmoP/i/jR67GasgBiSZkGJugPNy5
KmGERn88pmlX3W4L68qsRUQJeIbFcitXinb9L0Y1oxd5NlhqFnGU7xF0+trZ/q+w
eXfVNdUOQA7/usqE1+C004KppP57NEEkTdWoA+2GjgbXPUtlYOxOVkiDs7sv47Ox
gy/9pgzMQTNiHCGj8JF9nV8Q2xjrwr8PYhda0jQ3Z05WnNfk5CQsTLY/IXRFVG1m
6IHjO9Z31tiZB/qM6C0UjUjaiNrRnTNYSPJ06SOLR5atRz1yxfcl2F1daGzrsdwY
5uXjrzpBn1u9ve6tH+ai00EYTJtHrXTRy+9YjInp1NrZ4lrZ2kn5MSB7v4S1Hd0P
OoAgA8GZtJvuVHViZz5YzYNkH+U73PruS+oCJdMRdY7MvHLYW1j9ozfL+Cd4tEWf
QTGtVt353QrVhAhUZg8z0p/wxTRWVzDCLICf1nhSEcF/7s1vtufR8kAzN2zuO3Su
5Ei8Ztg4Tau34WuW0bsdU9ihOJcYqoF50YlrIhH4NOUEbMwASwz94FpBs1dO/Zw4
uRvnueWcSCRubCmr5phIciApdPuNLYCsBNWP4rExohnYf0iBmlZHTDRsRAWOAK35
J1Mz4CTSIksOxfNKtuKFgBk7EFTLU27UVXXIibTf/U4FHfpU60yZ6gFDCcTFU+Q8
QnYp8FnyM2OyXmZSBUOT
=qaQI
-----END PGP SIGNATURE-----

--Sig_/ZI3wKlJ/typf/IypW.gJMyo--
