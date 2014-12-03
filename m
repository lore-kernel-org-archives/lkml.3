Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaLCNFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:05:05 -0500
Received: from down.free-electrons.com ([37.187.137.238]:40182 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752520AbaLCNFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:05:03 -0500
Date: Wed, 3 Dec 2014 14:01:36 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 5/8] ARM: at91/clocksource: remove !DT PIT initializations
Message-ID: <20141203130136.GK30256@lukather>
References: <e093d7cf37ec9ff24b0631b0a2e405a7cf7574db.1417541118.git.nicolas.ferre@atmel.com>
 <60ebb777ae686d2a8c6820f9c891d9a0dd0fd03d.1417541118.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hk6Zb6cduJ+I0Tmj"
Content-Disposition: inline
In-Reply-To: <60ebb777ae686d2a8c6820f9c891d9a0dd0fd03d.1417541118.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hk6Zb6cduJ+I0Tmj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 02, 2014 at 06:27:25PM +0100, Nicolas Ferre wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> As AT91 !DT code is now removed, cleanup the PIT clocksource driver.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> [nicolas.ferre@atmel.com: split patch]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  arch/arm/mach-at91/generic.h          |  2 --
>  drivers/clocksource/timer-atmel-pit.c | 32 -----------------------------=
---
>  2 files changed, 34 deletions(-)
>=20
> diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
> index 8527e8bd675f..d53324210adf 100644
> --- a/arch/arm/mach-at91/generic.h
> +++ b/arch/arm/mach-at91/generic.h
> @@ -31,8 +31,6 @@ extern void __init at91_sysirq_mask_rtt(u32 rtt_base);
> =20
>   /* Timer */
>  extern void at91rm9200_timer_init(void);
> -extern void at91sam926x_ioremap_pit(u32 addr);
> -extern void at91sam926x_pit_init(int irq);
> =20
>  /* idle */
>  extern void at91sam9_idle(void);
> diff --git a/drivers/clocksource/timer-atmel-pit.c b/drivers/clocksource/=
timer-atmel-pit.c
> index d5289098b3df..b5b4d4585c9a 100644
> --- a/drivers/clocksource/timer-atmel-pit.c
> +++ b/drivers/clocksource/timer-atmel-pit.c
> @@ -262,35 +262,3 @@ static void __init at91sam926x_pit_dt_init(struct de=
vice_node *node)
>  }
>  CLOCKSOURCE_OF_DECLARE(at91sam926x_pit, "atmel,at91sam9260-pit",
>  		       at91sam926x_pit_dt_init);
> -
> -static void __iomem *pit_base_addr;
> -
> -void __init at91sam926x_pit_init(int irq)
> -{
> -	struct pit_data *data;
> -
> -	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
> -	if (!data)
> -		panic(pr_fmt("Unable to allocate memory\n"));
> -
> -	data->base =3D pit_base_addr;
> -
> -	data->mck =3D clk_get(NULL, "mck");
> -	if (IS_ERR(data->mck))
> -		panic(pr_fmt("Unable to get mck clk\n"));
> -
> -	data->irq =3D irq;
> -
> -	at91sam926x_pit_common_init(data);
> -}
> -
> -void __init at91sam926x_ioremap_pit(u32 addr)
> -{
> -	if (of_have_populated_dt())
> -		return;
> -
> -	pit_base_addr =3D ioremap(addr, 16);
> -
> -	if (!pit_base_addr)
> -		panic(pr_fmt("Impossible to ioremap PIT\n"));
> -}

This can be a bit more cleaned up, by merging
at91sam926x_pit_common_init and at91sam926x_pit_dt_init, but you have

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--hk6Zb6cduJ+I0Tmj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfwmwAAoJEBx+YmzsjxAghl0QAKOeoxA67tlhBY4Hrnvl90Uw
fnXum82q8tYfTW0gFrowS13BAnldz8p6XANFki2sgSWkBuIW/67+VCyUO459ZNtL
uX+D7szG3lmv4SiuFp5ZLwhEkYlad46nR92eWxaKBnoETmiHeQA1vWyYlfHrm7LL
S0//S3gQCNIy6VElENxleqzE2dmFj77OHmFnIIR7+ZJmZOr+k4OTyQtJ8tzHPxaS
EXt6/Qp1Ca+yM0bnP/NiJIV+NHw9YnhjNUgeop2ibUyXAPkTvym+qC6A8vccMJZh
j7xb9pwd80vozThIL5Y1PgXYFpA3o4oTI/QxPGK/wzuaci6Z306yb8KXcpwI2Rvq
cKyGYNqstehPi6XAbK1Zjumj34jO+OYxhl1PHyj2Osz6uBAgaKrwC+0NGIVzJrvM
+FC9DYwdSAmw6s8FSQOEH2RDut1KK2RUsAA15/eU8yQeqdLPSC55Nf7aK/a2S6DN
UihMPNwtSU0jwnBMDV7iRgkSOtnyIk4Ane4cvc3WRpRYnIihmqL9dkPYRbyJ/fNh
Y0UNoDn41lcwl+dQ/AkWfobPkfmvrp7YkR6vh3iHJfXZDDzPkksS4U/j5Kynfk3K
KmBo2pTtEJprvURA/6JIVVqhuriMKy8bhiowxPLk9iH0p6IGPJ4yXKk6Ne2bIHCG
lMzfwZTaGuKlQAw3pRfO
=jBMy
-----END PGP SIGNATURE-----

--hk6Zb6cduJ+I0Tmj--
