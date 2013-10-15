Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab3JOLAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:00:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54314 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758564Ab3JOLAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:00:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.5.y.z extended stable] Linux 3.5.7.23
Date: Tue, 15 Oct 2013 12:00:35 +0100
Message-Id: <1381834836-18835-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.5.7.23 kernel.

The updated 3.5.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.5.y;a=shortlog

The diff from v3.5.7.22 is posted as a follow-up to this email.

The 3.5.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Makefile                                    |  2 +-
 arch/powerpc/kernel/iommu.c                 |  2 +-
 arch/powerpc/kernel/sysfs.c                 | 18 +++++++-
 arch/powerpc/kernel/vio.c                   | 12 +++--
 arch/powerpc/lib/checksum_64.S              |  4 +-
 arch/sparc/kernel/entry.S                   |  2 +-
 arch/sparc/kernel/ktlb.S                    |  3 +-
 arch/sparc/kernel/syscalls.S                |  8 ++--
 arch/sparc/kernel/trampoline_64.S           |  2 -
 arch/sparc/lib/ksyms.c                      |  9 ----
 arch/x86/kernel/reboot.c                    | 16 +++++++
 arch/x86/platform/efi/efi.c                 | 11 +++--
 block/cfq-iosched.c                         |  2 +-
 drivers/block/cciss.c                       |  1 +
 drivers/block/cpqarray.c                    |  1 +
 drivers/bluetooth/ath3k.c                   |  2 +
 drivers/bluetooth/btusb.c                   |  2 +
 drivers/dma/at_hdmac.c                      |  8 ++--
 drivers/dma/ep93xx_dma.c                    |  2 +-
 drivers/dma/fsldma.c                        |  2 +-
 drivers/dma/imx-dma.c                       | 35 +++++++-------
 drivers/dma/intel_mid_dma_regs.h            |  6 +--
 drivers/dma/pl330.c                         |  2 +-
 drivers/dma/ppc4xx/adma.c                   |  2 +-
 drivers/dma/ste_dma40_ll.h                  |  2 +-
 drivers/gpu/drm/ast/ast_drv.h               |  2 +-
 drivers/gpu/drm/i915/intel_dp.c             | 13 +++++-
 drivers/gpu/drm/radeon/atombios_encoders.c  |  8 +++-
 drivers/gpu/drm/radeon/radeon_connectors.c  | 34 ++++++++++++--
 drivers/gpu/drm/radeon/radeon_device.c      | 15 ++++--
 drivers/gpu/drm/ttm/ttm_tt.c                |  2 +-
 drivers/hid/hid-core.c                      | 72 +++++++++++++++++++++++++++--
 drivers/hid/hid-ids.h                       |  1 +
 drivers/hid/hid-input.c                     | 11 ++++-
 drivers/hid/hid-lg2ff.c                     | 19 ++------
 drivers/hid/hid-lg3ff.c                     | 29 +++---------
 drivers/hid/hid-lg4ff.c                     | 20 +-------
 drivers/hid/hid-lgff.c                      | 17 +------
 drivers/hid/hid-logitech-dj.c               | 10 +++-
 drivers/hid/hid-multitouch.c                | 26 ++++++-----
 drivers/hid/hid-speedlink.c                 | 11 +++--
 drivers/hid/hid-zpff.c                      | 18 ++------
 drivers/hid/usbhid/hid-quirks.c             |  2 +
 drivers/hwmon/applesmc.c                    | 11 ++++-
 drivers/infiniband/ulp/srpt/ib_srpt.c       | 14 +++---
 drivers/md/dm-snap-persistent.c             |  2 +-
 drivers/md/dm-snap.c                        |  5 +-
 drivers/net/bonding/bond_main.c             | 13 ++++--
 drivers/net/ethernet/broadcom/tg3.c         | 19 +++++++-
 drivers/net/ethernet/freescale/gianfar.c    | 11 ++++-
 drivers/net/ethernet/freescale/gianfar.h    | 11 ++++-
 drivers/net/ethernet/sfc/rx.c               |  3 +-
 drivers/net/ethernet/via/via-rhine.c        |  9 +++-
 drivers/net/ethernet/xilinx/ll_temac_main.c |  6 +++
 drivers/net/ppp/pptp.c                      |  2 +-
 drivers/net/usb/cdc_ether.c                 |  5 ++
 drivers/net/usb/dm9601.c                    |  2 +-
 drivers/net/wireless/mwifiex/11n_aggr.c     |  3 +-
 drivers/net/wireless/mwifiex/11n_aggr.h     |  2 +-
 drivers/net/wireless/mwifiex/main.c         |  5 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c    | 18 ++++----
 drivers/net/wireless/mwifiex/usb.c          |  7 ---
 drivers/net/wireless/mwifiex/wmm.c          |  3 +-
 drivers/net/wireless/p54/p54usb.c           |  1 +
 drivers/net/wireless/rtlwifi/wifi.h         |  2 +-
 drivers/scsi/esp_scsi.c                     | 14 +++---
 drivers/scsi/esp_scsi.h                     |  1 +
 drivers/staging/comedi/drivers/ni_65xx.c    | 26 +++++------
 drivers/staging/vt6656/main_usb.c           |  3 +-
 drivers/tty/serial/pch_uart.c               |  5 +-
 drivers/usb/core/devio.c                    | 16 +++++++
 drivers/usb/dwc3/dwc3-pci.c                 |  2 +
 drivers/usb/gadget/dummy_hcd.c              |  7 +--
 drivers/usb/gadget/f_fs.c                   | 60 +++++++++++-------------
 drivers/usb/host/ehci-pci.c                 |  2 +-
 drivers/usb/host/uhci-pci.c                 |  2 +-
 drivers/usb/host/xhci-hub.c                 |  2 +-
 drivers/usb/host/xhci-pci.c                 |  2 +-
 drivers/usb/host/xhci-ring.c                | 24 +++++++++-
 drivers/usb/host/xhci.c                     | 25 ++--------
 drivers/usb/host/xhci.h                     |  1 +
 drivers/usb/serial/option.c                 |  3 ++
 drivers/video/mxsfb.c                       |  1 +
 fs/ext4/namei.c                             |  3 +-
 fs/isofs/inode.c                            | 16 ++-----
 fs/notify/fanotify/fanotify.c               |  6 +++
 include/linux/hid.h                         |  5 ++
 include/linux/perf_event.h                  |  2 +-
 include/net/ip.h                            | 12 +++--
 include/net/ipip.h                          |  2 +-
 kernel/cgroup.c                             | 11 +++++
 kernel/events/core.c                        | 21 +++++----
 kernel/sched/fair.c                         | 14 ++++--
 kernel/workqueue.c                          |  9 ++++
 mm/oom_kill.c                               |  8 ++--
 net/bluetooth/hci_event.c                   |  6 ++-
 net/bridge/br_private.h                     |  1 +
 net/bridge/br_stp.c                         | 23 ++++++---
 net/bridge/br_stp_if.c                      | 12 ++++-
 net/caif/cfctrl.c                           |  3 +-
 net/core/flow_dissector.c                   |  4 +-
 net/core/netpoll.c                          |  9 ++--
 net/ipv4/igmp.c                             |  8 ++--
 net/ipv4/inetpeer.c                         |  4 +-
 net/ipv4/ip_output.c                        |  8 ++--
 net/ipv4/ipmr.c                             |  2 +-
 net/ipv4/raw.c                              |  2 +-
 net/ipv4/xfrm4_mode_tunnel.c                |  2 +-
 net/ipv6/ip6_output.c                       | 53 +++++++++------------
 net/ipv6/mcast.c                            |  4 +-
 net/netfilter/ipvs/ip_vs_xmit.c             |  2 +-
 net/sctp/ipv6.c                             | 42 ++++++-----------
 net/sctp/sm_sideeffect.c                    |  3 +-
 net/sctp/socket.c                           |  3 ++
 security/smack/smackfs.c                    |  2 +-
 sound/core/compress_offload.c               |  3 +-
 sound/soc/codecs/88pm860x-codec.c           |  3 ++
 sound/soc/codecs/max98095.c                 |  4 +-
 tools/perf/util/map.c                       |  1 +
 119 files changed, 675 insertions(+), 454 deletions(-)

Al Viro (1):
      USB: Fix breakage in ffs_fs_mount()

Alan Stern (2):
      usb: gadget: fix a bug and a WARN_ON in dummy-hcd
      USB: fix PM config symbol in uhci-hcd, ehci-hcd, and xhci-hcd

Alex Deucher (3):
      drm/radeon/atom: workaround vbios bug in transmitter table on rs880 (v2)
      drm/radeon: fix panel scaling with eDP and LVDS bridges
      drm/radeon: disable tests/benchmarks if accel is disabled

Amitkumar Karwar (1):
      mwifiex: fix hang issue for USB chipsets

Anatol Pomozov (1):
      cfq: explicitly use 64bit divide operation for 64bit arguments

Andi Kleen (1):
      perf tools: Handle JITed code in shared memory

Andre Guedes (2):
      Bluetooth: Fix security level for peripheral role
      Bluetooth: Fix encryption key size for peripheral role

Ansis Atteka (2):
      ip: use ip_hdr() in __ip_make_skb() to retrieve IP header
      ip: generate unique IP identificator if local fragmentation is allowed

Ben Hutchings (1):
      sfc: Fix efx_rx_buf_offset() for recycled pages

Ben Skeggs (1):
      drm/ttm: fix the tt_populated check in ttm_tt_destroy()

Benjamin Tissoires (3):
      HID: add usage_index in struct hid_usage.
      HID: validate feature and input report details
      HID: multitouch: validate indexes details

Bing Zhao (1):
      mwifiex: fix NULL pointer dereference in usb suspend handler

Chris Healy (1):
      resubmit bridge: fix message_age_timer calculation

Christian Lamparter (1):
      p54usb: add USB ID for Corega WLUSB2GTST USB adapter

Claudiu Manoil (1):
      gianfar: Change default HW Tx queue scheduling mode

Daisuke Nishimura (1):
      sched/fair: Fix small race where child->se.parent,cfs_rq might point to invalid ones

Dan Carpenter (4):
      cciss: fix info leak in cciss_ioctl32_passthru()
      cpqarray: fix info leak in ida_locked_ioctl()
      ASoC: max98095: a couple array underflows
      ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()

Daniel Borkmann (2):
      net: sctp: fix smatch warning in sctp_send_asconf_del_ip
      net: sctp: fix ipv6 ipsec encryption bug in sctp_v6_xmit

Daniel Drake (1):
      mwifiex: fix memory corruption when unsetting multicast list

Dave Airlie (1):
      drm/ast: fix the ast open key function

Dave Jones (1):
      caif: Add missing braces to multiline if in cfctrl_linkup_request

David Rientjes (1):
      mm, memcg: give exiting processes access to memory reserves

David S. Miller (2):
      esp_scsi: Fix tag state corruption when autosensing.
      sparc64: Fix off by one in trampoline TLB mapping installation loop.

Eric Dumazet (1):
      net: flow_dissector: fix thoff for IPPROTO_AH

Fabio Porcedda (1):
      net: usb: cdc_ether: Use wwan interface for Telit modules

Florian Wolter (1):
      xhci: Fix race between ep halt and URB cancellation

Hannes Frederic Sowa (1):
      ipv6: udp packets following an UFO enqueued packet need also be handled by UFO

Heikki Krogerus (1):
      usb: dwc3: pci: add support for BayTrail

Henrik Rydberg (1):
      hwmon: (applesmc) Check key count before proceeding

Herbert Xu (1):
      bridge: Clamp forward_delay when enabling STP

Ian Abbott (1):
      staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevice

Jack Wang (1):
      ib_srpt: always set response for task management

Jan Kara (1):
      isofs: Refuse RW mount of the filesystem instead of making it RO

Jani Nikula (1):
      drm/i915/dp: increase i2c-over-aux retry interval on AUX DEFER

Johan Hovold (2):
      serial: pch_uart: fix tty-kref leak in rx-error path
      serial: pch_uart: fix tty-kref leak in dma-rx path

Josh Boyer (1):
      x86, efi: Don't map Boot Services on i386

Kees Cook (4):
      HID: provide a helper for validating hid reports
      HID: zeroplus: validate output report details
      HID: LG: validate HID output report details
      HID: logitech-dj: validate output report details

Kirill Tkhai (4):
      sparc32: Fix exit flag passed from traced sys_sigreturn
      sparc64: Fix not SRA'ed %o5 in 32-bit traced syscall
      sparc64: Fix ITLB handler of null page
      sparc64: Remove RWSEM export leftovers

Kurt Garloff (1):
      usb/core/devio.c: Don't reject control message to endpoint with wrong direction bit

Larry Finger (1):
      rtlwifi: Align private space in rtl_priv struct

Li Zefan (1):
      cgroup: fail if monitored file and event_control are in different cgroup

Liam Girdwood (1):
      ALSA: compress: Fix compress device unregister.

Lino Sanfilippo (1):
      fanotify: dont merge permission events

Luis Henriques (2):
      Revert "sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()"
      Linux 3.5.7.23

Madhavan Srinivasan (1):
      powerpc/sysfs: Disable writing to PURR in guest mode

Malcolm Priestley (1):
      staging: vt6656: [BUG] main_usb.c oops on device_close move flag earlier.

Marek Vasut (1):
      video: mxsfb: Add missing break

Masanari Iida (1):
      dma: fix comments

Masoud Sharbiani (1):
      x86/reboot: Add quirk to make Dell C6100 use reboot=pci automatically

Mathias Nyman (2):
      xhci: Fix oops happening after address device timeout
      xhci: Ensure a command structure points to the correct trb on the command ring

Michael Grzeschik (3):
      dmaengine: imx-dma: fix slow path issue in prep_dma_cyclic
      dmaengine: imx-dma: fix lockdep issue between irqhandler and tasklet
      dmaengine: imx-dma: fix callback path in tasklet

Michal Malý (1):
      USB: serial: option: Ignore card reader interface on Huawei E1750

Mikulas Patocka (2):
      dm snapshot: workaround for a false positive lockdep warning
      dm-snapshot: fix performance degradation due to small hash size

Neil Horman (1):
      bonding: Fix broken promiscuity reference counting issue

Nicholas Bellinger (1):
      ib_srpt: Destroy cm_id before destroying QP.

Nikolay Aleksandrov (1):
      netpoll: fix NULL pointer dereference in netpoll_cleanup

Nishanth Aravamudan (1):
      powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_table()

Nithin Sujir (2):
      tg3: Don't turn off led on 5719 serdes port 0
      tg3: Expand led off fix to include 5720

Passion,Zhao (1):
      Smack: Fix the bug smackcipso can't set CIPSO correctly

Paul E. McKenney (1):
      powerpc: Fix parameter clobber in csum_partial_copy_generic()

Peng Chen (1):
      Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012.

Peter Korsgaard (1):
      dm9601: fix IFF_ALLMULTI handling

Peter Zijlstra (2):
      perf: Clarify perf_cpu_context::active_pmu usage by renaming it to ::unique_pmu
      perf: Fix perf_cgroup_switch for sw-events

Prarit Bhargava (1):
      powerpc/vio: Fix modalias_show return values

Raphael Kubo da Costa (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17cb]

Ricardo Ribalda (1):
      ll_temac: Reset dma descriptors indexes on ndo_open

Roger Luethi (1):
      via-rhine: fix VLAN priority field (PCP, IEEE 802.1p)

Salam Noureddine (2):
      ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put
      ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put

Stefan Kriwanek (1):
      HID: Fix Speedlink VAD Cezanne support for some devices

Tejun Heo (1):
      workqueue: cond_resched() after processing each work item

Theodore Ts'o (1):
      ext4: avoid hang when mounting non-journal filesystems with orphan list

Vasily Titskiy (1):
      HID: usbhid: quirk for N-Trig DuoSense Touch Screen

