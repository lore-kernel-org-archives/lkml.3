Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaBJKkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:40:39 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:42272 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaBJKkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:40:37 -0500
Date: Mon, 10 Feb 2014 11:40:34 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org
Subject: Re: [PATCH] backlight: add PWM dependencies
Message-ID: <20140210104032.GB20143@ulmo.nvidia.com>
References: <1391518634-6472-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Content-Disposition: inline
In-Reply-To: <1391518634-6472-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 04, 2014 at 01:57:14PM +0100, Linus Walleij wrote:
> In some compilations the LM3630A and LP855X backlight drivers
> fail like this:
>=20
> drivers/built-in.o: In function `lm3630a_pwm_ctrl':
> drivers/video/backlight/lm3630a_bl.c:168: undefined reference to `pwm_con=
fig'
> drivers/video/backlight/lm3630a_bl.c:172: undefined reference to `pwm_dis=
able'
> drivers/video/backlight/lm3630a_bl.c:170: undefined reference to `pwm_ena=
ble'
> drivers/built-in.o: In function `lp855x_pwm_ctrl':
> drivers/video/backlight/lp855x_bl.c:249: undefined reference to `pwm_conf=
ig'
> drivers/video/backlight/lp855x_bl.c:253: undefined reference to `pwm_disa=
ble'
> drivers/video/backlight/lp855x_bl.c:251: undefined reference to `pwm_enab=
le'
>=20
> This is because both drivers depend on the PWM framework, so
> add this dependency to their Kconfig entries.
>=20
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/video/backlight/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)

Hi Linus,

it seems like at least BACKLIGHT_LP8788 is missing a corresponding
dependency as well.

I have applied Sascha's patch to remove the obsolete HAVE_PWM symbol,
and this will fix at least the build issues. However it will also cause
the driver to fail at runtime because the pwm_*() functions won't work.

So I wonder if we should still apply this patch to make it clear that
PWM support is necessary to make the driver work. I guess the point is
somewhat moot because even if we had PWM enabled it could still happen
that no PWM driver is enabled to provide a PWM device... I guess it's
equally justifiable to leave that up to the defconfig.

Should we just drop this patch? Cc'ing Arnd who's commented on Jingoo's
alternate proposal.

Thierry

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+KygAAoJEN0jrNd/PrOhfbcP/3oRQku7bR3KbIgDBe50UF99
h6V/ToVfLD7tdhyHNz0sVLLJAeOUdCCRw2ABrDAQu27c1OH0ss38isg2866lZD4Z
9XMSmWkLYocmXjXyKAOgRdlSIJ9CDM8QWsH6V3ciBt7vKjt0e+bV7UXysuZCc3MI
IUcDm/VqxIXezK6MEpHmwRuTdUUiofiiTu+foYhsHTQtHvZ+zNoYTzn3iQBOcu04
3RkQWyf+N4MZ7mcTpK2o35/Zy9v6Z1i69J2vP9AxR3VxkdHHCJMfykPe0mtTzhUv
7qMhBS3vXPAdE0hIMzvQiaR2/N57RuEHVElWRUA/L0vnc5lAV9Kc1hUqegt4h3l7
oNzNnXQUIPIWKG7lqJHPPF6y7VyT0G2PKLsmyvmvD9IgugNY+Qgf4moeZm91veCZ
L9u8YijOV3OxRKwB+BahshF20evdeM4FG8JnXRbSe1m1rKKo+TkiweCzLvOEcGKf
/EAAH4bICc0grJ3d0aK+IbUrvlAto9djGyvIMqV1M+wU7Obc/dCPMomJh+/Pr7OF
/QnDmiLy944LKR5ACYsIJnJeEZVtJvKFuKnCdXEQhyxS24LPtJdCfBuEPJNYAnXj
hlYt9HuZdLDappgHcf8dB+PNky/6VrYSjhZM2g85ykHRCDuXecVwR5cZ5wIlvW8q
4+vAD7DCVRtUcuoCmts2
=71tB
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
