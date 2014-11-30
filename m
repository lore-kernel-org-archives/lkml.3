Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaK3SAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 13:00:52 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55013 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaK3SAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:00:51 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Date: Sun, 30 Nov 2014 19:00:48 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <201411301844.44562@pali> <547B59CD.90305@roeck-us.net>
In-Reply-To: <547B59CD.90305@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3189524.Chrq40zeqy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411301900.48898@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3189524.Chrq40zeqy
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 30 November 2014 18:54:21 Guenter Roeck wrote:
> On 11/30/2014 09:44 AM, Pali Roh=C3=A1r wrote:
> > On Sunday 30 November 2014 17:00:18 Guenter Roeck wrote:
> >> On 11/30/2014 01:53 AM, Pali Roh=C3=A1r wrote:
> >> [ ... ]
> >>=20
> >>>>> Original Dell DOS executable ignores all temperature
> >>>>> sensors if type SMM function fails (if I decoded and
> >>>>> understand that DOS assembler code correctly). So maybe
> >>>>> we should do same...
> >>>>>=20
> >>>>> But because our i8k.c code ignores sensor only if it
> >>>>> returns invalid temperature, there could be possible
> >>>>> regression that on same machines type SMM function is
> >>>>> not implemented or not working...
> >>>>>=20
> >>>>> What do you think?
> >>>>=20
> >>>> Tested with XPS13, Studio 1555 (with GPU), and XPS M140.
> >>>> Reading the type works with all of them. The Studio 1555
> >>>> reports the GPU temperature in temp4. The M140 is quite
> >>>> old (about 10 years), so I guess we can be reasonably
> >>>> sure that all laptops currently in use support reporting
> >>>> the type.
> >>>=20
> >>> Good. Then I will split this patch into two parts. One
> >>> which adds labels and one which change init code to
> >>> register only those sensors which have valid type.
> >>=20
> >> Ok.
> >>=20
> >>>> Do you know what is returned for the type if the GPU is
> >>>> turned off on a system with GPU ? I think that is the
> >>>> only open question.
> >>>=20
> >>> Yes, on my E6440 in both cases when GPU is turned off and
> >>> on is returned same type (GPU). So this does not help us.
> >>=20
> >> Unless I misunderstand you, it does help us; it simplifies
> >> sensor detection since we don't have to handle the special
> >> case that the GPU is turned off anymore.
> >>=20
> >> Thanks,
> >> Guenter
> >=20
> > Yes, sensor type is returned always correctly, so this is
> > good.
> >=20
> > I mean that it cannot be used for detecting if GPU is turned
> > on or off.
>=20
> Yes, but that is a good thing, because it helps us figuring
> out if the GPU sensor should be enabled or not during probe,
> so we no longer need to try reading the temperature, and we
> no longer have to handle the case of "GPU supported, but
> turned off" during probe.
>=20
> When reading the temperature, returning -ENODATA if the GPU
> is turned off is the best we can do.
>=20
> Thanks,
> Guenter

Yes, you are right. I will create new patches.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3189524.Chrq40zeqy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEABECAAYFAlR7W1AACgkQi/DJPQPkQ1JHtwCYiARnnO0SlwHZB+1qM5qczG5U
mgCffwjyAJC0yQqS1Tk7QqbN8yAQauQ=
=DwB9
-----END PGP SIGNATURE-----

--nextPart3189524.Chrq40zeqy--
