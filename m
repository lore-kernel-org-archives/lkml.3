Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3JDJx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 05:53:56 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:50704 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3JDJxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 05:53:54 -0400
Message-ID: <524E902D.8030809@monstr.eu>
Date: Fri, 04 Oct 2013 11:53:49 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 2/3] i2c: xilinx: Set tx direction in write operation
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1380550490.git.michal.simek@xilinx.com> <57a4f5352ce6f03bde7aafe8b880f91b52994379.1380550490.git.michal.simek@xilinx.com> <20131004054636.GC3194@katana>
In-Reply-To: <20131004054636.GC3194@katana>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="5s7D0pM9Tp2q9xQskXgdKVA6MhP0dgJOs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5s7D0pM9Tp2q9xQskXgdKVA6MhP0dgJOs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/04/2013 07:46 AM, Wolfram Sang wrote:
>=20
>> +	cr =3D xiic_getreg32(i2c, XIIC_CR_REG_OFFSET);
>> +	cr |=3D XIIC_CR_DIR_IS_TX_MASK;
>> +	xiic_setreg32(i2c, XIIC_CR_REG_OFFSET, cr);
>> +
>=20
> Is there no need to clear the bit again when receiving?

This bit is cleared in xiic_xfer() -> xiic_start_xfer() ->xiic_reinit()

xiic_setreg8(i2c, XIIC_CR_REG_OFFSET, XIIC_CR_TX_FIFO_RESET_MASK);


> And did
> transferring ever work if this bit was never set before?

I really don't know. We have switched from old driver to this new mainlin=
e one
and based on our eeprom testing we have found that this bit hasn't been s=
etup properly.

It is described here.
http://www.xilinx.com/support/documentation/ip_documentation/axi_iic/v1_0=
2_a/axi_iic_ds756.pdf
page 28 - step 3.

IIC Master Transmitter with a Repeated Start
1. Write the IIC device address to the TX_FIFO.
2. Write data to TX_FIFO.
3. Write to Control Register (CR) to set MSMS =3D 1 and TX =3D 1.
4. Continue writing data to TX_FIFO.
5. Wait for transmit FIFO empty interrupt. This implies the IIC has throt=
tled the bus.
6. Write to CR to set RSTA =3D 1.
7. Write IIC device address to TX_FIFO.
8. Write all data except last byte to TX_FIFO.
9. Wait for transmit FIFO empty interrupt. This implies the IIC has throt=
tled the bus.
10. Write to CR to set MSMS =3D 0. The IIC generates a stop condition at =
the end of the last byte.
11. Write last byte of data to TX_FIFO.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--5s7D0pM9Tp2q9xQskXgdKVA6MhP0dgJOs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJOkC4ACgkQykllyylKDCHhjwCffkHFB+2wY1HuYRpgQd3QkpZh
k+UAnRTh7gbp66sWAgvODcf+MIz9tIFb
=gr7A
-----END PGP SIGNATURE-----

--5s7D0pM9Tp2q9xQskXgdKVA6MhP0dgJOs--
