Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaLCL2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:28:41 -0500
Received: from sauhun.de ([89.238.76.85]:50479 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbaLCL2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:28:39 -0500
Date: Wed, 3 Dec 2014 12:28:30 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Harini Katakam <harinik@xilinx.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, michal.simek@xilinx.com,
        soren.brinkmann@xilinx.com, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, vishnum@xilinx.com
Subject: Re: [PATCH 2/4] i2c: cadence: Set the hardware time-out register to
 maximum value
Message-ID: <20141203112830.GD1039@katana>
References: <1417514749-24319-1-git-send-email-harinik@xilinx.com>
 <1417514749-24319-3-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zbGR4y+acU1DwHSi"
Content-Disposition: inline
In-Reply-To: <1417514749-24319-3-git-send-email-harinik@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zbGR4y+acU1DwHSi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 02, 2014 at 03:35:47PM +0530, Harini Katakam wrote:
> From: Vishnu Motghare <vishnum@xilinx.com>
>=20
> Cadence I2C controller has bug wherein it generates invalid read transact=
ions
> after time-out in master receiver mode. This driver does not use the HW
> timeout and this interrupt is disabled but the feature itself cannot be
> disabled. Hence, this patch writes the maximum value (0xFF) to this regis=
ter.
> This is one of the workarounds to this bug and it will not avoid the issue
> completely but reduce the chances of error.

This is a good description and should be in a comment in the driver.

>=20
> Signed-off-by: Vishnu Motghare <vishnum@xilinx.com>
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> ---
>  drivers/i2c/busses/i2c-cadence.c |    4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-ca=
dence.c
> index e54899e..8065205 100644
> --- a/drivers/i2c/busses/i2c-cadence.c
> +++ b/drivers/i2c/busses/i2c-cadence.c
> @@ -111,6 +111,8 @@
>  #define CDNS_I2C_DIVA_MAX	4
>  #define CDNS_I2C_DIVB_MAX	64
> =20
> +#define CDNS_I2C_TIMEOUT_MAX	0xFF
> +
>  #define cdns_i2c_readreg(offset)       readl_relaxed(id->membase + offse=
t)
>  #define cdns_i2c_writereg(val, offset) writel_relaxed(val, id->membase +=
 offset)
> =20
> @@ -858,6 +860,8 @@ static int cdns_i2c_probe(struct platform_device *pde=
v)
>  		goto err_clk_dis;
>  	}
> =20
> +	cdns_i2c_writereg(CDNS_I2C_TIMEOUT_MAX, CDNS_I2C_TIME_OUT_OFFSET);
> +
>  	dev_info(&pdev->dev, "%u kHz mmio %08lx irq %d\n",
>  		 id->i2c_clk / 1000, (unsigned long)r_mem->start, id->irq);
> =20
> --=20
> 1.7.9.5
>=20

--zbGR4y+acU1DwHSi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfvPeAAoJEBQN5MwUoCm2BlIQAIyiQ/Cl6ZY9TjwtUoS+uq3R
xJR0pS+CzzWlC9zv7YTATu9FyngTpTOM9f0sWjpPWQ03hLxkrouZoyqk3wXR2xpa
hLVvYOekLia6eSmI25Xr9/tsKsS6QN4ToQbTvB2T7fcphcRAsQPdUm7O9f62D8SA
nvAvH9qalBL82P4qA0K3YYBHU/y9PUx7TkCT8c6otPb2C5lSSb9HY9PSAvwbJgii
aDwHuJfT8w3e+1JeCtpk2PDvx/NuLCv1s1KCWGi6IRcPvAEhVDsb+B6lsaKg/h8U
Ycooe2IyDrF6bAtjrTAFITDAFS+4j8eAXQJ+8NKxCAVJSw+zIgYuTMtvq0QrUmmy
jaNtaq1M+5w5pbpsMPx2fIRe9yCgWXf1/t/dYkPxDKsvVvpcRnAaAdadsqhldIsx
4aJcMFFA41IgPqR0lpEaVotint/ahCjh9LUHldRiKfytfIY7LvZEpJ8EaxVdf/r5
FbBVdMra4WkV35bPaX91uFb1PwDvOaWW6VkryAsmBhaQZTh68VS4xy3Ft6zxxwXz
w2Rabclu3mmQQL7puQeaxHqDql2Hv9oaXA2qmixvtflX2rth+6rRQW0S9y1uahkN
ZKFyTwKCzQaWK/RwPySG+9xJocdFwddJvsIAaiu0P1qEqIFArBo/ok7iB1XTJ7oF
h8xXeWqvjmGPWOFCBTfc
=HoJW
-----END PGP SIGNATURE-----

--zbGR4y+acU1DwHSi--
