Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762611Ab3ECNpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:45:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762417Ab3ECNpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:45:43 -0400
Date: Fri, 3 May 2013 15:45:39 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arto Merilainen <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: Re: [PATCH, RFC 06/22] gpu/drm: host1x: add dependency on Tegra
Message-ID: <20130503134539.GA18652@avionic-0098.adnet.avionic-design.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
 <1367507786-505303-7-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <1367507786-505303-7-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:DAo530alXAO0UGm++0T6dllqyLgf9QNQeq86BgUE/QP
 XsVba0ExMWsY5Wbp1oFlhgIu7jPDZ3rpSCgEfuh4FO+94XF/Uw
 LbCPsZSoXGV0DdHEkUue/HEUD4EJrb4oN0bE/XtUVNYwolRv3t
 gOvu4N9/2xWKw3QoUjcWpb5zt/lO6pAuO3dA8Rrk8jhkQEwb8n
 CdHz1N/T92HMs23dCqPQEec/jyKN6XWDC0Hj0r85H4rmgY8xk6
 Or+lFhsket8gyLoeGy/EEGS3hxlOFAb6t5Ynq0i/z8ph5S6be2
 IcvJZQM0j/4R9prw6olN8teutmognc1mRdgeOYpNdRPcP4PGbN
 DQCIXWscMt++4DruKoqwJN7cYKGiHwgIxM5jSdAXx46Ovv0HE8
 6datrfmbt2RvbmSt20tgY6OsXY6WNsp/MA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 02, 2013 at 05:16:10PM +0200, Arnd Bergmann wrote:
> While we try to make drivers platform independent, this driver currently
> calls into an exported interface that is only provided on its own
> platform, so we have to add the dependency.
>=20
> drivers/built-in.o: In function `tegra_crtc_prepare':
>  drivers/gpu/host1x/drm/dc.c:650: undefined reference to `tegra_periph_re=
set_deassert'
> drivers/built-in.o: In function `tegra_output_hdmi_disable':
>  drivers/gpu/host1x/drm/hdmi.c:840: undefined reference to `tegra_periph_=
reset_assert'
> drivers/built-in.o: In function `tegra_output_hdmi_enable':
>  drivers/gpu/host1x/drm/hdmi.c:651: undefined reference to `tegra_periph_=
reset_assert'
>  drivers/gpu/host1x/drm/hdmi.c:653: undefined reference to `tegra_periph_=
reset_deassert'
>=20
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Arto Merilainen <amerilainen@nvidia.com>
> Cc: Terje Bergstrom <tbergstrom@nvidia.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/gpu/host1x/drm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/gpu/host1x/drm/Kconfig b/drivers/gpu/host1x/drm/Kcon=
fig
> index 69853a4..5a6a5cd 100644
> --- a/drivers/gpu/host1x/drm/Kconfig
> +++ b/drivers/gpu/host1x/drm/Kconfig
> @@ -1,6 +1,7 @@
>  config DRM_TEGRA
>  	bool "NVIDIA Tegra DRM"
>  	depends on DRM
> +	depends on ARCH_TEGRA
>  	select DRM_KMS_HELPER
>  	select FB_SYS_FILLRECT
>  	select FB_SYS_COPYAREA

This was solved by a patch that went into Dave's DRM pull request for
3.10 by adding:

	depends on ARCH_TEGRA || ARCH_MULTIPLATFORM

to the Kconfig entry for TEGRA_HOST1X. The plan was to eventually remove
ARCH_TEGRA from that condition after 3.10 since ARCH_MULTIPLATFORM will
include ARCH_TEGRA anyway. I'm not sure why that patch hasn't made it
into linux-next yet, though.

Thierry

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRg7+DAAoJEN0jrNd/PrOhCmAP/RyjMD+f0XEN1eYUQX6Gt6v/
1MK4j1jL3WrTQhzSGCOQvy5o0k+zzhsf4dgfVmzugTMefJXoqABTfcl1fiTPwlXv
y5hukc6xDo52UuDiPTi3wNUOeswaOlF77eELtBdh6jn3xfScVvdNEKsHIO8BlxlW
nf17u5kTkKA3V3fRV7oHrYommLUwAPXsWX/mzAcy/0yTrwRE8RLCLM1DGcyULYJM
Rewx3iuq5X5cXiJGmxOCPKxe5traz+zvNimf2unAZPznjR+0P/HUY+CXnlYlRDXZ
DchxBIfsoiJZKs6+vol8YW/fu9noWMA53qx9EW1ihgeEDlh5ildBjcb02cRdCOQj
DBLJ9a7QZA4rTs0Q0d6MfqxwBT21UtcHQ3qKe9tiMAZ1H5YAxLcyjvQ4W2dtOI08
y/mmdRPf5R+aWwNKT0b1q02gr5ojs+xPge0S87Wcxcsd4MWMgZIE6VnaaMISqAe6
0k6SGQUHfvcnV6gXppGiUD7YNw5CU0/ZuB9eXRpwRVhr4sEsMLLWGAEdE2PFZC2p
CrvFm93oU3Jj8IQtiV7bfdvx6A7Fzd4anH/rCBVvNiDuw9JoJsYjqKJE7rT/yuji
5QVXLqjgNzkTfT02V1GD10bb8SdJ/bYUv2szW5+9q+zGMHGsWYSunTd2pLIgb9iK
fWd7ykq06Qt0OaIrrSXK
=WhtH
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
