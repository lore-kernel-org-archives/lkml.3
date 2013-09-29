Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab3I2SoX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 14:44:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51182 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754738Ab3I2SoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 14:44:21 -0400
Date: Sun, 29 Sep 2013 21:44:14 +0300
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] clocksource: Add Allwinner SoCs HS timers driver
Message-ID: <20130929184414.GB2939@lukather>
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
 <1380117790-19390-3-git-send-email-maxime.ripard@free-electrons.com>
 <52437062.5040705@elopez.com.ar>
 <20130926131329.GQ2954@lukather>
 <5247ADC0.5080204@elopez.com.ar>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <5247ADC0.5080204@elopez.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2013 at 01:34:08AM -0300, Emilio L=F3pez wrote:
> >>Also, would any special considerations be needed when adjusting the
> >>ahb clock? A future cpufreq driver will most likely need to.
> >
> >While this will be needed at some point, I don't really see how to
> >handle that properly. The clock framework doesn't seem to have any
> >callback when it comes to reconfiguring a clock that a device might
> >use.
>=20
> Maybe we should consider using one of the other timers; from a quick
> look at the A20 user manual, it seems they can run at ~200MHz
> ("PLL6/6" as input)

Which timers are you talking about? I only find the usual timers we
already have support for and the timers supported in this user manual.

> >This will also creates trouble for IPs such as the I2C that have to
> >setup internal dividers, and use clk_get_rate to do so.
>=20
> Not really, because they use APB1 which is not scaled. The manual
> makes it explicit when describing APB1:
>=20
> "This clock is used for some special module apbclk(twi,uart,
> ps2, can, scr). Because these modules need special clock rate
> even if the apbclk changed."

Hmmm, right. But still, we can have IPs that depend on this one that
requires to readjust their internal rate whenever AHB is recalculated.
These HS timers for example :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSSHT+AAoJEBx+YmzsjxAgeesP/1vPyOkGlb52C2Do0MACyltU
ZhBKFoG1+aLqms7BMbKPXZl0EdnwUXLG0cvefbY5x40AAYzPO9Fj3noOgwQ2L45g
Im3EZWrPQ0eMlogkaNnevnVQM1oWMx76/VQ+JNIlLS5J7VE9TQ/Hcgt+onQBLi74
RZvWs2Gftesa9WfEUcVjHGWr81T2iop6AHymHrzQsCdQMmStOADyPNymzA/KJI0y
c2LvpXDK3zGVGDp14o+4ppQL+1Yb4qtlSjvFm0RVhvUOBtwiwAu12jq+VqHdQu0s
C/Ho8pECDMmZjo8gz850CUtjnqr8l53mhyYpeSUReqsfpi0k1FMkGDCvQXE3Y5O/
0StzDmjI1hSxKE1eJOSSbXRfSpj5IyeMEcarWhkGZQjEL15xWv8piOvOCWFx2/WU
LodxJJqHyhtv/JSYxsYujPFQvwrnrw7RONglXzkXfWPU7n6pL8xv0eJ1QPyQzL+3
ldrA4xDE6P/tHsW2PkLtNpOLSc3d1PpcHzFLGo7ZHgoN3+PdgwzKB+6sad0zB1rm
3b58YfKqMsVDunE43jfSaNADexDA1nuavKEmVxjK/edTGDqg3ma1zZQHYmsja14e
8+k38oS9ud3pGeSQA2+o8ibx0E4Z/tsOf4L6PlHVHm/kTsprDNOOnfBBifMSoK7X
NjyZWn6MhTndpvienM/y
=7m+R
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
