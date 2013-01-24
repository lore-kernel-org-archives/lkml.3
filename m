Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3AXMgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:36:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58589 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab3AXMgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:36:43 -0500
Date: Thu, 24 Jan 2013 13:36:15 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: nsekhar@ti.com, khilman@ti.com, ben-linux@fluff.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: question about drivers/i2c/busses/i2c-davinci.c
Message-ID: <20130124123615.GG12933@pengutronix.de>
References: <alpine.DEB.2.02.1301062057260.2029@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MiFvc8Vo6wRSORdP"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1301062057260.2029@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MiFvc8Vo6wRSORdP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 06, 2013 at 09:00:59PM +0100, Julia Lawall wrote:
> The function davinci_i2c_remove in drivers/i2c/busses/i2c-davinci.c
> contains the following code:
>=20
>         put_device(&pdev->dev);
>=20
>         clk_disable_unprepare(dev->clk);
>         clk_put(dev->clk);
>         dev->clk =3D NULL;
>=20
>         davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, 0);
> 	free_irq(dev->irq, dev);
>=20
> Is there any danger in putting free_irq(dev->irq, dev); after
> put_device(&pdev->dev);, because the interrupt handler
> i2c_davinci_isr can eg refer to dev->dev.

Not having a clock doesn't sound exactly thrilling either when servicing
an interrupt. I've seen something like this in the remove path of
another driver today as well. I assume a lot of drivers might have such
issues. It is also one of the subtle issues with devm_request_irq. The
remove path can already render the ISR unusable/oopsable but devm will
free the interrupt only after remove has finished. Interrupts need to be
properly masked out before.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--MiFvc8Vo6wRSORdP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEBKr8ACgkQD27XaX1/VRth+QCgxvSuaCWBWBWEzWAOXdyZXI8d
VkIAn0YlJWCOCQvrVJThR/16q0+A6B8z
=yvUF
-----END PGP SIGNATURE-----

--MiFvc8Vo6wRSORdP--
