Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbaDIHXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:23:48 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:38113 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaDIHXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:23:46 -0400
Date: Wed, 9 Apr 2014 09:22:50 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Tim Kryger <tim.kryger@linaro.org>,
        Lothar =?utf-8?Q?Wa=C3=9Fmann?= <LW@karo-electronics.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv3 1/3] pwm: make the PWM_POLARITY flag in DTB optional
Message-ID: <20140409072248.GB9886@ulmo>
References: <1395235375-12925-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-2-git-send-email-LW@KARO-electronics.de>
 <20140402055350.GX17250@pengutronix.de>
 <20140407113652.GE26985@ulmo>
 <20140408070259.68923987@ipc1.ka-ro>
 <CAAYSxhpqe1BVDigMKQ18qEpYNyHGFQ6n5cXWdnUO7HZKSCwzWQ@mail.gmail.com>
 <20140409061209.GF27055@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <20140409061209.GF27055@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 08:12:09AM +0200, Sascha Hauer wrote:
> On Tue, Apr 08, 2014 at 01:43:22PM -0700, Tim Kryger wrote:
> > On Mon, Apr 7, 2014 at 10:02 PM, Lothar Wa=C3=9Fmann <LW@karo-electroni=
cs.de> wrote:
> > > Thierry Reding wrote:
> >=20
> > >> No. You cannot emulate polarity inversion in software.
> > >>
> > > Why not?
> > >
> > > duty_ns =3D period_ns - duty_ns;
> >=20
> > Since I made the same mistake, I will pass along the pointer Thierry ga=
ve me.
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
> > Either way, hacking the duty in software certainly would get the
> > high/low order wrong.
>=20
> This only relevant if you have some reference signal the PWM must be
> relative to, for example if you combine multiple PWMs for motor control.
> For PWMs used for backlight or beepers a signal inversion in software is
> perfectly fine. And I also think that it makes sense to put it once into
> the framework instead of bothering all consumer drivers with the
> inversion.

The PWM framework itself doesn't have enough knowledge about what a PWM
is being used for. Therefore it cannot determine whether emulating
polarity inversion by reversing the duty cycle will be appropriate.

Putting such functionality into the core will prevent PWM channels from
being used for cases where the signal polarity does matter.

Thierry

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTRPVIAAoJEN0jrNd/PrOhW+kP/2SXBSep3q6wn+YsRYiVoNes
coOYOG/R8HlbayawosXhyaBNHFaFW+SNiNluy/9yEHEXpuAd6Yq9uQ7a+jXAHjtm
QfbrZtuF3JOWhlK1XYTcHzVLOzNjFwo8YghDpr2r++y+ueqwKlP11FXXqP+mPo/j
glpdS/wI/JiMng0+M9nL0Cy+DJDMtcdkFgAsriDga5lLGfXXmUYdSaG6A5HylsTN
JRIF/Ulyv58RwrhUgLoVciNAK6UgRK68kkEMF2Ed09RZvmC+bLNFrvJ4YoAxZcXP
PG/YvGbzueP1j/210zhjW/gFSxHDKHcB52MpmFJ13jmlYmx+Qo53To5EwNFeGG/c
ObOu30a/PdB/9UNMS1j/jMwMvfL8AMuEH+W39iI2x9FMRJutxALW89X8X4YgcGlP
QzklStfiZMZF0n4psSsArBZkA8CAnOQO8CdyeA/w5A+jNnZxsswfwIPOCa+q2K7H
DzRdJPq7HNaKYUjARKq2eRmQJw3CIcok3d8UmY1Z6dB3bkGBrcR5VWevChtiW+9w
t+EyUbfC9r5BCU9HqWY8GeSUUfwUTasPQobFRdrNwPVMGkjwiGwl/mxitKHGAt5h
Sacrd/l99arHBVw18Rtcfk3FSle5qCBEc83Eps1XYmr4CeWYeI98VyeJAwRFUTRo
tDbAmG+ztYtDOhik8HBC
=BJBY
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
