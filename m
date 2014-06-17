Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965444AbaFQVpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:45:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53549 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965112AbaFQVpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.13.y.z extended stable] Linux 3.13.11.4 stable review
Date: Tue, 17 Jun 2014 14:41:34 -0700
Message-Id: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.13.11.4 stable kernel.

This version contains 212 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review

The review period for version 3.13.11.4 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.13.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 Documentation/ABI/testing/ima_policy              |   2 +-
 Documentation/devicetree/bindings/dma/ti-edma.txt |   4 +-
 arch/arm/boot/dts/am33xx.dtsi                     |   2 +-
 arch/arm/boot/dts/armada-xp-db.dts                |   2 +-
 arch/arm/boot/dts/armada-xp-gp.dts                |   2 +-
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts  |   2 +-
 arch/arm/boot/dts/imx53.dtsi                      |   2 +-
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts    |  18 +-
 arch/arm/boot/dts/kirkwood-nsa310-common.dtsi     |  18 +-
 arch/arm/boot/dts/ste-ccu8540.dts                 |   1 +
 arch/arm/common/edma.c                            |  48 +---
 arch/arm/include/asm/uaccess.h                    |   3 +-
 arch/arm/kernel/entry-header.S                    |   4 +
 arch/arm/mach-imx/devices/platform-ipu-core.c     |   2 +-
 arch/arm/mach-omap2/board-flash.c                 |   2 +-
 arch/arm/mach-omap2/cclock3xxx_data.c             |   3 +-
 arch/arm/mach-omap2/cpuidle44xx.c                 |  25 +-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c        |   2 +-
 arch/arm/mach-orion5x/common.h                    |   2 +-
 arch/arm64/mm/hugetlbpage.c                       |   4 +
 arch/ia64/configs/generic_defconfig               |   1 -
 arch/ia64/configs/tiger_defconfig                 |   1 -
 arch/ia64/configs/zx1_defconfig                   |   1 -
 arch/metag/include/asm/barrier.h                  |   3 +
 arch/metag/include/asm/processor.h                |   2 +
 arch/mips/lantiq/dts/easy50712.dts                |   1 +
 arch/mips/ralink/dts/mt7620a_eval.dts             |   1 +
 arch/mips/ralink/dts/rt2880_eval.dts              |   1 +
 arch/mips/ralink/dts/rt3052_eval.dts              |   1 +
 arch/mips/ralink/dts/rt3883_eval.dts              |   1 +
 arch/parisc/Kconfig                               |   1 +
 arch/parisc/include/asm/processor.h               |   2 +
 arch/parisc/kernel/syscall.S                      |  12 +-
 arch/parisc/kernel/traps.c                        |  54 ++--
 arch/parisc/mm/fault.c                            |  44 ++-
 arch/powerpc/Makefile                             |   4 +-
 arch/powerpc/include/asm/ppc_asm.h                |   7 +-
 arch/powerpc/kernel/machine_kexec_64.c            |   2 +-
 arch/powerpc/platforms/powernv/eeh-ioda.c         |   3 +-
 arch/s390/net/bpf_jit_comp.c                      |   2 +-
 arch/x86/configs/i386_defconfig                   |   1 -
 arch/x86/configs/x86_64_defconfig                 |   1 -
 arch/x86/include/asm/hugetlb.h                    |   1 +
 arch/x86/kernel/ldt.c                             |   4 +-
 arch/x86/net/bpf_jit_comp.c                       |   2 +-
 arch/x86/vdso/vdso32-setup.c                      |   8 +
 drivers/acpi/Kconfig                              |  22 +-
 drivers/acpi/Makefile                             |   1 +
 drivers/acpi/ac.c                                 | 117 ++++----
 drivers/acpi/acpi_platform.c                      |   1 -
 drivers/acpi/acpi_processor.c                     |   1 -
 drivers/acpi/battery.c                            | 329 +++++++++++++++++++++-
 drivers/acpi/blacklist.c                          |  21 ++
 drivers/acpi/cm_sbs.c                             | 105 +++++++
 drivers/ata/libata-core.c                         |   9 +
 drivers/block/virtio_blk.c                        |  14 +-
 drivers/bus/mvebu-mbus.c                          |   6 -
 drivers/clk/clk.c                                 |  71 ++---
 drivers/clk/tegra/clk-pll.c                       |  10 +-
 drivers/clk/tegra/clk-tegra114.c                  |   3 +-
 drivers/cpufreq/cpufreq-cpu0.c                    |  16 +-
 drivers/cpufreq/cpufreq_governor.c                |   6 +
 drivers/cpufreq/intel_pstate.c                    |  21 +-
 drivers/crypto/caam/error.c                       |  10 +-
 drivers/dma/dmaengine.c                           |   2 +
 drivers/dma/dw/core.c                             |  11 +-
 drivers/dma/mv_xor.c                              |   8 +-
 drivers/gpio/gpio-mcp23s08.c                      |  12 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c        |  54 ++--
 drivers/gpu/drm/i915/intel_panel.c                |   8 +-
 drivers/gpu/drm/i915/intel_pm.c                   |  40 +++
 drivers/gpu/drm/i915/intel_uncore.c               |   2 +
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c   |   2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c            |   6 +-
 drivers/gpu/drm/radeon/radeon_asic.c              |   4 +-
 drivers/gpu/drm/radeon/radeon_bios.c              |  14 +
 drivers/gpu/drm/radeon/radeon_cs.c                |  21 +-
 drivers/gpu/drm/radeon/radeon_device.c            |   5 +
 drivers/gpu/drm/radeon/radeon_kms.c               |  57 ++--
 drivers/gpu/drm/radeon/radeon_object.c            |  38 ++-
 drivers/gpu/drm/radeon/radeon_pm.c                |  43 ++-
 drivers/gpu/drm/radeon/sid.h                      |   4 +-
 drivers/hwmon/emc1403.c                           |  10 +-
 drivers/i2c/busses/i2c-designware-core.c          |   3 +
 drivers/i2c/busses/i2c-rcar.c                     |   9 +-
 drivers/i2c/busses/i2c-s3c2410.c                  |   2 +-
 drivers/infiniband/ulp/isert/ib_isert.c           |  29 +-
 drivers/infiniband/ulp/isert/ib_isert.h           |   2 +-
 drivers/input/mouse/synaptics.c                   |  10 +-
 drivers/iommu/amd_iommu.c                         |   2 +-
 drivers/md/dm-cache-target.c                      |   2 +
 drivers/md/dm-crypt.c                             |  61 +---
 drivers/md/md.c                                   |   8 +-
 drivers/media/i2c/ov7670.c                        |   2 +-
 drivers/media/media-device.c                      |   1 +
 drivers/media/tuners/fc2580.c                     |   6 +-
 drivers/media/tuners/fc2580_priv.h                |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c     |  12 +-
 drivers/memory/mvebu-devbus.c                     |  15 +-
 drivers/net/bonding/bond_main.c                   |   1 +
 drivers/net/can/led.c                             |   3 +
 drivers/net/can/sja1000/peak_pci.c                |  14 +-
 drivers/net/ethernet/broadcom/tg3.c               |   4 +-
 drivers/net/ethernet/sfc/nic.c                    |  14 +-
 drivers/net/macvlan.c                             |  21 +-
 drivers/net/macvtap.c                             |   9 +
 drivers/net/slip/slip.c                           |   6 +-
 drivers/net/usb/cdc_mbim.c                        |  57 ++--
 drivers/net/usb/cdc_ncm.c                         |   2 +-
 drivers/net/usb/qmi_wwan.c                        |  28 ++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c       |   2 +-
 drivers/pci/host/pci-mvebu.c                      |  92 ++++--
 drivers/pci/hotplug/shpchp_ctrl.c                 |   4 +-
 drivers/spi/spi.c                                 |  11 +-
 drivers/staging/speakup/main.c                    |   1 +
 drivers/staging/speakup/selection.c               |  38 ++-
 drivers/staging/speakup/speakup.h                 |   1 +
 drivers/target/iscsi/iscsi_target.c               |   4 +-
 drivers/target/iscsi/iscsi_target_login.c         |  57 ++--
 drivers/target/target_core_configfs.c             |   5 +
 drivers/target/target_core_device.c               |   8 +-
 drivers/target/target_core_transport.c            |   2 +-
 drivers/target/tcm_fc/tfc_cmd.c                   |   8 +-
 drivers/usb/core/driver.c                         |   9 +-
 drivers/usb/core/hub.c                            |  15 +-
 drivers/usb/host/xhci-mem.c                       |  20 +-
 drivers/usb/serial/ftdi_sio.c                     |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                 |   5 +
 drivers/usb/serial/io_ti.c                        |   2 +-
 drivers/usb/serial/io_usbvend.h                   |   2 +-
 drivers/usb/serial/option.c                       |   2 +
 fs/exec.c                                         |   6 +-
 fs/nfsd/nfs4acl.c                                 |  17 +-
 fs/nfsd/nfs4state.c                               |  40 ++-
 fs/proc/task_mmu.c                                |   2 +-
 fs/sysfs/file.c                                   |   3 +-
 include/linux/dmaengine.h                         |   1 +
 include/linux/if_macvlan.h                        |   1 +
 include/linux/if_vlan.h                           |   3 +-
 include/linux/interrupt.h                         |   5 +
 include/linux/net.h                               |  15 +-
 include/linux/netdevice.h                         |  18 +-
 include/linux/percpu-refcount.h                   |   6 +-
 include/linux/rtnetlink.h                         |   5 +
 include/net/af_vsock.h                            |   6 +-
 include/net/ip6_route.h                           |   5 +
 include/net/sctp/structs.h                        |   4 +-
 include/uapi/linux/usb/cdc-wdm.h                  |   2 +
 kernel/events/core.c                              |  16 +-
 kernel/futex.c                                    | 239 ++++++++++++----
 kernel/hrtimer.c                                  |   8 +-
 kernel/kexec.c                                    |   8 +
 kernel/locking/rtmutex.c                          |  32 ++-
 kernel/sched/cpupri.c                             |   3 +-
 kernel/sched/cputime.c                            |  32 +--
 kernel/workqueue.c                                |  36 ++-
 mm/memory-failure.c                               |  17 +-
 mm/mempolicy.c                                    |   6 +-
 mm/mremap.c                                       |   9 +-
 mm/percpu.c                                       |   2 +-
 mm/rmap.c                                         |   3 +-
 net/8021q/vlan.c                                  |   1 +
 net/8021q/vlan_dev.c                              |  13 +-
 net/batman-adv/distributed-arp-table.c            |   3 +-
 net/batman-adv/fragmentation.c                    |  11 +-
 net/batman-adv/gateway_client.c                   |  11 +-
 net/bridge/br_input.c                             |   2 +-
 net/bridge/br_netlink.c                           |  15 +
 net/bridge/br_vlan.c                              |   7 +-
 net/ceph/messenger.c                              |  20 +-
 net/core/dev.c                                    |  54 +++-
 net/core/filter.c                                 |   6 +-
 net/core/net_namespace.c                          |   2 +-
 net/core/rtnetlink.c                              |  66 ++++-
 net/core/skbuff.c                                 |  16 +-
 net/core/utils.c                                  |   8 +-
 net/ipv4/fib_semantics.c                          |   2 +-
 net/ipv4/ip_forward.c                             |   4 +-
 net/ipv4/ip_gre.c                                 |   2 +-
 net/ipv4/ip_tunnel.c                              |   3 +
 net/ipv4/ip_vti.c                                 |   2 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c               |   5 +-
 net/ipv4/ping.c                                   |  15 +-
 net/ipv4/route.c                                  |   4 +-
 net/ipv4/tcp_cubic.c                              |   2 +-
 net/ipv6/ip6_fib.c                                |   3 +-
 net/ipv6/ip6_gre.c                                |  10 +
 net/ipv6/ip6_output.c                             |   8 +-
 net/ipv6/ip6_tunnel.c                             |   2 +-
 net/ipv6/route.c                                  |   5 +-
 net/iucv/af_iucv.c                                |   2 +-
 net/l2tp/l2tp_ppp.c                               |   4 +-
 net/mac80211/ieee80211_i.h                        |   1 +
 net/mac80211/mlme.c                               |  20 +-
 net/mac80211/offchannel.c                         |  27 +-
 net/sctp/auth.c                                   |  17 +-
 net/sctp/endpointola.c                            |   3 +-
 net/sctp/protocol.c                               |   7 +-
 net/sctp/sm_make_chunk.c                          |  32 ++-
 net/sctp/sm_sideeffect.c                          |   8 +-
 net/sctp/sm_statefuns.c                           |   6 +-
 net/sctp/socket.c                                 |  96 +++++--
 net/sctp/sysctl.c                                 |  36 ++-
 net/sunrpc/clnt.c                                 |  12 +-
 net/vmw_vsock/af_vsock.c                          |  47 ++--
 net/wireless/sme.c                                |   2 +-
 security/device_cgroup.c                          | 203 ++++++++++---
 security/integrity/ima/ima_api.c                  |  10 +-
 security/integrity/ima/ima_crypto.c               |  32 ++-
 security/integrity/ima/ima_main.c                 |   5 +-
 security/integrity/ima/ima_policy.c               |   6 +-
 security/integrity/integrity.h                    |   1 +
 sound/pci/hda/hda_intel.c                         |   3 +
 sound/pci/hda/patch_analog.c                      |   1 +
 sound/pci/hda/patch_realtek.c                     |  13 +-
 sound/soc/codecs/wm8962.c                         |  15 +-
 sound/soc/codecs/wm8962.h                         |   4 +
 217 files changed, 2538 insertions(+), 954 deletions(-)

Aaron Lu (1):
      drm/i915: restore backlight precision when converting from ACPI

Alan Stern (1):
      USB: Avoid runtime suspend loops for HCDs that can't handle suspend/resume

Alex Deucher (4):
      drm/radeon: handle non-VGA class pci devices with ATRM
      drm/radeon: fix register typo on si
      drm/radeon/pm: don't allow debugfs/sysfs access when PX card is off (v2)
      drm/radeon/dpm: resume fixes for some systems

Alex Williamson (1):
      iommu/amd: Fix interrupt remapping for aliased devices

Alexei Starovoitov (1):
      net: filter: x86: fix JIT address randomization

Alexej Starschenko (1):
      USB: serial: option: add support for Novatel E371 PCIe card

Andrey Ryabinin (2):
      ARM: 8051/1: put_user: fix possible data corruption in put_user
      mm: rmap: fix use-after-free in __put_anon_vma

Andy Grover (1):
      target: Don't allow setting WC emulation if device doesn't support

Andy King (1):
      vsock: Make transport the proto owner

Andy Shevchenko (1):
      dmaengine: dw: went back to plain {request,free}_irq() calls

Anthony Iliopoulos (1):
      x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()

Antonio Quartulli (3):
      batman-adv: fix reference counting imbalance while sending fragment
      batman-adv: increase orig refcount when storing ref in gw_node
      batman-adv: fix local TT check for outgoing arp requests in DAT

Antti Palosaari (1):
      [media] fc2580: fix tuning failure on 32-bit arch

Aristeu Rozanski (2):
      device_cgroup: rework device access check and exception checking
      device_cgroup: check if exception removal is allowed

Arnd Bergmann (1):
      genirq: Provide irq_force_affinity fallback for non-SMP

Ben Hutchings (1):
      Staging: speakup: Move pasting into a work item

Ben Skeggs (1):
      drm/gf119-/disp: fix nasty bug which can clobber SOR0's clock setup

Bibek Basu (1):
      cpufreq: remove race while accessing cur_policy

Bjørn Mork (10):
      net: qmi_wwan: add Sierra Wireless EM7355
      net: qmi_wwan: add Sierra Wireless MC73xx
      net: qmi_wwan: add Sierra Wireless MC7305/MC7355
      net: qmi_wwan: add Olivetti Olicard 500
      net: qmi_wwan: add Alcatel L800MA
      net: qmi_wwan: add a number of CMOTech devices
      net: qmi_wwan: add a number of Dell devices
      net: cdc_ncm: fix buffer overflow
      net: cdc_mbim: __vlan_find_dev_deep need rcu_read_lock
      net: cdc_mbim: handle unaccelerated VLAN tagged frames

Charles Keepax (1):
      ASoC: wm8962: Update register CLASS_D_CONTROL_1 to be non-volatile

Chen Yucong (1):
      hwpoison, hugetlb: lock_page/unlock_page does not match for handling a free hugepage

Chris Wilson (1):
      drm/i915: Only copy back the modified fields to userspace from execbuffer

Christian König (3):
      drm/radeon: also try GART for CPU accessed buffers
      drm/radeon: avoid crash if VM command submission isn't available
      drm/radeon: use the CP DMA on CIK

Chunwei Chen (1):
      libceph: fix corruption when using page_count 0 page in rbd

Cong Wang (1):
      rtnetlink: wait for unregistering devices in rtnl_link_unregister()

Daeseok Youn (1):
      workqueue: fix bugs in wq_update_unbound_numa() failure path

Daniel Borkmann (2):
      net: sctp: wake up all assocs if sndbuf policy is per socket
      net: sctp: test if association is dead in sctp_wake_up_waiters

David Gibson (2):
      rtnetlink: Warn when interface's information won't fit in our packet
      rtnetlink: Only supply IFLA_VF_PORTS information when RTEXT_FILTER_VF is set

Dirk Brandewie (1):
      intel_pstate: Set turbo VID for BayTrail

Dmitry Kasatkin (1):
      ima: introduce ima_kernel_read()

Dmitry Petukhov (1):
      l2tp: take PMTU from tunnel UDP socket

Du, Wenkai (1):
      i2c: designware: Mask all interrupts during i2c controller enable

Edward Lin (1):
      ACPI: blacklist win8 OSI for Dell Inspiron 7737

Eliad Peller (1):
      cfg80211: free sme on connection failures

Emil Goode (1):
      ARM: imx: fix error handling in ipu device registration

Emmanuel Grumbach (2):
      mac80211: fix suspend vs. association race
      iwlwifi: mvm: fix setting channel in monitor mode

Eric Dumazet (3):
      ipv6: Limit mtu to 65575 bytes
      net: gro: make sure skb->cb[] initial content has not to be zero
      net-gro: reset skb->truesize in napi_reuse_skb()

Ezequiel Garcia (1):
      dma: mv_xor: Flush descriptors before activating a channel

Florian Westphal (4):
      net: core: don't account for udp header size when computing seglen
      net: ipv4: ip_forward: fix inverted local_df test
      net: ipv6: send pkttoobig immediately if orig frag size > mtu
      netfilter: ipv4: defrag: set local_df flag on defragmented skb

Gavin Shan (1):
      powerpc/powernv: Reset root port in firmware

Geert Uytterhoeven (1):
      spi: core: Ignore unsupported Dual/Quad Transfer Mode bits

George McCollister (1):
      USB: ftdi_sio: add NovaTech OrionLXm product ID

Greg Kroah-Hartman (1):
      USB: cdc-wdm: properly include types.h

Guennadi Liakhovetski (2):
      [media] V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
      [media] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode

Guenter Roeck (2):
      ACPI: Revert "ACPI / AC: convert ACPI ac driver to platform bus"
      powerpc: Fix 64 bit builds with binutils 2.24

Hannes Frederic Sowa (2):
      net: avoid dependency of net_get_random_once on nop patching
      ipv6: fix calculation of option len in ip6_append_data

Hans de Goede (3):
      ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015PX
      Input: synaptics - add min/max quirk for the ThinkPad W540
      Input: synaptics - T540p - unify with other LEN0034 models

Heiko Carstens (1):
      net: filter: s390: fix JIT address randomization

Heinz Mauelshagen (1):
      dm cache: always split discards on cache block boundaries

Helge Deller (1):
      parisc: ratelimit userspace segfault printing

Horia Geanta (1):
      crypto: caam - add allocation failure handling in SPRINTFCAT macro

Hui Wang (1):
      ALSA: hda - add headset mic detect quirks for three Dell laptops

Igor Mammedov (1):
      ACPI / processor: do not mark present at boot but not onlined CPU as onlined

Ivan Vecera (1):
      tg3: update rx_jumbo_pending ring param only when jumbo frames are enabled

J. Bruce Fields (2):
      nfsd4: remove lockowner when removing lock stateid
      nfsd4: warn on finding lockowner without stateid's

James Hogan (1):
      metag: Reduce maximum stack size to 256MB

Jani Nikula (1):
      drm/i915/vlv: reset VLV media force wake request register

Jean Delvare (1):
      hwmon: (emc1403) Fix resource leak on module unload

Jianyu Zhan (1):
      percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()

Jiri Olsa (1):
      perf: Prevent false warning in perf_swevent_add

Johan Hovold (1):
      USB: io_ti: fix firmware download on big-endian machines (part 2)

Johannes Berg (1):
      mac80211: fix on-channel remain-on-channel

John David Anglin (1):
      parisc: Improve LWS-CAS performance

Josef Gajdusek (2):
      hwmon: (emc1403) fix inverted store_hyst()
      hwmon: (emc1403) Support full range of known chip revision numbers

Julian Anastasov (1):
      ipv4: return valid RTA_IIF on ip route get

Jérôme Glisse (1):
      drm/radeon: avoid segfault on device open when accel is not working.

Karl Heiss (1):
      net: sctp: Don't transition to PF state when transport has exhausted 'Path.Max.Retrans'.

Kinglong Mee (1):
      NFSD: Call ->set_acl with a NULL ACL structure if no entries

Kirill A. Shutemov (1):
      mm, thp: close race between mremap() and split_huge_page()

Kumar Sundararajan (1):
      ipv6: fib: fix fib dump restart

Lai Jiangshan (2):
      workqueue: make rescuer_thread() empty wq->maydays list before exiting
      workqueue: fix a possible race condition between rescuer and pwq-release

Lan Tianyu (2):
      ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"
      ACPI: Revert "ACPI / Battery: Remove battery's proc directory"

Laurent Pinchart (1):
      ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms

Leif Lindholm (2):
      arm: dts: Fix missing device_type="memory" for ste-ccu8540
      mips: dts: Fix missing device_type="memory" property in memory nodes

Levente Kurusa (1):
      libata: clean up ZPODD when a port is detached

Li RongQing (1):
      ipv4: initialise the itag variable in __mkroute_input

Linus Torvalds (1):
      x86-64, modify_ldt: Make support for 16-bit segments a runtime option

Liu Yu (1):
      tcp_cubic: fix the range of delayed_ack

Lucas Stach (1):
      cpufreq: cpu0: drop wrong devm usage

Marcel Apfelbaum (1):
      PCI: shpchp: Check bridge's secondary (not primary) bus speed

Marek Olšák (1):
      drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission

Mark Salter (1):
      arm64: fix pud_huge() for 2-level pagetables

Mathias Krause (1):
      filter: prevent nla extensions to peek beyond the end of the message

Mathias Nyman (1):
      xhci: delete endpoints from bandwidth list before freeing whole device

Matija Glavinic Pecotic (1):
      net: sctp: Potentially-Failed state should not be reached from unconfirmed state

Michael Welling (1):
      gpio: mcp23s08: Bug fix of SPI device tree registration.

Mikulas Patocka (3):
      dm crypt: fix cpu hotplug crash by removing per-cpu structure
      metag: fix memory barriers
      target: fix memory leak on XCOPY

Mimi Zohar (1):
      ima: audit log files opened with O_DIRECT flag

Ming Lei (1):
      virtio_blk: fix race between start and stop queue

Naoya Horiguchi (2):
      mm/memory-failure.c: fix memory leak by race between poison and unpoison
      mm: add !pte_present() check on existing hugetlb_entry callbacks

NeilBrown (3):
      md: avoid possible spinning md thread at shutdown.
      md: always set MD_RECOVERY_INTR when aborting a reshape or other "resync".
      md: always set MD_RECOVERY_INTR when interrupting a reshape thread.

Nicholas Bellinger (4):
      iscsi-target: Change BUG_ON to REJECT in iscsit_process_nop_out
      tcm_fc: Fix free-after-use regression in ft_free_cmd
      iser-target: Add missing target_put_sess_cmd for ImmedateData failure
      target: Fix alua_access_state attribute OOPs for un-configured devices

Nicolas Dichtel (3):
      gre: don't allow to add the same tunnel twice
      vti: don't allow to add the same tunnel twice
      ip6_gre: don't allow to remove the fb_tunnel_dev

Nikolay Aleksandrov (1):
      sfc: fix calling of free_irq with already free vector

Oliver Hartkopp (2):
      slip: fix spinlock variant
      can: only rename enabled led triggers when changing the netdev name

Olof Johansson (1):
      i2c: s3c2410: resume race fix

Paul Bolle (1):
      ACPI: Remove Kconfig symbol ACPI_PROCFS

Peter Christensen (1):
      macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.

Peter De Schrijver (1):
      clk: tegra: use pll_ref as the pll_e parent

Peter Ujfalusi (1):
      ARM: omap5: hwmod_data: Correct IDLEMODE for McPDM

Peter Zijlstra (1):
      perf: Limit perf_event_attr::sample_period to 63 bits

Rabin Vincent (1):
      ARM: 8064/1: fix v7-M signal return

Roger Quadros (1):
      ARM: OMAP2+: nand: Fix NAND on OMAP2 and OMAP3 boards

Roland Dreier (1):
      iscsi-target: Fix wrong buffer / buffer overrun in iscsi_change_param_value()

Ronan Marquet (1):
      ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop

Rusty Russell (1):
      virtio_blk: don't crash, report error if virtqueue is broken.

Sagi Grimberg (2):
      Target/iser: Fix wrong connection requests list addition
      Target/iser: Fix iscsit_accept_np and rdma_cm racy flow

Salva Peiró (1):
      [media] media-device: fix infoleak in ioctl media_enum_entities()

Santosh Shilimkar (1):
      ARM: OMAP4: Fix the boot regression with CPU_IDLE enabled

Sascha Hauer (1):
      ARM: dts: i.MX53: Fix ipu register space size

Sebastian Hesselbarth (1):
      ARM: dts: kirkwood: fix mislocated pcie-controller nodes

Sebastian Ott (1):
      percpu-refcount: fix usage of this_cpu_ops

Sergey Popovich (1):
      ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation

Srivatsa S. Bhat (1):
      powerpc, kexec: Fix "Processor X is stuck" issue during kexec from ST mode

Steffen Klassert (1):
      ip_tunnel: Initialize the fallback device properly

Stephane Grosjean (1):
      can: peak_pci: prevent use after free at netdev removal

Stephen Boyd (1):
      clk: Fix double free due to devm_clk_register()

Steve Dickson (1):
      SUNRPC: Ensure call_connect_status() deals correctly with SOFTCONN tasks

Steven Rostedt (Red Hat) (1):
      sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check

Susant Sahani (1):
      ip6_tunnel: fix potential NULL pointer dereference

Takashi Iwai (3):
      ALSA: hda - Fix onboard audio on Intel H97/Z97 chipsets
      ALSA: hda/analog - Fix silent output on ASUS A8JN
      ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup

Tejun Heo (1):
      sysfs: make sure read buffer is zeroed

Thomas Gleixner (9):
      ARM: common: edma: Fix xbar mapping
      sched: Sanitize irq accounting madness
      futex: Add another early deadlock detection check
      futex: Prevent attaching to kernel threads
      rtmutex: Fix deadlock detector for real
      futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr == uaddr2 in futex_requeue(..., requeue_pi=1)
      futex: Validate atomic acquisition in futex_lock_pi_atomic()
      futex: Always cleanup owner tid in unlock_pi
      futex: Make lookup_pi_state more robust

Thomas Petazzoni (7):
      memory: mvebu-devbus: fix the conversion of the bus width
      ARM: orion5x: fix target ID for crypto SRAM window
      bus: mvebu-mbus: allow several windows with the same target/attribute
      PCI: mvebu: split PCIe BARs into multiple MBus windows when needed
      ARM: mvebu: fix NOR bus-width in Armada XP GP Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP DB Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP OpenBlocks AX3 Device Tree

Thomas Richter (1):
      bonding: Remove debug_fs files when module init fails

Toshiaki Makita (2):
      bridge: Fix double free and memory leak around br_allowed_ingress
      bridge: Handle IFLA_ADDRESS correctly when creating bridge device

Trond Myklebust (3):
      SUNRPC: Ensure that call_connect times out correctly
      NFSd: Move default initialisers from create_client() to alloc_client()
      NFSd: call rpc_destroy_wait_queue() from free_client()

Tuomas Tynkkynen (1):
      clk: tegra: Fix wrong value written to PLLE_AUX

Ursula Braun (1):
      af_iucv: wrong mapping of sent and confirmed skbs

Ville Syrjälä (1):
      drm/i915: Increase WM memory latency values on SNB

Viresh Kumar (1):
      hrtimer: Set expiry time before switch_hrtimer_base()

Vlad Yasevich (7):
      net: Find the nesting level of a given device by type.
      net: Allow for more then a single subclass for netif_addr_lock
      vlan: Fix lockdep warning with stacked vlan devices.
      macvlan: Fix lockdep warnings with stacked macvlan devices
      net: sctp: cache auth_enable per endpoint
      mactap: Fix checksum errors for non-gso packets in bridge mode
      Revert "macvlan : fix checksums error when we are in bridge mode"

Wang, Xiaoming (1):
      net: ipv4: current group_info should be put after using.

Willy Tarreau (1):
      PCI: mvebu: fix off-by-one in the computed size of the mbus windows

Wolfram Sang (1):
      i2c: rcar: bail out on zero length transfers

Xuelin Shi (1):
      dmaengine: fix dmaengine_unmap failure

Xufeng Zhang (1):
      sctp: reset flowi4_oif parameter on route lookup

Ying Cai (1):
      ip_tunnel: Set network header properly for IP_ECN_decapsulate()

dingtianhong (1):
      vlan: Fix lockdep warning when vlan dev handle notification
