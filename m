Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaDDOjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:39:08 -0400
Received: from sauhun.de ([89.238.76.85]:34872 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbaDDOjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:39:06 -0400
Date: Fri, 4 Apr 2014 16:38:47 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Mike Looijmans <mike.looijmans@topic.nl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Harini Katakam <harinik@xilinx.com>, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v4 2/3] i2c: Add driver for Cadence I2C controller
Message-ID: <20140404143847.GA5529@katana>
References: <1396547967-19260-1-git-send-email-soren.brinkmann@xilinx.com>
 <1396547967-19260-2-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <1396547967-19260-2-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 03, 2014 at 10:59:26AM -0700, Soren Brinkmann wrote:
> Add a driver for the Cadence I2C controller. This controller is for
> example found in Xilinx Zynq.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Tested-by: Michal Simek <michal.simek@xilinx.com>
> Reviewed-by: Harini Katakam <harinik@xilinx.com>

Only minor stuff, but since you resend anyhow because of 400kHz issue...

> +static void cdns_i2c_mrecv(struct cdns_i2c *id)
> +{
> +	unsigned int ctrl_reg;
> +	unsigned int isr_status;
> +
> +	id->p_recv_buf =3D id->p_msg->buf;
> +	id->recv_count =3D id->p_msg->len;
> +
> +	/* Put the controller in master receive mode and clear the FIFO */
> +	ctrl_reg =3D cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
> +	ctrl_reg |=3D CDNS_I2C_CR_RW | CDNS_I2C_CR_CLR_FIFO;
> +
> +	if ((id->p_msg->flags & I2C_M_RECV_LEN) =3D=3D I2C_M_RECV_LEN)

'if (id->p_msg->flags & I2C_M_RECV_LEN)' is enough.

> +		/* Report the other error interrupts to application as EIO */
> +		if (id->err_status & (CDNS_I2C_IXR_RX_UNF |
> +				      CDNS_I2C_IXR_TX_OVF |
> +				      CDNS_I2C_IXR_RX_OVF |
> +				      CDNS_I2C_IXR_NACK)) {
> +			cdns_i2c_master_reset(adap);
> +			return -EIO;
> +		}

NACK is returned as -ENXIO. Check 'Documentation/i2c/fault-codes' for
standard patterns. I'd think the rest is EIO, though.


--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTPsP3AAoJEBQN5MwUoCm2WV4P/39bAkxtCvoj8gUKN3f3hLse
ykH+NCPg3/G2UekYs27KtwY/+Zp7d+9a3moLwDJJxgjghav33Aryq1jPLBYoequM
kn9P9vc/QtSWiIOWsHR4c+ZzdXFRfQAD+Xozb26eHup3xOXYmrCJ3I8SK7gzN/F9
fnLUp3OvkRheB0+iM6NNopuNktvfg1xmvReOEQmsAQCO/t6jsONoNXj+XbBAud7E
GpKtflVQEk/pqSGZA6OtIcYt4Zj0nch9g4BGlc19vUjTqN/51B1IEEraTUn+Hjwg
ZIXOztZyT9sBnCRm26XYlKfXeV8c0IGMA99PUxKYbBq4ph8dLH+rylJSLkVIP739
hu8YwRUMQZascv/VOBmEBguKH15BHNn8NXnYsixFb7rJVkS6fUwKLLSU2qb5y1Ny
4Q43Q5aLTrbpNylkk9GzmQnJbptWTy9ZrLwu26dXiR0SiPxRL3HD1y2NkNBK23bF
OBrYosH9GsHbb8s6qOPbC6dT47HBU2wvTf5sCCwQGoqkpsNHfE4z4pdG6c1sY1ij
aXgw6KOQ3tyVLjBL+eWf9+TqM9SB69QfOKAn4WhqeCw0v6SeBWY5+9xxs0VbU5KX
Nept3zeKD5d65PS59KpD+nYlCiNqAtVDw0DCgjIlaQb/DnpobXklPJUC8WnqmsZk
4xcMVytvijLDUqoem3cE
=QQu0
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
