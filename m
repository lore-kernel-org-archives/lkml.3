Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab3JNTFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:05:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34595 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab3JNTFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:05:52 -0400
Date: Mon, 14 Oct 2013 14:05:39 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <b-liu@ti.com>
Subject: Re: USB regression in v3.12-rc4
Message-ID: <20131014190539.GI3132@radagast>
Reply-To: <balbi@ti.com>
References: <20131012214618.GD29989@blackmetal.musicnaut.iki.fi>
 <20131014153356.GA18373@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G3juXO9GfR42w+sw"
Content-Disposition: inline
In-Reply-To: <20131014153356.GA18373@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--G3juXO9GfR42w+sw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 14, 2013 at 08:33:56AM -0700, Greg Kroah-Hartman wrote:
> On Sun, Oct 13, 2013 at 12:46:18AM +0300, Aaro Koskinen wrote:
> > Hi,
> >=20
> > With v3.12-rc4 I can no longer connect to N800 (OMAP2) with USB
> > (peripheral, g_ether).
> >=20
> > According to git bisect this is caused by:
> >=20
> > 9b0a1de3c85d99d881c86a29b3d52da7b9c7bd61 is the first bad commit
> > commit 9b0a1de3c85d99d881c86a29b3d52da7b9c7bd61
> > Author: Bin Liu <b-liu@ti.com>
> > Date:   Tue Sep 17 15:33:35 2013 -0500
> >=20
> >     usb: musb: gadget: fix otg active status flag
> >=20
> >     In gadget mode, musb->is_active should be set only when connected t=
o the
> >     host. musb_g_reset() already takes care of it.
> >=20
> >     Signed-off-by: Bin Liu <b-liu@ti.com>
> >     Signed-off-by: Felipe Balbi <balbi@ti.com>
> >=20
> > Reverting that commit from v3.12-rc4 will fix the issue. Based on the
> > commit log this is not fixing any real issue, so I wonder why was it
> > included in -rc4 in the first place?
>=20
> Hm, Felipe, should I just revert this patch for 3.12-final?

Yeah, let's do that... It's unfortunate that tusb6010 is so messed up
:-(

--=20
balbi

--G3juXO9GfR42w+sw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSXECDAAoJEIaOsuA1yqRE6kgP/3oVWFm6NiJvk/fD7lu/lLZ1
ci0pl4sguil/ljlHdlyur1FOfQyCB9xI7IrG7zzlocQAW7up/ztwq0YAphsTOmnQ
n+koiWrOYyYE/JkEfth5SK6ZY6Scu/9BQ7XNjHq7hMiEtqzd6RqgHJ6JwRx6mq9/
t3VQPCPnsM1P42bIr5d15KYPQZAhRnX0YAWMk/pyJBKwy6WsGj7pBAFk8+nyZgpu
Y8jzT+wUY26+kVXCg/Cytv//35a3CX1izprIEPs0PXsnTFNuGD9aIWCQJE7XfLXx
2YoknZpi8KZl0KbFSl2SxWOhBjbovQN3osZhaPmV8P5UtiCCr36f6xFW1RkuqpXU
Pl57T0bCABYC3bWHuV9vyFiDc0ppnlZm0rDyWrM6yzfC8w8/47YWFeQYUbNDuPyY
3dGha7sTtALwvhBovEKZ+kK4aEZ7oKyUvNsLOlAy6TierDuAhmqa0I/1mM0hBnEm
0FtXHkaecmKaRKCEIDVv7l5uQ7IswPLxcBnf1jP4XQ5K1Pb3TBo8NqXmLW2wZAec
Bcif23N/p/DScOYZnnvFI+HTfATgR8qbFl50y/4NSXh2BEppiovf0YvK6dRFwOzt
xzQnTaO/WoX/OU+0r2s3QD5AAYHFhGQkcPFyjFyWhT8I4PEq4HBuf+bs229d8BMV
BqmIrfGmcAcmkK5eGCjt
=egog
-----END PGP SIGNATURE-----

--G3juXO9GfR42w+sw--
