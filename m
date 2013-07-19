Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257Ab3GSMUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:20:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53349 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab3GSMUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:20:44 -0400
Date: Fri, 19 Jul 2013 15:20:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <balbi@ti.com>, <broonie@kernel.org>,
        <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
Message-ID: <20130719122029.GE16115@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>
 <1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
 <20130718102404.GH11251@arwen.pp.htv.fi>
 <51E7CF11.5030301@ti.com>
 <20130718112458.GJ11251@arwen.pp.htv.fi>
 <51E9279F.6010601@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ILuaRSyQpoVaJ1HG"
Content-Disposition: inline
In-Reply-To: <51E9279F.6010601@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ILuaRSyQpoVaJ1HG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 19, 2013 at 05:18:47PM +0530, Sourav Poddar wrote:
> On Thursday 18 July 2013 04:54 PM, Felipe Balbi wrote:
> >On Thu, Jul 18, 2013 at 04:48:41PM +0530, Sourav Poddar wrote:
> >>>>+static void qspi_write_msg(struct ti_qspi *qspi, struct spi_transfer=
 *t)
> >>>>+{
> >>>>+	const u8 *txbuf;
> >>>>+	int wlen, count;
> >>>>+
> >>>>+	count =3D t->len;
> >>>>+	txbuf =3D t->tx_buf;
> >>>>+	wlen =3D t->bits_per_word;
> >>>>+
> >>>>+	while (count--) {
> >>>>+		dev_dbg(qspi->dev, "tx cmd %08x dc %08x data %02x\n",
> >>>>+			qspi->cmd | QSPI_WR_SNGL, qspi->dc, *txbuf);
> >>>>+		ti_qspi_writel_data(qspi, *txbuf++, QSPI_SPI_DATA_REG, wlen);
> >>>you always increment by each byte. Here, if you used writel(), you wro=
te
> >>>4 bytes and should increment txbuf by 4.
> >>hmm..got this point. Yes, my mistake, here I agree if wlen is not 8 bits
> >>txbuf++ is not valid.
> >>>  Same goes for read_data(),
> >>>below. Another thing. Even though your wlen might be 8 bits, if you
> >>>write 4 bytes to write, you can save a few CPU cycles by using writel(=
).
> >>>
> >>Do you mean 4 words of 8 bits?
> >yeah. Say you have wlen =3D 8 but the transfer length is 8 bytes (64
> >bits). If you use writeb(), you will do 8 writes, if you use writel()
> >you'll do 2 writes.
> >
> Just some more findings on this, after wlen bits are transferred we
> need an WC interrupt.
> So, if I try to pack 4 words of 8bits and use readl/writel, there
> will be an interrupt after every
> wlen bits transferred and things will get screwd up.

they will not if you throttle the IRQs or add some knowledge about the
FIFO sizes. I mean, there are ways to get this working.

> So, for 8 bits word we need to use readb, for 16 bits word readw.

not entirely true...

I mean, you have a 32-bit FIFO, why would underutilize the FIFO by
always writing 8-bits ? Write 32 bits, when you get the first word
completion, you know you have 8-bits of space in the FIFO, then you
can fill those 8 bits with new data. (all of this is assuming word
length is 8-bits, clearly if it is more, then you need to change the
assumptions).

Another thing which might help, is checking if the HW will even access
the other DATA registers even if word length is <=3D 32 bits. If it does,
then you have a total of 128 bits to shift data into, which can save you
a lot of time filling up FIFOs and waiting for them to empty.

--=20
balbi

--ILuaRSyQpoVaJ1HG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR6S8NAAoJEIaOsuA1yqREcxAQAJ3fzcYXPhzrs/UkmLCYktEJ
XBBvsLuWxHSQpDCrdJOHM3c6KPw+EXeWBwbL94d3GeViInt4a5rPT89TdshHgex4
VFmKkX6meREDZjy0YBO9KPrhxHn2XzuUQsOf+omOG9UOpGuw1mu3y/oERoZBjQB8
g6KYu5ZHp2nZEjl1/vXoSXFF2Yd6CGzTEhuKOzN31mxxWyiqWz8LBLsjbeiuMQp3
EEOvujxUQI64LrgB1y+jp6rfF2u0zQroOjHj1IfFxhH02tFSE/cLZ1b3DaQ3T0vH
sGOKiVRO23pbGGmUZFUYPau7LMJ9dHzKB9jCWBhVy+N1Ni1uo7saALZ2As7+K0LU
13IgrteV5ZvRzXxmrZZCq9BFrOVME+3so3i9g9IF01P0N68IaKPCjesX5Ll2t/te
PwV3mMj+8k9iQ8KehFi+XJ6jgaHEiExxyhvERoQQwlXN9TmIgMNajguL75IXtdIH
T+6H9SYk9iODunAT3M/A87j1KUfbQ9NTu1g5BWRxQrvu0CI4oZZ3llGmCVG3jqnW
d/Z0kCSHNDvY9DHtYb8+wFS8hwZWZA/OzgU+nN1oqJ75ho38D/KHZ4MvG4A4/hOC
l9f5juv5vavJHNARpUSMx6x+Zgm1sNV83PqEC94JtQ7MCFabbuwPz6EIb3oYnv1f
Kg5GuoqMpWzx42ARb6vN
=jiHB
-----END PGP SIGNATURE-----

--ILuaRSyQpoVaJ1HG--
