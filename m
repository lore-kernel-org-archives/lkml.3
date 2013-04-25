Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab3DYNhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:37:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59138 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab3DYNhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:37:17 -0400
Message-ID: <51793172.9030802@pengutronix.de>
Date: Thu, 25 Apr 2013 15:36:50 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Andres Salomon <dilinger@queued.net>, arm@kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: RFC: [PATCH] clocksource: tcb: fix min_delta calculation
References: <517687AB.1040309@pengutronix.de> <1366722524-25991-1-git-send-email-mkl@pengutronix.de>
In-Reply-To: <1366722524-25991-1-git-send-email-mkl@pengutronix.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2EJVVDBJDMFMHGKXVTWRL"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2EJVVDBJDMFMHGKXVTWRL
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

Who will take care of this patch?

Marc

> ---
>  drivers/clocksource/tcb_clksrc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb=
_clksrc.c
> index 8a61872..7cf6dc7 100644
> --- a/drivers/clocksource/tcb_clksrc.c
> +++ b/drivers/clocksource/tcb_clksrc.c
> @@ -197,7 +197,7 @@ static void __init setup_clkevents(struct atmel_tc =
*tc, int clk32k_divisor_idx)
> =20
>  	clkevt.clkevt.cpumask =3D cpumask_of(0);
> =20
> -	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
> +	clockevents_config_and_register(&clkevt.clkevt, 32768, 2, 0xffff);
> =20
>  	setup_irq(irq, &tc_irqaction);
>  }
>=20


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2EJVVDBJDMFMHGKXVTWRL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlF5MXYACgkQjTAFq1RaXHNiFACaAjwTQA5eagZjhP+QQJYxUYsF
1XcAn2FUu8tweA6guS6skxauU6fR+IXu
=L/0D
-----END PGP SIGNATURE-----

------enig2EJVVDBJDMFMHGKXVTWRL--
