Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaDGL3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 07:29:21 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:49291 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbaDGL3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:29:14 -0400
Date: Mon, 7 Apr 2014 13:28:23 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-leds@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 09/16] avr32/at32ap: switch to the generic PWM framework
Message-ID: <20140407112821.GC26985@ulmo>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395234209-15546-10-git-send-email-alexandre.belloni@free-electrons.com>
 <20140319141820.GA20872@samfundet.no>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c3bfwLpm8qysLVxt"
Content-Disposition: inline
In-Reply-To: <20140319141820.GA20872@samfundet.no>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 03:18:20PM +0100, Hans-Christian Egtvedt wrote:
> Around Wed 19 Mar 2014 14:03:22 +0100 or thereabout, Alexandre Belloni wr=
ote:
> > Switch to the pwm/pwm-atmel driver instead of misc/atmel_pwm
> >=20
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>=20
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
>=20
> > ---
> >  arch/avr32/mach-at32ap/at32ap700x.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32=
ap/at32ap700x.c
> > index a1f4d1e91b52..db85b5ec3351 100644
> > --- a/arch/avr32/mach-at32ap/at32ap700x.c
> > +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> > @@ -1553,7 +1553,7 @@ static struct resource atmel_pwm0_resource[] __in=
itdata =3D {
> >  	IRQ(24),
> >  };
> >  static struct clk atmel_pwm0_mck =3D {
> > -	.name		=3D "pwm_clk",
> > +	.name		=3D "at91sam9rl-pwm",
>=20
> I found this a tiny bit weird, but found the matching instance in
> drivers/pwm/pwm-atmel.c
>=20
> IMHO it would initially have been better to call it atpwm_v1 or something
> similar, more generic. But I guess that is too late to change at this poi=
nt.

Generally when you call clk_get(dev, NULL), you'll pass in the consumer
device as "dev". Now the avr32 clock implementation compares that to the
device associated with the clock, which for the case of the PWM pwm0_mck
is the PWM controller (at32_add_device_pwm() for reference). So it seems
to be set up properly (the PWM controller is the consumer).

Also since the consumer ID isn't specified to the clk_get() call, the
name of the clock (what's being changed in the above hunk) shouldn't
matter because it won't match anyway.

Now that I look at it more closely, I wonder how clk_get(dev, NULL) can
even work on avr32, since there's no check for id =3D=3D NULL and therefore
NULL will be blindly passed into strcmp() and then crash.

Thierry

--c3bfwLpm8qysLVxt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTQovVAAoJEN0jrNd/PrOhucMP/AoHAzsOLJ8icc3WxuDeKNY6
/iZXiKYAOTW9/P7d1aerqWy2hc3wA7+hyOIQl7JtCWZ/cCO+/5b1Xp67LWn9OKQO
6TwrNphjftw8OGEzgi0ENgM46WYWwdtZF7PZPv6F5+HdwegQjUJBDnja8o8gQBle
o0U1KyZ+ycjOYGIc9+tNF6Omi6MbA9Q5HVKsLO621EmcSCxuGZqfO6Kv7gMn79Ib
+U0C99mPadGEhxgXGu6WIvR0mDZEl1jS0Typ9Jcc5WEtClrlD58/GZJjiu2xUKG7
OCITv3A1JmFRZ0+2d9OreXSUlzbUBKFZX0tvbmIdfDwuIFyYvMDGwofFX+N3htDm
GjjFZsHz2QjGnzIFtmkuBroi/kSvgvauXhc8RTwc4bz1E6FL89of1YJFpZewRY93
PpNvv0wKXd3OOcT7NZg+Z0sDBRlorOurGRQzPqW1zsF605Du54EoiQiZdNo1IVfV
rJjeQQ4oGSIowepcFuuzLcRL3uLlfS/zVJMe3G4OlSC/knCORLUN07DzpceQrJcN
mb083m4AV5tbKnjMc2nXu78Th6LmlWG+ZFgOI0mF0rcIK1SedkBj2wXUEVWL+KyV
PMoDhJyO1Joguxw1fksl+zIvYEDIB8NCEiqi/Oj5O/bQ1mw5Hxx9qQ87Jfexi7aW
R+IlGh54dZmwsMUEum54
=b9uY
-----END PGP SIGNATURE-----

--c3bfwLpm8qysLVxt--
