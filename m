Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaEMPzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:55:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40307 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753742AbaEMPzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:55:03 -0400
Date: Tue, 13 May 2014 17:54:01 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: p.zabel@pengutronix.de, marex@denx.de, wsa@the-dreams.de,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] reset: stub out devm_reset_control_get()
Message-ID: <20140513155401.GD29258@lukather>
References: <1399995245-15095-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Content-Disposition: inline
In-Reply-To: <1399995245-15095-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 10:34:05AM -0500, Felipe Balbi wrote:
> without that stub, drivers will fail to build
> when CONFIG_RESET_CONTROLLER=3Dn.
>=20
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  include/linux/reset.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/include/linux/reset.h b/include/linux/reset.h
> index c0eda50..aa94420 100644
> --- a/include/linux/reset.h
> +++ b/include/linux/reset.h
> @@ -75,6 +75,12 @@ static inline struct reset_control *devm_reset_control=
_get_optional(
>  	return ERR_PTR(-ENOSYS);
>  }
> =20
> +static inline struct reset_control *devm_reset_control_get(
> +					struct device *dev, const char *id)
> +{
> +	return ERR_PTR(-ENOSYS);
> +}
> +

reset_control_get should only be used in cases where the reset
controller is mandatory for the driver to work, and hence, this driver
should select or depend on CONFIG_RESET_CONTROLLER

If the reset controller is optional, reset_control_get_optional should
be preferred, that is stubed out.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTckAZAAoJEBx+YmzsjxAgzroP/17864W/yZno4i55nVn+wx4j
o7uoQI4rIhGSXlYLV1bt+7bPa+xgXCG+Ks8q5b46CeKDsdTEkR+aN8h8/rlx+Jei
PhnMUquy+qv0r/MVaeqLZrSS9S1Rdfer0MmA3Hfo9siCfNraLYk2Al1d61YUwbjY
z5VJnPfUrnUNsmFF/uAwlbK7T+8A0ylOVJBGwlF3AZ0I3AtDEbrcGD6ob0ZLy6v8
S/IOvlOB32BJmpMZziBbzueegv+iMH6lgfFDrf/UiTzRdtg5Vgddg6cDIiSMpW8H
IiObfglY1EQhKX7qDMFTkLam1iCSEDJ6wZpj/QtbkH+Obg9FWEoW5pLIJC5SMKML
H+HfpjzXimBDuhe7VCEDapbrKH+kecvviCXdEyZb76A6Pseyr/UAp0sGLIuzbSdT
GqKAm4GBYqlN4B+7531sRIXxQhwbxKHs1k0Onaljam/y+4eaqxm8Azw/ir0Hm6tQ
gRS3+O7pFv3W8OSbNZvLBFAiV8FQVrlP8MdtyohcF4zY3KBHF8G9hiMCyPjurqrA
G17z1tbpjc11AFspY85p8FAo2Oa9xo7aAeknGOE2rPxRLCMOclkPhOPMLwrLr6Ve
edPnmXIbFCdW1DGTQTGiKV1XlpZocAxCvdoF8G1WMhYAOVyunRbJ15Loiy0aX7OP
sDNMnrv1LppqDUFCSvDa
=c9ve
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
