Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaGKRVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:21:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35781 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040AbaGKRVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:21:09 -0400
Message-ID: <1405099258.26540.79.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v2] drivers/base: Fix length checks in
 create_syslog_header()/dev_vprintk_emit()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Kay Sievers <kay@vrfy.org>
Date: Fri, 11 Jul 2014 18:20:58 +0100
In-Reply-To: <20140709235736.GA31914@kroah.com>
References: <1402267903.23860.45.camel@deadeye.wl.decadent.org.uk>
	 <20140709235736.GA31914@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-82oPO/5jBPj8vw2RPIAU"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-82oPO/5jBPj8vw2RPIAU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-07-09 at 16:57 -0700, Greg Kroah-Hartman wrote:
> On Sun, Jun 08, 2014 at 11:51:43PM +0100, Ben Hutchings wrote:
> > snprintf() returns the number of bytes that could have been written
> > (excluding the null), not the actual number of bytes written.  Given a
> > long enough subsystem or device name, these functions will advance
> > beyond the end of the on-stack buffer in dev_vprintk_exit(), resulting
> > in an information leak or stack corruption.  I don't know whether such
> > a long name is currently possible.
> >=20
> > In case snprintf() returns a value >=3D the buffer size, do not add
> > structured logging information.  Also WARN if this happens, so we can
> > fix the driver or increase the buffer size.
> >=20
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> > v2: use dev_WARN() not dev_WARN_ON()
>=20
> This patch breaks the build in a huge way:
>=20
> drivers/base/core.c: In function =E2=80=98create_syslog_header=E2=80=99:
> drivers/base/core.c:2049:16: error: expected =E2=80=98)=E2=80=99 before n=
umeric constant
>   dev_WARN(dev, 1, "device/subsystem name too long");
>                   ^
>=20
> is the start of it, it goes on for a page or so after that :(

Sorry about that, I must not have committed the working version before
mailing it.  If you delete the '1, ' it should work.  If you've already
deleted the patch, I'll check and send the working version.

Ben.

--=20
Ben Hutchings
To err is human; to really foul things up requires a computer.

--=-82oPO/5jBPj8vw2RPIAU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU8Ac++e/yOyVhhEJAQqhUQ/+JdraNTZNHL/j4YOdZerj/iqR4WlpTyUp
4CMRnWV4eqMLOXrp4dlt3DfYdxAJv1FXhapIgsvvrdBxFyJsciVUuOvKa36XxHw/
36sLEW6r0ICz3OPpda4m9DrqhpYkhearzsW+bggju05rtCtut5eqcy3rTtorhA/H
2NQnZuP1srSJwxqhcEgC3NcrDy09RX7w2aI26jH4EOdWdSjiKAnzQOZNpGhNdRhw
ZCcxIestdwvuvRHiYBjFEWnhyDliORBa3sGO9h/RFzf1st9RhR7veuemg2mdDf2q
iC9vGPkKU5LIMxVTNpiBP8ItsDrnpispKhzumRj4MQAC2iDls5UuPn/1/wQEcRvY
DHwMb0ehXCHHkZKGHRELjbX5sWwEa/fu16bAAr2KP4SelE7bU5gf/EoDo3N9rGaJ
sPAc5bFVk1QU4E9XlF21CU4JFlm9RxKAlaccud0DCpVb4aIr1w7WIm/RcZrvHzL7
JaafqMaWp1DhYm4anUojbm8qpT6pldGwr1J1Y7FYqvsH8z1atuuFO/a3xMM6xQW1
u14OW0/FGRt/Chsdl6R95OiSZz02ocRMnffpmEjetgysHzh3LJQaLoTx0yFhnexE
rcpTPdGofYJ2/c0/VZnOsxClyJ0ycvQHxJ5GmNOXlTcNVT2pQgwTmZQMrRQcW2Sl
5rPFzowPnDc=
=4eBi
-----END PGP SIGNATURE-----

--=-82oPO/5jBPj8vw2RPIAU--
