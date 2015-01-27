Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbbA0RND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:13:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbbA0RNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:13:00 -0500
Date: Tue, 27 Jan 2015 09:12:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.66
Message-ID: <20150127171259.GA19115@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.66 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt         |    1=20
 Makefile                                    |    2 -
 arch/arc/boot/dts/nsimosci.dts              |   18 ++++-----
 arch/arm/boot/dts/imx25.dtsi                |    2 -
 arch/arm/mach-imx/clk-imx6q.c               |    4 +-
 arch/arm/mach-omap2/timer.c                 |    8 ++--
 arch/arm/mach-shmobile/setup-sh73a0.c       |    3 +
 arch/um/Kconfig.common                      |    1=20
 arch/x86/kernel/kprobes/core.c              |   20 +++++++---
 arch/x86/um/sys_call_table_32.c             |    2 -
 arch/x86/um/sys_call_table_64.c             |    2 -
 drivers/gpio/gpiolib-of.c                   |   11 ++++-
 drivers/gpu/drm/i915/i915_reg.h             |    1=20
 drivers/gpu/drm/i915/intel_ringbuffer.c     |    3 +
 drivers/gpu/drm/radeon/atombios_dp.c        |    4 ++
 drivers/gpu/drm/radeon/radeon_ttm.c         |    2 -
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c       |   17 +++-----
 drivers/input/serio/i8042-x86ia64io.h       |   39 ++++++++++++++++++++
 drivers/input/serio/i8042.c                 |   14 +++++++
 drivers/media/i2c/smiapp-pll.c              |    4 +-
 drivers/media/i2c/smiapp/smiapp-core.c      |    2 +
 drivers/media/usb/dvb-usb/af9005.c          |    3 +
 drivers/media/usb/uvc/uvc_driver.c          |    6 +--
 drivers/mmc/host/sdhci.c                    |    3 +
 drivers/net/can/usb/kvaser_usb.c            |   20 +++++-----
 drivers/net/ethernet/atheros/alx/main.c     |   24 ++++++------
 drivers/net/ethernet/broadcom/tg3.c         |   34 ++++++++---------
 drivers/net/ethernet/cisco/enic/enic_main.c |   12 ++++--
 drivers/platform/x86/hp_accel.c             |    1=20
 drivers/s390/char/con3215.c                 |   52 +++++++++++++++++------=
---
 drivers/scsi/storvsc_drv.c                  |    7 +--
 drivers/target/iscsi/iscsi_target_util.c    |   26 +++++--------
 drivers/usb/dwc3/gadget.c                   |    6 ++-
 drivers/usb/host/pci-quirks.c               |   18 +++++++--
 drivers/usb/serial/cp210x.c                 |    4 +-
 drivers/usb/serial/keyspan.c                |   20 +++++++---
 drivers/vfio/pci/vfio_pci.c                 |    4 --
 drivers/video/logo/logo.c                   |   17 ++++++++
 fs/lockd/svc.c                              |    8 ++--
 fs/nfs/nfs4client.c                         |   17 ++++----
 fs/notify/inode_mark.c                      |   17 +++++---
 lib/decompress_bunzip2.c                    |    2 -
 net/ipv4/tcp_output.c                       |    4 +-
 net/netfilter/ipset/ip_set_core.c           |    6 +++
 net/netlink/af_netlink.c                    |   54 ++++++++---------------=
-----
 net/wireless/chan.c                         |    9 +++-
 46 files changed, 335 insertions(+), 199 deletions(-)

Ahmed S. Darwish (3):
      can: kvaser_usb: Don't free packets when tight on URBs
      can: kvaser_usb: Reset all URB tx contexts upon channel close
      can: kvaser_usb: Don't send a RESET_CHIP for non-existing channels

Alex Deucher (2):
      drm/radeon: check the right ring in radeon_evict_flags()
      drm/radeon: properly filter DP1.2 4k modes on non-DP1.2 hw

Amit Virdi (2):
      usb: dwc3: gadget: Fix TRB preparation during SG
      usb: dwc3: gadget: Stop TRB preparation after limit is reached

Arseny Solokha (1):
      OHCI: add a quirk for ULi M5237 blocking on reset

Chris Wilson (2):
      drm/i915: Invalidate media caches on gen7
      drm/i915: Force the CS stall for invalidate flushes

Dan Carpenter (2):
      decompress_bunzip2: off by one in get_next_block()
      netfilter: ipset: small potential read beyond the end of buffer

Daniel Borkmann (1):
      x86, um: actually mark system call tables readonly

David Miller (1):
      netlink: Always copy on mmap TX.

David Peterson (1):
      USB: cp210x: add IDs for CEL USB sticks and MeshWorks devices

Dmitry Torokhov (1):
      Input: I8042 - add Acer Aspire 7738 to the nomux list

Dmitry Voytik (1):
      ARM: imx6q: drop unnecessary semicolon

Dominique Leuenberger (1):
      hp_accel: Add support for HP ZBook 15

Eric Dumazet (1):
      alx: fix alx_poll()

Fabio Estevam (1):
      ARM: dts: imx25: Fix the SPI1 clocks

Frank Schaefer (1):
      af9005: fix kernel panic on init if compiled without IR

Gary Bisson (1):
      ARM: clk-imx6q: fix video divider for rev T0 1.0

Geert Uytterhoeven (1):
      ARM: shmobile: sh73a0 legacy: Set .control_parent for all irqpin inst=
ances

Govindarajulu Varadarajan (1):
      enic: fix rx skb checksum

Greg Kroah-Hartman (1):
      Linux 3.10.66

Hans Holmberg (1):
      gpiolib: of: Correct error handling in of_get_named_gpiod_flags

Herbert Xu (1):
      tcp: Do not apply TSO segment limit to non-TSO packets

Jerry Hoemann (1):
      fsnotify: next_i is freed during fsnotify_unmount_inodes.

Johan Hovold (1):
      USB: keyspan: fix null-deref at probe

Jouni Malinen (1):
      cfg80211: Fix 160 MHz channels with 80+80 and 160 MHz drivers

Krzysztof Kozlowski (1):
      mmc: sdhci: Fix sleep in atomic after inserting SD card

Lennart Sorensen (1):
      ARM: omap5/dra7xx: Fix frequency typos

Long Li (1):
      storvsc: ring buffer failures may result in I/O freeze

Martin Schwidefsky (2):
      s390/3215: fix hanging console issue
      s390/3215: fix tty output containing tabs

Nicholas Bellinger (1):
      iscsi-target: Fail connection on short sendmsg writes

Prashant Sreedharan (1):
      tg3: tg3_disable_ints using uninitialized mailbox value to disable in=
terrupts

Preston Fick (1):
      USB: cp210x: fix ID for production CEL MeshConnect USB Stick

Richard Weinberger (1):
      um: Skip futex_atomic_cmpxchg_inatomic() test

Sakari Ailus (2):
      smiapp-pll: Correct clock debug prints
      smiapp: Take mutex during PLL update in sensor initialisation

Srihari Vijayaraghavan (1):
      Input: i8042 - reset keyboard to fix Elantech touchpad detection

Steven Rostedt (Red Hat) (1):
      ftrace/jprobes/x86: Fix conflict between jprobes and function graph t=
racing

Takashi Iwai (1):
      uvcvideo: Fix destruction order in uvc_delete()

Thomas Graf (1):
      netlink: Don't reorder loads/stores before marking mmap netlink frame=
 as available

Thomas Hellstrom (1):
      drm/vmwgfx: Fix fence event code

Tomi Valkeinen (1):
      video/logo: prevent use of logos after they have been freed

Trond Myklebust (2):
      NFSv4.1: Fix client id trunking on Linux
      LOCKD: Fix a race when initialising nlmsvc_timeout

Vineet Gupta (1):
      ARC: [nsimosci] move peripherals to match model to FPGA

Wei Yang (1):
      vfio-pci: Fix the check on pci device type in vfio_pci_probe()


--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUx8cYAAoJEDjbvchgkmk+aiEP/RwUSzYPWrrSXE0zGFxjgjn6
0Tsveab1DPIY499Rke2cuLZJUMa90FJtzM1jc/l2Mlo3cNJ9szAhG+ZhYQPlJxAM
m1yEYVKHmbEGQvLlwL30izwJFCutsB/eHyNKBSIEgkcd0SzPhCoBGqeiMN9s/nnL
0gXKcNt3BodDeIgSHl5yNIBwtPQK1b51mWFmoRFsWYK7GxbQhlv++Nau004quoZB
stunxmFvGahNRKBI3eyVEeGzNdeMjE4hPf5IWcW8hukS9jJgo7nVhCMQsaM45+wa
SvA3wVcYIQnuI+5Efnt+rfoIy9eCP3/gBNLiC352Eb8m9ssGCXVWfkAt4V9zLsC+
WJfGyH5Ur2sScbfu9hVMJgpIzWWve5+sIdFBmgwqOwV3EvSzCEVnFhwYXHXraSGE
RJ80dAAa8ABOIHlNLYcWI73IhHDqbDerXcMAPHkZzzDnfZWJ4MFezR2T3jKGhL1x
oe7uk3q8eKJsTDLbZvX79Lp8o1AIUcOh9YssWsZO7fDRGRjyvr2OcSKdsvRx1Rg9
hk7F5FJ3g93JQwZs8FsVcLR1zpvBSCj5Z4S0A1wKvlq32NHA4Jn3eNGtKqGl1V7b
jIlfX8WrGyakNaeLvBqnZPG3phcFDTkLepIlowEqBvKHuQV2ay9YhUc8QtVE28cj
OlI7EDighh04qBJ42x12
=Ivn0
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
