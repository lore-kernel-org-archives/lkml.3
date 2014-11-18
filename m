Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbaKROxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:53:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44435 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162AbaKROxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:53:47 -0500
Message-ID: <546B5D5A.8020304@ti.com>
Date: Tue, 18 Nov 2014 16:53:14 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Hans de Goede <hdegoede@redhat.com>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Luc Verhaegen <libv@skynet.be>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: linux-next: build failure after merge of the omap_dss2 tree
References: <20141117190905.4e96294a@canb.auug.org.au>
In-Reply-To: <20141117190905.4e96294a@canb.auug.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="OqvjuiOJgstrjmFCM7nIoLAhoTvasBlH3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OqvjuiOJgstrjmFCM7nIoLAhoTvasBlH3
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks Stephen!

Hans, have you had a look at this? kbuild test bot also reported this.

 Tomi

On 17/11/14 10:09, Stephen Rothwell wrote:
> Hi Tomi,
>=20
> After merging the omap_dss2 tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>=20
> drivers/video/fbdev/simplefb.c: In function 'simplefb_clocks_init':
> drivers/video/fbdev/simplefb.c:207:2: error: implicit declaration of fu=
nction 'of_clk_get_parent_count' [-Werror=3Dimplicit-function-declaration=
]
>   par->clk_count =3D of_clk_get_parent_count(np);
>   ^
>=20
> Caused by commit fc219bfd5b2e ("simplefb: add clock handling code").
> This build does not have CONFIG_COMMON_CLK set.
>=20
> I have added the following fix for today (there is probably a better
> one):
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 17 Nov 2014 19:05:42 +1100
> Subject: [PATCH] simplefb: make it depend on CONFIG_COMMON_CLK
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/video/fbdev/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
> index 025b439d4fe1..1f0298e166c3 100644
> --- a/drivers/video/fbdev/Kconfig
> +++ b/drivers/video/fbdev/Kconfig
> @@ -2457,6 +2457,7 @@ config FB_HYPERV
>  config FB_SIMPLE
>  	bool "Simple framebuffer support"
>  	depends on (FB =3D y)
> +	depends on COMMON_CLK
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
>=20



--OqvjuiOJgstrjmFCM7nIoLAhoTvasBlH3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa11aAAoJEPo9qoy8lh71cpAP/RaKarGAGy0eJG47TOxOs+Gf
99quEgYX4ygJpDTZ0ggUMS+98asJg6hXIuSen3GtSFg9ilBPX/wTN53zJH/F36Zx
9CMF5L0dKffgxH4qWjkk5qA1gQEiM1K66aloIUUMK9b46AzP7CE0qVBkn+O7j8Zz
uFDZuhU0RYaMJ4v7VCbyV95LXo7qQ8EVm2rl0Y10wfowHfXGgXSOBvIcVXbh5dFq
UG2jgI5uAwvg0hS1xT+gMLaKmjUrbFOx7s3iFMcj4fGfGwwQfKT7Dd7CABJdIFGy
sms+6b0ymGXrHXhLDOkfr076R+C+++YxKH4ZUzdk4XXbP2q/CY4ApmXJ/dWRCxMR
/emJ8AZaEI99gWTiirMhQO9d1BCyl5A84bdR25Gnk8nGgdu1C0g9EVEUd3PKQCny
y/PCGaV8eyTJ3kv2I0qFn0qzo9SnSwO0N+ewaZxTnfAy1Lrr3/jGp5noGmh40+F/
ZZ8n8goL67EsWutTFv7DToAaehERORGqvzDkzdC5BQNaezwVwPJyD+Jl00Qw7Wtj
k73wo6gA5cFCNMIb9+DSGCl5MZslk4ZnN0FE6WSGnEM/mSyOQOmYKdtqAFhSQXBt
FwUcEuxGF3n6YiYd92YZD2ApGEIGWC3G9aXk5waBIDDUeqzwuIjqHkWDYJMEGFcK
gkVe2YBQ1SKKuF7taGee
=5dAf
-----END PGP SIGNATURE-----

--OqvjuiOJgstrjmFCM7nIoLAhoTvasBlH3--
