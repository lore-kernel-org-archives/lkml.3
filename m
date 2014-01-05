Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaAEQwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 11:52:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57676 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaAEQwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 11:52:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.11.y.z extended stable] Linux 3.11.10.2
Date: Sun,  5 Jan 2014 16:52:06 +0000
Message-Id: <1388940727-5846-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.11.10.2 kernel.

The updated 3.11.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.11.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.11.y;a=shortlog

The diff from v3.11.10.1 is posted as a follow-up to this email.

The 3.11.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Documentation/networking/ip-sysctl.txt             |   3 -
 Makefile                                           |   2 +-
 arch/arm/boot/dts/armada-370-xp.dtsi               |   2 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi           |  16 +-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           |  78 ++++++++--
 arch/arm/include/asm/pgtable.h                     |   2 +-
 arch/arm/kernel/process.c                          |   7 +-
 arch/arm/kernel/stacktrace.c                       |   2 +-
 arch/arm/mach-at91/sama5d3.c                       |   6 +-
 arch/arm/mach-footbridge/common.c                  |   3 +
 arch/arm/mach-footbridge/dc21285.c                 |   2 -
 arch/arm/mach-footbridge/ebsa285.c                 |  22 +--
 arch/arm/mach-highbank/highbank.c                  |  23 +++
 arch/arm/mach-pxa/reset.c                          |   8 +-
 arch/arm/mach-pxa/tosa.c                           | 102 ++++++-------
 arch/arm/mm/mmap.c                                 |   2 +-
 arch/arm/mm/pgd.c                                  |   3 +-
 arch/arm/plat-omap/include/plat/dmtimer.h          |   5 +-
 arch/arm64/include/asm/pgtable-hwdef.h             |   2 +-
 arch/mips/mm/dma-default.c                         |  16 +-
 arch/parisc/kernel/sys_parisc.c                    |  25 ++--
 arch/powerpc/include/asm/pgalloc-32.h              |   6 +-
 arch/powerpc/include/asm/pgalloc-64.h              |   6 +-
 arch/s390/crypto/aes_s390.c                        |  31 ++--
 arch/x86/Makefile                                  |   8 +-
 arch/x86/boot/Makefile                             |   6 +-
 arch/x86/boot/compressed/Makefile                  |   1 +
 arch/x86/kvm/lapic.c                               |  35 +++--
 arch/x86/kvm/lapic.h                               |   4 +-
 arch/x86/kvm/x86.c                                 |  40 +----
 arch/x86/platform/efi/efi.c                        |   7 -
 arch/x86/realmode/rm/Makefile                      |   3 +-
 block/blk-cgroup.h                                 |   8 +-
 block/blk-core.c                                   |  10 +-
 block/elevator.c                                   |  22 ++-
 crypto/algif_hash.c                                |   5 +-
 crypto/algif_skcipher.c                            |   4 +-
 crypto/authenc.c                                   |   7 +-
 crypto/ccm.c                                       |   3 +-
 drivers/ata/libata-scsi.c                          |   1 +
 drivers/atm/idt77252.c                             |   2 +-
 drivers/char/i8k.c                                 |   7 +
 drivers/connector/cn_proc.c                        |  72 +++++----
 drivers/cpufreq/intel_pstate.c                     |   6 +-
 drivers/cpuidle/cpuidle.c                          |   2 +-
 drivers/firewire/sbp2.c                            |   1 +
 drivers/firmware/efi/efi-pstore.c                  | 161 +++++++++++++++++++--
 drivers/firmware/efi/efivars.c                     |  12 +-
 drivers/firmware/efi/vars.c                        |  12 +-
 drivers/gpio/gpio-mpc8xxx.c                        |   8 +-
 drivers/gpu/drm/i915/intel_display.c               |   2 +-
 drivers/gpu/drm/radeon/atombios_i2c.c              |  23 ++-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |  82 +++++++----
 drivers/gpu/drm/radeon/radeon_atombios.c           |   2 +-
 drivers/gpu/drm/radeon/si.c                        |  11 +-
 drivers/hid/hid-core.c                             |   1 +
 drivers/hid/hid-elo.c                              |  35 ++++-
 drivers/hid/hid-ids.h                              |   6 +
 drivers/hid/hid-kye.c                              |   6 +
 drivers/hid/hid-lg.c                               |  58 ++++++++
 drivers/hid/usbhid/hid-quirks.c                    |   3 +
 drivers/hwmon/hih6130.c                            |  16 +-
 drivers/hwmon/lm78.c                               |   2 +
 drivers/hwmon/sis5595.c                            |   2 +
 drivers/hwmon/vt8231.c                             |   2 +-
 drivers/hwmon/w83l786ng.c                          |  13 +-
 drivers/input/Kconfig                              |   2 +-
 drivers/input/keyboard/Kconfig                     |   4 +-
 drivers/input/serio/Kconfig                        |   6 +-
 drivers/iommu/arm-smmu.c                           |  62 ++++----
 drivers/iommu/intel-iommu.c                        |   6 +-
 drivers/iommu/intel_irq_remapping.c                |  13 +-
 drivers/isdn/isdnloop/isdnloop.c                   |   8 +-
 drivers/isdn/mISDN/socket.c                        |  13 +-
 drivers/md/dm-bufio.c                              |   5 +
 drivers/md/dm-delay.c                              |  23 ++-
 drivers/md/dm-snap.c                               |  71 ++++++++-
 drivers/md/dm-table.c                              |   5 +
 drivers/md/dm-thin-metadata.c                      |   8 +
 drivers/md/dm-thin-metadata.h                      |   1 +
 drivers/md/dm-thin.c                               |  17 ++-
 drivers/md/persistent-data/dm-array.c              |  10 +-
 drivers/md/persistent-data/dm-block-manager.c      |   6 +
 drivers/md/persistent-data/dm-block-manager.h      |   1 +
 drivers/md/persistent-data/dm-space-map-metadata.c |   8 +-
 drivers/media/dvb-frontends/af9033.c               |  12 +-
 drivers/media/i2c/wm8775.c                         |   4 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   3 +-
 drivers/media/pci/saa7164/saa7164-core.c           |   4 +-
 drivers/media/radio/radio-tea5764.c                |   2 +-
 drivers/media/radio/tef6862.c                      |   2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |  17 ++-
 drivers/misc/enclosure.c                           |   7 +
 drivers/misc/mei/hw-me-regs.h                      |   6 +-
 drivers/misc/mei/pci-me.c                          |   5 +-
 drivers/mmc/card/block.c                           |  45 +++++-
 drivers/net/bonding/bond_sysfs.c                   |  11 +-
 drivers/net/can/c_can/c_can.c                      |  21 ++-
 drivers/net/can/flexcan.c                          |   2 +-
 drivers/net/can/sja1000/sja1000.c                  |  17 ++-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   5 +-
 drivers/net/ethernet/broadcom/tg3.c                |  12 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c         |   5 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |   8 +-
 drivers/net/ethernet/realtek/8139cp.c              |   5 +-
 drivers/net/ethernet/realtek/r8169.c               |   5 +
 drivers/net/ethernet/smsc/smc91x.h                 |  22 +--
 drivers/net/ethernet/via/via-velocity.c            |  11 +-
 drivers/net/macvtap.c                              |   8 +-
 drivers/net/ppp/pppoe.c                            |   2 -
 drivers/net/team/team.c                            |   4 +
 drivers/net/tun.c                                  |  10 +-
 drivers/net/usb/usbnet.c                           |   3 -
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |  22 +--
 drivers/net/wireless/iwlwifi/dvm/tx.c              |  14 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c            |   6 +
 drivers/net/wireless/iwlwifi/iwl-config.h          |   3 +
 drivers/net/wireless/iwlwifi/iwl-csr.h             |   5 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c         |   4 +
 drivers/net/wireless/iwlwifi/pcie/rx.c             |   4 +
 drivers/net/wireless/iwlwifi/pcie/trans.c          |   3 -
 drivers/net/wireless/mwifiex/sta_ioctl.c           |   4 +-
 drivers/pci/pci-driver.c                           |  12 +-
 drivers/rtc/rtc-at91rm9200.c                       |   2 +
 drivers/scsi/3w-9xxx.c                             |   3 +-
 drivers/scsi/3w-sas.c                              |   3 +-
 drivers/scsi/3w-xxxx.c                             |   3 +-
 drivers/scsi/aacraid/linit.c                       |   1 +
 drivers/scsi/arcmsr/arcmsr_hba.c                   |   1 +
 drivers/scsi/bfa/bfa_fcs.h                         |   1 +
 drivers/scsi/bfa/bfa_fcs_lport.c                   |  14 +-
 drivers/scsi/bfa/bfad_attr.c                       |   7 +-
 drivers/scsi/gdth.c                                |   1 +
 drivers/scsi/hosts.c                               |   1 +
 drivers/scsi/hpsa.c                                |   5 +-
 drivers/scsi/ipr.c                                 |   3 +-
 drivers/scsi/ips.c                                 |   1 +
 drivers/scsi/libsas/sas_ata.c                      |   2 +-
 drivers/scsi/megaraid.c                            |   1 +
 drivers/scsi/megaraid/megaraid_mbox.c              |   1 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |   1 +
 drivers/scsi/pmcraid.c                             |   1 +
 drivers/scsi/sd.c                                  |   6 +
 drivers/scsi/storvsc_drv.c                         |   1 +
 drivers/spi/spi-pxa2xx.c                           |   2 +
 drivers/usb/class/cdc-acm.c                        |   2 +
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/dwc3/ep0.c                             |   2 +
 drivers/usb/dwc3/gadget.c                          |   5 +-
 drivers/usb/gadget/composite.c                     |   1 +
 drivers/usb/musb/musb_core.c                       |   8 +-
 drivers/usb/serial/ftdi_sio.c                      |  37 +++--
 drivers/usb/serial/generic.c                       |   9 +-
 drivers/usb/serial/mos7840.c                       |  32 ++--
 drivers/usb/serial/option.c                        |  27 ++++
 drivers/usb/serial/pl2303.c                        |  31 ++--
 drivers/usb/serial/spcp8x5.c                       |  30 ++--
 drivers/video/kyro/fbdev.c                         |   6 +-
 .../omap2/displays-new/panel-sony-acx565akm.c      |   5 +-
 drivers/xen/grant-table.c                          |   6 +-
 fs/aio.c                                           |  10 +-
 fs/btrfs/ioctl.c                                   |   3 +-
 fs/btrfs/send.c                                    |   4 +-
 fs/gfs2/inode.c                                    |   5 +-
 fs/nfs/blocklayout/extents.c                       |   2 +-
 fs/nfs/nfs4proc.c                                  |  13 +-
 fs/nfsd/nfscache.c                                 |   9 +-
 fs/pipe.c                                          |  39 +++--
 fs/xfs/xfs_fsops.c                                 |   6 +-
 fs/xfs/xfs_ioctl.c                                 |   9 +-
 fs/xfs/xfs_ioctl32.c                               |   3 +-
 include/crypto/scatterwalk.h                       |   3 +-
 include/linux/compiler-intel.h                     |   2 -
 include/linux/efi.h                                |   4 +
 include/linux/genalloc.h                           |   4 +-
 include/linux/kexec.h                              |   3 +
 include/linux/net.h                                |   8 +
 include/linux/random.h                             |   6 +-
 include/linux/skbuff.h                             |  32 ----
 include/net/ip.h                                   |   2 +-
 include/net/ip_vs.h                                |  32 +---
 include/net/ipv6.h                                 |   6 +-
 include/net/netfilter/ipv6/nf_defrag_ipv6.h        |   5 +-
 include/net/ping.h                                 |   3 +-
 include/scsi/scsi_host.h                           |   6 +
 include/sound/memalloc.h                           |   2 +-
 include/uapi/sound/compress_offload.h              |   6 +-
 kernel/futex.c                                     |   2 +-
 kernel/irq/pm.c                                    |   2 +-
 kernel/kexec.c                                     |   4 +
 kernel/sched/debug.c                               |   8 +
 kernel/sched/fair.c                                |   2 +
 kernel/time/ntp.c                                  |   3 +-
 kernel/time/timekeeping.c                          |   2 +-
 lib/genalloc.c                                     |  19 ++-
 lib/random32.c                                     |  14 +-
 net/appletalk/ddp.c                                |  16 +-
 net/atm/common.c                                   |   2 -
 net/ax25/af_ax25.c                                 |   4 +-
 net/bluetooth/af_bluetooth.c                       |   4 -
 net/bluetooth/hci_sock.c                           |   2 -
 net/bluetooth/rfcomm/sock.c                        |   1 -
 net/bluetooth/sco.c                                |   1 -
 net/bridge/br_if.c                                 |   2 +
 net/caif/caif_socket.c                             |   4 -
 net/compat.c                                       |   5 +-
 net/core/dev.c                                     |   2 +-
 net/core/fib_rules.c                               |   3 +-
 net/core/iovec.c                                   |   3 +-
 net/core/pktgen.c                                  |   7 +
 net/core/skbuff.c                                  |   3 -
 net/ieee802154/6lowpan.c                           |   4 +-
 net/ieee802154/dgram.c                             |   3 +-
 net/ipv4/datagram.c                                |   2 +-
 net/ipv4/ip_sockglue.c                             |   3 +-
 net/ipv4/ip_vti.c                                  |   1 +
 net/ipv4/ping.c                                    |  56 +++----
 net/ipv4/raw.c                                     |   6 +-
 net/ipv4/route.c                                   |   8 +-
 net/ipv4/tcp.c                                     |   6 -
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv4/tcp_metrics.c                             |   5 +-
 net/ipv4/tcp_offload.c                             |  31 ++--
 net/ipv4/tcp_output.c                              |   7 +-
 net/ipv4/udp.c                                     |  14 +-
 net/ipv6/datagram.c                                |   8 +-
 net/ipv6/ip6_flowlabel.c                           |   2 +
 net/ipv6/ip6_output.c                              |   7 +-
 net/ipv6/ip6_tunnel.c                              |   2 -
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |  54 +------
 net/ipv6/netfilter/nf_conntrack_reasm.c            |  19 +--
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |   7 +-
 net/ipv6/ping.c                                    |   3 +-
 net/ipv6/raw.c                                     |   8 +-
 net/ipv6/route.c                                   |   7 +-
 net/ipv6/tcpv6_offload.c                           |  32 ++--
 net/ipv6/udp.c                                     |   9 +-
 net/ipv6/udp_offload.c                             |   2 +-
 net/ipx/af_ipx.c                                   |   3 +-
 net/irda/af_irda.c                                 |   4 -
 net/iucv/af_iucv.c                                 |   2 -
 net/key/af_key.c                                   |   1 -
 net/l2tp/l2tp_ip.c                                 |   4 +-
 net/l2tp/l2tp_ip6.c                                |   2 +-
 net/l2tp/l2tp_ppp.c                                |   2 -
 net/llc/af_llc.c                                   |   2 -
 net/mac80211/cfg.c                                 |   3 +-
 net/mac80211/main.c                                |   1 +
 net/mac80211/rx.c                                  |   3 +-
 net/mac80211/scan.c                                |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  55 +------
 net/netfilter/ipvs/ip_vs_pe_sip.c                  |   8 +-
 net/netlink/af_netlink.c                           |   2 -
 net/netrom/af_netrom.c                             |   3 +-
 net/nfc/llcp_sock.c                                |   2 -
 net/nfc/rawsock.c                                  |   2 -
 net/packet/af_packet.c                             |  95 ++++++------
 net/packet/internal.h                              |   1 +
 net/phonet/datagram.c                              |   9 +-
 net/rds/recv.c                                     |   2 -
 net/rose/af_rose.c                                 |   8 +-
 net/rxrpc/ar-recvmsg.c                             |   9 +-
 net/sched/sch_tbf.c                                |  32 +++-
 net/socket.c                                       |  24 +--
 net/tipc/socket.c                                  |   6 -
 net/unix/af_unix.c                                 |   5 -
 net/vmw_vsock/af_vsock.c                           |   2 -
 net/vmw_vsock/vmci_transport.c                     |   2 -
 net/x25/af_x25.c                                   |   3 +-
 security/selinux/hooks.c                           |  93 +++++++++---
 sound/pci/hda/hda_generic.c                        |  47 +++++-
 sound/pci/hda/hda_generic.h                        |   3 +
 sound/pci/hda/patch_analog.c                       |  14 ++
 sound/pci/hda/patch_hdmi.c                         |   5 +-
 sound/pci/hda/patch_realtek.c                      |  58 +++++++-
 sound/soc/codecs/wm8731.c                          |   4 +-
 sound/soc/codecs/wm8990.c                          |   2 +
 virt/kvm/kvm_main.c                                |   3 +
 278 files changed, 1935 insertions(+), 1199 deletions(-)

Aaro Koskinen (1):
      ARM: OMAPFB: panel-sony-acx565akm: fix bad unlock balance

AceLan Kao (2):
      HID: usbhid: quirk for Synaptics Large Touchccreen
      HID: usbhid: quirk for SiS Touchscreen

Alan Cox (1):
      drivers/char/i8k.c: add Dell XPLS L421X

Alan Stern (1):
      usb: dwc3: fix implementation of endpoint wedge

Alex Deucher (5):
      drm/radeon: fix typo in fetching mpll params
      drm/radeon: program DCE2 audio dto just like DCE3
      drm/radeon: fixup bad vram size on SI
      drm/radeon: atombios hw i2c fixes
      drm/radeon/atom: fix bus probes when hw_i2c is set (v2)

Alexei Starovoitov (1):
      ipv4: fix race in concurrent ip_route_input_slow()

Amir Vadai (1):
      net/mlx4_en: Fixed crash when port type is changed

Andreas Henriksson (1):
      net: Fix "ip rule delete table 256"

Andrey Vagin (1):
      tcp: don't update snd_nxt, when a socket is switched from repair mode

Andy Adamson (1):
      NFSv4 wait on recovery for async session errors

Andy Honig (3):
      KVM: Improve create VCPU parameter (CVE-2013-4587)
      KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)
      KVM: x86: Convert vapic synchronization to _cached functions (CVE-2013-6368)

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix IEC958 ctl indexes for some simple HDMI devices

Antti Palosaari (3):
      [media] af9035: add [0413:6a05] Leadtek WinFast DTV Dongle Dual
      [media] af9035: fix broken I2C and USB I/O
      [media] af9033: fix broken I2C

Arnaud Ebalard (2):
      ARM: mvebu: fix second and third PCIe unit of Armada XP mv78260
      ARM: mvebu: second PCIe unit of Armada XP mv78230 is only x1 capable

Ben Hutchings (1):
      HID: kye: Fix missing break in kye_report_fixup()

Ben Segall (1):
      sched: Avoid throttle_cfs_rq() racing with period_timer stopping

Benjamin Tissoires (1):
      HID: kye: Add report fixup for Genius Manticore Keyboard

Bo Shen (1):
      ASoC: wm8731: fix dsp mode configuration

Bob Copeland (1):
      Revert "mac80211: allow disable power save in mesh"

Brian Carnes (1):
      hwmon: (w83l786ng) Fix fan speed control mode setting and reporting

Carolyn Wyborny (1):
      igb: Fix for issue where values could be too high for udelay function.

Chris Metcalf (1):
      connector: improved unaligned access error fix

Colin Leitner (4):
      USB: spcp8x5: correct handling of CS5 setting
      USB: mos7840: correct handling of CS5 setting
      USB: ftdi_sio: fixed handling of unsupported CSIZE setting
      USB: pl2303: fixed handling of CS5 setting

Dan Carpenter (6):
      isdnloop: use strlcpy() instead of strcpy()
      net: clamp ->msg_namelen instead of returning an error
      [media] af9035: unlock on error in af9035_i2c_master_xfer()
      hwmon: Prevent some divide by zeros in FAN_TO_REG()
      Btrfs: fix access_ok() check in btrfs_ioctl_send()
      xfs: underflow bug in xfs_attrlist_by_handle()

Dan Williams (1):
      [SCSI] libsas: fix usage of ata_tf_to_fis

Daniel Borkmann (2):
      random32: fix off-by-one in seeding requirement
      packet: fix use after free race in send path when dev is released

Dave Chinner (1):
      xfs: growfs overruns AGFL buffer on V4 filesystems

David Chang (1):
      r8169: check ALDPS bit and disable it if enabled for the 8168g

David Cluytens (1):
      USB: cdc-acm: Added support for the Lenovo RD02-D400 USB Modem

David Henningsson (2):
      ALSA: hda - Add mono speaker quirk for Dell Inspiron 5439
      ALSA: hda - Fix headset mic input after muted internal mic (Dell/Realtek)

David Sterba (1):
      btrfs: call mnt_drop_write after interrupted subvol deletion

Ding Tianhong (1):
      bridge: flush br's address entry in fdb when remove the

Dmitry Eremin-Solenikov (1):
      ARM: pxa: tosa: fix keys mapping

Duan Jiong (1):
      ipv6: use rt6_get_dflt_router to get default router in rt6_route_rcv

Dwight Engen (1):
      xfs: add capability check to free eofblocks ioctl

Emmanuel Grumbach (2):
      iwlwifi: dvm: don't override mac80211's queue setting
      iwlwifi: pcie: fix interrupt coalescing for 7260 / 3160

Eric Dumazet (5):
      tcp: tsq: restore minimal amount of queueing
      net-tcp: fix panic in tcp_fastopen_cache_set()
      ipv4: fix possible seqlock deadlock
      inet: fix possible seqlock deadlocks
      sch_tbf: handle too small burst

Fangxiaozhi (Franko) (1):
      USB: option: support new huawei devices

Felix Fietkau (1):
      usbnet: fix status interrupt urb handling

Gerald Schaefer (1):
      crypto: s390 - Fix aes-xts parameter corruption

Gleb Natapov (1):
      KVM: x86: fix guest-initiated crash with x2apic (CVE-2013-6376)

Gregory CLEMENT (1):
      ARM: mvebu: use the virtual CPU registers to access coherency registers

Gustavo Zacarias (1):
      USB: serial: option: blacklist interface 1 for Huawei E173s-6

H. Peter Anvin (3):
      x86-64, build: Always pass in -mno-sse
      x86, build: Pass in additional -mno-mmx, -mno-sse options
      x86, build, icc: Remove uninitialized_var() from compiler-intel.h

Hannes Frederic Sowa (9):
      ipv6: fix headroom calculation in udp6_ufo_fragment
      ipv6: protect for_each_sk_fl_rcu in mem_check with rcu_read_lock_bh
      inet: prevent leakage of uninitialized memory to user in recv syscalls
      net: rework recvmsg handler msg_name and msg_namelen logic
      net: add BUG_ON if kernel advertises msg_namelen > sizeof(struct sockaddr_storage)
      inet: fix addr_len/msg->msg_namelen assignment in recv_error and rxpmtu functions
      ipv6: fix leaking uninitialized port number of offender sockaddr
      ipv6: fix possible seqlock deadlock in ip6_finish_output2
      ping: prevent NULL pointer dereference on write to msg_name

Hans Verkuil (3):
      [media] bttv: don't setup the controls if there are no video devices
      [media] tef6862/radio-tea5764: actually assign clamp result
      [media] wm8775: fix broken audio routing

Helge Deller (2):
      parisc: fix mmap(MAP_FIXED|MAP_SHARED) to already mmapped address
      nfs: fix do_div() warning by instead using sector_div()

Herbert Xu (2):
      gro: Only verify TCP checksums for candidates
      gro: Clean up tcpX_gro_receive checksum verification

Hong H. Pham (1):
      powerpc: Fix PTE page address mismatch in pgtable ctor/dtor

Hong Zhiguo (1):
      Update of blkg_stat and blkg_rwstat may happen in bh context.     While u64_stats_fetch_retry is only preempt_disable on 32bit     UP system. This is not enough to avoid preemption by bh and     may read strange 64 bit value.

Horia Geanta (1):
      crypto: ccm - Fix handling of zero plaintext when computing mac

Hui Wang (3):
      ALSA: hda - A Dell headset detection quirk
      ALSA: hda - Another Dell headset detection quirk
      ALSA: hda - One more Dell headset detection quirk

Ivan Vecera (1):
      tg3: avoid double-freeing of rx data memory

James Bottomley (1):
      [SCSI] enclosure: fix WARN_ON in dual path device removing

Jason Wang (2):
      tuntap: limit head length of skb allocated
      macvtap: limit head length of skb allocated

Jean Delvare (1):
      hwmon: (w83l768ng) Fix fan speed control range

Jeff Layton (1):
      nfsd: when reusing an existing repcache entry, unhash it first

Jerome Glisse (1):
      radeon/i2c: do not count reg index in number of i2c byte we are writing.

Jim Quinlan (1):
      MIPS: DMA: For BMIPS5000 cores flush region just like non-coherent R10000

Jiri Pirko (3):
      ip6_output: fragment outgoing reassembled skb properly
      netfilter: push reasm skb through instead of original frag skbs
      team: fix master carrier set when user linkup is enabled

Joe Thornber (4):
      dm thin: switch to read only mode if a mapping insert fails
      dm thin: re-establish read-only state when switching to fail mode
      dm thin: allow pool in read-only mode to transition to read-write mode
      dm array: fix a reference counting bug in shadow_ablock

Joel Fernandes (1):
      ARM: OMAP2+: Disable POSTED mode for errata i103 and i767

Johan Hovold (1):
      USB: serial: fix race in generic write

Johannes Berg (3):
      mac80211: fix scheduled scan rtnl deadlock
      mac80211: don't attempt to reorder multicast frames
      iwlwifi: mvm: check sta_id/drain values in debugfs

Joonyoung Shim (1):
      lib/genalloc.c: fix overflow of ending address of memory chunk

José Miguel Gonçalves (1):
      hwmon: HIH-6130: Support I2C bus drivers without I2C_FUNC_SMBUS_QUICK

Jukka Rissanen (1):
      6lowpan: Uncompression of traffic class field was incorrect

Julian Stecklina (1):
      iommu/vt-d: Fixed interaction of VFIO_IOMMU_MAP_DMA with IOMMU address limits

Julius Werner (1):
      usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED

KOBAYASHI Yoshitake (1):
      mmc: block: fix a bug of error handling in MMC driver

Khalid Aziz (1):
      PCI: Disable Bus Master only on kexec reboot

Konrad Rzeszutek Wilk (1):
      cpuidle: Check for dev before deregistering it.

Konstantin Khlebnikov (2):
      ARM: 7912/1: check stack pointer in get_wchan
      ARM: 7913/1: fix framepointer check in unwind_frame

Laxman Dewangan (1):
      irq: Enable all irqs unconditionally in irq_resume

Linus Pizunski (1):
      drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap

Linus Torvalds (2):
      vfs: fix subtle use-after-free of pipe_inode_info
      futex: fix handling of read-only-mapped hugepages

Linus Walleij (1):
      net: smc91: fix crash regression on the versatile

Liu Gang (1):
      powerpc/gpio: Fix the wrong GPIO input data on MPC8572/MPC8536

Ludovic Desroches (1):
      ARM: at91: sama5d3: reduce TWI internal clock frequency

Luis Henriques (1):
      Linux 3.11.10.2

Madper Xie (1):
      efi-pstore: Make efi-pstore return a unique id

Marc Kleine-Budde (2):
      can: c_can: don't call pm_runtime_get_sync() from interrupt context
      can: flexcan: use correct clock as base for bit rate calculation

Mark Brown (1):
      ASoC: wm8990: Mark the register map as dirty when powering down

Martin K. Petersen (1):
      [SCSI] Disable WRITE SAME for RAID and virtual host adapter drivers

Martin Schwidefsky (1):
      time: Fix 1ns/tick drift w/ GENERIC_TIME_VSYSCALL_OLD

Mateusz Guzik (1):
      aio: restore locking of ioctx list on removal

Matt Wilson (1):
      xen/gnttab: leave lazy MMU mode in the case of a m2p override failure

Matthew Garrett (1):
      x86, efi: Don't use (U)EFI time services on 32 bit

Maxime Ripard (1):
      net: allwinner: emac: Add missing free_irq

Michael Grzeschik (1):
      usb: gadget: composite: reset delayed_status on reset_config

Mika Westerberg (1):
      spi/pxa2xx: add new ACPI IDs

Mike Snitzer (1):
      dm space map metadata: return on failure in sm_metadata_new_block

Mikulas Patocka (4):
      dm delay: fix a possible deadlock due to shared workqueue
      dm snapshot: avoid snapshot space leak on crash
      dm table: fail dm_table_create on dm_round_up overflow
      dm bufio: initialize read-only module parameters

Miroslav Lichvar (1):
      ntp: Make periodic RTC update more reliable

Neil Horman (1):
      iommu: Remove stack trace from broken irq remapping warning

Nicolas Dichtel (1):
      ip6tnl: fix use after free of fb_tnl_dev

Nikolay Aleksandrov (1):
      bonding: fix two race conditions in bond_store_updelay/downdelay

Oliver Hartkopp (1):
      can: sja1000: fix {pre,post}_irq() handling and IRQ handler return value

Oliver Neukum (1):
      HID: hid-elo: some systems cannot stomach work around

Paul Moore (2):
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute()

Pierre Ossman (2):
      drm/radeon/audio: improve ACR calculation
      drm/radeon/audio: correct ACR table

Rafael J. Wysocki (1):
      intel_pstate: Fix type mismatch warning

Rob Herring (1):
      ARM: highbank: handle soft poweroff and reset key events

Russell King (3):
      ARM: fix booting low-vectors machines
      ARM: footbridge: fix VGA initialisation
      ARM: footbridge: fix EBSA285 LEDs

Sasha Levin (1):
      video: kyro: fix incorrect sizes when copying to userspace

Sebastian Andrzej Siewior (2):
      usb: musb: cancel work on removal
      usb: musb: only cancel work if it is initialized

Seiji Aguchi (1):
      efivars, efi-pstore: Hold off deletion of sysfs entry until the scan is completed

Sergei Ianovich (1):
      ARM: pxa: prevent PXA270 occasional reboot freezes

Shawn Landden (1):
      net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Simon Wood (1):
      HID: lg: fix Report Descriptor for Logitech MOMO Force (Black)

Srinivas Pandruvada (1):
      intel_pstate: fix no_turbo

Stefano Panella (1):
      ALSA: memalloc.h - fix wrong truncation of dma_addr_t

Stephen M. Cameron (2):
      [SCSI] hpsa: do not discard scsi status on aborted commands
      [SCSI] hpsa: return 0 from driver probe function on success, not 1

Steve Capper (1):
      arm64: mm: Fix PMD_SECT_PROT_NONE definition

Steven Whitehouse (1):
      GFS2: Fix ref count bug relating to atomic_open

Sujith Manoharan (2):
      ath9k: Fix QuickDrop usage
      ath9k: Fix XLNA bias strength

Takashi Iwai (8):
      ALSA: hda - Fix silent output on ASUS W7J laptop
      ALSA: hda - Fix bad EAPD setup for HP machines with AD1984A
      ALSA: hda - Another fixup for ASUS laptop with ALC660 codec
      ALSA: hda - Use always amps for auto-mute on AD1986A codec
      ALSA: hda - Fix silent output on MacBook Air 2,1
      ALSA: compress: Fix 64bit ABI incompatibility
      ALSA: hda - Mute all aamix inputs as default
      ALSA: hda - Add static DAC/pin mapping for AD1986A codec

Tom Gundersen (2):
      Input: allow deselecting serio drivers even without CONFIG_EXPERT
      Input: mousedev - allow disabling even without CONFIG_EXPERT

Tom Lendacky (3):
      crypto: authenc - Find proper IV address in ablkcipher callback
      crypto: scatterwalk - Set the chain pointer indication bit
      crypto: scatterwalk - Use sg_chain_ptr on chain entries

Tomas Winkler (2):
      mei: me: add Lynx Point Wellsburg work station device id
      mei: add 9 series PCH mei device ids

Tomoki Sekiyama (2):
      elevator: Fix a race in elevator switching and md device initialization
      elevator: acquire q->sysfs_lock in elevator_change()

Trond Myklebust (1):
      NFSv4: Update list of irrecoverable errors on DELEGRETURN

Ujjal Roy (1):
      mwifiex: fix memory leak issue for ibss join

Veaceslav Falico (2):
      bonding: don't permit to use ARP monitoring in 802.3ad mode
      af_packet: block BH in prb_shutdown_retire_blk_timer()

Vijaya Mohan Guvva (1):
      [SCSI] bfa: Fix crash when symb name set for offline vport

Ville Syrjälä (1):
      drm/i915: Fix pipe CSC post offset calculation

Vlad Yasevich (1):
      net: core: Always propagate flag changes to interfaces

Wei Yongjun (1):
      [media] saa7164: fix return value check in saa7164_initdev()

Will Deacon (1):
      iommu/arm-smmu: use mutex instead of spinlock for locking page tables

Yang Yingliang (1):
      net: 8139cp: fix a BUG_ON triggered by wrong bytes_compl

Ying Xue (1):
      atm: idt77252: fix dev refcnt leak

fan.du (2):
      xfrm: Release dst if this dst is improper for vti tunnel
      {pktgen, xfrm} Update IPv4 header total len and checksum after tranformation

françois romieu (1):
      via-velocity: fix netif_receive_skb use in irq disabled section.

