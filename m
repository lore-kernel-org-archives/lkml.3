Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaLTMSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:18:13 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61186 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaLTMSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:18:12 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/2] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Sat, 20 Dec 2014 13:18:07 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <201412200957.38638@pali> <549565B3.5070504@roeck-us.net>
In-Reply-To: <549565B3.5070504@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2197299.nEOWuvKbjE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412201318.08216@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2197299.nEOWuvKbjE
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 20 December 2014 13:04:03 Guenter Roeck wrote:
> On 12/20/2014 12:57 AM, Pali Roh=C3=A1r wrote:
> > On Friday 19 December 2014 20:28:08 Guenter Roeck wrote:
> >> On Fri, Dec 19, 2014 at 07:51:25PM +0100, Pali Roh=C3=A1r wrote:
> >>> On Friday 19 December 2014 19:32:37 Guenter Roeck wrote:
> >>>>> -static int i8k_fan_mult;
> >>>>> -static int i8k_pwm_mult;
> >>>>> -static int i8k_fan_max =3D I8K_FAN_HIGH;
> >>>>> +static int i8k_fan_mult[2];
> >>>>> +static int i8k_pwm_mult[2];
> >>>>> +static int i8k_fan_max[2];
> >>>>=20
> >>>> The rationale for this change is not explained in the
> >>>> commit log.
> >>>>=20
> >>>> Do you have any indication that those values would ever
> >>>> be different for the two fans, ie that you actually need
> >>>> arrays here ?
> >>>=20
> >>> I do not know... But if we decide to use only single value
> >>> for multiplier and max value which fan to use for
> >>> autodetection?
> >>=20
> >> That does not answer my question. That you can not decide
> >> which fan to use for auto-detection does not mean that the
> >> result of that auto-detection would be different for
> >> different fans.
> >=20
> > Really I do not know if some dell products which have more
> > fans (some Precision models have 2) and each fan is using
> > different multiplier or has different max speed value.
>=20
> "I do not know" is not a reason for introducing such code.
>=20
> Guenter

And having broken fan rpm output in userspace is not good.

My code introduce fan rpm detection for each fan. I do not see=20
any problem for doing this detection per fan. You suggest to do=20
some global detection and use it for each fan. And for your=20
suggestion I have 2 objections:

1) I do not know if global multiplier will work for all fans.=20
Detection per fan does not have this problem "I do not know".

2) How to do that global multiplier detection? I have no idea how=20
you want to do that.

So I would say, "I do not know" refers yo your suggestion, not to=20
my current code.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2197299.nEOWuvKbjE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSVaP8ACgkQi/DJPQPkQ1IA3QCguO0TAb8as7w5llno0xDaDkFI
WoEAnj3yG3o3VkfutuA3ywQy/vD8wzWZ
=Krfm
-----END PGP SIGNATURE-----

--nextPart2197299.nEOWuvKbjE--
