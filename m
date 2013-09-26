Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab3IZIkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:40:42 -0400
Received: from sauhun.de ([89.238.76.85]:46249 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab3IZIkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:40:40 -0400
Date: Thu, 26 Sep 2013 10:40:32 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: James Ralston <james.d.ralston@intel.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, Seth Heasley <seth.heasley@intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] i2c-ismt: add Initialize DMA buffer code
 ismt_access()
Message-ID: <20130926084032.GB3057@katana>
References: <1380066475-2119-1-git-send-email-james.d.ralston@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <1380066475-2119-1-git-send-email-james.d.ralston@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 24, 2013 at 04:47:55PM -0700, James Ralston wrote:
> This patch adds code to Initialize the DMA buffer to compensate for possi=
ble hardware data corruption.

Take care of the line width here.

> Signed-off-by: James Ralston <james.d.ralston@intel.com>
> ---
>  drivers/i2c/busses/i2c-ismt.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
> index 8ed79a0..d3f30ea 100644
> --- a/drivers/i2c/busses/i2c-ismt.c
> +++ b/drivers/i2c/busses/i2c-ismt.c
> @@ -393,6 +393,9 @@ static int ismt_access(struct i2c_adapter *adap, u16 =
addr,
> =20
>  	desc =3D &priv->hw[priv->head];
> =20
> +	/* Initialize the DMA buffer */
> +	memset(priv->dma_buffer, 0, (I2C_SMBUS_BLOCK_MAX+1));

sizeof()?

> +
>  	/* Initialize the descriptor */
>  	memset(desc, 0, sizeof(struct ismt_desc));
>  	desc->tgtaddr_rw =3D ISMT_DESC_ADDR_RW(addr, read_write);
> --=20
> 1.7.7.6
>=20

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQ/MAAAoJEBQN5MwUoCm2k6gQAJ40U4RR8yZ0F8b362yqX4Ga
p+qVShXggMsDAD6kvdaz5AEgbCZqbSLthCeAgHH1LTnHyZPAEeBnaPe/Q9ZkoedK
RtvuJR84fd0jOjCTejKXW21at2tUyrW5a1OUYBH01ng8VVvLzC2M6EZLnslB3qRn
9oBfTiPp0Hc/pAuTFWmRJwMfCUv1yuhbW48ibqGcnt9WPPn+NhfgUTB5tb6TkMiM
p1ZqMTDtZckNMWyDG+RDOq/i7w499AnWEifryK26GYtkpVpm0O0AAHtmw+3iR6ue
LuKwq+XK4MBkDsny0vlTaQNuzOBnccTdrV1TLTNikgQlPfQbQwiZvDw/6b/cLTQ9
9Kwgw5Jol3zggqx3pkKo8JbkGDL5co38Z5lP88g5WNRdGGv+T8Ie3gcbUAjHy1em
G768eTr9fzyXNhVekrPaKXHa/kXVh+1pwGYgn7QGSvfdF5favzLniWBl+R8sHB55
+eP6/XSSsT/k7HByjOK+tHIYPyLNQyJJFl5qo+XJZu1j958XFIc/WuK1k+Lj3gNt
S8LmgEtgFbqOYcKQFJ4IMfOvu4iyFS0AARwoNHo5zafaeS4I05+48BJgTlrERukG
3A5FKqlYFu1/G4W5KlooonafSPTnZoJ1HUwWa7MiQ8mk+2Bx9TOSNhXiCZKuv0r5
xCt2qIpT+7kdWfmDWRY8
=1GxT
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
