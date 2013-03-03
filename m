Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3CCCvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 21:51:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51975 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313Ab3CCCvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 21:51:35 -0500
Message-ID: <1362279084.3768.200.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 019/150] serial_core: Fix type definition for
 PORT_BRCM_TRUMANAGE.
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Stephen Hurd <shurd@broadcom.com>, Michael Chan <mchan@broadcom.com>
Date: Sun, 03 Mar 2013 02:51:24 +0000
In-Reply-To: <20130228003906.GA3754@kroah.com>
References: <20130226235523.930663721@linuxfoundation.org>
	 <20130226235526.246172467@linuxfoundation.org>
	 <1362009959.3768.85.camel@deadeye.wl.decadent.org.uk>
	 <20130228003906.GA3754@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-n8wznbEKQJVYY44WRZVk"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-n8wznbEKQJVYY44WRZVk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-02-27 at 16:39 -0800, Greg Kroah-Hartman wrote:
> On Thu, Feb 28, 2013 at 12:05:59AM +0000, Ben Hutchings wrote:
> > On Tue, 2013-02-26 at 15:54 -0800, Greg Kroah-Hartman wrote:
[...]
> > > --- a/include/uapi/linux/serial_core.h
> > > +++ b/include/uapi/linux/serial_core.h
> > > @@ -50,7 +50,7 @@
> > >  #define PORT_LPC3220	22	/* NXP LPC32xx SoC "Standard" UART */
> > >  #define PORT_8250_CIR	23	/* CIR infrared port, has its own driver */
> > >  #define PORT_XR17V35X	24	/* Exar XR17V35x UARTs */
> > > -#define PORT_BRCM_TRUMANAGE	24
> > > +#define PORT_BRCM_TRUMANAGE	25
> > >  #define PORT_MAX_8250	25	/* max port ID */
> > > =20
> > >  /*
> >=20
> > Hang on, this is a uapi header - are these numbers actually used by
> > userland or are they really internal to the 8250 drivers?
>=20
> Interesting, I think they are internal to the 8250 drivers, as I don't
> see how the number can be exported to userspace.  So they should
> probably be moved into 8250.c somewhere.
>=20
> But I could be wrong, this code is so old it's scary, hopefully no one
> really is using this number in userspace.
>=20
> Only one way to find out, care to make up a patch for me to apply and
> queue up for 3.10?

It looks like they appear in serial_struct::type when the
TIOC{G,S}SERIAL ioctls are used.  Some of the values are also defined in
<linux/serial.h>, which is fine as long as the definitions are
token-wise identical.

For backported versions I had better not renumber them... oops, I'll go
and fix that now.  (Only reason I did so was because it looked like 8250
wouldn't cope with discontiguous numbering.)

Ben.

--=20
Ben Hutchings
Time is nature's way of making sure that everything doesn't happen at once.

--=-n8wznbEKQJVYY44WRZVk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTK6rOe/yOyVhhEJAQrVbhAAwIaPm7WrXhmsbBaDLDKeJ1MdJWBBWbqh
eoU1Sg7DP6PToxaXOUuYAWJAaUldpOH7BnOyHKtPIFLjz+LfIiIgxzgdQThcvv/W
hCaOgfS1zNKMA9l1IQHiDAcq9+RtScf4DMguLcVgu7wkrrEH5l4EDVh5907cTndx
R6WkXKLIhCQbseoWgxG2PU7fa1OD6U/M4CdEj7Bh2L71pS82+G23E8VBU6rgenoP
1psQpN7qg6tnmlCVlIOqNoGjg2VljQwN+vNKjYwIWaP8UWVDv5wvMY2ew7QA4+ap
PZrmysH1W1zIsAxekA2lPefsri03qHy1LQsmyjb/tGH+dojYR5D3tU7GTW24kk4b
u+/VGUaXeLW+QaAmZa9CaFY3Tyi9lDdECT+7me6MOtLnvZTsVBea45ESEsO72/AZ
+isxZLRlUlJbJxfTEy9UhPM10q8h0OIi2tzp1gCUvRQJPRqNwijo07Kk91uN+sRl
dUGoiGXQXW73TttB3e7TQ6kQ4+eA2gTcoYrFNDLBDXrr4s1p849RtpfKn1gW4tCU
BHl/iouTkHNYVz5hCReGfxv1UiIeUOZZlk4OLnAK8QyiO1L9mtIx7HIanxWFosrX
siDVY6uhkURySl5iIqJaXaWHzzcFVzaGhxnkP13ke4FQ+S4WykPgL8xFZ/SG1LKy
XUx3rmNy7ns=
=NITH
-----END PGP SIGNATURE-----

--=-n8wznbEKQJVYY44WRZVk--
