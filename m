Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3BDLIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:08:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54442 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3BDLIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:08:12 -0500
Date: Mon, 4 Feb 2013 12:08:04 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: amerilainen@nvidia.com, airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5,RESEND 5/8] drm: tegra: Move drm to live under host1x
Message-ID: <20130204110804.GA595@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-6-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <1358250244-9678-6-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ddo6RKPAtDSfOp9lQGR7LeE4zglyybrKI7IGTMG9Cx4
 XhrknZh3naJR0+Kb9wS9RNOUFsEZOKIkJE8dlDSMBaYROZhyxD
 OJO7l5HSYMQpk9/W4xyHodFzHWLvcsq+eWZznWglxide0ZG+rz
 fTtQEgTXg6NLid+URfGiu3Sr7LT/R3z+Vr2zyPIUZrKon6a+SL
 n8g9SLcnzRO5ubFTQG/tm+SfgZTFKbe0q0ePNBLB8znIwP9EAX
 MY+sJA2J8G6RpDKBY3IwIRQd/HoCQIUPya7hq1Pd8PgypAkMj0
 pQuVF0RiNWciDIJ8BHx7ACDXpKP1NNy7m9JQ0PwsP84hEueLPi
 YidxRXzjEsiWgyOj/ffQA9zL2RGmwnigjU1VtBxcKArV+LtLXO
 G8xJbB+a7b/+J0ulRLuU3B3xAw/51+MoP8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 15, 2013 at 01:44:01PM +0200, Terje Bergstrom wrote:
[...]
> diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
> index 697d49a..ffc8bf1 100644
> --- a/drivers/gpu/host1x/Makefile
> +++ b/drivers/gpu/host1x/Makefile
> @@ -12,4 +12,10 @@ host1x-y =3D \
>  	hw/host1x01.o
> =20
>  host1x-$(CONFIG_TEGRA_HOST1X_CMA) +=3D cma.o
> +
> +ccflags-y +=3D -Iinclude/drm
> +ccflags-$(CONFIG_DRM_TEGRA_DEBUG) +=3D -DDEBUG
> +
> +host1x-$(CONFIG_DRM_TEGRA) +=3D drm/drm.o drm/fb.o drm/dc.o drm/host1x.o
> +host1x-$(CONFIG_DRM_TEGRA) +=3D drm/output.o drm/rgb.o drm/hdmi.o
>  obj-$(CONFIG_TEGRA_HOST1X) +=3D host1x.o

Can this be moved into a separate Makefile in the drm subdirectory?

> diff --git a/drivers/gpu/host1x/host1x_client.h b/drivers/gpu/host1x/host=
1x_client.h
[...]
> new file mode 100644
> index 0000000..fdd2920
> --- /dev/null
> +++ b/drivers/gpu/host1x/host1x_client.h
> @@ -0,0 +1,25 @@
> +/*
> + * Copyright (c) 2013, NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef HOST1X_CLIENT_H
> +#define HOST1X_CLIENT_H
> +
> +struct platform_device;
> +
> +void host1x_set_drm_data(struct platform_device *pdev, void *data);
> +void *host1x_get_drm_data(struct platform_device *pdev);
> +
> +#endif

These aren't defined or used yet.

Thierry

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRD5aUAAoJEN0jrNd/PrOhKaYP/1935u+Jh8WXS/aXQQ8rn1PL
4NSOlIST1cebnRj4rJwOwh1GSAGM4uwaPKtHg7bS/qVTaTIpX2G7eO6yUybdlygp
mA4WQw5Kj164RMZiXEIBV62iNFNElQz4oNnONDGg7FDJWcZn3xqirJhqP5jeerly
JxksCVb4TtPdguAr+sWWrO5Hpw3QksNbr0gfSXgwmN9Tmbgd1mIPEsHY9ok8tUQl
916SjTk6WCu6rzj3vsKQI/gvGhRwMjACBqyaWcbPjOpzommh9bfNUms4UlbyKNJh
gY1PWxOs2eF4BA5VcbduYnqJuDqHZ2z+V3tH+vARCoEM8o+83DBRFL4ohxuAO+hn
ODSUevkUJck7AH5Up+Z4fIzRTDZGNybd8+1HwbNyqnlQTyIptYhLBnoS2oE4M6cm
u6Q9oiUXoGDFV3SMbn6qDWNeWNnzU9ZFKgbbokHrLIZADhLSSsO1sD5DMTsV+wyC
z6sttHGVyUW1yhRtf7EoNsx57+cBm1zdMYoruogS3U9M0gJwtqcaiUIiXctny0cC
cTnIgx5jJxCX3Vbe1DYph2q1NuBMM0ZkB4q77CX2bTDXqTrVNg+OgeFjycWyJd4p
aNoG8vsFw2OxsTrrwXkF1YFQCVad82HUWOjQYoh2i558oKK3nyfDO6l4PA2hz+hq
fWpdbtX6peKVBsGkC2tv
=fpe1
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
