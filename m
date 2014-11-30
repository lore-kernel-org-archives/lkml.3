Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaK3Ros (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:44:48 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:43143 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaK3Ror (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:44:47 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Date: Sun, 30 Nov 2014 18:44:44 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <201411301053.40222@pali> <547B3F12.9030705@roeck-us.net>
In-Reply-To: <547B3F12.9030705@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1644895.vnbMcIZKqE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411301844.44562@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1644895.vnbMcIZKqE
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 30 November 2014 17:00:18 Guenter Roeck wrote:
> On 11/30/2014 01:53 AM, Pali Roh=C3=A1r wrote:
> [ ... ]
>=20
> >>> Original Dell DOS executable ignores all temperature
> >>> sensors if type SMM function fails (if I decoded and
> >>> understand that DOS assembler code correctly). So maybe
> >>> we should do same...
> >>>=20
> >>> But because our i8k.c code ignores sensor only if it
> >>> returns invalid temperature, there could be possible
> >>> regression that on same machines type SMM function is not
> >>> implemented or not working...
> >>>=20
> >>> What do you think?
> >>=20
> >> Tested with XPS13, Studio 1555 (with GPU), and XPS M140.
> >> Reading the type works with all of them. The Studio 1555
> >> reports the GPU temperature in temp4. The M140 is quite old
> >> (about 10 years), so I guess we can be reasonably sure that
> >> all laptops currently in use support reporting the type.
> >=20
> > Good. Then I will split this patch into two parts. One which
> > adds labels and one which change init code to register only
> > those sensors which have valid type.
>=20
> Ok.
>=20
> >> Do you know what is returned for the type if the GPU is
> >> turned off on a system with GPU ? I think that is the only
> >> open question.
> >=20
> > Yes, on my E6440 in both cases when GPU is turned off and on
> > is returned same type (GPU). So this does not help us.
>=20
> Unless I misunderstand you, it does help us; it simplifies
> sensor detection since we don't have to handle the special
> case that the GPU is turned off anymore.
>=20
> Thanks,
> Guenter

Yes, sensor type is returned always correctly, so this is good.

I mean that it cannot be used for detecting if GPU is turned on=20
or off.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1644895.vnbMcIZKqE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR7V4wACgkQi/DJPQPkQ1IrIgCcDArZAMHSwhNqq22nuAcXacuT
EV0AoIk5gvODV8VKKsO/JAx27RMdvwfF
=P4Pe
-----END PGP SIGNATURE-----

--nextPart1644895.vnbMcIZKqE--
