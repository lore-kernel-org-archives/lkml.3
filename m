Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaKRSA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:00:27 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53128 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbaKRSAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:00:23 -0500
Date: Tue, 18 Nov 2014 12:00:39 -0600
From: Felipe Balbi <balbi@ti.com>
To: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
CC: felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH]  usb: gadget: USB3 support to the legacy printer driver
Message-ID: <20141118180039.GJ6179@saruman>
Reply-To: <balbi@ti.com>
References: <546A829A.8030106@linaro.org>
 <20141118003028.GA11280@saruman>
 <546B5578.8040809@linaro.org>
 <20141118151753.GB8223@saruman>
 <546B874B.8060700@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SBT+cnFS/G3NVgv4"
Content-Disposition: inline
In-Reply-To: <546B874B.8060700@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SBT+cnFS/G3NVgv4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(fix your mailer, lines should be broken at 80-characters.
Documentation/email-clients.txt has tips)

On Tue, Nov 18, 2014 at 12:52:11PM -0500, Jorge Ramirez-Ortiz wrote:
> On 11/18/2014 10:17 AM, Felipe Balbi wrote:
> > Hi,
> >
> > On Tue, Nov 18, 2014 at 09:19:36AM -0500, Jorge Ramirez-Ortiz wrote:
> >> Hi Felipe/Greg
> >>
> >> Thanks for your comments on my previous attempt.
> >> I think I addressed them here.
> > no you haven't. Read Documentation/SubmittingPatches, read the mailing
> > list archives and you'll see your basic mistake.
>=20
> For this fundamental mistake, could you not just share with me what I
> am missing?
> I don't see anything wrong other than maybe adding more maintainers to
> the DL as per the scripts since the feature itself is self
> explanatory.

Try to save your email from the mailing list and apply it with git am,
it should be very easy to see the problem.

If you also look at the mailing list archives for other patch
submissions (as I suggested) you'll easily see what your mistake is.

> > you have no clue what these mean, do you ? How about reading the USB
> > specification of even http://www.beyondlogic.org/usbnutshell/usb1.shtml
>=20
>=20
> Unfortunately I do.
> It was easier to temporarily hack the driver code for a test - while I
> was at it - rather than modifying the host code.
> Since you asked for them, I though you would read the logs and wonder
> where the funny ids where coming from.

why do you even need to hack the host driver for these ? The driver
shows a Printer Class interface and the linux host side driver should
bind to it without any issues.

> That hack above would have given you an answer: so I kind of know what
> the ids are for. honestly.  anyway, will send the new logs - it took
> me a while to find and modify the host test code.

Which host test code ? Why don't you just use lpr or even cat file >
/dev/lp0 or something like that ?

> > do you want to debug that and find the culprit since you're already at
> > it ?
>=20
> probably: I still need to get used to this process, thanks for bearing
> with me on this.

no problem.

> I spoke to Ricardo Ribalda three months ago while I was doing this
> stuff.  but yes, I might work on this -after I finish with this
> patch!- since I have access to the hardware locally.

cool, that'll help.

> >> 3) Patch:
> >> ---------
> >>
> >>
> >>
> >> From 9b5ee9330c5c02cf51328c350036c1dac998b732 Mon Sep 17 00:00:00 2001
> >> From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
> >> Date: Thu, 25 Sep 2014 16:17:20 -0400
> >> Subject: [PATCH 2/3] usb: gadget: add USB3 support to the printer driv=
er
> >>
> >> Add SS descriptors to support the capabilities provided by USB3 contro=
ller
> >> drivers; unit tests run using a PLX 3380 [max transfer speed measured =
of 1Gbps]
> >>
> >> This driver shall fallback to lower operating modes when the higher on=
es are
> >> not available.
> >>
> >> Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>

hint:

Everything up until this point will go to commit log.

> >> ---
> >>  drivers/usb/gadget/legacy/printer.c | 65 ++++++++++++++++++++++++++++=
+++++----
> >>  1 file changed, 59 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/usb/gadget/legacy/printer.c b/drivers/usb/gadget/=
legacy/printer.c
> >> index 6474081..456730b 100644
> >> --- a/drivers/usb/gadget/legacy/printer.c
> >> +++ b/drivers/usb/gadget/legacy/printer.c
> >> @@ -208,6 +208,43 @@ static struct usb_descriptor_header *hs_printer_f=
unction[] =3D {
> >>      NULL
> >>  };
> >> =20
> >> +/*
> >> + * Added endpoint descriptors for 3.0 devices
> >> + */
> >> +
> >> +static struct usb_endpoint_descriptor ss_ep_in_desc =3D {
> >> +    .bLength =3D              USB_DT_ENDPOINT_SIZE,
> >> +    .bDescriptorType =3D      USB_DT_ENDPOINT,
> >> +    .bmAttributes =3D         USB_ENDPOINT_XFER_BULK,
> >> +    .wMaxPacketSize =3D       cpu_to_le16(1024),
> >> +};
> >> As mentioned above, using the usb338x driver from PLX instead of the n=
et2280 from
> >> kernel.org, the effective file transfer rate increases 1Gbps.
> >>
> > all your tabs have been converted into spaces. Perhaps try:
> >
> > 	$ git help send-email
> >
> > and figure out how to use that ?
> >
>=20
> crap. really sorry about this!

np

--=20
balbi

--SBT+cnFS/G3NVgv4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa4lGAAoJEIaOsuA1yqREeGAQAIu6en0sIJzt7VjdVrSOdWY7
nDVQi6h75Xjypszr5MeNm1Z3/mAV4q1L0EjAV26XLLACOvSxwQikWK4cgwZkvo9F
RQKvtFMKQo6RMPBf0668//7MtgmFQNzsIuZFS0L8FdOeKIwQcb41SLNghW/kf1NQ
BF0yqJWvynXNp8jgJVHt1NZLaR7I4O4hqGLkGlM3/kUo74PNHI8Tgjuwgn3nRRDL
BcCb6HJmL2gsik1Kn3iOKCAuX1AFogEvVazGeYJFFZD7X4/rw7WS7CyiuMF0472g
vzIKQewySKgEO39sBSaXWjxrUJVnaXEFXLma6lr+k+0kuK8bsl2OQbEFgGd8aMBV
6ASl/ijTRXKiJ+OfO5jmYFRxQNXclVzOwGTvG9XVJ+g6dWS0kD/wIfD9602dmmPn
DXGS0qIkAwpwyZnTrYAmJ4K8hz7c+2B3HTmyBsMhdKalQDTXFLaKLK7dfD3mkSN9
31q70TSpPxppYnBUwCQR/eXveX7LqdqGr0uxxY/sM67VijoCyWJevsmyXrehksJb
3PH5w4T0UycSS4g7FkYLnqn+cXYXQ1AVn8gp7umfi17vz3cvPSgHv6DfuYwCuRE3
1SUvFA7CgW1jTw2xQik6xLVf6ce841sHOCBDoCiwYYTG0/ksnENzqxajUrUTfU7d
7WZJdJKFvrx4e1dSp4HI
=R5af
-----END PGP SIGNATURE-----

--SBT+cnFS/G3NVgv4--
