Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaK2RSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:18:22 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:40264 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaK2RSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:18:21 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Date: Sat, 29 Nov 2014 18:18:18 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <201411291709.35406@pali> <1419444.Nxv4HBGmNA@xps13>
In-Reply-To: <1419444.Nxv4HBGmNA@xps13>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2317648.ZnRxUNXLSI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411291818.18074@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2317648.ZnRxUNXLSI
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 29 November 2014 18:07:19 Gabriele Mazzotta wrote:
> On Saturday 29 November 2014 17:09:35 Pali Roh=C3=A1r wrote:
> > On Saturday 29 November 2014 17:04:07 Pali Roh=C3=A1r wrote:
> > > This patch adds labels for temperature sensors if SMM
> > > function with EAX register 0x11a3 reports it. These
> > > informations was taken from DOS binary NBSVC.MDM.
> > >=20
> > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > ---
> > >=20
> > >  drivers/char/i8k.c |  110
> > >=20
> > > +++++++++++++++++++++++++++++++++++++++++----------- 1
> > > file changed, 88 insertions(+), 22 deletions(-)
> >=20
> > I tested patch on Latitude E6440 and i8k CPU & GPU temps
> > match intel coretemp & amd radeion temps.
> >=20
> > But I would like if somebody with other Dell laptop can test
> > if temperature labels are correct...
>=20
> I tested it on my XPS13 9333, here what sensors outputs:
>=20
> acpitz-virtual-0
> Adapter: Virtual device
> temp1:        +27.8=C2=B0C  (crit =3D +105.0=C2=B0C)
> temp2:        +29.8=C2=B0C  (crit =3D +105.0=C2=B0C)
>=20
> coretemp-isa-0000
> Adapter: ISA adapter
> Physical id 0:  +62.0=C2=B0C  (high =3D +100.0=C2=B0C, crit =3D +100.0=C2=
=B0C)
> Core 0:         +62.0=C2=B0C  (high =3D +100.0=C2=B0C, crit =3D +100.0=C2=
=B0C)
> Core 1:         +61.0=C2=B0C  (high =3D +100.0=C2=B0C, crit =3D +100.0=C2=
=B0C)
>=20
> i8k-virtual-0
> Adapter: Virtual device
> fan2:           0 RPM
> CPU:          +62.0=C2=B0C
> Ambient:      +49.0=C2=B0C
> SODIMM:       +46.0=C2=B0C
> temp4:            N/A
>=20
> CPU seems to be correct, but I can't say anything on Ambient
> and SODIMM. temp4 is constantly equal to SODIMM without this
> patch, so I'd say N/A is correct.
>=20
>=20
> Gabriele

It is unknown for me how to directly read Ambient and SODIMM
temperatures (without Dell SMM functions). So we can only trust
Dell SMM that it reporting correct values and type is really
Ambient and SODIMM.

And about temp4:

Label is not set when SMM function fails. Original DOS NBSVC.MDM
just ignore all sensors for which SMM type function fails.

This patch should not disable any sensor, so if you previously
had some value (<=3D 128=C2=B0C) and now not, then there is some bug.

Can you test this patch?
https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/commit/?h=
=3Dchar-misc-testing&id=3D723493ca59c8d81fed3e7f261165fee493a29ffa

It is possible that same value is caused by incorrect use of
prev[] array which should be fixed by above patch.

Can you test i8k with and without above patch?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2317648.ZnRxUNXLSI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR5/9oACgkQi/DJPQPkQ1Lg6wCZAR40UBGGvfxLuSY8rX57PlPG
pmwAnR36Z15O1cV3+vCzYnamB5TtbEwO
=uU2b
-----END PGP SIGNATURE-----

--nextPart2317648.ZnRxUNXLSI--
