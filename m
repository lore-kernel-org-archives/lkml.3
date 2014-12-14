Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbaLNUeF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:34:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaLNUWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:22:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 00/34] 3.14.27-stable review
Date: Sun, 14 Dec 2014 12:20:38 -0800
Message-Id: <20141214201803.791392744@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.27 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Dec 16 20:17:55 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.27-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.27-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't resubmit pending URBs at MIDI error recovery

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix built-in mic at resume on Lenovo Ideapad S210

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add EAPD fixup for ASUS Z99He laptop

Ronald Wahl <ronald.wahl@raritan.com>
    mac80211: Fix regression that triggers a kernel BUG with CCMP

Anton Blanchard <anton@samba.org>
    powerpc: 32 bit getcpu VDSO function uses 64 bit instructions

Todd Fujinaka <todd.fujinaka@intel.com>
    igb: bring link up when PHY is powered up

Kan Liang <kan.liang@intel.com>
    perf/x86/intel: Protect LBR and extra_regs against KVM lying

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: use MAX_HEADER for headroom reserve in output path

Eric Dumazet <edumazet@google.com>
    net: mvneta: fix race condition in mvneta_tx()

willy tarreau <w@1wt.eu>
    net: mvneta: fix Tx interrupt delay

Tom Herbert <therbert@google.com>
    gre: Set inner mac header in gro complete

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    rtnetlink: release net refcnt on error in do_setlink()

Jack Morgenstein <jackm@dev.mellanox.co.il>
    net/mlx4_core: Limit count field to 24 bits in qp_alloc_res

Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
    tg3: fix ring init when there are more TX than RX channels

Marcelo Leitner <mleitner@redhat.com>
    Fix race condition between vxlan_sock_add and vxlan_sock_release

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

Mathias Nyman <mathias.nyman@linux.intel.com>
    USB: xhci: Reset a halted endpoint immediately when we encounter a stall.

Sakari Ailus <sakari.ailus@iki.fi>
    media: smiapp: Only some selection targets are settable

Chris Clayton <chris2553@googlemail.com>
    x86: Use $(OBJDUMP) instead of plain objdump

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Unlock panel even when LVDS is disabled

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: More cautious with pch fifo underruns

Petr Mladek <pmladek@suse.cz>
    drm/radeon: kernel panic in drm_calc_vbltimestamp_from_scanoutpos with 3.18.0-rc6

Grygorii Strashko <grygorii.strashko@ti.com>
    i2c: davinci: generate STP always when NACK is received

Alexander Kochetkov <al.kochet@gmail.com>
    i2c: omap: fix i207 errata handling

Alexander Kochetkov <al.kochet@gmail.com>
    i2c: omap: fix NACK and Arbitration Lost irq handling

Seth Forshee <seth.forshee@canonical.com>
    xen-netfront: Remove BUGs on paged skb data which crosses a page boundary

Daniel Forrest <dan.forrest@ssec.wisc.edu>
    mm: fix anon_vma_clone() error treatment

Hugh Dickins <hughd@google.com>
    mm: fix swapoff hang after page migration and fork

Andrew Morton <akpm@linux-foundation.org>
    mm/vmpressure.c: fix race in vmpressure_work_fn()

Weijie Yang <weijie.yang@samsung.com>
    mm: frontswap: invalidate expired data on a dup-store failure


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/powerpc/kernel/vdso32/getcpu.S                |  4 +-
 arch/x86/boot/compressed/Makefile                  |  2 +-
 arch/x86/kernel/cpu/perf_event.c                   |  3 +
 arch/x86/kernel/cpu/perf_event.h                   | 12 ++--
 arch/x86/kernel/cpu/perf_event_intel.c             | 66 +++++++++++++++++++++-
 drivers/ata/ahci.c                                 |  4 ++
 drivers/ata/sata_fsl.c                             |  2 +-
 drivers/gpu/drm/i915/intel_display.c               |  2 -
 drivers/gpu/drm/i915/intel_lvds.c                  | 22 ++++----
 drivers/gpu/drm/radeon/radeon_kms.c                |  2 +
 drivers/i2c/busses/i2c-davinci.c                   |  8 +--
 drivers/i2c/busses/i2c-omap.c                      | 10 ++--
 drivers/media/i2c/smiapp/smiapp-core.c             |  2 +-
 drivers/net/ethernet/broadcom/tg3.c                |  3 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  2 +
 drivers/net/ethernet/marvell/mvneta.c              |  5 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  2 +-
 drivers/net/vxlan.c                                | 10 +---
 drivers/net/xen-netfront.c                         |  5 --
 drivers/usb/host/xhci-ring.c                       | 40 ++++---------
 drivers/usb/host/xhci.c                            | 60 +++++---------------
 mm/frontswap.c                                     |  4 +-
 mm/memory.c                                        | 26 ++++-----
 mm/mmap.c                                          | 10 +++-
 mm/rmap.c                                          |  6 +-
 mm/vmpressure.c                                    |  8 ++-
 net/core/rtnetlink.c                               |  1 +
 net/ipv4/gre_offload.c                             |  3 +
 net/ipv4/ip_vti.c                                  |  1 +
 net/ipv6/ip6_gre.c                                 |  4 +-
 net/ipv6/ip6_vti.c                                 | 11 ++++
 net/mac80211/aes_ccm.c                             |  3 +
 net/sctp/output.c                                  |  4 +-
 sound/pci/hda/patch_analog.c                       |  1 +
 sound/pci/hda/patch_realtek.c                      |  1 +
 sound/usb/midi.c                                   |  2 +
 37 files changed, 202 insertions(+), 153 deletions(-)


