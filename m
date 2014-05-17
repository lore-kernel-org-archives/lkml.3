Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaEQVYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 17:24:31 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:55530 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaEQVY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 17:24:26 -0400
Date: Sat, 17 May 2014 23:24:22 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Manuel =?utf-8?Q?Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Cc: linus.walleij@linaro.org, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] pinctrl: Cleanup string initializations (char[] instead
 of char *)
Message-ID: <20140517212421.GD1046@mithrandir>
References: <1400337445-25750-1-git-send-email-manuel.schoelling@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HWvPVVuAAfuRc6SZ"
Content-Disposition: inline
In-Reply-To: <1400337445-25750-1-git-send-email-manuel.schoelling@gmx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 17, 2014 at 04:37:25PM +0200, Manuel Sch=C3=B6lling wrote:
[...]
> diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-te=
gra.c
> index 6545809..43eeb1b 100644
> --- a/drivers/pinctrl/pinctrl-tegra.c
> +++ b/drivers/pinctrl/pinctrl-tegra.c
> @@ -576,7 +576,7 @@ static void tegra_pinconf_config_dbg_show(struct pinc=
trl_dev *pctldev,
>  {
>  	enum tegra_pinconf_param param =3D TEGRA_PINCONF_UNPACK_PARAM(config);
>  	u16 arg =3D TEGRA_PINCONF_UNPACK_ARG(config);
> -	const char *pname =3D "unknown";
> +	const char pname[] =3D "unknown";
>  	int i;
> =20
>  	for (i =3D 0; i < ARRAY_SIZE(cfg_params); i++) {

When this hunk is applied, the build fails as follows:

  CC      drivers/pinctrl/pinctrl-tegra.o
drivers/pinctrl/pinctrl-tegra.c: In function 'tegra_pinconf_config_dbg_show=
':
drivers/pinctrl/pinctrl-tegra.c:589:4: warning: assignment of read-only loc=
ation 'pname' [enabled by default]
    pname =3D cfg_params[i].property;
    ^
drivers/pinctrl/pinctrl-tegra.c:589:10: error: incompatible types when assi=
gning to type 'const char[8]' from type 'const char * const'
    pname =3D cfg_params[i].property;
          ^

As you can see, pname is used to store a property name and the default
value is set to the static string "unknown" for cases where no matching
parameter is found in cfg_params. However, if a match is found the
default value will be overwritten, so you can't use const char [].

Thierry

--HWvPVVuAAfuRc6SZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTd9OFAAoJEN0jrNd/PrOhbVwP/Ra3RGk32WfUMOA17XaUKCMM
a4pjeE4SMSBjtoftO71aT+w5QOrcMXYLAOHx0cJCvdmwzZccfVm/zRsd3/D1Qigb
Z+G87c4toTcczV9S/19uwb0Iy021CiAqFbGW/dV9/9sQoKqRolf9JK45gi12WyOI
kL0q9lx5XqgfBMt8AujH/gf5HwdBAh/dMRaXBOOapgHKgCBWEoprxv2dghttPAXy
fGOjDCSK5F5ObvhtyrJwIMRWDA5Tly/I3ddfeY6JKtpjHjP6UgTrN0RpNANAi3lx
MUqSJhtGyhNilvfNOTE+qbpzN2THwTHM57a3WUiFIm/aMO4d4ZSSy+JIIh1Se774
3R4YxstkSI7fWGe//QfcpUBdL7Wz9q2gxj9ZbIEGosYLipBTiS7esYKYEFvKbpaN
uLEZ+eTJdjKYg5KG1QaQJ9UDqq9buOTohr2b4oA1KEx6BbGyTgw22wy9UahDPUTZ
2WJlOuZlC9vY5JIRNBkNq1RfCX3SWLrwIxI9MRlZz7moKNtT+z+b5ymiggWL7ros
VrkqafInq+UR/noK9lCXs4J6hkC9saWPgmumPQlHIDzWv0MF5XA0lO7k5UyabBf+
jyZWSSYrgnp+fpOaLes3U190x6UO+ugyisYWUzIZ8WaD3hXMbUSOd4J4xeo+e2lY
8adhmpi7K7Dhkf4vqbkh
=tfQb
-----END PGP SIGNATURE-----

--HWvPVVuAAfuRc6SZ--
