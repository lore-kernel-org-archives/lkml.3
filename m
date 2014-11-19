Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaKSJUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:20:18 -0500
Received: from sauhun.de ([89.238.76.85]:52764 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbaKSJUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:20:15 -0500
Date: Wed, 19 Nov 2014 10:21:22 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Baruch Siach <baruch@tkos.co.il>, "Du, Wenkai" <wenkai.du@intel.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] i2c: designware: prevent early stop on TX FIFO empty
Message-ID: <20141119092122.GC1439@katana>
References: <545CB6C4.8010201@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HG+GLK89HZ1zG0kk"
Content-Disposition: inline
In-Reply-To: <545CB6C4.8010201@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 07, 2014 at 12:10:44PM +0000, Andrew Jackson wrote:
> If the Designware core is configured with IC_EMPTYFIFO_HOLD_MASTER_EN
> set to zero, allowing the TX FIFO to become empty causes a STOP
> condition to be generated on the I2C bus. If the transmit FIFO
> threshold is set too high, an erroneous STOP condition can be
> generated on long transfers - particularly where the interrupt
> latency is extended.
>=20
> Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

So, what do other designware users think of this change (nice CC list
BTW, Andrew). Adding Mika, too.

> ---
>  drivers/i2c/busses/i2c-designware-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busse=
s/i2c-designware-core.c
> index 3c20e4b..e070edd 100644
> --- a/drivers/i2c/busses/i2c-designware-core.c
> +++ b/drivers/i2c/busses/i2c-designware-core.c
> @@ -363,7 +363,7 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
>  	}
> =20
>  	/* Configure Tx/Rx FIFO threshold levels */
> -	dw_writel(dev, dev->tx_fifo_depth - 1, DW_IC_TX_TL);
> +	dw_writel(dev, dev->tx_fifo_depth / 2, DW_IC_TX_TL);
>  	dw_writel(dev, 0, DW_IC_RX_TL);
> =20
>  	/* configure the i2c master */
> --=20
> 1.7.1
>=20

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJUbGESAAoJEBQN5MwUoCm2bjYP+Ie4QLkVvrtwxxKd4S0GR2Al
UnSMQoeq5yFZOKk+eO+7RdK7G5CWuMXYG/GIIpmx94X0XOGOi5AwX76TTY2nhsZf
Sq0CcsQ7dnspJ9lpr+KfYo8PmbQft13+qnzFZwlWwOECs2qmFryYK9c9R1b87zaE
mbz0DJtRiAWYroSKhpDXrFYp6u+qDGepxhuRgSo6ufgCNPm6axrNoM7ivoxw9ORK
v3fEBWbB7KN+UbwrRIWFD3jSZyQVN6MuHB1OLH1IedJR5K2Xrd+f/uA5tkcxOnQY
Wd2b//AMMrgSoWyNG7HF0cFeb996kOLshVz0zlxe+kmdkmN/n3hqJffLMrS8W+y0
F6w1bH45yQfc03vjihIOaJxb+XPi8TrZ/bEglpSAwn7X3atMgKgz4K8VI4NV+Vu+
pc4WYLh++HSMMyqK27ikVmckQ0VbMc2w6ZevEVrpBgS0yfC0KLQn7CY0CLn9LeFp
99KUkCLbhvv1EycXKfnlHyMh6GdYIFa04jGLhr/+EP7MFOPUIR72ZuFt+bAcBlEK
4hf0OegU0K6ICq9mkTAZKng6Kx6hehN6oA/L0jb4vwzCTGFrkDD+oVJr6giVTPz2
g/io4l+a8tkolpqsAbcIoRwQ8mEG9qbidytCKLmdrEwiM7DM1TpZSoxlVteFM7jZ
3GwRq80JDitC2BlvAHc=
=j73i
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--
