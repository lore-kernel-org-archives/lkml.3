Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaC0AOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:14:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48930 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaC0AOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:14:19 -0400
Date: Wed, 26 Mar 2014 19:12:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Balaji T K <balajitk@ti.com>, <chris@printf.net>, <ulf.hansson@linaro.org>,
        <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] mmc: host: omap_hsmmc: set max_blk_size correctly
Message-ID: <20140327001216.GC30531@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395878690-9650-1-git-send-email-balbi@ti.com>
 <1395878690-9650-6-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sHrvAb52M6C8blB9"
Content-Disposition: inline
In-Reply-To: <1395878690-9650-6-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sHrvAb52M6C8blB9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 26, 2014 at 07:04:50PM -0500, Felipe Balbi wrote:
> @@ -1867,6 +1879,37 @@ static inline struct omap_mmc_platform_data
>  }
>  #endif
> =20
> +static void omap_hsmmc_set_max_blk_size(struct omap_hsmmc_host *host)
> +{
> +	struct mmc_host *mmc =3D host->mmc;
> +
> +	if (of_device_is_compatible(host->dev->of_node, "ti,omap4-hsmmc")) {
> +		u32 mem;
> +		u32 reg;
> +
> +		reg =3D omap_hsmmc_read_no_offset(host, OMAP_HSMMC_HL_HWINFO);
> +		mem =3D OMAP_HSMMC_HL_HWINFO_MEM_SIZE(reg);
> +
> +		switch (mem) {
> +		case 1:
> +			mmc->max_blk_size =3D 512;
> +			break;
> +		case 2:
> +			mmc->max_blk_size =3D 1024;
> +			break;
> +		case 4:
> +			/* FALLTHROUGH */
> +		case 8:
> +			/* FALLTHROUGH */
> +		default:
> +			mmc->max_blk_size =3D 2048;
> +			break;
> +		}
> +	} else {
> +		mmc->max_blk_size =3D 512;       /* Block Length at max can be 1024 */

looks like here, we could read CAPA register to figure out if older
devices support bigger block sizes. According to TRM, omap3 should
support 1024 just fine.

--=20
balbi

--sHrvAb52M6C8blB9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTM2zgAAoJEIaOsuA1yqREr4MQAKfXD7YGglaQR9xZ/pJM8uvD
MmFZSirUnoz7NmJ4JQXq64dGOB2BVWEu2cGrrcbCSY2MWF6G7CTdG1Rx/Mn5HMYi
xgmyUTFT+uX4p6agFX0EyCYY05mjUhcbsMK/Wc0X+7EnbLUA/KJy9VGOWZdC+2sd
e2CPfW/We7ZfU4A+QE7s7WNglSa2t9bRxw5pTSnQ4eMcTWVyvs7u1cK2f+gvE5LN
FRwAGme+Na6Wh4j5r/V8Z/07VJ0L1ipn6Zhmo8GTi4N9e/tTMPkvmuhIWsS/vRLI
fXfZH1ogzn/xFBYhQ7840PZoguBLg7pNf8uTg0xxsXg4/tjjOa7oCS7UaiCjwj55
ZBSlmIHqqTyDDxdhexM7MxO/Lvhxko3xcm0qZF1CDW5sVeNjLTng1ST/tiNGYSvc
/ReUkspObPlXeB2QYpwtFgwPzfDsJ2IEW+dm/dVo/LDQkSciBCxij5hGMsjlJGOd
J92mQNt6utf4xgRnQ41nP+Yq/grrY3KVR9eL3/dBIOgvabzxJ1SEbrwtGpi4fDMy
5+C0EHfjOjhRqTLiw/1tiUncOqqLtsTHopzT6VGdTBWKsolyfSzku8mWoMAyUT9P
FIIAee4k9GNLdVDo/QDlO+cnXnWaPW/WxjWJk+ea3x9pHH/8R31eDSldRP1aB0Z2
MXLYAi1CpQZAW9jZmn5e
=Reqr
-----END PGP SIGNATURE-----

--sHrvAb52M6C8blB9--
