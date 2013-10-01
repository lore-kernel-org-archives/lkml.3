Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3JAUDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:03:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab3JAUDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:03:22 -0400
Date: Tue, 1 Oct 2013 13:03:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.14
Message-ID: <20131001200307.GA27892@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.14 kernel.

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

 Makefile                                           |    2=20
 block/cfq-iosched.c                                |    2=20
 drivers/gpu/drm/ast/ast_drv.h                      |    2=20
 drivers/gpu/drm/drm_crtc.c                         |   18 -
 drivers/gpu/drm/i915/i915_irq.c                    |   76 +++-
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |   15=20
 drivers/gpu/drm/radeon/atombios_dp.c               |    6=20
 drivers/gpu/drm/radeon/atombios_encoders.c         |    8=20
 drivers/gpu/drm/radeon/atombios_i2c.c              |    4=20
 drivers/gpu/drm/radeon/evergreen.c                 |   25 +
 drivers/gpu/drm/radeon/evergreend.h                |    4=20
 drivers/gpu/drm/radeon/radeon_atombios.c           |   13=20
 drivers/gpu/drm/radeon/radeon_connectors.c         |   34 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |    8=20
 drivers/gpu/drm/radeon/radeon_kms.c                |    3=20
 drivers/gpu/drm/radeon/rs400.c                     |    9=20
 drivers/gpu/drm/radeon/si.c                        |  129 ++++---
 drivers/gpu/drm/radeon/sid.h                       |    4=20
 drivers/gpu/drm/ttm/ttm_tt.c                       |    2=20
 drivers/hid/hid-core.c                             |   74 +++-
 drivers/hid/hid-input.c                            |   11=20
 drivers/hid/hid-lenovo-tpkbd.c                     |   25 +
 drivers/hid/hid-lg2ff.c                            |   19 -
 drivers/hid/hid-lg3ff.c                            |   29 -
 drivers/hid/hid-lg4ff.c                            |   20 -
 drivers/hid/hid-lgff.c                             |   17 -
 drivers/hid/hid-logitech-dj.c                      |   10=20
 drivers/hid/hid-multitouch.c                       |   26 -
 drivers/hid/hid-steelseries.c                      |    5=20
 drivers/hid/hid-zpff.c                             |   18 -
 drivers/media/pci/Kconfig                          |    4=20
 drivers/media/usb/Kconfig                          |    4=20
 drivers/net/ethernet/broadcom/bgmac.c              |    2=20
 drivers/net/ethernet/broadcom/bgmac.h              |    2=20
 drivers/net/usb/cdc_ether.c                        |    5=20
 drivers/net/wireless/rt2x00/rt2800lib.c            |   22 -
 drivers/pci/pci-acpi.c                             |    6=20
 drivers/usb/gadget/dummy_hcd.c                     |    7=20
 fs/bio-integrity.c                                 |    2=20
 fs/cifs/dir.c                                      |    1=20
 fs/udf/super.c                                     |  342 ++++++++++++----=
-----
 include/linux/hid.h                                |    4=20
 include/linux/timex.h                              |    1=20
 include/uapi/drm/radeon_drm.h                      |    2=20
 kernel/audit.c                                     |    5=20
 kernel/sched/cputime.c                             |   19 -
 kernel/sched/fair.c                                |   14=20
 kernel/time/ntp.c                                  |    6=20
 kernel/time/timekeeping.c                          |    2=20
 mm/swap.c                                          |   77 +++-
 net/netfilter/ipset/ip_set_hash_gen.h              |   28 -
 net/sunrpc/auth_gss/gss_rpc_upcall.c               |   26 +
 net/sunrpc/auth_gss/gss_rpc_xdr.c                  |   41 +-
 net/sunrpc/auth_gss/gss_rpc_xdr.h                  |    5=20
 tools/perf/util/map.c                              |    1=20
 55 files changed, 799 insertions(+), 447 deletions(-)

Alan Stern (1):
      usb: gadget: fix a bug and a WARN_ON in dummy-hcd

Alex Deucher (8):
      drm/radeon: fix LCD record parsing
      drm/radeon: fix endian bugs in hw i2c atom routines
      drm/radeon: update line buffer allocation for dce4.1/5
      drm/radeon: update line buffer allocation for dce6
      drm/radeon: fix resume on some rs4xx boards (v2)
      drm/radeon: fix handling of variable sized arrays for router objects
      drm/radeon/atom: workaround vbios bug in transmitter table on rs880 (=
v2)
      drm/radeon: fix panel scaling with eDP and LVDS bridges

Anatol Pomozov (1):
      cfq: explicitly use 64bit divide operation for 64bit arguments

Andi Kleen (1):
      perf tools: Handle JITed code in shared memory

Ben Skeggs (1):
      drm/ttm: fix the tt_populated check in ttm_tt_destroy()

Benjamin Tissoires (3):
      HID: validate feature and input report details
      HID: multitouch: validate indexes details
      HID: lenovo-tpkbd: fix leak if tpkbd_probe_tp fails

Bjorn Helgaas (1):
      bio-integrity: Fix use of bs->bio_integrity_pool after free

Christian K=C3=B6nig (1):
      drm/radeon: avoid UVD corruptions on AGP cards

Daisuke Nishimura (1):
      sched/fair: Fix small race where child->se.parent,cfs_rq might point =
to invalid ones

Daniel Vetter (2):
      drm/i915: fix gpu hang vs. flip stall deadlocks
      drm/i915: fix wait_for_pending_flips vs gpu hang deadlock

Dave Airlie (1):
      drm/ast: fix the ast open key function

David Herrmann (1):
      drm: fix DRM_IOCTL_MODE_GETFB handle-leak

Emil Velikov (1):
      drm/nv50/disp: prevent false output detection on the original nv50

Fabio Porcedda (1):
      net: usb: cdc_ether: Use wwan interface for Telit modules

Greg Kroah-Hartman (1):
      Linux 3.10.14

J. Bruce Fields (4):
      rpc: clean up decoding of gssproxy linux creds
      rpc: comment on linux_cred encoding, treat all as unsigned
      rpc: fix huge kmalloc's in gss-proxy
      rpc: let xdr layer allocate gssproxy receieve pages

Jan Kara (2):
      udf: Standardize return values in mount sequence
      udf: Refuse RW mount of the filesystem instead of making it RO

John Stultz (1):
      timekeeping: Fix HRTICK related deadlock from ntp lock changes

Kees Cook (6):
      HID: provide a helper for validating hid reports
      HID: LG: validate HID output report details
      HID: zeroplus: validate output report details
      HID: steelseries: validate output report details
      HID: lenovo-tpkbd: validate output report details
      HID: logitech-dj: validate output report details

Khalid Aziz (1):
      mm: fix aio performance regression for database caused by THP

Konstantin Khlebnikov (1):
      audit: fix endless wait in audit_log_start()

Mauro Carvalho Chehab (1):
      Properly handle tristate dependencies on USB/PCI menus

Miklos Szeredi (1):
      cifs: fix filp leak in cifs_atomic_open()

Oliver Smith (1):
      netfilter: ipset: Fix serious failure in CIDR tracking

Rafael J. Wysocki (1):
      PCI / ACPI / PM: Clear pme_poll for devices in D3cold on wakeup

Rafa=C5=82 Mi=C5=82ecki (1):
      bgmac: fix internal switch initialization

Randy Dunlap (1):
      media: media/usb: fix kconfig dependencies

Stanislaw Gruszka (3):
      rt2800: fix wrong TX power compensation
      sched/cputime: Do not scale when utime =3D=3D 0
      rt2800: change initialization sequence to fix system freeze

Tom Stellard (1):
      drm/radeon/si: Add support for CP DMA to CS checker for compute v2


--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSyp7AAoJEDjbvchgkmk+lkgQALuNPl/D1zxkZEewyxdPYAZD
3yktjhTdWLpZcMyUUAFVyi9P4F11e4Nh/9rTaxBjvkGjaClEcX2MszyDCLmDEFxT
FPGFFgLKw7fSWMRs0ghjeMXXdA0owWhzGwnD+PFHVoCV8xJRobv/yyHkkMLsvIoB
BnUyRBPQZeC84daC5M76FOusyAiuUwCmVYrqXpRWVhLaeGtTm4R52NgjGvPv5ZNm
v3ZhLTBKhsmf7MzO34EVdca695KM8RQV/297IqPN2Lf6TAPsATnugcvoT+o894MT
yrvtQhRFKSP3CgMp/rEjgyLBDVk8Va/Gh5CbV9XIRvo1T5rlBVwuJoSzVIfRqIlj
ip2h9bBCuPJ2ouArUMizFxbmgzShozXSHqvrKJU9xe0xcyskz+P/DCzyDfeVt6Gf
qcKY2jesoLExK6bUP3KINl6ruIQdOvb4NZ9bZGAJgO4E30JM7NrRTRQgWrbVAXMq
2DUOQmsAel44R7jqMddnmIiom8GxgZDsWNrB2crejQfRapDeS3wPd0vG4T5X4w1O
/I2KPgeDsQ5Xk1PCTlDSjV9COKhmQGbJ3XVzkIhRRBQZrFeX3ZFWBvc8h2uklq+I
E+HvDQoOrAbGtprI6WTbt9wHN1taBBvaWvygyRX0Lw9r1Yhc1mix76FXvIHiSPdf
5XvYl1QQvp+CiEVhWJxE
=Cb4/
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
