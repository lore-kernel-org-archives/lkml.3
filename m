Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3JDLzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 07:55:24 -0400
Received: from sauhun.de ([89.238.76.85]:37425 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab3JDLzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 07:55:23 -0400
Date: Fri, 4 Oct 2013 13:55:17 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org,
        Richard =?iso-8859-15?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "Steven A. Falco" <sfalco@harris.com>
Subject: Re: [PATCH v2 2/3] i2c: xilinx: Set tx direction in write operation
Message-ID: <20131004115517.GA2994@katana>
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1380550490.git.michal.simek@xilinx.com>
 <57a4f5352ce6f03bde7aafe8b880f91b52994379.1380550490.git.michal.simek@xilinx.com>
 <20131004054636.GC3194@katana>
 <524E902D.8030809@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <524E902D.8030809@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 04, 2013 at 11:53:49AM +0200, Michal Simek wrote:
> On 10/04/2013 07:46 AM, Wolfram Sang wrote:
> >=20
> >> +	cr =3D xiic_getreg32(i2c, XIIC_CR_REG_OFFSET);
> >> +	cr |=3D XIIC_CR_DIR_IS_TX_MASK;
> >> +	xiic_setreg32(i2c, XIIC_CR_REG_OFFSET, cr);
> >> +
> >=20
> > Is there no need to clear the bit again when receiving?
>=20
> This bit is cleared in xiic_xfer() -> xiic_start_xfer() ->xiic_reinit()
>=20
> xiic_setreg8(i2c, XIIC_CR_REG_OFFSET, XIIC_CR_TX_FIFO_RESET_MASK);

A bit implicit, but OK.

> > And did
> > transferring ever work if this bit was never set before?
>=20
> I really don't know. We have switched from old driver to this new mainlin=
e one
> and based on our eeprom testing we have found that this bit hasn't been s=
etup properly.
>=20
> It is described here.
> http://www.xilinx.com/support/documentation/ip_documentation/axi_iic/v1_0=
2_a/axi_iic_ds756.pdf
> page 28 - step 3.
>=20
> IIC Master Transmitter with a Repeated Start
> 1. Write the IIC device address to the TX_FIFO.
> 2. Write data to TX_FIFO.
> 3. Write to Control Register (CR) to set MSMS =3D 1 and TX =3D 1.
> 4. Continue writing data to TX_FIFO.
> 5. Wait for transmit FIFO empty interrupt. This implies the IIC has throt=
tled the bus.
> 6. Write to CR to set RSTA =3D 1.

Repeated start is not happening in the driver as well, or am I
overlooking something?

> 7. Write IIC device address to TX_FIFO.
> 8. Write all data except last byte to TX_FIFO.
> 9. Wait for transmit FIFO empty interrupt. This implies the IIC has throt=
tled the bus.
> 10. Write to CR to set MSMS =3D 0. The IIC generates a stop condition at =
the end of the last byte.
> 11. Write last byte of data to TX_FIFO.

CCing more people who worked on the driver in the past and might have
experiences

Thanks,

   Wolfram


--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSTqylAAoJEBQN5MwUoCm2BqkP/RGh1D841cSyfkBeQgQ3MpDJ
cmfPBmUCoYD6hI1l8Iv4fj8IVTVWwMM3IOSOpgxVJOR+myMRB4TXX/GvYo6+faCG
NDaZB+lusOMoiCB8z+05JWrGbVVs05bZukXDVBriBQBYOtr1st/bsbHHW0vb027l
C2fkfAq2ze0CwzHoDwq7+s0pu4kdmdsVHTgFd5obMfOMgirdTL26ymqZ66L/8E7+
UWkRFLrRVADB3zfxrVPduqhpSJ1uJq1KpegFRBh3haznO/EJOXf371g7keQpG+vN
K/bvpMF6ozKjyz5olVW9s1sQqKw408HVYn6oZuHfXn9jXV39GR4Wv3lzthAqmosY
FsWSQnNWhw6pVHtgw3JbMgBZVl+f1qPIK4VClLFnxTKis+tv5hBGqqI36A0aNWWc
POHg0O78uHa7ETCJMyi/UX/seLo62D3aBgRxs5TbpH3v53wGYqJIgbrVtgUZo5Hz
XJXlWkctCnzONqWFsZ9v/xRyK7dmTBcdz7hhvxpI4eYg+eHJyuF21+6gqqQ2rrzX
gDALaprHmBBpTswK4iHEon+K2EMQrEtKV09+BWgOSy0hTfqXvjVbp+Oi2u2owIyk
qXGF2VxFkUz3eIq+XJsoUm3xt7/NtoKzZer5oAsCFZBN9N1DowcWbVDvONI9bgBc
ed7R3Mbzc2jNwNKFd7kT
=o77G
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
