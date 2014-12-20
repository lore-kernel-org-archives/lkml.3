Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaLTMyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:54:51 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35789 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaLTMyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:54:50 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/2] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Sat, 20 Dec 2014 13:54:46 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-43-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <201412201318.08216@pali> <54956F4B.9070401@roeck-us.net>
In-Reply-To: <54956F4B.9070401@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1558421.cGymE9gpng";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412201354.46435@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1558421.cGymE9gpng
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 20 December 2014 13:44:59 Guenter Roeck wrote:
> On 12/20/2014 04:18 AM, Pali Roh=C3=A1r wrote:
> > On Saturday 20 December 2014 13:04:03 Guenter Roeck wrote:
> >> On 12/20/2014 12:57 AM, Pali Roh=C3=A1r wrote:
> >>> On Friday 19 December 2014 20:28:08 Guenter Roeck wrote:
> >>>> On Fri, Dec 19, 2014 at 07:51:25PM +0100, Pali Roh=C3=A1r=20
wrote:
> >>>>> On Friday 19 December 2014 19:32:37 Guenter Roeck wrote:
> >>>>>>> -static int i8k_fan_mult;
> >>>>>>> -static int i8k_pwm_mult;
> >>>>>>> -static int i8k_fan_max =3D I8K_FAN_HIGH;
> >>>>>>> +static int i8k_fan_mult[2];
> >>>>>>> +static int i8k_pwm_mult[2];
> >>>>>>> +static int i8k_fan_max[2];
> >>>>>>=20
> >>>>>> The rationale for this change is not explained in the
> >>>>>> commit log.
> >>>>>>=20
> >>>>>> Do you have any indication that those values would ever
> >>>>>> be different for the two fans, ie that you actually
> >>>>>> need arrays here ?
> >>>>>=20
> >>>>> I do not know... But if we decide to use only single
> >>>>> value for multiplier and max value which fan to use for
> >>>>> autodetection?
> >>>>=20
> >>>> That does not answer my question. That you can not decide
> >>>> which fan to use for auto-detection does not mean that
> >>>> the result of that auto-detection would be different for
> >>>> different fans.
> >>>=20
> >>> Really I do not know if some dell products which have more
> >>> fans (some Precision models have 2) and each fan is using
> >>> different multiplier or has different max speed value.
> >>=20
> >> "I do not know" is not a reason for introducing such code.
> >>=20
> >> Guenter
> >=20
> > And having broken fan rpm output in userspace is not good.
>=20
> Sure, but only if it is in fact broken.
>=20
> > My code introduce fan rpm detection for each fan. I do not
> > see any problem for doing this detection per fan. You
> > suggest to do some global detection and use it for each
> > fan. And for your
>=20
> > suggestion I have 2 objections:
> The problem is that there is no evidence that a per-fan
> multiplier is needed. You may not see it that way, but
> unnecessary code _is_ a problem since it increases code size
> for no good reason. Furthermore, people not involved in this
> discussion will be inclined to believe that the code is
> necessary, in the wrong assumption that it would not have
> been introduced unless it was necessary.
>=20
> > 1) I do not know if global multiplier will work for all
> > fans. Detection per fan does not have this problem "I do
> > not know".
>=20
> It has been working all along, with no evidence that it
> doesn't work.
>=20
> > 2) How to do that global multiplier detection? I have no
> > idea how you want to do that.
>=20
> A single multiplier worked all along. It doesn't matter which
> fan is used to auto-detect the multiplier, it is still a
> single multiplier.
>=20
> Again, introducing code if you don't know that or if it may be
> needed is not an argument for introducing such code. Introduce
> it if and when there is evidence that it is needed.
>=20
> Thanks,
> Guenter

Ok, so what you suggest now? We have function which reports on=20
supported models if speed level X is supported for fan Y and=20
which RPM speed Z is expected for that level X. I have no problem=20
to (re)write for fan multiplier detection and maximal fan speed=20
level, but I need to know how to do that (which approach you=20
accept and which not). What I want to have is correct data in=20
userspace and better without hardcoded constants for each laptop=20
in driver code.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1558421.cGymE9gpng
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSVcZYACgkQi/DJPQPkQ1K3jgCghEZv69SAJy1UkmZBaQk8RTFL
F0cAoI7fnbte+2xrZiRMWF7l1aAEZEmk
=8Pul
-----END PGP SIGNATURE-----

--nextPart1558421.cGymE9gpng--
