Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbaKXW36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:29:58 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39012 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaKXW35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:29:57 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Andreas =?utf-8?q?F=C3=A4rber?= <afaerber@suse.de>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Mon, 24 Nov 2014 23:29:54 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Mark Rutland <mark.rutland@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Pavel Machek <pavel@ucw.cz>, Fabio Estevam <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201409051552.05447@pali> <540B2997.4070600@suse.de>
In-Reply-To: <540B2997.4070600@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4679466.CyvrYIAkPG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411242329.54361@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4679466.CyvrYIAkPG
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 06 September 2014 17:34:47 Andreas F=C3=A4rber wrote:
> Am 05.09.2014 15:52, schrieb Pali Roh=C3=A1r:
> > On Friday 05 September 2014 15:45:42 Mark Rutland wrote:
> >> On Fri, Sep 05, 2014 at 12:38:40PM +0100, Pali Roh=C3=A1r wrote:
> >>> On Wednesday 18 June 2014 18:54:24 Pali Roh=C3=A1r wrote:
> >>>> Machine name from board description is some generic name
> >>>> on DT kernel. DT provides machine name property which is
> >>>> specific for board, so use it instead generic one when
> >>>> possible.
> >>>>=20
> >>>> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >>>> ---
> >>>>=20
> >>>>  arch/arm/kernel/setup.c |    7 +++++--
> >>>>  1 file changed, 5 insertions(+), 2 deletions(-)
> >>>>=20
> >>>> diff --git a/arch/arm/kernel/setup.c
> >>>> b/arch/arm/kernel/setup.c index 8a16ee5..fbc7b4f 100644
> >>>> --- a/arch/arm/kernel/setup.c
> >>>> +++ b/arch/arm/kernel/setup.c
> >>>> @@ -875,10 +875,13 @@ void __init setup_arch(char
> >>>> **cmdline_p)
> >>>>=20
> >>>>  	setup_processor();
> >>>>  	mdesc =3D setup_machine_fdt(__atags_pointer);
> >>>>=20
> >>>> -	if (!mdesc)
> >>>> +	if (mdesc)
> >>>> +		machine_name =3D of_flat_dt_get_machine_name();
> >>>> +	else
> >>>>=20
> >>>>  		mdesc =3D setup_machine_tags(__atags_pointer,
> >>>>=20
> >>>> __machine_arch_type); machine_desc =3D mdesc;
> >>>> -	machine_name =3D mdesc->name;
> >>>> +	if (!machine_name)
> >>>> +		machine_name =3D mdesc->name;
> >>>>=20
> >>>>  	if (mdesc->reboot_mode !=3D REBOOT_HARD)
> >>>>  =09
> >>>>  		reboot_mode =3D mdesc->reboot_mode;
> >>>=20
> >>> So, do you really want to break userspace which reading
> >>> file /proc/cpuinfo (after migration from boardcode -->
> >>> DT)?
> >>=20
> >> You have no guarantee model name in the DT =3D=3D the name in a
> >> board file anyhow, and trying to force that is wrong. So
> >> further to Russell's reply, I must NAK this from a DT
> >> perspective.
> >>=20
> >> Realistically your userspace is already broken if relying
> >> on such things. You built something that only ever worked
> >> for a particular arbitrary string. So it was already
> >> broken for every other board, and there was never any
> >> guarantee that new boards where your userspace could have
> >> worked would share the same name.
> >>=20
> >> You're trying to fix the wrong side of the equation.
> >=20
> > So what is your suggestion for identifing board (name/type)
> > which will work with any kernel (and will not be broken
> > again by kernel later)?
>=20
> /proc/device-tree/compatible should give you a nul-separated
> list of compatible strings for the machine. Ideally they're
> even documented under Documentation/devicetree/bindings/arm/.
>=20
> But as Mark said, depending on what you are actually trying to
> distinguish in userspace, there may be better ways.
>=20
> Regards,
> Andreas

Ok, this is better. It at least output that device is Nokia N900=20
and not some generic omap device...

$ cat /proc/device-tree/compatible
nokia,omap3-n900ti,omap3430ti,omap3

But I need also serial number and hw revisions which are reported=20
by bootloader in ATAGs.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4679466.CyvrYIAkPG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRzsWIACgkQi/DJPQPkQ1IW7wCdH/0W9//Nv7YC3iyBsfJezclu
udgAnjAziSixu5kBCI21bF1f62uSikWy
=X5s3
-----END PGP SIGNATURE-----

--nextPart4679466.CyvrYIAkPG--
