Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaKHReM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 12:34:12 -0500
Received: from sauhun.de ([89.238.76.85]:36759 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbaKHReK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 12:34:10 -0500
Date: Sat, 8 Nov 2014 18:35:13 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Yuan Yao <yao.yuan@freescale.com>
Cc: marex@denx.de, LW@KARO-electronics.de, mark.rutland@arm.com,
        fugang.duan@freescale.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v9 3/3] i2c: imx: add DMA support for freescale i2c driver
Message-ID: <20141108173513.GA4900@katana>
References: <1413025032-14958-1-git-send-email-yao.yuan@freescale.com>
 <1413025032-14958-4-git-send-email-yao.yuan@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <1413025032-14958-4-git-send-email-yao.yuan@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

mostly looking good...

> +#define IMX_I2C_DMA_THRESHOLD	16

Have you guessed or measured this value? A comment about this value
would be nice.

> =20
> +struct imx_i2c_dma {
> +	struct dma_chan		*chan_tx;
> +	struct dma_chan		*chan_rx;
> +	struct dma_chan		*chan_using;
> +	struct completion	cmd_complete;
> +	dma_addr_t		dma_buf;
> +	unsigned int		dma_len;
> +	unsigned int		dma_transfer_dir;
> +	unsigned int		dma_data_dir;

Please use proper types as there are things like 'enum
dma_data_direction' and the likes...

> +	dmaengine_submit(txdesc);

This can fail, too. Use dma_submit_error() to check.

> +	result =3D wait_for_completion_interruptible_timeout(
> +				&i2c_imx->dma->cmd_complete,
> +				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));

Have you tested signals extensively? I can't really recommend the
_intrruptible_ here. I don't see any cleaning up to get the bus to a
consistent state again. Most people drop the interruptible sooner or
later.

> +	/* Init DMA config if support*/
> +	i2c_imx_dma_request(i2c_imx, phy_addr);

Make this function void? DMA is optional anyhow.

Thanks,

   Wolfram


--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUXlRRAAoJEBQN5MwUoCm2U+EQAJ/DRCiZOK6+0nPvIzvKf0rk
Wo+0V2G/+ZWY0TNqQ/x4XuORsIvx3vyxvrzR7Kvm4+gHAiOrDqrH6LuX6jJXb/q7
3TbD8VPgJxmGaabJoUfXCgpUS3BU+CBM1DSiufSpKafoKWKV2eN6OmcS0sLZggKZ
ZtNn44neHVj2nx5texSRe69ABraT/jdyiV0SD10dcR6WkknfN/1GZdtuZkW5Fr5I
ZQroKMfs7vJPEmJsrWTgMqmk7U9Nd9hdEimHhOzHJQ+eJK5Uj+bHhhyq/1UPSuM0
m1WchTTlzfxl8LZn52UjVzpAPcls2SSUR9ADWFv3F3XJa5QonA0MasSUu0J0WkD0
rCMPX20+cilSDh01zcatWHVkgkoHazsWzDFJO151AmhskEUbu9G8aaw9F7VonynE
rF/a+bjVSfqN7Tp+zMoJP78rM/mcqyzoC0titXXYQs5mmV/4Wrf6OGwdo5aO+x2K
XfWD4jNCr8E5SMzYQSkabPqrReznLwRDHE56XoWSFaCLTJiJMrJU+HrdUP5zS18s
0hVaiBHMl6ti/lPaCkAzbcJQwr+9SmOKjWC8/pHJHwQbl63UpvpK7d/6Ixcx2qeC
akFMNMEbKjwyfMuquggp7g4ZY5pGcSMvGuYLt3q4JtCi1xWTYRjvBvYbE4Ty22tt
TGkSq1ohA2TEoTYWBNLp
=xq7W
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
