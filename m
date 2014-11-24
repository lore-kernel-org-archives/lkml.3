Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaKXWZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:25:53 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56305 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaKXWZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:25:48 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Mon, 24 Nov 2014 23:25:45 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Pavel Machek <pavel@ucw.cz>, Fabio Estevam <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201409051552.05447@pali> <20140905135816.GE20164@leverpostej>
In-Reply-To: <20140905135816.GE20164@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1889975.vjZDeJf3gR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411242325.45574@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1889975.vjZDeJf3gR
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 05 September 2014 15:58:16 Mark Rutland wrote:
> On Fri, Sep 05, 2014 at 02:52:05PM +0100, Pali Roh=C3=A1r wrote:
> > On Friday 05 September 2014 15:45:42 Mark Rutland wrote:
> > > On Fri, Sep 05, 2014 at 12:38:40PM +0100, Pali Roh=C3=A1r wrote:
> > > > On Wednesday 18 June 2014 18:54:24 Pali Roh=C3=A1r wrote:
> > > > > Machine name from board description is some generic
> > > > > name on DT kernel. DT provides machine name property
> > > > > which is specific for board, so use it instead
> > > > > generic one when possible.
> > > > >=20
> > > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > > > ---
> > > > >=20
> > > > >  arch/arm/kernel/setup.c |    7 +++++--
> > > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > > >=20
> > > > > diff --git a/arch/arm/kernel/setup.c
> > > > > b/arch/arm/kernel/setup.c index 8a16ee5..fbc7b4f
> > > > > 100644 --- a/arch/arm/kernel/setup.c
> > > > > +++ b/arch/arm/kernel/setup.c
> > > > > @@ -875,10 +875,13 @@ void __init setup_arch(char
> > > > > **cmdline_p)
> > > > >=20
> > > > >  	setup_processor();
> > > > >  	mdesc =3D setup_machine_fdt(__atags_pointer);
> > > > >=20
> > > > > -	if (!mdesc)
> > > > > +	if (mdesc)
> > > > > +		machine_name =3D of_flat_dt_get_machine_name();
> > > > > +	else
> > > > >=20
> > > > >  		mdesc =3D setup_machine_tags(__atags_pointer,
> > > > >=20
> > > > > __machine_arch_type); machine_desc =3D mdesc;
> > > > > -	machine_name =3D mdesc->name;
> > > > > +	if (!machine_name)
> > > > > +		machine_name =3D mdesc->name;
> > > > >=20
> > > > >  	if (mdesc->reboot_mode !=3D REBOOT_HARD)
> > > > >  =09
> > > > >  		reboot_mode =3D mdesc->reboot_mode;
> > > >=20
> > > > So, do you really want to break userspace which reading
> > > > file /proc/cpuinfo (after migration from boardcode -->
> > > > DT)?
> > >=20
> > > You have no guarantee model name in the DT =3D=3D the name in
> > > a board file anyhow, and trying to force that is wrong.
> > > So further to Russell's reply, I must NAK this from a DT
> > > perspective.
> > >=20
> > > Realistically your userspace is already broken if relying
> > > on such things. You built something that only ever worked
> > > for a particular arbitrary string. So it was already
> > > broken for every other board, and there was never any
> > > guarantee that new boards where your userspace could have
> > > worked would share the same name.
> > >=20
> > > You're trying to fix the wrong side of the equation.
> > >=20
> > > Mark.
> >=20
> > So what is your suggestion for identifing board (name/type)
> > which will work with any kernel (and will not be broken
> > again by kernel later)?
>=20
> Without knowing your use case I have no idea if that's even a
> sane thing to do.
>=20
> Mark.

Read information which was previously (non DT boot) in file:=20
/proc/cpuinfo

Hardware        : Nokia RX-51 board
Revision        : 0012
Serial          : 0000000000000000

Userspace applications using them for identifying on which device=20
and hw revisions are running.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1889975.vjZDeJf3gR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRzsGkACgkQi/DJPQPkQ1IiSwCdEhlT+i+IcnJz3kQD+vxZPX67
G5YAnjYv9nleGPJJwrjs4PsDoRNvV7yI
=T9KR
-----END PGP SIGNATURE-----

--nextPart1889975.vjZDeJf3gR--
