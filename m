Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaJ0Qlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:41:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52758 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbaJ0Qlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:41:36 -0400
Date: Mon, 27 Oct 2014 11:40:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: Romain Perier <romain.perier@gmail.com>
CC: <heiko@sntech.de>, <devicetree@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>, <robh@kernel.org>, <mark.rutland@arm.com>,
        <johan@kernel.org>, <linux-pm@vger.kernel.org>, <linux@roeck-us.net>,
        <lee.jones@linaro.org>, <balbi@ti.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v1 03/10] regulator: act8865: Use
 of_is_system_power_controller helper function
Message-ID: <20141027164022.GC14253@saruman>
Reply-To: <balbi@ti.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
 <1414427215-14380-3-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Content-Disposition: inline
In-Reply-To: <1414427215-14380-3-git-send-email-romain.perier@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 04:26:48PM +0000, Romain Perier wrote:
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  drivers/regulator/act8865-regulator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/ac=
t8865-regulator.c
> index 76301ed..435aba1 100644
> --- a/drivers/regulator/act8865-regulator.c
> +++ b/drivers/regulator/act8865-regulator.c
> @@ -365,7 +365,7 @@ static int act8865_pmic_probe(struct i2c_client *clie=
nt,
>  		return ret;
>  	}
> =20
> -	if (of_system_has_poweroff_source(dev->of_node)) {
> +	if (of_is_system_power_controller(dev->of_node)) {

so building this driver is broken until this patch ? not very good
either.

Looks to me you should add of_is_system_power_controller without remove
of_system_has_poweroff_source() until all users of that have been
converted over.

--=20
balbi

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUTnV2AAoJEIaOsuA1yqRE1dIQAI73rs9tLjyf0P8i5zcdoT2T
FQEYzL6cJFekHJZGFr9HIBTgN+spy9Gop7DaIOeCZ8yFjW0/Kww69EYLuGYn/wsW
NZCRhBsZAfhajPt/S0jIE0yP8z2wF5iNVVDvOb0xOKWqxYPI4rLCX4uQSdtBboXY
73uj/6n5g/QDPIlHjOqWm0uEOZ1xNhEdmfr6WhpK5olUdGyc+vQCJetOxlSBeYrt
z7nBYUx1KiBChVcb5sYZAl5z800BqUkKfw/y58cela07YuH75ILviCfoXlOR7S83
XCzriZzrxzyYgbBF6YU9spD2z9cEVxL+4zivBw95gm49ZflhvWovbRU8jjM9YrWD
Jnyqh8X9Dn1R5rt2epAwBALqom3qyNdgCO3jEpfHtM6hBZYUJZV1wyAeUugAwMlM
ez8PFOTLyTmRqYzcA9Lh9HpEWf+5ERfFdEJbYLX9RdPqJqkS8zF+nvI4Hf94E2Ud
MiuRpYOwPm5LyP8PRfeLhZYrNmYZxEo3HyRa3Z4B6AvCHpNqXoe4dgjjWXOWMQEG
9XSvHN30ApRugMzuBXnYRPXpGIkRMnVCJz8DzE4g2n2hQc8c/P4gvmOSgUi4QuyC
6RqhkDPQShEzDzKY7WN0S6aFdDzJ36vlKKDtdOX81Z/azLGe1Vogj0bOg50THeCB
WEs4knb7t/xqA3jYV2KN
=OfHJ
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
