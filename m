Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaLNUuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:50:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaLNUVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/24] 3.10.63-stable review
Date: Sun, 14 Dec 2014 12:20:20 -0800
Message-Id: <20141214201800.613573495@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.63 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Dec 16 20:17:48 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.63-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.63-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't resubmit pending URBs at MIDI error recovery

Anton Blanchard <anton@samba.org>
    powerpc: 32 bit getcpu VDSO function uses 64 bit instructions

Stephen Boyd <sboyd@codeaurora.org>
    ARM: sched_clock: Load cycle count after epoch stabilizes

Todd Fujinaka <todd.fujinaka@intel.com>
    igb: bring link up when PHY is powered up

Jan Kara <jack@suse.cz>
    ext2: Fix oops in ext2_get_block() called from ext2_quota_write()

Nadav Har'El <nyh@il.ibm.com>
    nEPT: Nested INVEPT

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: use MAX_HEADER for headroom reserve in output path

willy tarreau <w@1wt.eu>
    net: mvneta: fix Tx interrupt delay

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    rtnetlink: release net refcnt on error in do_setlink()

Jack Morgenstein <jackm@dev.mellanox.co.il>
    net/mlx4_core: Limit count field to 24 bits in qp_alloc_res

Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
    tg3: fix ring init when there are more TX than RX channels

Yuri Chislov <yuri.chislov@gmail.com>
    ipv6: gre: fix wrong skb->protocol in WCCP

Dmitry Torokhov <dtor@chromium.org>
    sata_fsl: fix error handling of irq_of_parse_and_map

Tejun Heo <tj@kernel.org>
    ahci: disable MSI on SAMSUNG 0xa800 SSD

Devin Ryles <devin.ryles@intel.com>
    AHCI: Add DeviceIDs for Sunrise Point-LP SATA controller

Sakari Ailus <sakari.ailus@iki.fi>
    media: smiapp: Only some selection targets are settable

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Unlock panel even when LVDS is disabled

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

Hugh Dickins <hughd@google.com>
    mm: fix swapoff hang after page migration and fork

Weijie Yang <weijie.yang@samsung.com>
    mm: frontswap: invalidate expired data on a dup-store failure


-------------

Diffstat:

 Makefile                                           |  4 ++--
 arch/arm/kernel/sched_clock.c                      | 13 +++++------
 arch/powerpc/kernel/vdso32/getcpu.S                |  4 ++--
 arch/x86/include/uapi/asm/vmx.h                    |  1 +
 arch/x86/kvm/vmx.c                                 |  8 +++++++
 drivers/ata/ahci.c                                 |  4 ++++
 drivers/ata/sata_fsl.c                             |  2 +-
 drivers/gpu/drm/i915/intel_lvds.c                  | 22 +++++++++---------
 drivers/gpu/drm/radeon/radeon_kms.c                |  2 ++
 drivers/i2c/busses/i2c-davinci.c                   |  8 +++----
 drivers/i2c/busses/i2c-omap.c                      | 10 ++++-----
 drivers/media/i2c/smiapp/smiapp-core.c             |  2 +-
 drivers/net/ethernet/broadcom/tg3.c                |  3 ++-
 drivers/net/ethernet/intel/igb/igb_main.c          |  2 ++
 drivers/net/ethernet/marvell/mvneta.c              |  2 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  2 +-
 drivers/net/xen-netfront.c                         |  5 -----
 fs/ext2/super.c                                    |  1 +
 mm/frontswap.c                                     |  4 +++-
 mm/memory.c                                        | 26 +++++++++++-----------
 net/core/rtnetlink.c                               |  1 +
 net/ipv6/ip6_gre.c                                 |  4 ++--
 net/sctp/output.c                                  |  4 ++--
 sound/usb/midi.c                                   |  2 ++
 24 files changed, 75 insertions(+), 61 deletions(-)


