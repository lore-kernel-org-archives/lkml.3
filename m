Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaKXWXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:23:36 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41899 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaKXWXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:23:35 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Mon, 24 Nov 2014 23:23:32 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <20140905121316.GI30401@n2100.arm.linux.org.uk> <20140910124615.GA466@xo-6d-61-c0.localdomain>
In-Reply-To: <20140910124615.GA466@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2759886.SMZ1BZ7mzx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411242323.32460@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2759886.SMZ1BZ7mzx
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 10 September 2014 14:46:15 Pavel Machek wrote:
> On Fri 2014-09-05 13:13:16, Russell King - ARM Linux wrote:
> > On Fri, Sep 05, 2014 at 01:38:40PM +0200, Pali Roh=C3=A1r wrote:
> > > On Wednesday 18 June 2014 18:54:24 Pali Roh=C3=A1r wrote:
> > > > -	if (!mdesc)
> > > > +	if (mdesc)
> > > > +		machine_name =3D of_flat_dt_get_machine_name();
> > > > +	else
> > > >=20
> > > >  		mdesc =3D setup_machine_tags(__atags_pointer,
> > > >=20
> > > > __machine_arch_type); machine_desc =3D mdesc;
> > > > -	machine_name =3D mdesc->name;
> > > > +	if (!machine_name)
> > > > +		machine_name =3D mdesc->name;
> > > >=20
> > > >  	if (mdesc->reboot_mode !=3D REBOOT_HARD)
> > > >  =09
> > > >  		reboot_mode =3D mdesc->reboot_mode;
> > >=20
> > > So, do you really want to break userspace which reading
> > > file /proc/cpuinfo (after migration from boardcode -->
> > > DT)?
> > >=20
> > > I still do not see reason for that. And only this one file
> > > is problematic...
> >=20
> > Sorry, I just don't give a damn about your whinging about
> > this.  I've made the situation perfectly clear.  Your patch
> > will not be accepted.
>=20
> Linus made it pretty clear that regressions are not accepted.
>=20
> You are an arm maintainer and there is regression in n900 that
> broke userspace.
>=20
> How do you solve it?
> 									Pavel

I must agree, it is breaking userspace. Even worse DT booting=20
does not provide those old information about board which=20
bootloader set in ATAG info (and which is needed for some=20
applications).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2759886.SMZ1BZ7mzx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRzr+QACgkQi/DJPQPkQ1KEdQCbByAoOQhMpfqfhPT5fA0Pn/eZ
A2MAniIHWYglx4arX6uh32kZ+yLon70+
=k/SU
-----END PGP SIGNATURE-----

--nextPart2759886.SMZ1BZ7mzx--
