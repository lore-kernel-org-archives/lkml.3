Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958AbaGAEDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 00:03:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaGAEDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 00:03:50 -0400
Date: Mon, 30 Jun 2014 21:03:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.96
Message-ID: <20140701040335.GA20260@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.96 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/arm/kernel/stacktrace.c                 |   18 ++-
 arch/s390/include/asm/lowcore.h              |   11 +-
 arch/x86/kernel/entry_32.S                   |   15 +--
 arch/x86/syscalls/syscall_64.tbl             |    6 -
 drivers/acpi/bus.c                           |    7 +
 drivers/char/applicom.c                      |    1=20
 drivers/hid/hid-core.c                       |   12 ++
 drivers/net/can/sja1000/peak_pci.c           |   14 +--
 drivers/staging/tidspbridge/core/dsp-clock.c |    4=20
 drivers/target/target_core_rd.c              |    2=20
 drivers/usb/dwc3/gadget.c                    |    4=20
 drivers/usb/gadget/inode.c                   |    2=20
 drivers/usb/host/pci-quirks.c                |   19 +++-
 drivers/usb/misc/usbtest.c                   |   40 +++++++-
 drivers/usb/serial/option.c                  |   15 ++-
 drivers/usb/serial/sierra.c                  |   54 +++++++++--
 drivers/usb/serial/usb_wwan.c                |  123 ++++++++++++++--------=
-----
 drivers/video/matrox/matroxfb_base.h         |    2=20
 fs/btrfs/backref.c                           |    2=20
 fs/btrfs/extent_io.c                         |    3=20
 fs/btrfs/volumes.c                           |    5 -
 fs/ext4/mballoc.c                            |    2=20
 include/linux/irqdesc.h                      |    4=20
 include/linux/skbuff.h                       |   16 +++
 kernel/irq/manage.c                          |    4=20
 kernel/irq/spurious.c                        |  106 ++++++++++++++++++++++-
 mm/memory-failure.c                          |   25 +++--
 mm/rmap.c                                    |    8 +
 mm/vmscan.c                                  |    3=20
 net/core/skbuff.c                            |    5 -
 31 files changed, 399 insertions(+), 135 deletions(-)

Alan Stern (2):
      USB: usbtest: add a timeout for scatter-gather tests
      USB: EHCI: avoid BIOS handover on the HASEE E200

Andy Lutomirski (1):
      x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)

Chris Mason (1):
      Btrfs: fix double free in find_lock_delalloc_range

Christian Borntraeger (1):
      s390/lowcore: reserve 96 bytes for IRB in lowcore

Dan Carpenter (1):
      applicom: dereferencing NULL on error path

Eric Sandeen (1):
      btrfs: fix use of uninit "ret" in end_extent_writepage()

Felipe Balbi (1):
      usb: dwc3: gadget: clear stall when disabling endpoint

Greg Kroah-Hartman (1):
      Linux 3.4.96

H. Peter Anvin (1):
      x86-32, espfix: Remove filter for espfix32 due to race

Huang Rui (1):
      usb: usbtest: fix unlink write error with pattern 1

Hugh Dickins (1):
      mm: fix sleeping function warning from __put_anon_vma

Johan Hovold (10):
      USB: option: fix runtime PM handling
      USB: usb_wwan: fix write and suspend race
      USB: usb_wwan: fix urb leak at shutdown
      USB: usb_wwan: fix potential NULL-deref at resume
      USB: usb_wwan: fix potential blocked I/O after resume
      USB: sierra: fix AA deadlock in open error path
      USB: sierra: fix use after free at suspend/resume
      USB: sierra: fix urb and memory leak in resume error path
      USB: sierra: fix urb and memory leak on disconnect
      USB: sierra: fix remote wakeup

Johannes Weiner (1):
      mm: vmscan: clear kswapd's special reclaim powers before exiting

Kees Cook (1):
      HID: core: fix validation of report id 0

Liu Bo (1):
      Btrfs: use right type to get real comparison

Lv Zheng (1):
      ACPI: Fix conflict between customized DSDT and DSDT local copy

Maurizio Lombardi (1):
      ext4: fix wrong assert in ext4_mb_normalize_request()

Michael S. Tsirkin (3):
      skbuff: add an api to orphan frags
      skbuff: export skb_copy_ubufs
      skbuff: skb_segment: orphan frags before copying

Mike Frysinger (1):
      x86, x32: Use compat shims for io_{setup,submit}

Mikulas Patocka (1):
      matroxfb: perform a dummy read of M_STATUS

Nicholas A. Bellinger (1):
      target: Explicitly clear ramdisk_mcp backend pages

Paul Bolle (2):
      staging: tidspbridge: check for CONFIG_SND_OMAP_SOC_MCBSP
      usb: gadget: rename CONFIG_USB_GADGET_PXA25X

Rickard Strandqvist (1):
      fs: btrfs: volumes.c: Fix for possible null pointer dereference

Roger Quadros (1):
      usb: usbtest: Add timetout to simple_io()

Russell King (1):
      ARM: stacktrace: avoid listing stacktrace functions in stacktrace

Stephane Grosjean (1):
      can: peak_pci: prevent use after free at netdev removal

Thomas Gleixner (1):
      genirq: Sanitize spurious interrupt detection of threaded irqs

Tony Luck (2):
      mm/memory-failure.c-failure: send right signal code to correct thread
      mm/memory-failure.c: don't let collect_procs() skip over processes fo=
r MF_ACTION_REQUIRED

xiao jin (2):
      USB: usb_wwan: fix urb leak in write error path
      USB: usb_wwan: fix race between write and resume


--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTsjMXAAoJEDjbvchgkmk+XJ4P/1YktJsAfrJFV5C4wC2r5UpA
27ts5NMXFXCcYoABTSddJOZlYVr2s8jRsAppqePhpNqhRrM31aTueJqV57BFUTwl
ipK/Kl8Raedr3mpMPyOpb9qWlw4Ucd91TtKXIiPZv6aIiG/sOPRDGpnQHLFoXY2m
y9mXTTp0NLrxIm4r8mSnS//VYH5QBOIBcGA1Z1ZZwWcm7IFlJw1MC8KgNPgPZYbq
rI5jQJfyUllG8ytUUiLAfif8+d5PuZ3QF1Btec293D6DHcpWc3F8hQxb5dHFR2k3
4wDMTFkxSkys4/0/1ZtEPmYHKLisSCVYWGDOmb9oq5QHpg42vyGiZNplMVXHzhxQ
c/bM4OaxHygXh9TgyZGF8apXXdqYhaGt+aZKAd9dM41FQKxb1MbS9IN84ktyvqTl
nYSb+6wxfn7iTHJvUIUTo9YWF1DoExrodWUKz10plN3emU66z8o88bVZi/b4+fLh
oQ8u21QYXTPISDzHhg36rPuwP5CoNpQDKi0+n3B4cRglFQ2CtBVfirI78I71gWYP
vcructuttFIgl7LfxvB1YN6Rsxjm/yPMUzQytXS6dmnctffS7QJ0CEtOMT56ZZfg
gbHlmvopCwLyjND5oHNkn7VI3Hia/vGqyeWIHkAoRTPRoz69ivOOAFqpUcpyAaGM
hfrlMIx9/TvJz5onuq2c
=+C29
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
