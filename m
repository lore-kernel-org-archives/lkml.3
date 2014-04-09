Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628AbaDIHRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:17:14 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:61037 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbaDIHRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:17:12 -0400
Date: Wed, 9 Apr 2014 09:16:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lothar =?utf-8?Q?Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Cc: Tim Kryger <tim.kryger@linaro.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv3 1/3] pwm: make the PWM_POLARITY flag in DTB optional
Message-ID: <20140409071614.GA9886@ulmo>
References: <1395235375-12925-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-2-git-send-email-LW@KARO-electronics.de>
 <20140402055350.GX17250@pengutronix.de>
 <20140407113652.GE26985@ulmo>
 <20140408070259.68923987@ipc1.ka-ro>
 <CAAYSxhpL_0FJvuvGODMTZDm7DtK3eBTVYdhf1Ot7PW94gSM8iw@mail.gmail.com>
 <20140409080450.4856681c@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20140409080450.4856681c@ipc1.ka-ro>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 08:04:50AM +0200, Lothar Wa=C3=9Fmann wrote:
> Hi,
>=20
> Tim Kryger wrote:
> > On Mon, Apr 7, 2014 at 10:02 PM, Lothar Wa=C3=9Fmann <LW@karo-electroni=
cs.de>wrote:
> > >
> > >
> > > Thierry Reding wrote:
> > >
> > > > No. You cannot emulate polarity inversion in software.
> > > >
> > > Why not?
> > >
> > > duty_ns =3D period_ns - duty_ns;
> > >
> >=20
> > Since I made the same mistake, I will pass along the pointer Thierry ga=
ve
> > me.
> >=20
> > In include/linux/pwm.h the second difference for an inverted signal is
> > described.
> >=20
> > /**
> >  * enum pwm_polarity - polarity of a PWM signal
> >  * @PWM_POLARITY_NORMAL: a high signal for the duration of the duty-
> >  * cycle, followed by a low signal for the remainder of the pulse
> >  * period
> >  * @PWM_POLARITY_INVERSED: a low signal for the duration of the duty-
> >  * cycle, followed by a high signal for the remainder of the pulse
> >  * period
> >  */
> > enum pwm_polarity {
> > PWM_POLARITY_NORMAL,
> > PWM_POLARITY_INVERSED,
> > };
> >=20
> > Of course, I suspect not all PWM hardware respects this definition of
> > inverted output.
> >=20
> > Either way, hacking the duty in software certainly would get the high/l=
ow
> > order wrong.
> >=20
> OK. But for a periodic signal this doesn't make any difference. It's
> just a matter of where you set your reference point.
> Only if you program the PWM to create a single cycle you would see the
> difference. I wonder if this is a real life usecase though.

It doesn't make a difference if all you're concerned about is the signal
power (which happens to be the case for LED and backlight use-cases).

Currently any in-kernel users only care about the signal power, but
there's no guarantee that it will stay that way. Furthermore, PWM
channels are exposed to userspace via sysfs, so code that we don't
actually see may rely on this behaviour.

Thierry

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTRPO+AAoJEN0jrNd/PrOhcDgP/1cPcVJGUa8QSwMKTEk4qQ0B
aINyoOvVc5JPK7wZ6qfqhEob5VNiliJT7IO/OKIKNfCe8zDvVb1iL0vRA+Ixs3TI
So3HcdiYLd24Gd4rYb/gdFvYN5dZukPRCGG+MZy2YNjF5cDwjXI1I5JTfClK6rq7
l3Ylr1RqO5Eca2ndEmSsJqGA7L9DaScB/ctQgfUTR2taEeMisq+6DEZR+YKsN5hg
yyrWWAJjYYqM5YVQUFilIFuuIOHW3fvwt+HSaFK6jZnNv7HUE/eJLuuWIfBCBCaq
c6kUGVmJJT2ZlBMsu/LSnJH9lE0CnjlyG4VZ1yvqA+qBF3JT1+d6639hZkw/oYho
pXqxcrialFLk9lHeZ9tKfZ1aXMdKO83KItLXeFrdAwenBismAsv3pdqZAPFBTGWz
4hfSB9xduLuNiZkCfdzNjsDyRUYGqKfBjOo0MG6xvfGoECrSoeL0e3hYMzN6riUk
fMa7IbRTm4OiprOK1jJT6qzHWcD59sl96cLiki0buNhJisobUghfuzhkC7r6HUEN
qbIHBBxP6TYTrcaX3OsCxH3fLIu47ZoJkM3dOhVzwqS1+ZHH7g679fpnDFc7/Uj7
gmLtNA5Wag/5w2McFLgnozMNir2FQYfcDCxJLEePUFQ4tLYPGG/8PsQPoOkVZRfc
jST9RQMcRhWNiedX4hcm
=emDn
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
