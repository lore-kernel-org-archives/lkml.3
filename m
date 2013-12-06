Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab3LFUOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:14:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36787 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773Ab3LFUOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:14:21 -0500
Date: Fri, 6 Dec 2013 14:13:37 -0600
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: David Cohen <david.a.cohen@linux.intel.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/5] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
Message-ID: <20131206201337.GD3889@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com>
 <1384201011-11114-3-git-send-email-david.a.cohen@linux.intel.com>
 <xa1tzjpawl1x.fsf@mina86.com>
 <5281706F.5050507@linux.intel.com>
 <xa1t1u2ln5kr.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yudcn1FV7Hsu/q59"
Content-Disposition: inline
In-Reply-To: <xa1t1u2ln5kr.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yudcn1FV7Hsu/q59
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2013 at 01:54:28PM +0100, Michal Nazarewicz wrote:
> On Tue, Nov 12 2013, David Cohen wrote:
> > On 11/11/2013 03:55 PM, Michal Nazarewicz wrote:
> >> Come to think of it, perhaps even better helper would be:
> >>
> >> static inline size_t usb_ep_align_maybe(
> >> 	struct usb_gadget *gadget, struct usb_ep *ep, size_t len) {
> >> 	return gadget->quir_ep_out_aligned_size ?
> >> 		round_up(len, (size_t)ep->desc->wMaxPacketSize) : len;
> >> }
> >
> > The CPU time to check unsigned:1 and possibly jump is about the same as
> > round_up() itself. For readability matters, we can round_up() directly.
>=20
> I was proposing to have this function and than not have functions check
> for the flag.  I.e. instead of
>=20
> 	if (gadget->quirk_ep_out_aligned_size)
> 		len =3D usb_ep_align_maxpacketsize(ep, len);
>=20
> the code would just be:
>=20
> 	len =3D usb_ep_align_maybe(gadget, ep, len);

that looks very good to me, do we have a version with that already ?

--=20
balbi

--yudcn1FV7Hsu/q59
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSoi/wAAoJEIaOsuA1yqREhuQP/3LoFJsguQqe6/WFcmWVZ+hI
SihftCSagpBXuNiHCrYb8nbSIB8yh2/F6wSwAq+duiVBwl0UiNM4IwI+fKVSdi6F
Xog50TFba7voyCdtBbJwy8u1uYwVE+Y5LlIsJ2C+8NQeTW0Lnv6DpKKqvCIeXzxK
hQ2+dHFSfokEN42+r90t7HDFy9LcmrIKDmsO/2L+gO2l0YP7v4wa8HM1Sw2DYxvI
eckx4V7xUq7bdzW9rLWxexc+RwzaUIRYYX9JBVFFebe7F2FJmnlMXDDAJ463DI8X
bwbwmMJdELCIYj05muhKHR5Z/rJ3aOXgytFSCKfuwST8HFyBfQPE6QEHme5hVC7H
hwhG0rz6t841SBMZb/WS8cv5DShQBthSspAo/VCM1NPjgeeVaCvxdkpi1DtWSi37
rfvUDh9Yoq+t9pHbrg6i4eeVAH9oTEGGgcdNtkdGnvlrTM7f3/ogzBxPJzapOSfQ
ijY4dNLF2c6FIFFabd5b2P3ddzl6r70BKOGohzOKMNYXsAEYBtvqk4PvRbjQe4Oe
87SjOM/ivkby8wuk1YtzTPnitG7vCy3NGOSGTjFby7ncvFaGWKExcargbETBkfZG
rqlNq7224caI9Q+2SRYDp/XjMvKtEo7JIvz196lGMFI2oly8hlAnqjnOiM5rDY7b
TJEemDbXZq54/yKrc8kX
=lkNb
-----END PGP SIGNATURE-----

--yudcn1FV7Hsu/q59--
