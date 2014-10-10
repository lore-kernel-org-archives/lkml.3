Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaJJIYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:24:11 -0400
Received: from tundra.namei.org ([65.99.196.166]:50400 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaJJIYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:24:00 -0400
Date: Fri, 10 Oct 2014 19:23:51 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [GIT] Security subsystem upate for 3.18
Message-ID: <alpine.LRH.2.11.1410101913460.13164@namei.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the security subsystem update for 3.18.

I'm not entirely sure what's going on with the diffstat output below -- 
it shows a bunch of unrelated changes.  The summary log is correct, 
however.

Stephen Rothwell suggested it's from having two merge bases:

$ git merge-base -a origin/master security/next
478d085524c57cf4283699f529d5a4c22188ea69
19583ca584d6f574384e17fe7613dfaeadcdc4a6

One of these is from merging with your v3.16, and the other from a merge 
of the keys tree.  That's about all I understand of it.


---
The following changes since commit bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9:

  Linux 3.17 (2014-10-05 12:23:04 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

Casey Schaufler (1):
      Smack: Bring-up access mode

David Howells (21):
      KEYS: Set pr_fmt() in asymmetric key signature handling
      KEYS: Fix missing statics
      PKCS#7: Add a missing static
      KEYS: Reinstate EPERM for a key type name beginning with a '.'
      PKCS#7: Provide a single place to do signed info block freeing
      PKCS#7: Fix the parser cleanup to drain parsed out X.509 certs
      Merge tag 'keys-fixes-20140916' into keys-next
      Merge tag 'keys-next-fixes-20140916' into keys-next
      Provide a binary to hex conversion function
      KEYS: Preparse match data
      KEYS: Remove key_type::def_lookup_type
      KEYS: Remove key_type::match in favour of overriding default by match_preparse
      KEYS: Make the key matching functions return bool
      KEYS: Update the keyrings documentation for match changes
      KEYS: Implement binary asymmetric key ID handling
      KEYS: Overhaul key identification when searching for asymmetric keys
      PKCS#7: Better handling of unsupported crypto
      PKCS#7: Handle PKCS#7 messages that contain no X.509 certs
      Merge tag 'keys-pkcs7-20140916' into keys-next
      KEYS: Check hex2bin()'s return when generating an asymmetric key ID
      X.509: If available, use the raw subjKeyId to form the key description

Dmitry Kasatkin (26):
      ima: prevent buffer overflow in ima_alloc_tfm()
      ima: fix fallback to use new_sync_read()
      evm: fix checkpatch warnings
      evm: prevent passing integrity check if xattr read fails
      ima: provide flag to identify new empty files
      evm: properly handle INTEGRITY_NOXATTRS EVM status
      ima: pass 'opened' flag to identify newly created files
      integrity: prevent flooding with 'Request for unknown key'
      integrity: remove declaration of non-existing functions
      ima: simplify conditional statement to improve performance
      ima: remove unnecessary extra variable
      ima: add missing '__init' keywords
      ima: remove unnecessary appraisal test
      ima: remove usage of filename parameter
      ima: initialize only required template
      integrity: move asymmetric keys config option
      integrity: base integrity subsystem kconfig options on integrity
      integrity: make integrity files as 'integrity' module
      ima: move keyring initialization to ima_init()
      ima: provide 'ima_appraise=log' kernel option
      KEYS: handle error code encoded in pointer
      KEYS: Restore partial ID matching functionality for asymmetric keys
      KEYS: use swapped SKID for performing partial matching
      KEYS: strip 'id:' from ca_keyid
      KEYS: output last portion of fingerprint in /proc/keys
      integrity: do zero padding of the key id

James Morris (6):
      Merge branch 'next' of git://git.kernel.org/.../zohar/linux-integrity into next
      Merge branch 'smack-for-3.18' of git://git.gitorious.org/smack-next/kernel into next
      Merge tag 'keys-next-20140922' of git://git.kernel.org/.../dhowells/linux-fs into next
      Merge commit 'v3.16' into next
      Merge branch 'next' of git://git.infradead.org/users/pcmoore/selinux into next
      Merge branch 'next' of git://git.kernel.org/.../zohar/linux-integrity into next

Jiri Pirko (1):
      selinux: register nf hooks with single nf_register_hooks call

Kees Cook (1):
      seccomp: Add reviewers to MAINTAINERS

Konstantin Khlebnikov (3):
      Smack: fix behavior of smack_inode_listsecurity
      Smack: handle zero-length security labels without panic
      Smack: remove unneeded NULL-termination from securtity label

Lukasz Pawelczyk (3):
      Small fixes in comments describing function parameters
      Fix a bidirectional UDS connect check typo
      Make Smack operate on smack_known struct where it still used char*

Marcin Niesluchowski (1):
      Smack: Fix setting label on successful file open

Mark Rustad (1):
      security: Silence shadow warning

Mimi Zohar (1):
      ima: fix ima_alloc_atfm()

Paul Moore (3):
      Merge tag 'v3.16' into next
      selinux: fix a problem with IPv6 traffic denials in selinux_ip_postroute()
      selinux: make the netif cache namespace aware

Richard Guy Briggs (2):
      selinux: cleanup error reporting in selinux_nlmsg_perm()
      selinux: normalize audit log formatting

Roberto Sassu (4):
      ima: return an error code from ima_add_boot_aggregate()
      ima: added ima_policy_flag variable
      ima: fix race condition on ima_rdwr_violation_check and process_measurement
      ima: detect violations for mmaped files

Stephen Smalley (1):
      selinux: Permit bounded transitions under NO_NEW_PRIVS or NOSUID.

 .mailmap                                           |    5 +
 CREDITS                                            |    7 +-
 Documentation/acpi/enumeration.txt                 |    6 -
 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |    6 +-
 Documentation/input/event-codes.txt                |   13 +
 Documentation/kernel-parameters.txt                |   10 +-
 Documentation/security/keys.txt                    |   65 ++-
 MAINTAINERS                                        |   26 +-
 Makefile                                           |    4 +-
 arch/arm/Kconfig                                   |    5 +-
 arch/arm/boot/dts/at91sam9n12.dtsi                 |    2 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |    4 +-
 arch/arm/boot/dts/hi3620.dtsi                      |    2 +-
 arch/arm/boot/dts/omap3-n900.dts                   |    2 +-
 arch/arm/boot/dts/r8a7791.dtsi                     |    4 +-
 arch/arm/boot/dts/ste-nomadik-s8815.dts            |    2 +-
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi         |    7 +-
 arch/arm/crypto/aesbs-glue.c                       |   10 +-
 arch/arm/include/asm/mach/arch.h                   |    1 +
 arch/arm/kernel/devtree.c                          |    8 +-
 arch/arm/kernel/iwmmxt.S                           |   23 +-
 arch/arm/kernel/kgdb.c                             |    4 +
 arch/arm/kernel/topology.c                         |    2 +-
 arch/arm/mach-exynos/exynos.c                      |   10 +
 arch/arm/mach-exynos/hotplug.c                     |   10 +-
 arch/arm/mach-exynos/platsmp.c                     |   34 +-
 arch/arm/mach-imx/clk-imx6q.c                      |    4 +-
 arch/arm/mach-mvebu/coherency.c                    |    6 +-
 arch/arm/mach-mvebu/headsmp-a9.S                   |    9 +-
 arch/arm/mach-mvebu/pmsu.c                         |   10 +-
 arch/arm/mach-omap2/gpmc-nand.c                    |   18 +-
 arch/arm/mach-omap2/omap4-common.c                 |    4 +
 arch/arm/mm/dma-mapping.c                          |   11 +-
 arch/arm/mm/idmap.c                                |   12 +
 arch/arm/mm/mmu.c                                  |    6 +-
 arch/arm/xen/grant-table.c                         |    5 +
 arch/arm64/Kconfig                                 |    1 +
 arch/arm64/crypto/aes-glue.c                       |   12 +-
 arch/arm64/kernel/efi-stub.c                       |    2 -
 arch/arm64/mm/init.c                               |   17 +-
 arch/blackfin/configs/BF609-EZKIT_defconfig        |    2 +-
 arch/blackfin/kernel/vmlinux.lds.S                 |    2 +-
 arch/blackfin/mach-bf533/boards/blackstamp.c       |    1 +
 arch/blackfin/mach-bf537/boards/cm_bf537e.c        |    1 +
 arch/blackfin/mach-bf537/boards/cm_bf537u.c        |    1 +
 arch/blackfin/mach-bf537/boards/tcm_bf537.c        |    1 +
 arch/blackfin/mach-bf548/boards/ezkit.c            |    6 +-
 arch/blackfin/mach-bf561/boards/acvilon.c          |    1 +
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |    1 +
 arch/blackfin/mach-bf561/boards/ezkit.c            |    1 +
 arch/blackfin/mach-bf609/boards/ezkit.c            |   20 +-
 arch/blackfin/mach-bf609/include/mach/pm.h         |    5 +-
 arch/blackfin/mach-bf609/pm.c                      |    4 +-
 arch/blackfin/mach-common/ints-priority.c          |    2 -
 arch/parisc/include/uapi/asm/signal.h              |    2 -
 arch/parisc/mm/init.c                              |    1 -
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/include/asm/cputable.h                |    1 +
 arch/powerpc/include/asm/kvm_book3s_64.h           |   19 +-
 arch/powerpc/include/asm/mmu-hash64.h              |    3 +-
 arch/powerpc/include/asm/ppc_asm.h                 |    2 +
 arch/powerpc/kernel/cputable.c                     |   20 +
 arch/powerpc/kernel/rtas_flash.c                   |    6 +-
 arch/powerpc/kernel/smp.c                          |    2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |    2 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                |    7 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |    2 +-
 arch/powerpc/kvm/book3s_interrupts.S               |    4 +
 arch/powerpc/kvm/book3s_rmhandlers.S               |    6 +-
 arch/powerpc/kvm/book3s_rtas.c                     |   65 +--
 arch/powerpc/kvm/e500_mmu_host.c                   |    3 +-
 arch/powerpc/lib/mem_64.S                          |    2 +-
 arch/powerpc/lib/sstep.c                           |   10 +-
 arch/powerpc/net/bpf_jit_comp.c                    |   10 +-
 arch/powerpc/perf/core-book3s.c                    |    6 +-
 arch/powerpc/platforms/powernv/opal-elog.c         |    4 +-
 arch/powerpc/platforms/pseries/dlpar.c             |    1 +
 arch/powerpc/platforms/pseries/reconfig.c          |    1 +
 arch/s390/include/asm/switch_to.h                  |    4 +-
 arch/s390/kernel/head.S                            |    6 +-
 arch/s390/kernel/ptrace.c                          |   12 +-
 arch/s390/pci/pci.c                                |   49 +--
 arch/sh/Makefile                                   |    3 +-
 arch/sparc/Kconfig                                 |    1 +
 arch/sparc/include/uapi/asm/unistd.h               |    3 +-
 arch/sparc/kernel/sys32.S                          |    1 +
 arch/sparc/kernel/systbls_32.S                     |    1 +
 arch/sparc/kernel/systbls_64.S                     |    2 +
 arch/um/kernel/tlb.c                               |    9 +-
 arch/um/kernel/trap.c                              |    2 +-
 arch/um/os-Linux/skas/process.c                    |    9 +-
 arch/x86/Kconfig                                   |    1 +
 arch/x86/boot/header.S                             |   26 +-
 arch/x86/boot/tools/build.c                        |   38 ++-
 arch/x86/include/asm/irqflags.h                    |    2 +-
 arch/x86/kernel/apm_32.c                           |    1 -
 arch/x86/kernel/cpu/intel.c                        |   22 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c              |   12 +
 arch/x86/kernel/cpu/mcheck/mce.c                   |   10 +-
 arch/x86/kernel/cpu/perf_event.c                   |    3 +
 arch/x86/kernel/cpu/perf_event.h                   |   12 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |   78 +++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |    6 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |   11 +-
 arch/x86/kernel/entry_32.S                         |    9 +-
 arch/x86/kernel/entry_64.S                         |   28 +-
 arch/x86/kernel/espfix_64.c                        |    5 +-
 arch/x86/kernel/kprobes/core.c                     |    3 +
 arch/x86/kernel/paravirt_patch_64.c                |    2 -
 arch/x86/kernel/tsc.c                              |    4 +-
 arch/x86/kvm/x86.c                                 |   12 +
 arch/x86/xen/grant-table.c                         |  148 ++++--
 arch/xtensa/kernel/vectors.S                       |  158 +++++-
 arch/xtensa/kernel/vmlinux.lds.S                   |    4 +-
 arch/xtensa/mm/init.c                              |    2 +-
 block/blk-cgroup.c                                 |    7 +
 block/blk-tag.c                                    |   33 +-
 block/compat_ioctl.c                               |    1 +
 crypto/af_alg.c                                    |    2 +
 crypto/asymmetric_keys/asymmetric_keys.h           |    5 +-
 crypto/asymmetric_keys/asymmetric_type.c           |  265 ++++++++---
 crypto/asymmetric_keys/pkcs7_key_type.c            |    2 -
 crypto/asymmetric_keys/pkcs7_parser.c              |   99 +++--
 crypto/asymmetric_keys/pkcs7_parser.h              |    6 +-
 crypto/asymmetric_keys/pkcs7_trust.c               |   90 +++-
 crypto/asymmetric_keys/pkcs7_verify.c              |  102 +++--
 crypto/asymmetric_keys/signature.c                 |    1 +
 crypto/asymmetric_keys/x509_cert_parser.c          |   57 ++-
 crypto/asymmetric_keys/x509_parser.h               |    8 +-
 crypto/asymmetric_keys/x509_public_key.c           |  115 +++--
 drivers/acpi/video.c                               |   10 +-
 drivers/ata/ahci.c                                 |    1 +
 drivers/ata/libata-core.c                          |   12 +-
 drivers/ata/libata-eh.c                            |    9 +-
 drivers/ata/pata_ep93xx.c                          |    2 +-
 drivers/base/platform.c                            |   18 +-
 drivers/block/drbd/drbd_nl.c                       |    6 +
 drivers/block/zram/zram_drv.c                      |   22 +-
 drivers/bluetooth/ath3k.c                          |    2 -
 drivers/bluetooth/btusb.c                          |    1 -
 drivers/bluetooth/hci_h5.c                         |    1 +
 drivers/char/hw_random/core.c                      |   47 ++-
 drivers/char/hw_random/virtio-rng.c                |   10 +
 drivers/char/random.c                              |   17 +-
 drivers/clk/ti/clk-7xx.c                           |    7 +-
 drivers/cpufreq/Kconfig.arm                        |    3 +-
 drivers/cpufreq/cpufreq-cpu0.c                     |    7 +-
 drivers/cpufreq/cpufreq.c                          |    6 +-
 drivers/cpufreq/sa1110-cpufreq.c                   |    2 +-
 drivers/firewire/Kconfig                           |    1 +
 drivers/firewire/ohci.c                            |    4 +-
 drivers/firmware/efi/efi.c                         |   22 +-
 drivers/firmware/efi/fdt.c                         |   10 -
 drivers/gpio/gpio-mcp23s08.c                       |    6 -
 drivers/gpio/gpio-rcar.c                           |    1 +
 drivers/gpu/drm/i915/i915_gem.c                    |   25 +-
 drivers/gpu/drm/i915/i915_gem_render_state.c       |    4 +-
 drivers/gpu/drm/i915/i915_irq.c                    |   11 +-
 drivers/gpu/drm/i915/intel_display.c               |    4 +
 drivers/gpu/drm/i915/intel_dp.c                    |    4 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |    7 +
 drivers/gpu/drm/i915/intel_panel.c                 |    8 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/temp.c   |    6 +-
 drivers/gpu/drm/qxl/qxl_irq.c                      |    3 +
 drivers/gpu/drm/radeon/atombios_crtc.c             |    8 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   10 +-
 drivers/gpu/drm/radeon/cik.c                       |    2 +
 drivers/gpu/drm/radeon/evergreen.c                 |    6 +-
 drivers/gpu/drm/radeon/evergreen_reg.h             |    1 -
 drivers/gpu/drm/radeon/r600.c                      |    1 +
 drivers/gpu/drm/radeon/radeon.h                    |   18 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   20 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   22 +-
 drivers/gpu/drm/radeon/radeon_display.c            |  198 ++++----
 drivers/gpu/drm/radeon/radeon_drv.c                |    4 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   26 +-
 drivers/gpu/drm/radeon/radeon_vm.c                 |   87 +++-
 drivers/gpu/drm/radeon/rv515.c                     |    5 +-
 drivers/gpu/drm/radeon/si.c                        |    1 +
 drivers/gpu/drm/radeon/trinity_dpm.c               |   15 +-
 drivers/hv/hv_fcopy.c                              |    2 +-
 drivers/hwmon/adt7470.c                            |    6 +-
 drivers/hwmon/da9052-hwmon.c                       |    2 +-
 drivers/hwmon/da9055-hwmon.c                       |    2 +-
 drivers/hwmon/smsc47m192.c                         |    4 +-
 drivers/ide/Kconfig                                |    5 +-
 drivers/ide/ide-probe.c                            |    8 +-
 drivers/iio/accel/bma180.c                         |    8 +-
 drivers/iio/accel/mma8452.c                        |    8 +-
 drivers/iio/industrialio-buffer.c                  |    2 +-
 drivers/iio/industrialio-event.c                   |    3 +
 drivers/infiniband/hw/cxgb4/cm.c                   |   14 +-
 drivers/infiniband/hw/cxgb4/device.c               |   18 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |    2 +-
 drivers/infiniband/hw/mlx5/qp.c                    |    2 +-
 drivers/input/input.c                              |    6 +-
 drivers/input/keyboard/st-keyscan.c                |    2 +
 drivers/input/misc/sirfsoc-onkey.c                 |    2 +-
 drivers/input/mouse/synaptics.c                    |    5 +-
 drivers/input/serio/i8042-x86ia64io.h              |    7 +
 drivers/input/tablet/wacom_wac.c                   |   28 +-
 drivers/input/touchscreen/ti_am335x_tsc.c          |    5 +-
 drivers/iommu/fsl_pamu.c                           |    8 +-
 drivers/iommu/fsl_pamu_domain.c                    |   18 +-
 drivers/irqchip/irq-gic.c                          |    7 +-
 drivers/isdn/gigaset/bas-gigaset.c                 |    1 +
 drivers/isdn/hisax/l3ni1.c                         |   14 +-
 drivers/isdn/i4l/isdn_ppp.c                        |   28 +-
 drivers/md/dm-bufio.c                              |    2 +-
 drivers/md/dm-cache-metadata.c                     |    9 +
 drivers/md/dm-cache-target.c                       |   13 +-
 drivers/md/dm-thin-metadata.c                      |    9 +
 drivers/media/dvb-frontends/si2168.c               |   16 +-
 drivers/media/dvb-frontends/si2168_priv.h          |    2 +-
 drivers/media/dvb-frontends/tda10071.c             |   12 +-
 drivers/media/dvb-frontends/tda10071_priv.h        |    1 +
 drivers/media/pci/saa7134/saa7134-empress.c        |    2 +-
 drivers/media/platform/davinci/vpif_capture.c      |    1 +
 drivers/media/platform/davinci/vpif_display.c      |    1 +
 drivers/media/tuners/si2157.c                      |    2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |   40 ++-
 drivers/media/usb/gspca/pac7302.c                  |    1 +
 drivers/media/usb/hdpvr/hdpvr-video.c              |    6 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |    4 +-
 drivers/mtd/chips/cfi_cmdset_0001.c                |   43 ++
 drivers/mtd/devices/elm.c                          |    2 +
 drivers/mtd/nand/nand_base.c                       |    6 +-
 drivers/mtd/ubi/fastmap.c                          |    4 +-
 drivers/net/bonding/bond_main.c                    |    2 +-
 drivers/net/can/c_can/c_can_platform.c             |    3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c          |    3 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   43 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   12 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   21 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |    2 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |    2 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |    4 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c       |    7 +
 drivers/net/ethernet/intel/igb/e1000_defines.h     |   18 +-
 drivers/net/ethernet/intel/igb/e1000_hw.h          |    3 +
 drivers/net/ethernet/intel/igb/e1000_i210.c        |   66 +++
 drivers/net/ethernet/intel/igb/e1000_i210.h        |   12 +
 drivers/net/ethernet/intel/igb/e1000_regs.h        |    1 +
 drivers/net/ethernet/intel/igb/igb_main.c          |   16 +
 drivers/net/ethernet/marvell/mvneta.c              |    4 +-
 drivers/net/ethernet/mellanox/mlx4/cq.c            |    2 -
 drivers/net/ethernet/mellanox/mlx4/en_cq.c         |    8 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |    7 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |    3 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   17 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   34 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |   69 +---
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |    4 +
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |   19 +-
 drivers/net/ethernet/realtek/r8169.c               |   27 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |    5 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |    2 +-
 drivers/net/ethernet/sun/sunvnet.c                 |   42 ++-
 drivers/net/fddi/defxx.c                           |   17 +-
 drivers/net/hyperv/netvsc.c                        |    4 +-
 drivers/net/phy/dp83640.c                          |    6 +-
 drivers/net/phy/mdio_bus.c                         |   45 ++
 drivers/net/phy/phy_device.c                       |   15 +-
 drivers/net/ppp/ppp_generic.c                      |   30 +-
 drivers/net/ppp/pppoe.c                            |    2 +-
 drivers/net/usb/cdc_ether.c                        |   16 +
 drivers/net/usb/hso.c                              |   50 +--
 drivers/net/usb/huawei_cdc_ncm.c                   |    3 +
 drivers/net/usb/qmi_wwan.c                         |    3 +
 drivers/net/usb/r8152.c                            |   14 +-
 drivers/net/usb/smsc95xx.c                         |   14 +-
 drivers/net/vxlan.c                                |    2 +-
 drivers/net/wan/farsync.c                          |  112 ++--
 drivers/net/wan/x25_asy.c                          |    6 +-
 drivers/net/wireless/ath/ath10k/core.c             |    6 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   18 -
 drivers/net/wireless/ath/ath9k/xmit.c              |    9 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    5 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c            |   12 -
 drivers/net/wireless/iwlwifi/iwl-fw.h              |    1 +
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c        |   20 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |   12 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c            |   65 +--
 drivers/net/wireless/iwlwifi/pcie/drv.c            |    3 +-
 drivers/net/wireless/mwifiex/11n_aggr.c            |    1 +
 drivers/net/wireless/mwifiex/cfg80211.c            |    1 +
 drivers/net/wireless/mwifiex/cmdevt.c              |    1 +
 drivers/net/wireless/mwifiex/main.c                |    1 +
 drivers/net/wireless/mwifiex/sta_tx.c              |    1 +
 drivers/net/wireless/mwifiex/tdls.c                |    2 +
 drivers/net/wireless/mwifiex/txrx.c                |    1 +
 drivers/net/wireless/mwifiex/uap_txrx.c            |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c            |   28 +-
 drivers/net/xen-netback/netback.c                  |   86 +++-
 drivers/net/xen-netfront.c                         |   27 +-
 drivers/of/fdt.c                                   |   66 +++-
 drivers/of/of_mdio.c                               |   34 --
 drivers/parport/Kconfig                            |   12 +-
 drivers/pinctrl/pinctrl-st.c                       |    2 +-
 drivers/pnp/pnpacpi/core.c                         |    3 +-
 drivers/rapidio/devices/tsi721_dma.c               |    8 +-
 drivers/s390/char/raw3270.c                        |    1 -
 drivers/s390/crypto/ap_bus.c                       |    9 +-
 drivers/scsi/scsi_lib.c                            |    8 +
 drivers/staging/media/omap4iss/Kconfig             |    2 +-
 drivers/staging/rtl8723au/os_dep/usb_intf.c        |    4 +-
 drivers/staging/vt6655/bssdb.c                     |    2 +-
 drivers/staging/vt6655/device_main.c               |    7 +-
 drivers/usb/chipidea/udc.c                         |    4 +-
 drivers/usb/core/hub.c                             |   19 +
 drivers/xen/balloon.c                              |   12 +-
 drivers/xen/grant-table.c                          |    9 +-
 drivers/xen/manage.c                               |    5 +-
 fs/afs/main.c                                      |    4 +-
 fs/aio.c                                           |    7 +
 fs/btrfs/ordered-data.c                            |   11 +
 fs/btrfs/volumes.c                                 |    8 +-
 fs/cifs/cifs_spnego.c                              |    1 -
 fs/cifs/cifsacl.c                                  |    1 -
 fs/coredump.c                                      |    2 +-
 fs/direct-io.c                                     |   23 +-
 fs/fuse/dev.c                                      |   51 +-
 fs/fuse/dir.c                                      |   41 +-
 fs/fuse/file.c                                     |    8 +-
 fs/fuse/inode.c                                    |   27 +-
 fs/gfs2/file.c                                     |    4 +-
 fs/gfs2/glock.c                                    |   14 +-
 fs/gfs2/glops.c                                    |    4 +-
 fs/gfs2/lock_dlm.c                                 |    4 +-
 fs/gfs2/rgrp.c                                     |    4 +-
 fs/namei.c                                         |    5 +-
 fs/nfs/direct.c                                    |    2 -
 fs/nfs/idmap.c                                     |    2 -
 fs/nfs/internal.h                                  |    1 +
 fs/nfs/nfs3acl.c                                   |   43 ++
 fs/nfs/nfs3proc.c                                  |    4 +-
 fs/nfs/pagelist.c                                  |   20 +-
 fs/nfs/write.c                                     |  335 ++++++++++--
 fs/nfsd/nfs4xdr.c                                  |    4 +-
 fs/nfsd/vfs.c                                      |    2 +-
 fs/open.c                                          |    5 +-
 fs/quota/dquot.c                                   |    2 +
 fs/xattr.c                                         |    2 +-
 fs/xfs/xfs_bmap.c                                  |    7 +-
 fs/xfs/xfs_bmap.h                                  |    4 +-
 fs/xfs/xfs_bmap_util.c                             |   53 --
 fs/xfs/xfs_bmap_util.h                             |    4 -
 fs/xfs/xfs_btree.c                                 |   82 +++-
 fs/xfs/xfs_iomap.c                                 |    3 +-
 fs/xfs/xfs_sb.c                                    |   25 +-
 include/crypto/public_key.h                        |    6 +-
 include/dt-bindings/pinctrl/dra.h                  |    7 +-
 include/keys/asymmetric-type.h                     |   41 ++
 include/keys/user-type.h                           |    1 -
 include/linux/cpufreq.h                            |    4 +-
 include/linux/hugetlb.h                            |    1 +
 include/linux/ima.h                                |    4 +-
 include/linux/kernel.h                             |    1 +
 include/linux/key-type.h                           |   34 +-
 include/linux/libata.h                             |    1 +
 include/linux/mlx4/device.h                        |    4 +-
 include/linux/mutex.h                              |    4 +-
 include/linux/of_fdt.h                             |    3 +
 include/linux/of_mdio.h                            |    8 -
 include/linux/osq_lock.h                           |   27 +
 include/linux/pagemap.h                            |   12 +
 include/linux/rcupdate.h                           |   46 +--
 include/linux/rwsem-spinlock.h                     |    8 +-
 include/linux/rwsem.h                              |   34 +-
 include/linux/sched.h                              |    8 +-
 include/linux/security.h                           |    2 +-
 include/net/ip.h                                   |   11 +-
 include/net/neighbour.h                            |    1 -
 include/net/netfilter/nf_tables.h                  |    6 +-
 include/net/netns/ieee802154_6lowpan.h             |    2 +-
 include/net/netns/nftables.h                       |    2 +-
 include/net/sock.h                                 |   12 +-
 include/uapi/linux/fuse.h                          |    3 +
 include/xen/grant_table.h                          |    1 +
 kernel/Kconfig.locks                               |    9 +-
 kernel/events/core.c                               |   34 ++-
 kernel/kexec.c                                     |    4 +
 kernel/kprobes.c                                   |   14 +-
 kernel/locking/mcs_spinlock.c                      |   64 ++-
 kernel/locking/mcs_spinlock.h                      |    9 +-
 kernel/locking/mutex.c                             |    2 +-
 kernel/locking/rwsem-spinlock.c                    |   28 +-
 kernel/locking/rwsem-xadd.c                        |   16 +-
 kernel/locking/rwsem.c                             |    2 +-
 kernel/power/process.c                             |    1 +
 kernel/power/suspend.c                             |    4 +-
 kernel/rcu/rcutorture.c                            |    4 +-
 kernel/rcu/tree.c                                  |  140 ++++-
 kernel/rcu/tree.h                                  |    6 +-
 kernel/rcu/tree_plugin.h                           |    2 +-
 kernel/rcu/update.c                                |   22 +-
 kernel/sched/core.c                                |    7 +-
 kernel/sched/debug.c                               |    2 +-
 kernel/time/alarmtimer.c                           |   20 +-
 kernel/time/clockevents.c                          |   10 +-
 kernel/time/sched_clock.c                          |    4 +-
 kernel/trace/ftrace.c                              |    4 +-
 kernel/trace/ring_buffer.c                         |    4 -
 kernel/trace/trace.c                               |   20 +-
 kernel/trace/trace_clock.c                         |    9 +-
 kernel/trace/trace_events.c                        |    1 +
 lib/cpumask.c                                      |    2 +-
 lib/hexdump.c                                      |   16 +
 mm/filemap.c                                       |   13 +-
 mm/hugetlb.c                                       |    3 +-
 mm/memcontrol.c                                    |    4 +
 mm/memory-failure.c                                |   18 +-
 mm/memory.c                                        |   24 +-
 mm/migrate.c                                       |    5 +-
 mm/page-writeback.c                                |    6 +-
 mm/page_alloc.c                                    |   31 +-
 mm/rmap.c                                          |   10 +-
 mm/shmem.c                                         |  102 +++--
 mm/slab_common.c                                   |    2 +-
 mm/truncate.c                                      |   11 +-
 net/8021q/vlan_dev.c                               |   13 +-
 net/appletalk/ddp.c                                |    3 -
 net/batman-adv/bridge_loop_avoidance.c             |   44 ++-
 net/batman-adv/soft-interface.c                    |   60 ++-
 net/batman-adv/translation-table.c                 |   26 +
 net/batman-adv/types.h                             |    2 +
 net/bluetooth/hci_conn.c                           |   12 +-
 net/bluetooth/smp.c                                |   60 ++-
 net/ceph/crypto.c                                  |    1 -
 net/compat.c                                       |    9 +-
 net/core/dev.c                                     |   32 +-
 net/core/iovec.c                                   |    6 +-
 net/core/neighbour.c                               |   11 +-
 net/dns_resolver/dns_key.c                         |   18 +-
 net/dns_resolver/dns_query.c                       |    2 +-
 net/ipv4/af_inet.c                                 |    3 +
 net/ipv4/gre_demux.c                               |    1 +
 net/ipv4/gre_offload.c                             |    3 +
 net/ipv4/icmp.c                                    |    2 -
 net/ipv4/igmp.c                                    |   10 +-
 net/ipv4/ip_options.c                              |    4 +
 net/ipv4/ip_tunnel.c                               |   12 +-
 net/ipv4/route.c                                   |   47 ++-
 net/ipv4/tcp.c                                     |    3 +-
 net/ipv4/tcp_input.c                               |    8 +-
 net/ipv4/tcp_offload.c                             |    2 +-
 net/ipv4/tcp_output.c                              |    6 +-
 net/ipv4/udp.c                                     |    5 +-
 net/ipv6/ip6_output.c                              |    2 +
 net/ipv6/mcast.c                                   |   13 +-
 net/ipv6/tcpv6_offload.c                           |    2 +-
 net/ipv6/udp.c                                     |    6 +-
 net/l2tp/l2tp_ppp.c                                |    4 +-
 net/mac80211/cfg.c                                 |    5 +-
 net/mac80211/tx.c                                  |   20 +-
 net/mac80211/util.c                                |    5 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |    1 -
 net/netfilter/nf_tables_api.c                      |  140 ++++--
 net/netfilter/nf_tables_core.c                     |   10 +-
 net/netlink/af_netlink.c                           |    4 +-
 net/openvswitch/actions.c                          |    2 +
 net/openvswitch/datapath.c                         |   27 +-
 net/openvswitch/flow.c                             |    4 +-
 net/openvswitch/flow.h                             |    5 +-
 net/openvswitch/flow_table.c                       |   16 +
 net/openvswitch/flow_table.h                       |    3 +-
 net/openvswitch/vport-gre.c                        |   17 +
 net/rxrpc/ar-key.c                                 |    2 -
 net/sched/cls_u32.c                                |   19 +-
 net/sctp/associola.c                               |    1 +
 net/sctp/ulpevent.c                                |  122 +----
 net/tipc/bcast.c                                   |    1 +
 net/tipc/msg.c                                     |   11 +-
 net/wireless/core.h                                |    2 +-
 net/wireless/nl80211.c                             |   11 +-
 net/wireless/reg.c                                 |   22 +-
 net/wireless/trace.h                               |    3 +-
 net/xfrm/xfrm_policy.c                             |    2 +
 net/xfrm/xfrm_user.c                               |    7 +-
 security/integrity/Kconfig                         |   46 ++-
 security/integrity/Makefile                        |    6 +-
 security/integrity/digsig_asymmetric.c             |    7 +-
 security/integrity/evm/Kconfig                     |    8 -
 security/integrity/evm/evm_main.c                  |   17 +-
 security/integrity/ima/Kconfig                     |    2 -
 security/integrity/ima/ima.h                       |   24 +-
 security/integrity/ima/ima_api.c                   |   10 +-
 security/integrity/ima/ima_appraise.c              |   17 +-
 security/integrity/ima/ima_crypto.c                |   20 +-
 security/integrity/ima/ima_init.c                  |   25 +-
 security/integrity/ima/ima_main.c                  |  123 +++--
 security/integrity/ima/ima_policy.c                |   23 +
 security/integrity/ima/ima_template.c              |   30 +-
 security/integrity/integrity.h                     |    2 +-
 security/keys/big_key.c                            |    2 -
 security/keys/encrypted-keys/encrypted.c           |    1 -
 security/keys/internal.h                           |   21 +-
 security/keys/key.c                                |    2 +-
 security/keys/keyctl.c                             |    2 +
 security/keys/keyring.c                            |   58 ++-
 security/keys/proc.c                               |    8 +-
 security/keys/process_keys.c                       |   13 +-
 security/keys/request_key.c                        |   21 +-
 security/keys/request_key_auth.c                   |   10 +-
 security/keys/trusted.c                            |    1 -
 security/keys/user_defined.c                       |   14 -
 security/selinux/hooks.c                           |  135 +++--
 security/selinux/include/netif.h                   |    4 +-
 security/selinux/include/objsec.h                  |    2 +
 security/selinux/netif.c                           |   43 +-
 security/selinux/ss/services.c                     |   14 +-
 security/smack/Kconfig                             |   16 +
 security/smack/smack.h                             |   39 +-
 security/smack/smack_access.c                      |  118 ++---
 security/smack/smack_lsm.c                         |  545 ++++++++++++++------
 security/smack/smackfs.c                           |   76 ++--
 sound/firewire/bebob/bebob_maudio.c                |   53 ++-
 sound/pci/hda/hda_controller.c                     |    3 +-
 sound/pci/hda/hda_intel.c                          |   12 +-
 sound/pci/hda/hda_priv.h                           |    1 +
 sound/pci/hda/hda_tegra.c                          |    2 +-
 sound/pci/hda/patch_hdmi.c                         |    2 +
 tools/lib/lockdep/include/liblockdep/mutex.h       |    4 +-
 tools/lib/lockdep/include/liblockdep/rwlock.h      |    8 +-
 tools/lib/lockdep/preload.c                        |   20 +-
 tools/perf/ui/browsers/hists.c                     |   21 +-
 tools/perf/util/machine.c                          |   54 +--
 virt/kvm/arm/vgic.c                                |   24 +-
 531 files changed, 5773 insertions(+), 3166 deletions(-)
 create mode 100644 include/linux/osq_lock.h
