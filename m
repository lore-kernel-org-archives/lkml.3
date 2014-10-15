Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaJORGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:06:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53258 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaJORGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:06:19 -0400
Date: Wed, 15 Oct 2014 12:06:10 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: be more verbose on ERRATIC_ERROR interrupt
Message-ID: <20141015170610.GC15770@saruman>
Reply-To: <balbi@ti.com>
References: <1413317705-10194-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141015050022.GA2378@saruman>
 <20141015165718.GB4529@psi-dev26.jf.intel.com>
 <20141015170145.GC4529@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fXStkuK2IQBfcDe+"
Content-Disposition: inline
In-Reply-To: <20141015170145.GC4529@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fXStkuK2IQBfcDe+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2014 at 10:01:45AM -0700, David Cohen wrote:
> On Wed, Oct 15, 2014 at 09:57:18AM -0700, David Cohen wrote:
> > On Wed, Oct 15, 2014 at 12:00:22AM -0500, Felipe Balbi wrote:
> > > Hi,
> > >=20
> > > On Tue, Oct 14, 2014 at 01:15:05PM -0700, David Cohen wrote:
> > > > ERRATIC_ERROR interrupt is an event that needs more attention from
> > > > developers than currently implemented, since this indicates a serio=
us
> > > > stability issue. The only way to get warned about it is by selectin=
g the
> > > > maximum driver's verbosity.
> > > >=20
> > > > This patch increases a bit the error's verbosity.
> > > >=20
> > > > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > > > ---
> > > >  drivers/usb/dwc3/gadget.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > > index 3818b26bfc05..132e761d62e4 100644
> > > > --- a/drivers/usb/dwc3/gadget.c
> > > > +++ b/drivers/usb/dwc3/gadget.c
> > > > @@ -2484,7 +2484,8 @@ static void dwc3_gadget_interrupt(struct dwc3=
 *dwc,
> > > >  		dev_vdbg(dwc->dev, "Start of Periodic Frame\n");
> > > >  		break;
> > > >  	case DWC3_DEVICE_EVENT_ERRATIC_ERROR:
> > > > -		dev_vdbg(dwc->dev, "Erratic Error\n");
> > > > +		WARN_ON_ONCE(1);
> > > > +		dev_dbg(dwc->dev, "Erratic Error\n");
> > >=20
> > > how about:
> > > 		WARN_ONCE(true, "Erratic Error\n");
> > >=20
> > > instead ?
> >=20
> > When erratic error event happens, in my experience it is usually
> > followed but many of them in a row. It may end up too verbose.
>=20
> Oops, sorry for my confusion. I read WARN(), not WARN_ONCE() when I read
> for the first time :)
>=20
> I let the dev_dbg() because it may be useful to get all the occurrences
> in case debug is enabled. But WARN_ONCE() is fine too if you prefer.

We might WARN_ONCE() and forcibly disconnect from host as the platform
worn't work anymore after Erratic Error happens. Then just make that
clear with "Erratic Error: disconnecting from host\n" or something like
that.

The only way to fix erratic error (by fixing code - probably PHY driver)
will require rebooting the platform anyway. At a minimum, you'd have to
unload and reload dwc3.ko, just make sure (if you can reproduce erratic
error easily) modprobe -r dwc3 && modprobe dwc3 still causes dwc3 to
reconnect to host.

cheers

--=20
balbi

--fXStkuK2IQBfcDe+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPqmCAAoJEIaOsuA1yqREjoMP/1JD+ypCfAb1uqp+HFYnP6oT
9OENNrFjuIHRKym1w/sdnUIgGSVFqQhP4gWtryjmyS5PGzqR2JmcMyZJDUyPUg9G
jCQPghA2K344etOX1HSfnK05j2moJeVGW1pQ4qA5qr1zNJJ+vQz9eUGDjTIzep3J
psj0mwOLyuspuPQoQl5YRFsQGoDWhxOjkbDB2ixQfNCbfolFcPw92IGqF+293tGT
1wnZTN/yULuBBQ6pBGvUZnB0a+NnEnQqHL4nMo1wzyE+Tb5ZTjDQjc6PaqKxja/o
3wSNVvMdBlatoSmlNmQZp6YU4gS3wGS/TtD/BWHjp00OOjTnQ10wVRoONVRXL+Wn
GkxDbVUN1w2NxOIh67y+HvPMEVImkAlcZEGbGlc5c/06i9TwRa1VdBMFxtCP+qVU
IiloGe0bfF79QWwhJ4O6kf/BI6MwOD17tJRvD6/25AMdfhSvy6an9pUV6lMe44Kr
f0HTuS7RzhjJcToxeucfbQnpYh0XwKJN4tDvJYXsNEclJZVeUE2U61QsLuUNQWFG
oc8lrjKS0yUt1HGfjq7x5/M+avjsTRVkiAV9n7DXGFqrzq5EG0UWGtorqsrP3/qc
l2k3WzpyYeg/AzLN7FnE8lnA61DxmBRNFht6cozCyTZIPJMfzy1P3ZRmIM2H8lYb
RCpSGHPUXGMTpEknNFYZ
=GKjL
-----END PGP SIGNATURE-----

--fXStkuK2IQBfcDe+--
