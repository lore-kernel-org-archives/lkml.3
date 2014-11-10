Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaKJUhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:37:19 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58111 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaKJUhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:37:14 -0500
Date: Mon, 10 Nov 2014 14:37:39 -0600
From: Felipe Balbi <balbi@ti.com>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: usb: dwc3: ep0: return early on NULL requests
Message-ID: <20141110203739.GD1041@saruman>
Reply-To: <balbi@ti.com>
References: <20141101222047.7178B6610BF@gitolite.kernel.org>
 <20141110203229.GA31249@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Content-Disposition: inline
In-Reply-To: <20141110203229.GA31249@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2014 at 03:32:29PM -0500, Dave Jones wrote:
> On Sat, Nov 01, 2014 at 10:20:47PM +0000, Linux Kernel wrote:
>  > Gitweb:     http://git.kernel.org/linus/;a=3Dcommit;h=3D6856d30c6c0038=
dc0648009853533af3af6c5ba8
>  > Commit:     6856d30c6c0038dc0648009853533af3af6c5ba8
>  > Parent:     7d643664ea559b36188cae264047ce3c9bfec3a2
>  > Refname:    refs/heads/master
>  > Author:     Felipe Balbi <balbi@ti.com>
>  > AuthorDate: Tue Sep 30 11:43:20 2014 -0500
>  > Committer:  Felipe Balbi <balbi@ti.com>
>  > CommitDate: Mon Oct 20 15:58:49 2014 -0500
>  >=20
>  >     usb: dwc3: ep0: return early on NULL requests
>  >    =20
>  >     if our list of requests is empty, return early.
>=20
> ....
>=20
>  > diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
>  > index ae6b575..a47cc1e 100644
>  > --- a/drivers/usb/dwc3/ep0.c
>  > +++ b/drivers/usb/dwc3/ep0.c
>  > @@ -789,9 +789,6 @@ static void dwc3_ep0_complete_data(struct dwc3 *dw=
c,
>  > =20
>  >  	dwc->ep0_next_event =3D DWC3_EP0_NRDY_STATUS;
>  > =20
>  > -	r =3D next_request(&ep0->request_list);
>  > -	ur =3D &r->request;
>  > -
>  >  	trb =3D dwc->ep0_trb;
>=20
> =20
> Since the deletion of this assignment to 'r', we're now doing
> a comparison on it, resulting in dead code that will never be
> reached..

very true, here's a patch to fix it up again :-) i'll send it properly
in a bit.

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 711b230..df38e7e 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -791,6 +791,10 @@ static void dwc3_ep0_complete_data(struct dwc3 *dwc,
=20
 	trb =3D dwc->ep0_trb;
=20
+	r =3D next_request(&ep0->request_list);
+	if (!r)
+		return;
+
 	status =3D DWC3_TRB_SIZE_TRBSTS(trb->size);
 	if (status =3D=3D DWC3_TRBSTS_SETUP_PENDING) {
 		dwc3_trace(trace_dwc3_ep0, "Setup Pending received");
@@ -801,10 +805,6 @@ static void dwc3_ep0_complete_data(struct dwc3 *dwc,
 		return;
 	}
=20
-	r =3D next_request(&ep0->request_list);
-	if (!r)
-		return;
-
 	ur =3D &r->request;
=20
 	length =3D trb->size & DWC3_TRB_SIZE_MASK;

--=20
balbi

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUYSITAAoJEIaOsuA1yqREkWAP/i+EYActUhopr4Wf7k35t024
622rYm7SNt20kFAH30UdnGPPIkGtnwZbPQsRSciC+JK1AKvkE1y7E1zoYWmkiRfA
dpdmSgV/FA4rWwusaypZma2+//KxVDJoXYj0BhQBwgs7I7gZSladPQqBlB5fRDqp
pMJDMnMxvLA8xn71/ZEmdO1CyBx0EsvEJgaIizcl+2xfFkptNGiPylncT4+8AXjQ
7XoYutm+JuxmoVcde7+Z4o/Ek1W30c5YID1QNJnN2VUI0nUtuwatQSsYdM+31Mio
Wbt52M6KL3kKOuYYH7f6tEAwc6Qi5rWZVIOTaQR/3HatmgHEcGQeZMcxBI6GZwkh
K6gCuQ2ndlEj4Mr/+XJQ1SoqHkayUZHU1XMDlwTgQ9kIcPE/UmusniLI00gIpRYB
XHBRB7QChb8z09UGpVs9mdkrd/9eizo/U68HC2nIglgHOy/N/cTrUSDqt6zvSNQB
+aEfRHpZ9mHhMd09wW5nN4WpQK0df5SbDNRewW8n/+YMexWJb+YuOLAZGSonFcAc
7BhCA18HFjtivIMe+H5U2uoSTlMOH319TINOfrSMOWQt3m/W2uJvihnynxrGKbDj
T4BV0X9Kdoa36zVo29CrKm4Dfu0Xe62NIA47l5jRFIPaYB1tqY6nKc+cu1R8DKLf
7bxpcJ7jZLUS3jFMb9GN
=ftRj
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--
