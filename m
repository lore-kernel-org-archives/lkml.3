Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3DWNLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:11:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60591 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab3DWNLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:11:50 -0400
Message-ID: <51768885.4080301@pengutronix.de>
Date: Tue, 23 Apr 2013 15:11:33 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Andres Salomon <dilinger@queued.net>, arm@kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: RFC: [PATCH] clocksource: tcb: fix min_delta calculation
References: <517687AB.1040309@pengutronix.de> <1366722524-25991-1-git-send-email-mkl@pengutronix.de>
In-Reply-To: <1366722524-25991-1-git-send-email-mkl@pengutronix.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2TJBODEXETGKJQWLACCBL"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2TJBODEXETGKJQWLACCBL
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 04/23/2013 03:08 PM, Marc Kleine-Budde wrote:
> The commit
>=20
>     77cc982 clocksource: use clockevents_config_and_register() where po=
ssible
>=20
> switches from manually calculating min_delta_ns (and others) and
> clockevents_register_device() to automatic calculation via
> clockevents_config_and_register(). During this conversation the "+ 1" i=
n
>=20
>     min_delta_ns =3D clockevent_delta2ns(1, &clkevt.clkevt) + 1;
>=20
> was lost. This leads to problems with schedule_delayed_work() with a de=
lay of
> "1". Resulting in the work not scheduled in time.
>=20
> This patch fixes the problem by increasing the min_delta to "2" ticks.
>=20
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

The problem appears on at91sam9263. This patch successfully fixes the
problem and applies to current linus/master (post v3.9-rc8).

regards,
Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2TJBODEXETGKJQWLACCBL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlF2iIUACgkQjTAFq1RaXHORuQCfQqefXtQMmK5qW68UR49i4Mx2
K+YAoJlCMeTQjgdfg3QBoMRT15tiMvK2
=8KhZ
-----END PGP SIGNATURE-----

------enig2TJBODEXETGKJQWLACCBL--
