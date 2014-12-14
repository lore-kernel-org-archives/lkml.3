Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaLNUcW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:32:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaLNUWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:22:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.17 00/47] 3.17.7-stable review
Date: Sun, 14 Dec 2014 12:20:35 -0800
Message-Id: <20141214201818.552715149@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.17.7 release.
There are 47 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Dec 16 20:18:09 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.17.7-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.17.7-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't resubmit pending URBs at MIDI error recovery

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix built-in mic at resume on Lenovo Ideapad S210

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add EAPD fixup for ASUS Z99He laptop

Christian König <christian.koenig@amd.com>
    drm/radeon: sync all BOs involved in a CS v2

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert: ACPI / EC: Add support to disallow QR_EC to be issued before completing previous QR_EC

Daniel Borkmann <dborkman@redhat.com>
    netlink: use jhash as hashfn for rhashtable

David Vrabel <david.vrabel@citrix.com>
    xen-netfront: use correct linear area after linearizing an skb

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: use MAX_HEADER for headroom reserve in output path

Eric Dumazet <edumazet@google.com>
    net: mvneta: fix race condition in mvneta_tx()

willy tarreau <w@1wt.eu>
    net: mvneta: fix Tx interrupt delay

Denis Kirjanov <kda@linux-powerpc.org>
    mips: bpf: Fix broken BPF_MOD

Tom Herbert <therbert@google.com>
    gre: Set inner mac header in gro complete

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    rtnetlink: release net refcnt on error in do_setlink()

Thomas Graf <tgraf@suug.ch>
    bond: Check length of IFLA_BOND_ARP_IP_TARGET attributes

Willem de Bruijn <willemb@google.com>
    net-timestamp: make tcp_recvmsg call ipv6_recv_error for AF_INET6 socks

Jack Morgenstein <jackm@dev.mellanox.co.il>
    net/mlx4_core: Limit count field to 24 bits in qp_alloc_res

Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
    tg3: fix ring init when there are more TX than RX channels

Marcelo Leitner <mleitner@redhat.com>
    Fix race condition between vxlan_sock_add and vxlan_sock_release

Alexander Duyck <alexander.h.duyck@redhat.com>
    vxlan: Fix boolean flip in VXLAN_F_UDP_ZERO_CSUM6_[TX|RX]

Yuri Chislov <yuri.chislov@gmail.com>
    ipv6: gre: fix wrong skb->protocol in WCCP

lucien <lucien.xin@gmail.com>
    ip_tunnel: the lack of vti_link_ops' dellink() cause kernel panic

Dmitry Torokhov <dtor@chromium.org>
    sata_fsl: fix error handling of irq_of_parse_and_map

Tejun Heo <tj@kernel.org>
    ahci: disable MSI on SAMSUNG 0xa800 SSD

Devin Ryles <devin.ryles@intel.com>
    AHCI: Add DeviceIDs for Sunrise Point-LP SATA controller

Sakari Ailus <sakari.ailus@iki.fi>
    media: smiapp: Only some selection targets are settable

sensoray-dev <linux-dev@sensoray.com>
    media: s2255drv: fix payload size for JPG, MJPEG

David Härdeman <david@hardeman.nu>
    media: rc-core: fix toggle handling in the rc6 decoder

Chris Clayton <chris2553@googlemail.com>
    x86: Use $(OBJDUMP) instead of plain objdump

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Unlock panel even when LVDS is disabled

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: More cautious with pch fifo underruns

Ian Campbell <ian.campbell@citrix.com>
    of/fdt: memblock_reserve /memreserve/ regions in the case of partial overlap

Petr Mladek <pmladek@suse.cz>
    drm/radeon: kernel panic in drm_calc_vbltimestamp_from_scanoutpos with 3.18.0-rc6

Michel Dänzer <michel.daenzer@amd.com>
    drm/radeon: Ignore RADEON_GEM_GTT_WC on 32-bit x86

Vishnu Motghare <vishnum@xilinx.com>
    i2c: cadence: Set the hardware time-out register to maximum value

Grygorii Strashko <grygorii.strashko@ti.com>
    i2c: davinci: generate STP always when NACK is received

Alexander Kochetkov <al.kochet@gmail.com>
    i2c: omap: fix i207 errata handling

Alexander Kochetkov <al.kochet@gmail.com>
    i2c: omap: fix NACK and Arbitration Lost irq handling

Dave Airlie <airlied@redhat.com>
    nouveau: move the hotplug ignore to correct place.

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau/gf116: remove copy1 engine

Seth Forshee <seth.forshee@canonical.com>
    xen-netfront: Remove BUGs on paged skb data which crosses a page boundary

Paul Mackerras <paulus@samba.org>
    slab: fix nodeid bounds check for non-contiguous node IDs

Daniel Forrest <dan.forrest@ssec.wisc.edu>
    mm: fix anon_vma_clone() error treatment

Hugh Dickins <hughd@google.com>
    mm: fix swapoff hang after page migration and fork

Al Viro <viro@zeniv.linux.org.uk>
    fat: fix oops on corrupted vfat fs

Andrew Morton <akpm@linux-foundation.org>
    drivers/input/evdev.c: don't kfree() a vmalloc address

Andrew Morton <akpm@linux-foundation.org>
    mm/vmpressure.c: fix race in vmpressure_work_fn()

Weijie Yang <weijie.yang@samsung.com>
    mm: frontswap: invalidate expired data on a dup-store failure


-------------

Diffstat:

 Makefile                                           |  4 ++--
 arch/mips/net/bpf_jit.c                            |  4 ++--
 arch/x86/boot/compressed/Makefile                  |  2 +-
 drivers/acpi/ec.c                                  |  4 ++--
 drivers/ata/ahci.c                                 |  4 ++++
 drivers/ata/sata_fsl.c                             |  2 +-
 drivers/gpu/drm/i915/intel_display.c               |  2 --
 drivers/gpu/drm/i915/intel_lvds.c                  | 22 +++++++++---------
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  |  1 -
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  2 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |  9 +++-----
 drivers/gpu/drm/radeon/radeon_kms.c                |  2 ++
 drivers/gpu/drm/radeon/radeon_object.c             |  7 ++++++
 drivers/i2c/busses/i2c-cadence.c                   | 11 +++++++++
 drivers/i2c/busses/i2c-davinci.c                   |  8 +++----
 drivers/i2c/busses/i2c-omap.c                      | 10 ++++-----
 drivers/input/evdev.c                              |  2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  2 +-
 drivers/media/rc/ir-rc6-decoder.c                  |  2 +-
 drivers/media/usb/s2255/s2255drv.c                 |  2 +-
 drivers/net/bonding/bond_netlink.c                 |  7 +++++-
 drivers/net/ethernet/broadcom/tg3.c                |  3 ++-
 drivers/net/ethernet/marvell/mvneta.c              |  5 +++--
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  2 +-
 drivers/net/vxlan.c                                | 14 +++++-------
 drivers/net/xen-netfront.c                         |  8 +++----
 drivers/of/fdt.c                                   |  2 --
 fs/fat/namei_vfat.c                                | 20 +++++++++--------
 include/net/inet_common.h                          |  2 ++
 mm/frontswap.c                                     |  4 +++-
 mm/memory.c                                        | 26 +++++++++++-----------
 mm/mmap.c                                          | 10 ++++++---
 mm/rmap.c                                          |  6 +++--
 mm/slab.c                                          |  2 +-
 mm/vmpressure.c                                    |  8 ++++---
 net/core/rtnetlink.c                               |  1 +
 net/ipv4/af_inet.c                                 | 11 +++++++++
 net/ipv4/gre_offload.c                             |  3 +++
 net/ipv4/ip_vti.c                                  |  1 +
 net/ipv4/ping.c                                    | 12 ++--------
 net/ipv4/tcp.c                                     |  2 +-
 net/ipv6/ip6_gre.c                                 |  4 ++--
 net/ipv6/ip6_vti.c                                 | 11 +++++++++
 net/netlink/af_netlink.c                           |  2 +-
 net/sctp/output.c                                  |  4 ++--
 sound/pci/hda/patch_analog.c                       |  1 +
 sound/pci/hda/patch_realtek.c                      |  1 +
 sound/usb/midi.c                                   |  2 ++
 48 files changed, 164 insertions(+), 112 deletions(-)


