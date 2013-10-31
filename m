Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3JaVPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 17:15:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37036 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab3JaVPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 17:15:32 -0400
Date: Thu, 31 Oct 2013 16:16:02 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stern@rowland.harvard.edu>,
        <Paul.Zimmerman@synopsys.com>
Subject: Re: [PATCH v3 3/3] usb: dwc3: add quirk
 USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE to gadget driver
Message-ID: <20131031211602.GL2281@gimli>
Reply-To: <balbi@ti.com>
References: <1383152778-30739-1-git-send-email-david.a.cohen@linux.intel.com>
 <1383152778-30739-4-git-send-email-david.a.cohen@linux.intel.com>
 <20131030173553.GP12193@gimli>
 <5272B67B.6050509@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KIbT1ud6duwZIwNL"
Content-Disposition: inline
In-Reply-To: <5272B67B.6050509@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KIbT1ud6duwZIwNL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2013 at 12:58:51PM -0700, David Cohen wrote:
> On 10/30/2013 10:35 AM, Felipe Balbi wrote:
> > On Wed, Oct 30, 2013 at 10:06:18AM -0700, David Cohen wrote:
> >> DWC3 requires epout to have buffer size aligned to MaxPacketSize value.
> >> This patch adds necessary quirk for it.
> >>
> >> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> >> ---
> >>  drivers/usb/dwc3/gadget.c | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> >> index 5452c0f..528c7d7 100644
> >> --- a/drivers/usb/dwc3/gadget.c
> >> +++ b/drivers/usb/dwc3/gadget.c
> >> @@ -2600,6 +2600,12 @@ int dwc3_gadget_init(struct dwc3 *dwc)
> >>  	dwc->gadget.name		=3D "dwc3-gadget";
> >> =20
> >>  	/*
> >> +	 * Per databook, DWC3 needs buffer size to be aligned to MaxPacketSi=
ze
> >> +	 * on ep out.
> >> +	 */
> >> +	dwc->gadget.quirk_ep_out_aligned_size =3D 1;
> >=20
> > just to make it look cooler and neater, could you set to 'true' instead
> > :-)
>=20
> 'bool' is an alien in C :)
> But I can change to true in next patch set.

don't change the type, just assign true instead of 1. true is defined as
!0, so it'll be a 1 anywa. Still the rest of the driver uses true/false
for one-bit fields.

--=20
balbi

--KIbT1ud6duwZIwNL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIbBAEBAgAGBQJScsiSAAoJEIaOsuA1yqREH/MP9jGSy+O1DtqxOippNh+MbmXJ
nT+npE7hEYMiDWUqjD3KKLuDy7epJ0GlyXNi9+MmJoviJ2MI7iZvFUAlg8VWAN2Q
7GoU+lI94Jd/Nw35Qwg3t7eLXpqyMEol6FnlA8btMWi0FD/FoQAc7pqC5VcdtFEe
XNjuQ6wFTp2CaWhUQ+BtjaH0v7EbIK3LbHq3bGK+r5N1hh/vZ5AflB+9SBmjWBua
4opa8JQmYqB2oC5J+FpQnebVelk6oITknFR9b85qFnEONoGp5fTcqCoDyPxfuUGb
YZJqQGwuZudOUZCZpTWD4efuQNW+McBaHfW4MYT4/g3G3cCKFzG8Uqy4bQd+kJTl
rU0S4XjCO7dISY067F818u+KgTSYuR1Xk+gG06sTbKK7loT9rJtWdE8FYZI6btbv
9sxoluqqoxgHxOTDce/KnCjyEWv8G+XpMHJfGA/JWUW8Hu8KC1SG5dxuc94ei2qQ
ElrzFZVYckvUwOIfZYV9m7Ex9iaP8xQNtXLN2lYuntsDE34xjmmN3U7xwVtG9sMd
J3c3kG742DQhF6lA8U6jJxEAQgL30DiNCjbhUg6nzs83zltE1fpRiVWS1ni73YbE
H1EMkmhQ0BxIpfVvqYJ4uyJxzSB6yPOeFWIP7BgxxXFXq2Ukr/nEfegX0M+oGRso
ZuGVGnNvcpzaNDjesYQ=
=YsUB
-----END PGP SIGNATURE-----

--KIbT1ud6duwZIwNL--
