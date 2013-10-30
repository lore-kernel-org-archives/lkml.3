Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab3J3RX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:23:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56224 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab3J3RX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:23:56 -0400
Date: Wed, 30 Oct 2013 12:24:23 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v2 0/3] add gadget quirk to adapt f_fs for DWC3
Message-ID: <20131030172423.GM12193@gimli>
Reply-To: <balbi@ti.com>
References: <1383083578-16447-1-git-send-email-david.a.cohen@linux.intel.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458E2061F@US01WEMBX2.internal.synopsys.com>
 <52713584.60804@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aiCxlS1GuupXjEh3"
Content-Disposition: inline
In-Reply-To: <52713584.60804@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--aiCxlS1GuupXjEh3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 30, 2013 at 09:36:20AM -0700, David Cohen wrote:
> On 10/29/2013 03:47 PM, Paul Zimmerman wrote:
> >>From: David Cohen
> >>Sent: Tuesday, October 29, 2013 2:53 PM
> >>
> >>These patches are a proposal to add gadget quirks in an immediate objec=
tive to
> >>adapt f_fs when using DWC3 controller. But the quirk solution is generi=
c and
> >>can be used by other controllers to adapt gadget functions to their
> >>non-standard restrictions.
> >>
> >>This change is necessary to make Android's adbd service to work on Intel
> >>Merrifield with f_fs instead of out-of-tree android gadget.
> >>
> >>---
> >>David Cohen (3):
> >>   usb: gadget: add quirks field to struct usb_gadget
> >>   usb: ffs: check quirk to pad epout buf size when not aligned to
> >>     maxpacketsize
> >>   usb: dwc3: add quirk USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE to gadget
> >>     driver
> >>
> >>  drivers/usb/dwc3/gadget.c  |  1 +
> >>  drivers/usb/gadget/f_fs.c  | 17 +++++++++++++++++
> >>  include/linux/usb/gadget.h |  5 +++++
> >>  3 files changed, 23 insertions(+)
> >
> >Wouldn't it be simpler and safer to just do this unconditionally? Sure,
> >you need it for DWC3 because the controller refuses to do an OUT transfer
> >at all if the transfer size is less than maxpacketsize. But it's possible
> >that other controllers allow the transfer, and it works in most cases,
> >but if an error occurs and the host sends too much data, they could
> >overrun the buffer and crash your device.
> >
> >For example, the DWC2 databook says "For OUT transfers, the Transfer
> >Size field in the endpoint's Transfer Size register must be a multiple
> >of the maximum packet size of the endpoint". But I don't think the
> >controller enforces that, it is up to the programmer to do the right
> >thing. So that controller probably needs this quirk also. There could be
> >more like that which we don't know about.
>=20
> Unfortunately DWC2 is a bad example... the driver couldn't even get out
> of staging. If the author was reckless to ignore this restriction (s)he
> should fix.
> But I don't have enough data to tell it's better to waste everybody's
> memory in this case in favor of DWC3. I'd still stick with the
> exception.

on top of that we don't what quirks other controllers might have. There
could very well be a controller which quirk goes the other around: you
_must_ set bulk out length to the correct size (e.g. 31 bytes for mass
storage's CBW) otherwise transfer won't complete.

I could see that happening on controllers with broken short packet
handling.

> >So unless the buffer allocation code is in a real fast path, I would
> >suggest to just do the aligned buffer allocation always.
>=20
> This code would affect embedded devices which value too much memory
> consumption (and performance on handling it!). IMO we'd need to be more
> careful prior to take such decision.

agreed. Quirk flag is the way to go here.

--=20
balbi

--aiCxlS1GuupXjEh3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJScUDGAAoJEIaOsuA1yqREO6EP/1Nj0yY8bg2S1H9jCjVqNGza
q9D1Wtq2F+WWvWBrY9XB9zEkal8Yq37c/p7wyZU0Qo/qcZ27wsEI8VlqJWWjLlwZ
n9aF9YjJtP6COWNpXoAkJ6+N9IbStng8iSMpTanx3SQq51lqc79Hp3b2p8j/DZSD
6FemQNNdduxGsvSALZBuOLE77MBstq7MgjFz84TlYp3I0tcXTQVpTburKXDGOIAR
bw+HbA3bAoRrVgk8lHzkGkUz/PGRC7/nVeEeQDi3sF5IUGeK+A61rKzo5nejx2zR
mLODklZCIwWCxxHyzLJKic0APgRjWidq7hP/TONGtI0C5D6NFmg1mYJUmbuthROr
orREAoA7/BfIyrnMvskNcY3oIF1pLP3zi8p+wSPiPhowEQWqzmkVm8EJpO+kZR/b
eLs8MEZq4fbpDHYmWFEWckkXhZZ2fgZgusY7nPZsnVgabdXVyMWIFJVN+VKhOMgt
o1LflFC6Wd/EJvtHbYF1i0e9D4IoczvKhBsFntG3CazvUG8HskfPKe/XBk1rtCS1
ULT0/mzIQafm9LaWh2fvl/6atgAHx9LMWDIgiEf087Vn7MpexaGHjfIAoHl4j1gf
RJqF3XQVi/D2GaWxlSd+/Ia4b1MnhPGvLygKwSGqd8eMGyQ0XWii0spQSheJljx+
mCBAaTb+kgtv4hPEdeaO
=oCCC
-----END PGP SIGNATURE-----

--aiCxlS1GuupXjEh3--
