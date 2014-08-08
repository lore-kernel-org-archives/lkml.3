Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaHHUlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:41:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39983 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaHHUla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.13.y.z extended stable] Linux 3.13.11.6 stable review
Date: Fri,  8 Aug 2014 13:37:03 -0700
Message-Id: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.13.11.6 stable kernel.

This version contains 259 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review

The review period for version 3.13.11.6 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.13.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 Makefile                                        |   2 +
 arch/arm/Kconfig                                |   1 +
 arch/arm/crypto/aesbs-glue.c                    |  10 +-
 arch/arm/mach-omap2/mux.c                       |   6 +-
 arch/arm/mm/mmu.c                               |   6 +-
 arch/arm/xen/grant-table.c                      |   5 +
 arch/arm64/Kconfig                              |   1 +
 arch/arm64/include/asm/memory.h                 |   2 +
 arch/arm64/mm/flush.c                           |   3 +-
 arch/mips/kvm/kvm_mips.c                        |   1 +
 arch/parisc/include/uapi/asm/signal.h           |   2 -
 arch/parisc/kernel/hardware.c                   |   3 +-
 arch/parisc/kernel/sys_parisc32.c               |  46 ++-----
 arch/parisc/kernel/syscall_table.S              |   2 +-
 arch/powerpc/Kconfig                            |   1 +
 arch/powerpc/include/asm/perf_event_server.h    |   3 +-
 arch/powerpc/perf/core-book3s.c                 |  24 +++-
 arch/powerpc/perf/power8-pmu.c                  |   2 +-
 arch/s390/kernel/ptrace.c                       |  12 +-
 arch/sparc/Kconfig                              |   1 +
 arch/sparc/net/bpf_jit_comp.c                   |   8 +-
 arch/x86/Kconfig                                |   1 +
 arch/x86/boot/header.S                          |  26 +++-
 arch/x86/boot/tools/build.c                     |  37 +++++-
 arch/x86/crypto/sha512_ssse3_glue.c             |   2 +-
 arch/x86/include/asm/kvm_host.h                 |   4 +-
 arch/x86/include/asm/ptrace.h                   |  16 +++
 arch/x86/kernel/cpu/perf_event_intel.c          |   9 ++
 arch/x86/kernel/entry_32.S                      |   9 +-
 arch/x86/kernel/tsc.c                           |   4 +-
 arch/x86/xen/grant-table.c                      | 148 +++++++++++++--------
 arch/xtensa/kernel/vectors.S                    | 158 ++++++++++++++++++----
 arch/xtensa/kernel/vmlinux.lds.S                |   4 +-
 block/blk-cgroup.c                              |   7 +
 block/blk-tag.c                                 |  33 +----
 block/compat_ioctl.c                            |   1 +
 crypto/af_alg.c                                 |   2 +
 crypto/crypto_user.c                            |   2 +-
 drivers/acpi/ac.c                               | 130 +++++++++++++++++-
 drivers/acpi/acpi_pad.c                         |   9 +-
 drivers/acpi/battery.c                          |  27 +++-
 drivers/acpi/ec.c                               | 128 +++++++++---------
 drivers/ata/ahci.c                              |   1 +
 drivers/ata/libata-core.c                       |  12 +-
 drivers/base/platform.c                         |  21 ++-
 drivers/bluetooth/hci_h5.c                      |   1 +
 drivers/clk/clk-s2mps11.c                       |   7 +-
 drivers/clk/spear/spear3xx_clock.c              |   2 +-
 drivers/connector/cn_proc.c                     |   2 +-
 drivers/cpufreq/Makefile                        |   2 +-
 drivers/cpufreq/cpufreq.c                       |   6 +-
 drivers/cpufreq/intel_pstate.c                  |  35 +++--
 drivers/crypto/caam/jr.c                        |   8 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c          |  44 +++++++
 drivers/gpu/drm/i915/i915_irq.c                 |  11 +-
 drivers/gpu/drm/i915/i915_reg.h                 |   3 +
 drivers/gpu/drm/qxl/qxl_irq.c                   |   3 +
 drivers/gpu/drm/radeon/atombios_dp.c            |   2 +-
 drivers/gpu/drm/radeon/atombios_encoders.c      |  10 +-
 drivers/gpu/drm/radeon/ci_dpm.c                 |   2 +-
 drivers/gpu/drm/radeon/cik.c                    |   2 +
 drivers/gpu/drm/radeon/cikd.h                   |   2 +-
 drivers/gpu/drm/radeon/cypress_dpm.c            |   2 +-
 drivers/gpu/drm/radeon/evergreen.c              |   9 +-
 drivers/gpu/drm/radeon/ni_dpm.c                 |   2 +-
 drivers/gpu/drm/radeon/r600.c                   |   1 +
 drivers/gpu/drm/radeon/radeon_display.c         |   5 +
 drivers/gpu/drm/radeon/rv770_dpm.c              |   6 -
 drivers/gpu/drm/radeon/si.c                     |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c              |   1 -
 drivers/hv/connection.c                         |   8 +-
 drivers/hwmon/adm1021.c                         |  14 +-
 drivers/hwmon/adm1029.c                         |   3 +
 drivers/hwmon/adm1031.c                         |   8 +-
 drivers/hwmon/adt7470.c                         |   6 +-
 drivers/hwmon/amc6821.c                         |   2 +-
 drivers/hwmon/da9052-hwmon.c                    |   2 +-
 drivers/hwmon/da9055-hwmon.c                    |   2 +-
 drivers/hwmon/emc2103.c                         |  15 +--
 drivers/hwmon/smsc47m192.c                      |   4 +-
 drivers/iio/accel/bma180.c                      |   8 +-
 drivers/iio/adc/ti_am335x_adc.c                 |   2 +-
 drivers/iio/industrialio-buffer.c               |   2 +-
 drivers/iio/industrialio-event.c                |   3 +
 drivers/iio/inkern.c                            |   6 +-
 drivers/input/input.c                           |   6 +-
 drivers/irqchip/irq-gic.c                       |   6 +-
 drivers/irqchip/spear-shirq.c                   |   2 +-
 drivers/md/dm-bufio.c                           |   2 +-
 drivers/md/dm-cache-metadata.c                  |   9 ++
 drivers/md/dm-cache-target.c                    |  13 +-
 drivers/md/dm-io.c                              |  22 ++--
 drivers/md/dm-thin-metadata.c                   |   9 ++
 drivers/md/dm.c                                 |  15 ++-
 drivers/md/md.c                                 |  13 ++
 drivers/media/dvb-frontends/tda10071.c          |   6 +-
 drivers/media/usb/gspca/pac7302.c               |   1 +
 drivers/media/usb/hdpvr/hdpvr-video.c           |   6 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c       |   4 +-
 drivers/mtd/devices/elm.c                       |   2 +
 drivers/net/can/c_can/c_can_platform.c          |   3 +-
 drivers/net/can/slcan.c                         |  41 ++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |   3 +-
 drivers/net/ethernet/emulex/benet/be_main.c     |   2 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c    |   7 +
 drivers/net/ethernet/intel/igb/e1000_defines.h  |  18 +--
 drivers/net/ethernet/intel/igb/e1000_hw.h       |   3 +
 drivers/net/ethernet/intel/igb/e1000_i210.c     |  66 ++++++++++
 drivers/net/ethernet/intel/igb/e1000_i210.h     |  12 ++
 drivers/net/ethernet/intel/igb/e1000_regs.h     |   1 +
 drivers/net/ethernet/intel/igb/igb_main.c       |  16 +++
 drivers/net/ethernet/marvell/mvneta.c           |   4 +-
 drivers/net/ethernet/mellanox/mlx4/main.c       | 168 ++++++++++++++----------
 drivers/net/ethernet/mellanox/mlx4/mlx4.h       |   1 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c |   1 +
 drivers/net/ethernet/renesas/sh_eth.c           |  31 +++--
 drivers/net/ethernet/renesas/sh_eth.h           |   2 -
 drivers/net/ethernet/sfc/io.h                   |   7 +
 drivers/net/ethernet/sfc/tx.c                   |  22 +++-
 drivers/net/ethernet/sun/sunvnet.c              |  20 ++-
 drivers/net/macvlan.c                           |   1 -
 drivers/net/ppp/pppoe.c                         |   2 +-
 drivers/net/slip/slip.c                         |  36 +++--
 drivers/net/slip/slip.h                         |   1 +
 drivers/net/team/team.c                         |   7 +-
 drivers/net/usb/huawei_cdc_ncm.c                |  10 +-
 drivers/net/usb/qmi_wwan.c                      |  10 +-
 drivers/net/vxlan.c                             |   7 +-
 drivers/net/wireless/ath/ath9k/xmit.c           |   9 ++
 drivers/net/wireless/iwlwifi/dvm/rxon.c         |  12 --
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c     |   7 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c         |   3 +-
 drivers/net/wireless/mwifiex/main.c             |   1 +
 drivers/of/irq.c                                |  22 ++++
 drivers/parport/Kconfig                         |  12 +-
 drivers/phy/phy-core.c                          |   7 +-
 drivers/rapidio/devices/tsi721_dma.c            |   8 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                |  13 +-
 drivers/scsi/scsi_error.c                       |   2 +-
 drivers/scsi/scsi_lib.c                         |   8 ++
 drivers/scsi/scsi_netlink.c                     |   2 +-
 drivers/scsi/sd.c                               |   5 +-
 drivers/scsi/virtio_scsi.c                      |  26 +++-
 drivers/staging/iio/adc/ad7291.c                |   4 +-
 drivers/staging/vt6655/bssdb.c                  |   2 +-
 drivers/staging/vt6655/device_main.c            |   7 +-
 drivers/target/target_core_rd.c                 |   2 +-
 drivers/thermal/thermal_hwmon.c                 |  33 ++---
 drivers/usb/chipidea/udc.c                      |  11 +-
 drivers/usb/core/hub.c                          |  19 +++
 drivers/usb/gadget/f_fs.c                       |  12 +-
 drivers/usb/host/xhci-hub.c                     |   5 +-
 drivers/usb/host/xhci-ring.c                    |   9 +-
 drivers/usb/host/xhci.c                         |  10 +-
 drivers/usb/musb/musb_am335x.c                  |  23 +---
 drivers/usb/musb/musb_cppi41.c                  |   2 +-
 drivers/usb/musb/ux500.c                        |   1 -
 drivers/usb/serial/cp210x.c                     |   1 +
 drivers/usb/serial/ftdi_sio.c                   |  12 +-
 drivers/usb/serial/ftdi_sio_ids.h               |   9 +-
 drivers/usb/serial/option.c                     |  28 +++-
 drivers/usb/storage/scsiglue.c                  |   4 +
 drivers/usb/storage/unusual_devs.h              |   7 +
 drivers/xen/balloon.c                           |  12 +-
 drivers/xen/grant-table.c                       |   5 +
 drivers/xen/manage.c                            |   5 +-
 fs/aio.c                                        |   7 +
 fs/coredump.c                                   |   2 +-
 fs/ext4/extents_status.c                        |   4 +-
 fs/ext4/ialloc.c                                |  14 +-
 fs/ext4/indirect.c                              |  20 ++-
 fs/ext4/mballoc.c                               |   4 +-
 fs/ext4/super.c                                 |   9 +-
 fs/fuse/dir.c                                   |   7 +-
 fs/fuse/inode.c                                 |  20 ++-
 fs/jbd2/transaction.c                           |   5 +-
 fs/namei.c                                      |   3 +-
 fs/nfsd/nfs4proc.c                              |   9 --
 fs/nfsd/nfs4xdr.c                               |  13 +-
 fs/proc/stat.c                                  |  22 +---
 fs/quota/dquot.c                                |   2 +
 fs/seq_file.c                                   |  30 +++--
 include/linux/if_team.h                         |   1 +
 include/linux/libata.h                          |   1 +
 include/linux/mm.h                              |   2 +
 include/linux/netlink.h                         |  14 +-
 include/linux/of_irq.h                          |   5 +
 include/linux/printk.h                          |   6 +-
 include/linux/ptrace.h                          |   3 +
 include/linux/sock_diag.h                       |   2 +-
 include/linux/usb_usual.h                       |   6 +-
 include/net/inetpeer.h                          |   9 +-
 include/net/sock.h                              |  21 +--
 include/scsi/scsi_device.h                      |   1 +
 include/xen/grant_table.h                       |   1 +
 kernel/Kconfig.locks                            |   5 +-
 kernel/audit.c                                  |   4 +-
 kernel/cpuset.c                                 |   8 +-
 kernel/events/core.c                            |   2 +-
 kernel/power/process.c                          |   1 +
 kernel/printk/printk.c                          |   2 +-
 kernel/sched/core.c                             |   2 +-
 kernel/sched/debug.c                            |   2 +-
 kernel/sched/rt.c                               |   2 +-
 kernel/time/alarmtimer.c                        |  20 ++-
 kernel/time/clockevents.c                       |  10 +-
 kernel/time/sched_clock.c                       |   4 +-
 kernel/trace/ftrace.c                           |   4 +-
 kernel/trace/ring_buffer.c                      |   4 -
 kernel/trace/trace.c                            |  22 +++-
 kernel/trace/trace_clock.c                      |   9 +-
 kernel/workqueue.c                              |   3 +-
 lib/lz4/lz4_decompress.c                        |   6 +-
 lib/nlattr.c                                    |   4 +-
 mm/hugetlb.c                                    |   1 +
 mm/memcontrol.c                                 |   4 +
 mm/mempolicy.c                                  |   2 -
 mm/page-writeback.c                             |   6 +-
 mm/page_alloc.c                                 |  32 +++--
 mm/shmem.c                                      | 104 +++++++++++++--
 mm/slab_common.c                                |   2 +-
 mm/util.c                                       |  10 ++
 net/8021q/vlan_core.c                           |   5 +-
 net/8021q/vlan_dev.c                            |  13 +-
 net/appletalk/ddp.c                             |   3 -
 net/bridge/br_input.c                           |   4 +-
 net/bridge/br_private.h                         |   7 +
 net/bridge/br_vlan.c                            |  28 ++++
 net/can/gw.c                                    |   4 +-
 net/compat.c                                    |   9 +-
 net/core/dev.c                                  |  11 +-
 net/core/dst.c                                  |  16 ++-
 net/core/iovec.c                                |   6 +-
 net/core/rtnetlink.c                            |  43 ++++--
 net/core/skbuff.c                               |   3 +-
 net/core/sock.c                                 |  49 +++++++
 net/core/sock_diag.c                            |   4 +-
 net/dcb/dcbnl.c                                 |   2 +-
 net/decnet/dn_dev.c                             |   4 +-
 net/decnet/dn_fib.c                             |   4 +-
 net/decnet/netfilter/dn_rtmsg.c                 |   2 +-
 net/dns_resolver/dns_query.c                    |   4 +-
 net/ipv4/datagram.c                             |  20 ++-
 net/ipv4/icmp.c                                 |   2 -
 net/ipv4/igmp.c                                 |  10 +-
 net/ipv4/ip_options.c                           |   4 +
 net/ipv4/ip_tunnel.c                            |  12 +-
 net/ipv4/ipip.c                                 |   5 +-
 net/ipv4/route.c                                |  15 ++-
 net/ipv4/tcp.c                                  |   3 +-
 net/ipv4/tcp_input.c                            |  21 ++-
 net/ipv4/tcp_output.c                           |   6 +-
 net/ipv4/udp.c                                  |   4 +
 net/ipv6/ip6_tunnel.c                           |   1 +
 net/ipv6/output_core.c                          |  11 +-
 net/ipv6/sit.c                                  |   5 +-
 net/l2tp/l2tp_ppp.c                             |   4 +-
 net/mac80211/iface.c                            |   1 -
 net/mac80211/tx.c                               |  26 ++--
 net/netfilter/ipvs/ip_vs_core.c                 |  15 ++-
 net/netfilter/nfnetlink.c                       |   3 +-
 net/netlink/af_netlink.c                        |  84 +++++++++++-
 net/netlink/genetlink.c                         |   2 +-
 net/packet/diag.c                               |   7 +-
 net/phonet/pn_netlink.c                         |   8 +-
 net/sched/act_api.c                             |   2 +-
 net/sched/cls_api.c                             |   2 +-
 net/sched/sch_api.c                             |   6 +-
 net/sctp/associola.c                            |   2 +-
 net/sctp/sysctl.c                               |  46 +++----
 net/sctp/ulpevent.c                             | 122 +++--------------
 net/tipc/bcast.c                                |   1 +
 net/tipc/netlink.c                              |   2 +-
 net/wireless/trace.h                            |   3 +-
 net/xfrm/xfrm_user.c                            |   2 +-
 security/apparmor/include/apparmor.h            |   1 -
 security/apparmor/lib.c                         |  14 --
 sound/pci/hda/hda_intel.c                       |  10 +-
 sound/pci/hda/patch_hdmi.c                      |  57 +++++++-
 tools/usb/ffs-test.c                            |   4 +-
 virt/kvm/ioapic.c                               |   2 +-
 281 files changed, 2358 insertions(+), 1090 deletions(-)

Aaron Lu (1):
      thermal: hwmon: Make the check for critical temp valid consistent

Abbas Raza (1):
      usb: chipidea: udc: Disable auto ZLP generation on ep0

Adam Thomson (1):
      iio: of_iio_channel_get_by_name() returns non-null pointers for error legs

Al Viro (1):
      nick kvfree() from apparmor

Alan Stern (1):
      usb-storage/SCSI: Add broken_fua blacklist flag

Alex Deucher (8):
      drm/radeon/dpm: fix typo in vddci setup for eg/btc
      drm/radeon/dpm: fix vddci setup typo on cayman
      drm/radeon/cik: fix typo in EOP packet
      drm/radeon/dp: return -EIO for flags not zero case
      drm/radeon: fix typo in golden register setup on evergreen
      drm/radeon: fix typo in ci_stop_dpm()
      drm/radeon: avoid leaking edid data
      drm/radeon: set default bl level to something reasonable

Alexandre Bounine (1):
      rapidio/tsi721_dma: fix failure to obtain transaction descriptor

Alexandre Demers (1):
      drm/radeon/dpm: Reenabling SS on Cayman

Alexei Starovoitov (2):
      net: filter: fix typo in sparc BPF JIT
      net: filter: fix sparc32 typo

Amitkumar Karwar (1):
      mwifiex: fix Tx timeout issue

Anand Avati (1):
      fuse: ignore entry-timeout on LOOKUP_REVAL

Andras Kovacs (1):
      USB: cp210x: add support for Corsair usb dongle

Andrey Ryabinin (1):
      net: sendmsg: fix NULL pointer dereference

Andrey Utkin (1):
      appletalk: Fix socket referencing in skb

Anssi Hannula (1):
      dm cache: fix race affecting dirty block count

Anton Blanchard (1):
      powerpc/perf: Never program book3s PMCs with values >= 0x80000000

Antti Palosaari (1):
      [media] tda10071: force modulation to QPSK on DVB-S

Axel Lin (5):
      hwmon: (amc6821) Fix permissions for temp2_input
      hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div
      hwmon: (adm1021) Fix cache problem when writing temperature limits
      hwmon: (da9052) Don't use dash in the name attribute
      hwmon: (da9055) Don't use dash in the name attribute

Ben Dooks (1):
      sh_eth: use RNC mode for packet reception

Ben Hutchings (1):
      dns_resolver: Null-terminate the right string

Ben Pfaff (1):
      netlink: Fix handling of error from netlink_dump().

Benjamin LaHaise (1):
      aio: protect reqs_available updates from changes in interrupt handlers

Bernd Wachter (2):
      usb: option: Add ID for Telewell TW-LTE 4G v2
      net: qmi_wwan: Add ID for Telewell TW-LTE 4G v2

Bert Vermeulen (1):
      USB: ftdi_sio: Add extra PID.

Bjørn Mork (5):
      usb: option: add/modify Olivetti Olicard modems
      net: qmi_wwan: add Olivetti Olicard modems
      net: huawei_cdc_ncm: increase command buffer size
      net: qmi_wwan: add two Sierra Wireless/Netgear devices
      net: huawei_cdc_ncm: add "subclass 3" devices

Brian King (2):
      ibmvscsi: Abort init sequence during error recovery
      ibmvscsi: Add memory barriers for send / receive

Chris Wilson (1):
      drm/i915: Reorder the semaphore deadlock check, again

Christian König (1):
      drm/radeon: fix irq ring buffer overflow handling

Christoph Hellwig (1):
      block: don't assume last put of shared tags is for the host

Christoph Paasch (1):
      tcp: Fix divide by zero when pushing during tcp-repair

Christoph Schulz (1):
      net: pppoe: use correct channel MTU when using Multilink PPP

Colin Cross (1):
      arm64: implement TASK_SIZE_OF

Cong Wang (1):
      vxlan: use dev->needed_headroom instead of dev->hard_header_len

Cristian Stoica (1):
      crypto: caam - fix memleak in caam_jr module

Dan Carpenter (2):
      staging: iio/ad7291: fix error code in ad7291_probe()
      qlcnic: info leak in qlcnic_dcb_peer_app_info()

Daniel Borkmann (3):
      net: sctp: propagate sysctl errors from proc_do* properly
      net: sctp: check proc_dointvec result in proc_sctp_do_auth
      net: sctp: fix information leaks in ulpevent layer

David R. Piegdon (1):
      ARM: OMAP2+: Fix parser-bug in platform muxing code

David Rientjes (1):
      mm, thp: do not allow thp faults to avoid cpuset restrictions

David Vrabel (3):
      x86/xen: safely map and unmap grant frames when in atomic context
      xen/manage: fix potential deadlock when resuming the console
      xen/balloon: set ballooned out pages as invalid in p2m

Deng-Cheng Zhu (1):
      MIPS: KVM: Fix memory leak on VCPU

Dirk Brandewie (2):
      intel_pstate: Fix setting VID
      intel_pstate: don't touch turbo bit if turbo disabled or unavailable.

Dmitry Popov (2):
      ipip, sit: fix ipv4_{update_pmtu,redirect} calls
      ip_tunnel: fix ip_tunnel_lookup

Dmitry Torokhov (1):
      Input: fix defuzzing logic

Edward Allcutt (1):
      ipv4: icmp: Fix pMTU handling for rare case

Eliad Peller (1):
      cfg80211: fix mic_failure tracing

Emmanuel Grumbach (2):
      iwlwifi: dvm: don't enable CTS to self
      iwlwifi: mvm: disable CTS to Self

Eric Dumazet (10):
      net: fix inet_getid() and ipv6_select_ident() bugs
      net: force a list_del() in unregister_netdevice_many()
      ipv4: fix a race in ip4_datagram_release_cb()
      udp: ipv4: do not waste time in __udp4_lib_mcast_demux_lookup
      ipv4: fix dst race in sk_dst_get()
      ipv4: irq safe sk_dst_[re]set() and ipv4_sk_update_pmtu() fix
      net: fix sparse warning in sk_dst_set()
      vlan: free percpu stats in device destructor
      bnx2x: fix possible panic under memory stress
      ipv4: fix buffer overflow in ip_options_compile()

Eric Sandeen (1):
      ext4: disable synchronous transaction batching if max_batch_time==0

Eric W. Biederman (6):
      netlink: Rename netlink_capable netlink_allowed
      net: Move the permission check in sock_diag_put_filterinfo to packet_diag_dump
      net: Add variants of capable for use on on sockets
      net: Add variants of capable for use on netlink messages
      net: Use netlink_ns_capable to verify the permisions of netlink messages
      netlink: Only check file credentials for implicit destinations

Ezequiel Garcia (1):
      usb: musb: Fix panic upon musb_am335x module removal

Felix Fietkau (1):
      ath9k: fix aggregation session lockup

Gavin Guo (1):
      usb: Check if port status is equal to RxDetect

George Cherian (1):
      can: c_can_platform: Fix raminit, use devm_ioremap() instead of devm_ioremap_resource()

Greg Kroah-Hartman (1):
      lz4: add overrun checks to lz4_uncompress_unknownoutputsize()

Greg Thelen (1):
      dm bufio: fully initialize shrinker

Grygorii Strashko (1):
      of/irq: do irq resolution in platform_get_irq_byname()

Gu Zheng (1):
      cpuset,mempolicy: fix sleeping function called from invalid context

Guenter Roeck (5):
      hwmon: (adm1031) Fix writes to limit registers
      hwmon: (emc2103) Clamp limits instead of bailing out
      platform_get_irq: Revert to platform_get_resource if of_irq_get fails
      hwmon: (adt7470) Fix writes to temperature limit registers
      hwmon: (smsc47m192) Fix temperature limit and vrm write operations

HATAYAMA Daisuke (1):
      perf/x86/intel: ignore CondChgd bit to avoid false NMI handling

Hans Verkuil (1):
      [media] hdpvr: fix two audio bugs

Hans de Goede (1):
      [media] gspca_pac7302: Add new usb-id for Genius i-Look 317

Heiko Carstens (2):
      /proc/stat: convert to single_open_size()
      fs/seq_file: fallback to vmalloc allocation

Helge Deller (3):
      parisc: add serial ports of C8000/1GHz machine to hardware database
      parisc: fix fanotify_mark() syscall on 32bit compat kernel
      parisc: drop unused defines and header includes

Hugh Dickins (3):
      shmem: fix faulting into a hole while it's punched
      shmem: fix faulting into a hole, not taking i_mutex
      shmem: fix splicing from a hole while it's punched

J. Bruce Fields (1):
      nfsd: fix rare symlink decoding bug

James Bottomley (1):
      scsi: handle flush errors properly

Jan Kara (3):
      ext4: Fix buffer double free in ext4_alloc_branch()
      ext4: Fix hole punching for files with indirect blocks
      timer: Fix lock inversion between hrtimer_bases.lock and scheduler locks

Jan Kardell (1):
      iio: ti_am335x_adc: Fix: Use same step id at FIFOs both ends

Jason Wang (1):
      drm/qxl: return IRQ_NONE if it was not our irq

Jerome Glisse (1):
      drm/radeon: fix cut and paste issue for hawaii.

Jiri Olsa (1):
      perf: Do not allow optimized switch for non-cloned events

Jiri Pirko (1):
      team: fix mtu setting

Joe Thornber (1):
      dm io: fix a race condition in the wake up code for sync_io

Joel Stanley (2):
      powerpc/perf: Add PPMU_ARCH_207S define
      powerpc/perf: Clear MMCR2 when enabling PMU

Johan Hovold (1):
      USB: ftdi_sio: fix null deref at port probe

Johannes Berg (1):
      Revert "mac80211: move "bufferable MMPDU" check to fix AP mode scan"

John David Anglin (1):
      parisc: Remove SA_RESTORER define

John Stultz (2):
      alarmtimer: Fix bug where relative alarm timers were treated as absolute
      printk: rename printk_sched to printk_deferred

Jon Cooper (1):
      sfc: PIO:Restrict to 64bit arch and use 64-bit writes.

Jon Paul Maloy (1):
      tipc: clear 'next'-pointer of message fragments before reassembly

Jussi Kivilinna (1):
      crypto: sha512_ssse3 - fix byte count to bit count conversion

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code

Kevin Hao (1):
      libata: support the ata host which implements a queue depth less than 32

Krzysztof Kozlowski (1):
      clk: s2mps11: Fix double free corruption during driver unbind

Lan Tianyu (2):
      Revert "ACPI / AC: Remove AC's proc directory."
      ACPI / battery: Retry to get battery information if failed during probing

Lars-Peter Clausen (1):
      iio: buffer: Fix demux table creation

Li RongQing (1):
      8021q: fix a potential memory leak

Linus Torvalds (1):
      Fix gcc-4.9.0 miscompilation of load_balance()  in scheduler

Linus Walleij (1):
      usb: musb: ux500: don't propagate the OF node

Loic Poulain (1):
      Bluetooth: Ignore H5 non-link packets in non-active state

Loic Prylli (1):
      net: Fix NETDEV_CHANGE notifier usage causing spurious arp flush

Lu Baolu (1):
      xhci: clear root port wake on bits if controller isn't wake-up capable

Lv Zheng (4):
      ACPI / EC: Avoid race condition related to advance_transaction()
      ACPI / EC: Add asynchronous command byte write support
      ACPI / EC: Remove duplicated ec_wait_ibf0() waiter
      ACPI / EC: Fix race condition in ec_transaction_completed()

Malcolm Priestley (2):
      staging: vt6655: Fix Warning on boot handle_irq_event_percpu.
      staging: vt6655: Fix disassociated messages every 10 seconds

Manuel Schölling (1):
      dns_resolver: assure that dns_query() result is null-terminated

Martin Lau (1):
      ring-buffer: Fix polling on trace_pipe

Martin Schwidefsky (1):
      s390/ptrace: fix PSW mask check

Mateusz Guzik (1):
      sched: Fix possible divide by zero in avg_atom() calculation

Mathias Nyman (2):
      xhci: Use correct SLOT ID when handling a reset device command
      xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Matthias Brugger (1):
      irqchip: gic: Add support for cortex a7 compatible string

Max Filippov (1):
      xtensa: add fixup for double exception raised in window overflow

Maxim Patlasov (1):
      mm/page-writeback.c: fix divide by zero in bdi_dirty_limits()

Maxime Bizon (1):
      workqueue: fix dev_set_uevent_suppress() imbalance

Mengdong Lin (3):
      ALSA: hda/hdmi - apply all Haswell fix-ups to Broadwell display codec
      ALSA: hda - verify pin:converter connection on unsol event for HSW and VLV
      ALSA: hda - verify pin:cvt connection on preparing a stream for Intel HDMI codec

Michael Brown (1):
      x86/efi: Include a .bss section within the PE/COFF headers

Michael Ellerman (1):
      powerpc/perf: Fix MMCR2 handling for EBB

Michal Hocko (1):
      memcg: oom_notify use-after-free fix

Michal Nazarewicz (3):
      usb: gadget: f_fs: fix NULL pointer dereference when there are no strings
      tools: ffs-test: fix header values endianess
      mm: page_alloc: fix CMA area initialisation when pageblock > MAX_ORDER

Michal Schmidt (2):
      netlink: rate-limit leftover bytes warning and print process name
      rtnetlink: fix userspace API breakage for iproute2 < v3.9.0

Michal Sojka (1):
      USB: serial: ftdi_sio: Add Infineon Triboard

Mike Snitzer (2):
      dm thin metadata: do not allow the data block size to change
      dm cache metadata: do not allow the data block size to change

Miklos Szeredi (2):
      fuse: timeout comparison fix
      fuse: handle large user and group ID

Mikulas Patocka (4):
      dm: allocate a special workqueue for deferred device removal
      slab_common: fix the check for duplicate slab names
      block: provide compat ioctl for BLKZEROOUT
      crypto: arm-aes - fix encryption of unaligned data

Milan Broz (1):
      crypto: af_alg - properly label AF_ALG socket

Nadav Amit (1):
      KVM: x86: Increase the number of fixed MTRR regs to 10

Naoya Horiguchi (1):
      mm: hugetlb: fix copy_hugetlb_page_range()

Neal Cardwell (1):
      tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb

NeilBrown (1):
      md: flush writes before starting a recovery.

Nicholas Bellinger (1):
      target: Explicitly clear ramdisk_mcp backend pages

Niu Yawei (1):
      quota: missing lock in dqcache_shrink_scan()

Oliver Neukum (1):
      USB: option: add device ID for SpeedUp SU9800 usb 3g modem

Oren Givon (1):
      iwlwifi: update the 7265 series HW IDs

Paolo Bonzini (4):
      KVM: ioapic: fix assignment of ioapic->rtc_status.pending_eoi (CVE-2014-0155)
      KVM: x86: preserve the high 32-bits of the PAT register
      virtio-scsi: avoid cancelling uninitialized work items
      virtio-scsi: fix various bad behavior on aborted requests

Peter Chen (1):
      usb: chipidea: udc: delete td from req's td list at ep_dequeue

Peter Christensen (1):
      ipvs: Fix panic due to non-linear skb

Peter Meerwald (2):
      iio:bma180: Fix scale factors to report correct acceleration units
      iio:bma180: Missing check for frequency fractional part

Peter Zijlstra (2):
      x86, tsc: Fix cpufreq lockup
      locking/mutex: Disable optimistic spinning on some architectures

Prabhakar Lad (1):
      cpufreq: Makefile: fix compilation for davinci platform

Randy Dunlap (1):
      parport: fix menu breakage

Rickard Strandqvist (1):
      [media] media: v4l2-core: v4l2-dv-timings.c: Cleaning up code wrong value used in aspect ratio

Roger Quadros (1):
      phy: core: Fix error path in phy_create()

Romain Degez (1):
      ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode)

Russell King (1):
      ARM: fix alignment of keystone page table fixup

Sasha Levin (1):
      net/l2tp: don't fall back on UDP [get|set]sockopt

Sergei Shtylyov (1):
      sh_eth: fix SH7619/771x support

Silesh C V (1):
      coredump: fix the setting of PF_DUMPCORE

Sowmini Varadhan (1):
      sunvnet: clean up objects created in vnet_new() on vnet_exit()

Srinivas Pandruvada (1):
      iio:core: Handle error when mask type is not separate

Stefan Assmann (1):
      igb: do a reset on SR-IOV re-init if device is down

Stephen Boyd (1):
      sched_clock: Avoid corrupting hrtimer tree during suspend

Steve Capper (1):
      arm64: mm: Make icache synchronisation logic huge page aware

Steven Rostedt (Red Hat) (2):
      tracing: Remove ftrace_stop/start() from reading the trace file
      tracing: Fix graph tracer with stack tracer on other archs

Suresh Reddy (1):
      be2net: set EQ DB clear-intr bit in be_open()

Sven Wegener (1):
      x86_32, entry: Store badsys error code in %eax

Takashi Iwai (2):
      PM / sleep: Fix request_firmware() error at resume
      ALSA: hda - Fix broken PM due to incomplete i915 initialization

Ted Juan (1):
      mtd: devices: elm: fix elm_context_save() and elm_context_restore() functions

Tejun Heo (3):
      ptrace,x86: force IRET path after a ptrace_stop()
      blkcg: don't call into policy draining if root_blkg is already gone
      libata: introduce ata_host->n_tags to avoid oops on SAS controllers

Theodore Ts'o (4):
      ext4: fix unjournalled bg descriptor while initializing inode bitmap
      ext4: clarify error count warning messages
      ext4: clarify ext4_error message in ext4_mb_generate_buddy_error()
      ext4: fix a potential deadlock in __ext4_es_shrink()

Thomas Fitzsimmons (1):
      net: mvneta: Fix big endian issue in mvneta_txq_desc_csum()

Thomas Gleixner (3):
      irqchip: spear_shirq: Fix interrupt offset
      usb: musb: Ensure that cppi41 timer gets armed on premature DMA TX irq
      clk: spear3xx: Use proper control register offset

Thomas Hellstrom (1):
      drm/vmwgfx: Fix incorrect write to read-only register v2:

Thomas Petazzoni (1):
      net: mvneta: fix operation in 10 Mbit/s mode

Todd Fujinaka (1):
      igb: Workaround for i210 Errata 25: Slow System Clock

Tom Gundersen (1):
      net: tunnels - enable module autoloading

Tomasz Figa (1):
      irqchip: gic: Fix core ID calculation when topology is read from DT

Tony Camuso (1):
      ACPI / PAD: call schedule() when need_resched() is true

Tony Luck (1):
      tracing: Fix wraparound problems in "uptime" trace clock

Toshiaki Makita (1):
      bridge: Prevent insertion of FDB entry with disallowed vlan

Tyler Hall (2):
      slip: Fix deadlock in write_wakeup
      slcan: Port write_wakeup deadlock fix from slip

Ulrich Obergfell (1):
      scsi_error: fix invalid setting of host byte

Vasily Averin (1):
      fs: umount on symlink leaks mnt count

Ville Syrjälä (1):
      drm/i915: Don't clobber the GTT when it's within stolen memory

Vincent Minet (1):
      intel_pstate: Set CPU number before accessing MSRs

Viresh Kumar (1):
      cpufreq: move policy kobj to policy->cpu at resume

Wang, Yu (1):
      xhci: Fix runtime suspended xhci from blocking system suspend.

Wei Yang (2):
      net/mlx4_core: pass pci_device_id.driver_data to __mlx4_init_one during reset
      net/mlx4_core: Preserve pci_dev_data after __mlx4_remove_one()

Wei-Chun Chao (1):
      net: fix UDP tunnel GSO of frag_list GRO packets

Xufeng Zhang (1):
      sctp: Fix sk_ack_backlog wrap-around problem

Yasuaki Ishimatsu (1):
      workqueue: zero cpumask of wq_numa_possible_cpumask on init

Yuchung Cheng (2):
      tcp: fix cwnd undo on DSACK in F-RTO
      tcp: fix false undo corner cases

dingtianhong (1):
      igmp: fix the problem when mc leave group

zhangwei(Jovi) (2):
      tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs
      tracing: Add TRACE_ITER_PRINTK flag check in __trace_puts/__trace_bputs
