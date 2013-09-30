Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab3I3KWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:22:50 -0400
Received: from sauhun.de ([89.238.76.85]:42192 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357Ab3I3KWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:22:44 -0400
Date: Mon, 30 Sep 2013 12:22:42 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 2/3] i2c: xilinx: Set tx direction in write operation
Message-ID: <20130930102242.GB3222@katana>
References: <c122ad49b27406ee495ef0d6cac191968d64f09f.1380532113.git.michal.simek@xilinx.com>
 <5d234cfc8d23cfc7e8d750f103344cf4e8e398d4.1380532113.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <5d234cfc8d23cfc7e8d750f103344cf4e8e398d4.1380532113.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2013 at 11:08:51AM +0200, Michal Simek wrote:
> From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
>=20
> In write operation, after filling address byte to tx fifo,
> set the direction of transfer to tx using control register.

You describe WHAT you do, yet you should describe WHY the change is
needed. For example, I can't tell if this is an urgent bugfix or not.
Please rephrase.

>=20
> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  drivers/i2c/busses/i2c-xiic.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
> index 5eb0a8b..44e6ae7 100644
> --- a/drivers/i2c/busses/i2c-xiic.c
> +++ b/drivers/i2c/busses/i2c-xiic.c
> @@ -536,6 +536,7 @@ static void xiic_start_recv(struct xiic_i2c *i2c)
>  static void xiic_start_send(struct xiic_i2c *i2c)
>  {
>  	struct i2c_msg *msg =3D i2c->tx_msg;
> +	u32 cr;
>=20
>  	xiic_irq_clr(i2c, XIIC_INTR_TX_ERROR_MASK);
>=20
> @@ -556,6 +557,10 @@ static void xiic_start_send(struct xiic_i2c *i2c)
>  		xiic_setreg16(i2c, XIIC_DTR_REG_OFFSET, data);
>  	}
>=20
> +	cr =3D xiic_getreg32(i2c, XIIC_CR_REG_OFFSET);
> +	cr |=3D XIIC_CR_DIR_IS_TX_MASK;
> +	xiic_setreg32(i2c, XIIC_CR_REG_OFFSET, cr);
> +
>  	xiic_fill_tx_fifo(i2c);
>=20
>  	/* Clear any pending Tx empty, Tx Error and then enable them. */
> --
> 1.8.2.3
>=20



--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSSVDyAAoJEBQN5MwUoCm2AsQP/3XNI4au5zxLKhGvQgqkkfbY
x2a3wNr+VmKnFz4FOjDLcMJ8ms3j2hmDZEHYE45Q7tKcJtaf6z9HcnsheV00Hvl4
v7jXj0LwosaJFQXFiI9AJuLU4RipTr9oE5WZHszfvwikYVIVR/7FsbbuEjoxXLGj
EMdEO90FB0mVOuVO2wDnYXvbsFdl5bCuOLVQrmRwa2sdBZBoX793WlwpgqnEtfDw
6bpca1LrDN/GBtawm1z2/JxGuR2FP0pzSHZNmSuVo1owFjtLliRRdS7sUKSqwICl
nDyrug81U7p/Znoj2lEqSbN6kQ0SFCO05Iu3tsYkfIVdsyDDZHPaVbyBCYbXHFmd
Z336Oav5XoBk3gIAQRtyaEDb7ul/Gp3BATnGaUKGil6X+usBzJ2PWL9iZl54k3Lh
6UXid8xbmOggtFNhgOxjLBNJcTKhRyRUkKkHErlD6xU1a8KYT7SYrr//9F+RQ6M0
2q42NABjNiWOYg1/372KLjTv67abcrb421FYBam1nBcoGcjJXmM0Ft6d7p+9FxZa
eleiMOFAC4zabXTQWrUuW9l/LnlZgjS8HdQ7hxUqP1zUNk98CZldBiuevwgfwuva
0diSynsTRugnMs8D47DzLFYaoQAmp1Vq3hd8aJR6SnZ2D8JO3K6wd+SNkJsSN2zv
Gm1GJnlqAECO2FnCpPFB
=GoIN
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
