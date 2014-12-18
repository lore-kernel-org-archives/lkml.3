Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaLRTb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:31:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59246 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaLRTbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:31:24 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.13.y-ckt stable] Linux 3.13.11-ckt13
Date: Thu, 18 Dec 2014 11:31:18 -0800
Message-Id: <1418931079-18256-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.13.11-ckt13 kernel.

The updated 3.13.y-ckt tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.13.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.13.y;a=shortlog

The diff from v3.13.11-ckt12 is posted as a follow-up to this email.

The 3.13.y-ckt extended stable tree is maintained by the Canonical Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                                           |   2 +-
 arch/arm/include/asm/thread_info.h                 |  11 --
 arch/arm/kernel/traps.c                            |  31 +---
 arch/arm/mm/proc-v7.S                              |   2 -
 arch/arm/mm/proc-xscale.S                          |   4 +-
 arch/mips/loongson/common/Makefile                 |   3 +-
 arch/powerpc/kernel/vdso32/getcpu.S                |   4 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   3 +-
 arch/powerpc/platforms/powernv/pci.c               |   3 +-
 arch/powerpc/platforms/pseries/msi.c               |   2 +-
 arch/powerpc/xmon/xmon.c                           |   6 +-
 arch/sparc/include/asm/atomic_32.h                 |   2 +-
 arch/sparc/include/asm/cmpxchg_32.h                |  12 +-
 arch/sparc/include/asm/vio.h                       |  14 +-
 arch/sparc/include/uapi/asm/swab.h                 |  12 +-
 arch/sparc/kernel/pci_schizo.c                     |   6 +-
 arch/sparc/kernel/smp_64.c                         |   4 +
 arch/sparc/lib/atomic32.c                          |  27 ++++
 arch/x86/kernel/entry_64.S                         |  79 +++------
 arch/x86/kernel/traps.c                            |  53 +++++++
 drivers/ata/ahci.c                                 |   4 +
 drivers/ata/sata_fsl.c                             |   2 +-
 drivers/block/sunvdc.c                             | 176 +++++++++++++++------
 drivers/gpu/drm/i915/intel_display.c               |   2 -
 drivers/gpu/drm/i915/intel_lvds.c                  |  22 +--
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  |   1 -
 drivers/gpu/drm/radeon/dce6_afmt.c                 |   2 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |   2 +-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |   2 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |  10 ++
 drivers/gpu/drm/radeon/radeon_kms.c                |   2 +
 drivers/i2c/busses/i2c-davinci.c                   |   8 +-
 drivers/i2c/busses/i2c-omap.c                      |   2 -
 drivers/input/evdev.c                              |   2 +-
 drivers/input/joystick/xpad.c                      |  16 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   2 +-
 drivers/net/Kconfig                                |   2 +
 drivers/net/ethernet/broadcom/tg3.c                |   3 +-
 drivers/net/ethernet/marvell/mvneta.c              |   5 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   2 +-
 drivers/net/ethernet/smsc/smsc911x.c               |  46 ++++++
 drivers/net/ethernet/sun/sunvnet.c                 |   4 +-
 drivers/net/ieee802154/fakehard.c                  |  13 +-
 drivers/net/macvtap.c                              |   3 +
 drivers/net/ppp/pptp.c                             |   4 +-
 drivers/net/tun.c                                  |   6 +-
 drivers/net/usb/ax88179_178a.c                     |   7 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/vxlan.c                                |  53 ++++---
 drivers/net/xen-netfront.c                         |   5 -
 drivers/pci/msi.c                                  |  26 +++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |   7 +
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/spi/spi-dw.c                               |   6 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   1 +
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/host/xhci-hub.c                        |   5 +-
 drivers/usb/host/xhci-pci.c                        |   2 +-
 drivers/usb/host/xhci-plat.c                       |  10 +-
 drivers/usb/host/xhci-ring.c                       |  43 ++---
 drivers/usb/host/xhci.c                            | 103 ++++++------
 drivers/usb/host/xhci.h                            |   2 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/ftdi_sio.c                      |  33 ++++
 drivers/usb/serial/ftdi_sio_ids.h                  |  39 ++++-
 drivers/usb/serial/keyspan.c                       |  97 +++++++-----
 drivers/usb/serial/ssu100.c                        |  11 +-
 fs/aio.c                                           |  21 ++-
 fs/btrfs/compression.c                             |  33 +++-
 fs/btrfs/compression.h                             |   4 +-
 fs/btrfs/lzo.c                                     |  15 ++
 fs/btrfs/zlib.c                                    |  20 ++-
 fs/nfsd/nfs4callback.c                             |   8 +-
 fs/nfsd/nfsd.h                                     |   9 +-
 include/linux/iio/events.h                         |   2 +-
 include/linux/inetdevice.h                         |   2 +-
 include/linux/pci.h                                |   1 +
 include/net/ipv6.h                                 |   2 +
 mm/frontswap.c                                     |   4 +-
 mm/memory.c                                        |  26 +--
 mm/mmap.c                                          |  10 +-
 mm/rmap.c                                          |   6 +-
 mm/slab.c                                          |   2 +-
 mm/truncate.c                                      |   1 -
 mm/vmpressure.c                                    |   8 +-
 net/core/rtnetlink.c                               |   1 +
 net/ipv4/fib_rules.c                               |   4 +
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv4/ip_output.c                               |  12 +-
 net/ipv4/ip_tunnel_core.c                          |   3 +-
 net/ipv4/ip_vti.c                                  |   1 +
 net/ipv4/ping.c                                    |   2 +
 net/ipv4/tcp.c                                     |  59 +++----
 net/ipv6/ip6_gre.c                                 |   9 +-
 net/ipv6/ip6_tunnel.c                              |  10 +-
 net/ipv6/ip6_vti.c                                 |  22 +--
 net/ipv6/output_core.c                             |  33 ++++
 net/ipv6/sit.c                                     |  15 +-
 net/ipx/af_ipx.c                                   |   6 +-
 net/sctp/auth.c                                    |   2 -
 net/sctp/output.c                                  |   4 +-
 net/sunrpc/svcsock.c                               |  27 ++--
 sound/pci/hda/hda_intel.c                          |  25 ++-
 103 files changed, 951 insertions(+), 539 deletions(-)

Aaro Koskinen (1):
      MIPS: Loongson: Make platform serial setup always built-in.

Alex Deucher (1):
      drm/radeon: initialize sadb to NULL in the audio code

Alexander Kochetkov (1):
      i2c: omap: fix NACK and Arbitration Lost irq handling

Alexey Khoroshilov (1):
      ieee802154: fix error handling in ieee802154fake_probe()

Allen Pais (2):
      sunvdc: add cdrom and v1.1 protocol support
      sunvdc: compute vdisk geometry from capacity

Andreas Larsson (1):
      sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks

Andrew Morton (2):
      mm/vmpressure.c: fix race in vmpressure_work_fn()
      drivers/input/evdev.c: don't kfree() a vmalloc address

Andy Lutomirski (2):
      x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
      x86_64, traps: Rework bad_iret

Anton Blanchard (1):
      powerpc: 32 bit getcpu VDSO function uses 64 bit instructions

Ben Hutchings (2):
      drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets
      drivers/net: macvtap and tun depend on INET

Benjamin Herrenschmidt (5):
      PCI/MSI: Add device flag indicating that 64-bit MSIs don't work
      gpu/radeon: Set flag to indicate broken 64-bit MSI
      sound/radeon: Move 64-bit MSI quirk from arch to driver
      powerpc/powernv: Honor the generic "no_64bit_msi" flag
      powerpc/pseries: Honor the generic "no_64bit_msi" flag

Chris Mason (1):
      btrfs: zero out left over bytes after processing compression streams

Christian Sünkenberg (1):
      scsi: add Intel Multi-Flex to scsi scan blacklist

Christoph Hellwig (1):
      nfsd: correctly define v4.2 support attributes

Cristina Ciocan (1):
      iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask

Daniel Borkmann (2):
      net: sctp: fix memory leak in auth key management
      net: sctp: use MAX_HEADER for headroom reserve in output path

Daniel Forrest (1):
      mm: fix anon_vma_clone() error treatment

Daniel Vetter (2):
      drm/i915: More cautious with pch fifo underruns
      drm/i915: Unlock panel even when LVDS is disabled

David S. Miller (3):
      sparc64: Fix crashes in schizo_pcierr_intr_other().
      sparc64: Do irq_{enter,exit}() around generic_smp_call_function*().
      sparc64: Fix constraints on swab helpers.

Devin Ryles (1):
      AHCI: Add DeviceIDs for Sunrise Point-LP SATA controller

Dmitry Eremin-Solenikov (1):
      ARM: 8216/1: xscale: correct auxiliary register in suspend/resume

Dmitry Torokhov (1):
      sata_fsl: fix error handling of irq_of_parse_and_map

Dwight Engen (3):
      sunvdc: limit each sg segment to a page
      vio: fix reuse of vio_dring slot
      sunvdc: don't call VD_OP_GET_VTOC

Enric Balletbo i Serra (1):
      smsc911x: power-up phydev before doing a software reset.

Eric Dumazet (2):
      tcp: md5: do not use alloc_percpu()
      net: mvneta: fix race condition in mvneta_tx()

Greg Kroah-Hartman (1):
      Input: xpad - use proper endpoint type

Grygorii Strashko (1):
      i2c: davinci: generate STP always when NACK is received

Gu Zheng (1):
      aio: fix uncorrent dirty pages accouting when truncating AIO ring buffer

Hans de Goede (1):
      usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000

Hugh Dickins (1):
      mm: fix swapoff hang after page migration and fork

Ian Morgan (1):
      ax88179_178a: fix bonding failure

Ilia Mirkin (1):
      drm/nouveau/gf116: remove copy1 engine

Jack Morgenstein (1):
      net/mlx4_core: Limit count field to 24 bits in qp_alloc_res

Jan Kara (1):
      mm: Remove false WARN_ON from pagecache_isize_extended()

Jane Zhou (1):
      net/ping: handle protocol mismatching scenario

Jiri Bohac (1):
      ipx: fix locking regression in ipx_sendmsg and ipx_recvmsg

Jiri Pirko (1):
      ipv4: fix nexthop attlen check in fib_nh_match

Johan Hovold (3):
      USB: keyspan: fix tty line-status reporting
      USB: keyspan: fix overrun-error reporting
      USB: ssu100: fix overrun-error reporting

Kamal Mostafa (1):
      Linux 3.13.11-ckt13

Larry Finger (1):
      staging: r8188eu: Add new device ID for DLink GO-USB-N150

Laurent Dufour (1):
      powerpc/pseries: Fix endiannes issue in RTAS call from xmon

Li RongQing (4):
      vxlan: fix a use after free in vxlan_encap_bypass
      vxlan: using pskb_may_pull as early as possible
      vxlan: fix a free after use
      ipv4: fix a potential use after free in ip_tunnel_core.c

Lu Baolu (2):
      Revert "xhci: clear root port wake on bits if controller isn't wake-up capable"
      usb: xhci: rework root port wake bits if controller isn't allowed to wakeup

Marcelo Leitner (2):
      vxlan: Do not reuse sockets for a different address family
      Fix race condition between vxlan_sock_add and vxlan_sock_release

Martin Hauke (1):
      qmi_wwan: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem

Mathias Krause (1):
      pptp: fix stack info leak in pptp_getname()

Mathias Nyman (2):
      USB: xhci: don't start a halted endpoint before its new dequeue is set
      USB: xhci: Reset a halted endpoint immediately when we encounter a stall.

Maurizio Lombardi (1):
      bnx2fc: do not add shared skbs to the fcoe_rx_list

Nicolas Dichtel (1):
      rtnetlink: release net refcnt on error in do_setlink()

Panu Matilainen (1):
      ipv4: Fix incorrect error code when adding an unreachable route

Paul Mackerras (1):
      slab: fix nodeid bounds check for non-contiguous node IDs

Petr Mladek (1):
      drm/radeon: kernel panic in drm_calc_vbltimestamp_from_scanoutpos with 3.18.0-rc6

Preston Fick (1):
      USB: serial: cp210x: add IDs for CEL MeshConnect USB Stick

Sakari Ailus (1):
      [media] smiapp: Only some selection targets are settable

Seth Forshee (1):
      xen-netfront: Remove BUGs on paged skb data which crosses a page boundary

Steffen Klassert (4):
      ip6_tunnel: Use ip6_tnl_dev_init as the ndo_init function.
      vti6: Use vti6_dev_init as the ndo_init function.
      sit: Use ipip6_tunnel_init as the ndo_init function.
      gre6: Move the setting of dev->iflink into the ndo_init functions.

Takashi Iwai (1):
      ALSA: hda - Limit 40bit DMA for AMD HDMI controllers

Tejun Heo (1):
      ahci: disable MSI on SAMSUNG 0xa800 SSD

Thadeu Lima de Souza Cascardo (1):
      tg3: fix ring init when there are more TX than RX channels

Thomas Petazzoni (1):
      ARM: 8222/1: mvebu: enable strex backoff delay

Thor Thayer (1):
      spi: dw: Fix dynamic speed change.

Trond Myklebust (2):
      SUNRPC: Fix locking around callback channel reply receive
      nfsd: Fix slot wake up race in the nfsv4.1 callback code

Troy Clark (1):
      usb: serial: ftdi_sio: add PIDs for Matrix Orbital products

Vasily Averin (1):
      ipv4: dst_entry leak in ip_send_unicast_reply()

Vincent BENAYOUN (1):
      inetdevice: fixed signed integer overflow

Vladimir Murzin (1):
      ARM: 8226/1: cacheflush: get rid of restarting block

Weijie Yang (1):
      mm: frontswap: invalidate expired data on a dup-store failure

Yuri Chislov (1):
      ipv6: gre: fix wrong skb->protocol in WCCP

lucien (1):
      ip_tunnel: the lack of vti_link_ops' dellink() cause kernel panic

willy tarreau (1):
      net: mvneta: fix Tx interrupt delay

