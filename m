Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbaDGTOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:14:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33813 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718AbaDGTOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:14:36 -0400
Message-ID: <1396898056.8206.32.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 17/18] cifs: ensure that uncached writes handle
 unmapped areas correctly
From: Ben Hutchings <ben@decadent.org.uk>
To: Raphael Geissert <geissert@debian.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Shilovsky <piastry@etersoft.ru>, 741958@bugs.debian.org
Date: Mon, 07 Apr 2014 20:14:16 +0100
In-Reply-To: <CAA7hUgEiAtb_R3_ODpXVgVSVoQvREChjPCL6GyyVTF8VXiYNyg@mail.gmail.com>
References: <lsq.1396827348.486893332@decadent.org.uk>
	 <1396834881.11513.41.camel@deadeye.wl.decadent.org.uk>
	 <CAA7hUgEiAtb_R3_ODpXVgVSVoQvREChjPCL6GyyVTF8VXiYNyg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cSLzMt8+10bnIfba8rH0"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cSLzMt8+10bnIfba8rH0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-04-07 at 15:45 +0200, Raphael Geissert wrote:
> Hi,
>=20
> On 7 April 2014 03:41, Ben Hutchings <ben@decadent.org.uk> wrote:
> > On Mon, 2014-04-07 at 00:35 +0100, Ben Hutchings wrote:
> >> 3.2.57-rc1 review patch.  If anyone has any objections, please let me =
know.
> > [...]
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> [...]
> > +               /*
> > +                * i + 1 now represents the number of pages we actually=
 used in
> > +                * the copy phase above.
> > +                */
> > +               npages =3D min(npages, i + 1);
>=20
> I'm having trouble understanding why min() is needed here. It
> shouldn't harm either, but I find it confusing.

Because in the case where no error occurred, the comment is not true:
i =3D=3D npages and npages have been used.  The loop used upstream works,
but it seemed a bit silly to use a loop here.

Ben.

--=20
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.

--=-cSLzMt8+10bnIfba8rH0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAU0L5COe/yOyVhhEJAQraUA/+NrJxyG094gApRm3zM8/1E40D4p+Bqzvh
fPFw3IUgHfe0r+RlV9lNvDrAv8g0To/gL118oITatunhHHk1sJvqTmO+pMLyiM4J
Q6nkaIE9Pu50ZE3zZmhZljlXgddhJNiAL1LV/G2kYDM8/kq2CirrDemmSV7p4i/r
riZrinjOF7LcPiHw3EodmM4A5a/oG1SjPbrMkHnr8C0jdSh6q+XdIbaZM22PE1lh
iNwCMs9nCCmAPxW/2V70sViqm3TNiljPzB2O+Nb50YJTRE053sxfyCz+7/4FCS8i
gtCYEiGtJaUTyissN0sonvURyy92rLV0LJqJWauoUQyOhJknPOdYZ28m2XVHnNBr
ruTwR4htVknqgybIjCB1qWd8OIFpJql/U/N+nkA/7gtkA+ua4ZaNlkv0r6Gt4qJh
RKtWoSWROB5rDGpakpf4m9QDlcBBouxd56J73PKz/I8OqCUlvQegkwfat2TN76l6
RMeZThcUgQvTxZMVq2kjW3mTFXlHy8vOUyY+xYabxugjZYWlmD66pmrX8+P1sl4R
8NmQwvgSdWVVzl31lpr74YJfWZ8mg0eqq0lcX03AXpAFiF6PJT51NSWBAZIerE8w
SeIOWEuRp8I+OTw3UE7BExBILQB6NVIk3qaU50t3zA6NKDw/4jC/1vync4XtXhWs
30moYiJfTDA=
=WJi9
-----END PGP SIGNATURE-----

--=-cSLzMt8+10bnIfba8rH0--
