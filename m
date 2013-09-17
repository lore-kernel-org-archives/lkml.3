Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3IQWZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 18:25:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45017 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3IQWZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:25:43 -0400
Message-ID: <5238D6BE.6040603@pengutronix.de>
Date: Wed, 18 Sep 2013 00:25:02 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        nicolas.ferre@atmel.com, LKML <linux-kernel@vger.kernel.org>,
        Marc Pignat <marc.pignat@hevs.ch>, john.stultz@linaro.org,
        kernel@pengutronix.de, Ronald Wahl <ronald.wahl@raritan.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7Y=?= =?UTF-8?B?bmln?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] clockevents: Sanitize ticks to nsec conversion
References: <1379077365-18458-1-git-send-email-mkl@pengutronix.de> <20130917095600.GJ26819@ludovic.desroches@atmel.com> <20130917100417.GQ12758@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1309171210450.4089@ionos.tec.linutronix.de> <20130917130153.GL26819@ludovic.desroches@atmel.com> <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="lXvI9XfF7mgXCgDbuVn0cQiKUs2rrQQ7E"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lXvI9XfF7mgXCgDbuVn0cQiKUs2rrQQ7E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/17/2013 11:15 PM, Thomas Gleixner wrote:
> Marc Kleine-Budde pointed out, that commit 77cc982 "clocksource: use
> clockevents_config_and_register() where possible" caused a regression
> for some of the converted subarchs.
>=20
> The reason is, that the clockevents core code converts the minimal
> hardware tick delta to a nanosecond value for core internal
> usage. This conversion is affected by integer math rounding loss, so
> the backwards conversion to hardware ticks will likely result in a
> value which is less than the configured hardware limitation. The
> affected subarchs used their own workaround (SIGH!) which got lost in
> the conversion.
>=20
> Now instead of fixing the underlying core code problem, Marcs patch
> tried to work around the core code issue by increasing the minimal
> tick delta at clockevents registration time so the resulting limit in
> the core code backwards conversion did not violate the hardware
> limits. More SIGH!

It was not easy getting your attention with this problem :)

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--lXvI9XfF7mgXCgDbuVn0cQiKUs2rrQQ7E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlI41r4ACgkQjTAFq1RaXHPzFACeNit+gHlSELWSMdSOnu3lKCQU
YbwAnjjdVI2CSJEWKFCAj6qf3ZHDoP8V
=/iZ5
-----END PGP SIGNATURE-----

--lXvI9XfF7mgXCgDbuVn0cQiKUs2rrQQ7E--
