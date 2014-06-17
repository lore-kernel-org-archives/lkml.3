Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbaFQQP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:15:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50320 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364AbaFQQP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:15:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.8.y.z extended stable] Linux 3.8.13.24 stable review
Date: Tue, 17 Jun 2014 09:13:13 -0700
Message-Id: <1403021714-16320-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.8.13.24 stable kernel.

This version contains 121 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.8.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.8.y-review

The review period for version 3.8.13.24 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.8.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 Documentation/input/elantech.txt               |  5 +-
 arch/arm/include/asm/div64.h                   |  2 +-
 arch/arm/kernel/machine_kexec.c                |  7 ++
 arch/mips/cavium-octeon/octeon-irq.c           |  2 +-
 arch/parisc/kernel/syscall_table.S             |  2 +-
 arch/s390/net/bpf_jit_comp.c                   |  1 -
 drivers/acpi/ec.c                              | 77 +++++++++++++++++++--
 drivers/ata/libata-core.c                      | 21 +++---
 drivers/ata/pata_at91.c                        | 11 +--
 drivers/base/dd.c                              | 17 +++++
 drivers/bluetooth/ath3k.c                      |  2 +
 drivers/bluetooth/btusb.c                      |  1 +
 drivers/gpu/drm/i915/intel_display.c           | 26 +++----
 drivers/gpu/drm/nouveau/nouveau_acpi.c         |  3 -
 drivers/gpu/drm/radeon/radeon_atpx_handler.c   |  7 ++
 drivers/gpu/drm/radeon/radeon_kms.c            |  5 +-
 drivers/gpu/drm/radeon/si.c                    |  4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c        | 22 ++++++
 drivers/hid/hid-ids.h                          |  1 +
 drivers/hid/usbhid/hid-quirks.c                |  1 +
 drivers/iio/industrialio-buffer.c              |  6 +-
 drivers/input/mouse/elantech.c                 | 26 ++++++-
 drivers/input/mouse/elantech.h                 |  1 +
 drivers/input/mouse/synaptics.c                | 50 ++++++++++++++
 drivers/misc/mei/interrupt.c                   |  3 +-
 drivers/misc/mei/main.c                        |  3 +-
 drivers/net/bonding/bond_main.c                |  1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |  3 -
 drivers/net/ethernet/broadcom/tg3.c            |  4 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |  1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |  6 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |  1 -
 drivers/net/macvlan.c                          |  9 ++-
 drivers/net/usb/cdc_mbim.c                     | 39 ++++++++---
 drivers/net/usb/qmi_wwan.c                     | 37 +++++++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c        | 22 +++---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c    |  2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c           |  1 -
 drivers/staging/rtl8712/rtl871x_recv.c         | 13 ++--
 drivers/tty/hvc/hvc_console.c                  |  2 +-
 drivers/usb/class/cdc-acm.c                    | 28 ++++++--
 drivers/usb/core/hcd-pci.c                     |  2 +-
 drivers/usb/host/ehci-fsl.c                    |  3 +-
 drivers/usb/host/xhci-pci.c                    |  2 +
 drivers/usb/host/xhci-ring.c                   | 76 +++++++++++---------
 drivers/usb/host/xhci.c                        |  1 -
 drivers/usb/host/xhci.h                        |  2 -
 drivers/usb/serial/cp210x.c                    |  1 +
 drivers/usb/serial/ftdi_sio.c                  | 33 +++++++++
 drivers/usb/serial/ftdi_sio_ids.h              | 37 ++++++++++
 drivers/usb/serial/io_ti.c                     | 50 +++++++++-----
 drivers/usb/serial/option.c                    | 83 ++++++++++++++++++++--
 drivers/usb/serial/pl2303.c                    |  3 +
 drivers/usb/serial/pl2303.h                    |  5 +-
 drivers/usb/serial/qcserial.c                  | 24 +++++++
 drivers/usb/serial/sierra.c                    |  1 -
 drivers/usb/serial/usb-serial.c                |  4 +-
 drivers/usb/serial/usb_wwan.c                  |  9 +--
 drivers/usb/storage/shuttle_usbat.c            |  2 +-
 drivers/usb/storage/unusual_devs.h             | 14 ++++
 fs/btrfs/inode-map.c                           | 18 +----
 fs/ext4/file.c                                 |  2 +-
 fs/ext4/page-io.c                              |  5 +-
 fs/ext4/xattr.c                                | 23 ++++--
 fs/locks.c                                     |  7 +-
 fs/nfsd/nfs4callback.c                         |  4 +-
 fs/posix_acl.c                                 |  6 ++
 include/asm-generic/pgtable.h                  | 31 ++++++---
 include/linux/ftrace.h                         |  2 +
 include/linux/interrupt.h                      | 35 +++++++++-
 include/linux/irq.h                            |  3 +-
 include/linux/libata.h                         |  1 +
 include/linux/list.h                           | 16 +++++
 include/net/ip6_route.h                        |  5 ++
 include/net/sctp/structs.h                     |  4 +-
 kernel/events/core.c                           |  3 -
 kernel/hrtimer.c                               | 22 ++++++
 kernel/irq/manage.c                            | 17 ++---
 kernel/module.c                                |  3 +
 kernel/timer.c                                 |  2 +-
 kernel/trace/ftrace.c                          | 27 ++------
 kernel/user_namespace.c                        | 11 ++-
 mm/compaction.c                                | 22 +++---
 mm/hugetlb.c                                   |  1 +
 mm/memory.c                                    |  5 ++
 net/8021q/vlan_dev.c                           | 46 ++++++++++--
 net/bluetooth/hci_event.c                      |  6 ++
 net/bridge/br_netlink.c                        | 15 ++++
 net/core/dev.c                                 |  2 +
 net/core/filter.c                              |  6 +-
 net/core/rtnetlink.c                           | 33 ++++++---
 net/core/skbuff.c                              | 15 ++--
 net/ipv4/fib_semantics.c                       |  2 +-
 net/ipv4/ip_forward.c                          |  4 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c            |  5 +-
 net/ipv4/ping.c                                | 15 ++--
 net/ipv4/route.c                               |  4 +-
 net/ipv4/tcp_cubic.c                           |  2 +-
 net/ipv6/ip6_fib.c                             |  3 +-
 net/ipv6/ip6_gre.c                             | 10 +++
 net/ipv6/ip6_output.c                          |  6 +-
 net/ipv6/ip6_tunnel.c                          |  2 +-
 net/ipv6/route.c                               |  5 +-
 net/l2tp/l2tp_ppp.c                            |  4 +-
 net/mac80211/main.c                            |  2 +
 net/mac80211/offchannel.c                      |  1 +
 net/sctp/auth.c                                | 17 ++---
 net/sctp/endpointola.c                         |  3 +-
 net/sctp/protocol.c                            |  7 +-
 net/sctp/sm_make_chunk.c                       | 32 +++++----
 net/sctp/sm_statefuns.c                        |  6 +-
 net/sctp/socket.c                              | 96 ++++++++++++++++++--------
 net/sctp/sysctl.c                              | 38 +++++++++-
 sound/pci/hda/patch_realtek.c                  |  2 +
 sound/usb/card.h                               |  1 +
 sound/usb/endpoint.c                           | 15 +++-
 116 files changed, 1138 insertions(+), 369 deletions(-)

Aaron Sanders (1):
      USB: pl2303: add ids for Hewlett-Packard HP POS pole displays

Alan Stern (1):
      USB: fix crash during hotplug of PCI USB controller card

Alec Berg (1):
      iio: querying buffer scan_mask should return 0/1

Aleksander Morgado (2):
      net: qmi_wwan: fix Cinterion PLXX product ID
      net: qmi_wwan: add support for Cinterion PXS8 and PHS8

Alex Deucher (2):
      drm/radeon/si: make sure mc ucode is loaded before checking the size
      drm/radeon: fix ATPX detection on non-VGA GPUs

Alexander Usyskin (1):
      mei: ignore client writing state during cb completion

Bartlomiej Zolnierkiewicz (1):
      pata_at91: fix ata_host_activate() failure handling

Ben Hutchings (1):
      rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init()

Bjørn Mork (18):
      usb: qcserial: add Sierra Wireless EM7355
      usb: qcserial: add Sierra Wireless MC73xx
      usb: qcserial: add Sierra Wireless MC7305/MC7355
      usb: option: add Olivetti Olicard 500
      usb: option: add Alcatel L800MA
      usb: option: add and update a number of CMOTech devices
      net: cdc_mbim: handle unaccelerated VLAN tagged frames
      net: qmi_wwan: fixup Sierra Wireless MC8305 entry
      net: qmi_wwan: add Option GTM681W
      net: qmi_wwan: add TP-LINK MA260
      net: qmi_wwan: add Sierra Wireless EM7355
      net: qmi_wwan: add Sierra Wireless MC73xx
      net: qmi_wwan: add Sierra Wireless MC7305/MC7355
      net: qmi_wwan: add Olivetti Olicard 500
      net: qmi_wwan: add Alcatel L800MA
      net: qmi_wwan: add a number of CMOTech devices
      net: qmi_wwan: add a number of Dell devices
      usb: qcserial: add a number of Dell devices

Chris Mason (1):
      mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll

Christoph Hellwig (1):
      posix_acl: handle NULL ACL in posix_acl_equiv_mode

Clemens Ladisch (1):
      ALSA: usb-audio: work around corrupted TEAC UD-H01 feedback data

Dan Williams (1):
      libata/ahci: accommodate tag ordered controllers

Daniel Borkmann (2):
      net: sctp: wake up all assocs if sndbuf policy is per socket
      net: sctp: test if association is dead in sctp_wake_up_waiters

Daniele Forsi (2):
      usb: storage: shuttle_usbat: fix discs being detected twice
      USB: Nokia 5300 should be treated as unusual dev

Daniele Palmas (1):
      usb: option driver, add support for Telit UE910v2

David Gibson (2):
      rtnetlink: Warn when interface's information won't fit in our packet
      rtnetlink: Only supply IFLA_VF_PORTS information when RTEXT_FILTER_VF is set

Denis Turischev (1):
      xhci: Switch Intel Lynx Point ports to EHCI on shutdown.

Dmitry Petukhov (1):
      l2tp: take PMTU from tunnel UDP socket

Egbert Eich (1):
      drm/i915: Break encoder->crtc link separately in intel_sanitize_crtc()

Enrico Mioso (2):
      qmi_wwan: add ONDA MT689DC device ID (fwd)
      net: qmi_wwan: Olivetti Olicard 200 support

Eric Dumazet (2):
      ipv6: Limit mtu to 65575 bytes
      net-gro: reset skb->truesize in napi_reuse_skb()

Fabio Porcedda (1):
      net: qmi_wwan: add Telit LE920 newer firmware support

Felix Fietkau (1):
      mac80211: exclude AP_VLAN interfaces from tx power calculation

Florian Westphal (4):
      net: core: don't account for udp header size when computing seglen
      net: ipv4: ip_forward: fix inverted local_df test
      netfilter: ipv4: defrag: set local_df flag on defragmented skb
      net: ipv6: send pkttoobig immediately if orig frag size > mtu

Grant Likely (1):
      drivercore: deferral race condition fix

Hans de Goede (5):
      Input: synaptics - add min/max quirk for ThinkPad T431s, L440, L540, S1 Yoga and X1
      xhci: For streams the css flag most be read from the stream-ctx on ep stop
      Input: synaptics - add min/max quirk for ThinkPad Edge E431
      HID: add NO_INIT_REPORTS quirk for Synaptics Touch Pad V 103S
      Input: elantech - fix touchpad initialization on Gigabyte U2442

Helge Deller (1):
      parisc: fix epoll_pwait syscall on compat kernel

Ilia Mirkin (1):
      drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi

Ivan Vecera (1):
      tg3: update rx_jumbo_pending ring param only when jumbo frames are enabled

Jan Kara (1):
      ext4: fix jbd2 warning under heavy xattr load

Jeff Layton (2):
      locks: allow __break_lease to sleep even when break_time is 0
      nfsd: set timeparms.to_maxval in setup_callback_client

Jiri Bohac (1):
      timer: Prevent overflow in apply_slack

Johan Hedberg (1):
      Bluetooth: Fix triggering BR/EDR L2CAP Connect too early

Johan Hovold (4):
      Revert "USB: serial: add usbid for dell wwan card to sierra.c"
      USB: usb_wwan: fix handling of missing bulk endpoints
      USB: serial: fix sysfs-attribute removal deadlock
      USB: io_ti: fix firmware download on big-endian machines

Johannes Berg (1):
      mac80211: fix software remain-on-channel implementation

Julian Anastasov (1):
      ipv4: return valid RTA_IIF on ip route get

Julius Werner (1):
      usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb

Kailang Yang (1):
      ALSA: hda/realtek - Add support of ALC288 codec

Kieran Clancy (2):
      ACPI / EC: Clear stale EC events on Samsung systems
      ACPI / EC: Process rather than discard events in acpi_ec_clear

Kumar Sundararajan (1):
      ipv6: fib: fix fib dump restart

Larry Finger (1):
      staging: r8712u: Fix case where ethtype was never obtained and always be checked against 0

Leon Ma (1):
      hrtimer: Prevent remote enqueue of leftmost timers

Li RongQing (1):
      ipv4: initialise the itag variable in __mkroute_input

Linus Torvalds (1):
      mm: make fixup_user_fault() check the vma access rights too

Liu Hua (1):
      ARM: 8030/1: ARM : kdump : add arch_crash_save_vmcoreinfo

Liu Yu (1):
      tcp_cubic: fix the range of delayed_ack

Martin Schwidefsky (1):
      s390/bpf,jit: initialize A register if 1st insn is BPF_S_LDX_B_MSH

Mathias Krause (1):
      filter: prevent nla extensions to peek beyond the end of the message

Matthew Wilcox (1):
      ext4: note the error in ext4_end_bio()

Mel Gorman (1):
      mm: use paravirt friendly ops for NUMA hinting ptes

Miao Xie (1):
      Btrfs: fix inode caching vs tree log

Michael S. Tsirkin (1):
      skbuff: skb_segment: orphan frags before copying

Michael Ulbricht (1):
      USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM driver

Michele Baldessari (1):
      USB: serial: ftdi_sio: add id for Brainboxes serial cards

Mikulas Patocka (1):
      user namespace: fix incorrect memory barriers

Mizuma, Masayoshi (1):
      mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()

Mohammed Habibulla (1):
      Bluetooth: Add support for Lite-on [04ca:3007]

Nicolas Dichtel (1):
      ip6_gre: don't allow to remove the fb_tunnel_dev

Nikita Yushchenko (1):
      fsl-usb: do not test for PHY_CLK_VALID bit on controller version 1.6

Oleg Nesterov (1):
      list: introduce list_next_entry() and list_prev_entry()

Peter Christensen (1):
      macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.

Quentin Casasnovas (1):
      drm/radeon: memory leak on bo reservation failure. v2

Raymond Wanyoike (1):
      net: qmi_wwan: add ZTE MF667

Sergey Popovich (1):
      ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation

Stanislaw Gruszka (1):
      rt2x00: fix beaconing on USB

Steven Rostedt (Red Hat) (1):
      ftrace/module: Hardcode ftrace_module_init() call into load_module()

Stuart Hayes (1):
      hrtimer: Prevent all reprogramming if hang detected

Susant Sahani (1):
      ip6_tunnel: fix potential NULL pointer dereference

Theodore Ts'o (1):
      ext4: use i_size_read in ext4_unaligned_aio()

Thomas Gleixner (1):
      genirq: Allow forcing cpu affinity of interrupts

Thomas Hellstrom (1):
      drm/vmwgfx: Make sure user-space can't DMA across buffer object boundaries v2

Thomas Richter (1):
      bonding: Remove debug_fs files when module init fails

Tomoki Sekiyama (1):
      drivers/tty/hvc: don't free hvc_console_setup after init

Toshiaki Makita (1):
      bridge: Handle IFLA_ADDRESS correctly when creating bridge device

Tristan Bruns (1):
      USB: cp210x: Add 8281 (Nanotec Plug & Drive)

Tyler Stachecki (1):
      [SCSI] mpt2sas: Don't disable device twice at suspend.

Victor A. Santos (1):
      USB: Nokia 305 should be treated as unusual dev

Vlad Yasevich (2):
      net: sctp: cache auth_enable per endpoint
      Revert "macvlan : fix checksums error when we are in bridge mode"

Vlastimil Babka (1):
      mm/compaction: make isolate_freepages start at pageblock boundary

Wang, Xiaoming (1):
      net: ipv4: current group_info should be put after using.

Xiangyu Lu (1):
      ARM: 8027/1: fix do_div() bug in big-endian systems

Xufeng Zhang (1):
      sctp: reset flowi4_oif parameter on route lookup

dingtianhong (1):
      vlan: Fix lockdep warning when vlan dev handle notification
