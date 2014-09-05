Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbaIENwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:52:17 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45002 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbaIENwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:52:15 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Fri, 5 Sep 2014 15:52:05 +0200
User-Agent: KMail/1.13.7 (Linux/3.13.0-32-generic; KDE/4.13.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Pavel Machek <pavel@ucw.cz>, Fabio Estevam <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201409051338.40988@pali> <20140905134542.GD20164@leverpostej>
In-Reply-To: <20140905134542.GD20164@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2474447.dz5nrn0Vt0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201409051552.05447@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2474447.dz5nrn0Vt0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 05 September 2014 15:45:42 Mark Rutland wrote:
> On Fri, Sep 05, 2014 at 12:38:40PM +0100, Pali Roh=C3=A1r wrote:
> > On Wednesday 18 June 2014 18:54:24 Pali Roh=C3=A1r wrote:
> > > Machine name from board description is some generic name
> > > on DT kernel. DT provides machine name property which is
> > > specific for board, so use it instead generic one when
> > > possible.
> > >=20
> > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > ---
> > >=20
> > >  arch/arm/kernel/setup.c |    7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/arch/arm/kernel/setup.c
> > > b/arch/arm/kernel/setup.c index 8a16ee5..fbc7b4f 100644
> > > --- a/arch/arm/kernel/setup.c
> > > +++ b/arch/arm/kernel/setup.c
> > > @@ -875,10 +875,13 @@ void __init setup_arch(char
> > > **cmdline_p)
> > >=20
> > >  	setup_processor();
> > >  	mdesc =3D setup_machine_fdt(__atags_pointer);
> > >=20
> > > -	if (!mdesc)
> > > +	if (mdesc)
> > > +		machine_name =3D of_flat_dt_get_machine_name();
> > > +	else
> > >=20
> > >  		mdesc =3D setup_machine_tags(__atags_pointer,
> > >=20
> > > __machine_arch_type); machine_desc =3D mdesc;
> > > -	machine_name =3D mdesc->name;
> > > +	if (!machine_name)
> > > +		machine_name =3D mdesc->name;
> > >=20
> > >  	if (mdesc->reboot_mode !=3D REBOOT_HARD)
> > >  =09
> > >  		reboot_mode =3D mdesc->reboot_mode;
> >=20
> > So, do you really want to break userspace which reading file
> > /proc/cpuinfo (after migration from boardcode --> DT)?
>=20
> You have no guarantee model name in the DT =3D=3D the name in a
> board file anyhow, and trying to force that is wrong. So
> further to Russell's reply, I must NAK this from a DT
> perspective.
>=20
> Realistically your userspace is already broken if relying on
> such things. You built something that only ever worked for a
> particular arbitrary string. So it was already broken for
> every other board, and there was never any guarantee that new
> boards where your userspace could have worked would share the
> same name.
>=20
> You're trying to fix the wrong side of the equation.
>=20
> Mark.

So what is your suggestion for identifing board (name/type) which=20
will work with any kernel (and will not be broken again by kernel=20
later)?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2474447.dz5nrn0Vt0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlQJwAUACgkQi/DJPQPkQ1JsUgCbBHVxSwXT5NJT5YLndjaWqV2J
al0AnRUGbfJXuwapu1XLtvK+/oCvwUmq
=rfoi
-----END PGP SIGNATURE-----

--nextPart2474447.dz5nrn0Vt0--
