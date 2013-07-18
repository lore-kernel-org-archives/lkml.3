Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab3GRNcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:32:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51989 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758913Ab3GRNcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:32:13 -0400
Date: Thu, 18 Jul 2013 16:31:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Sourav Poddar <sourav.poddar@ti.com>,
        <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <balbi@ti.com>, <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
Message-ID: <20130718133158.GA1628@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>
 <1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
 <20130718104233.GG22506@sirena.org.uk>
 <51E7D569.2010709@ti.com>
 <20130718131822.GN22506@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20130718131822.GN22506@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 18, 2013 at 02:18:22PM +0100, Mark Brown wrote:
> > >>+static irqreturn_t ti_qspi_isr(int irq, void *dev_id)
> > >>+{
> > >>+	struct ti_qspi *qspi =3D dev_id;
> > >>+	u16 mask, stat;
> > >>+
> > >>+	irqreturn_t ret =3D IRQ_HANDLED;
> > >>+
> > >>+	spin_lock(&qspi->lock);
> > >>+
> > >>+	stat =3D ti_qspi_readl(qspi, QSPI_SPI_STATUS_REG);
> > >>+	mask =3D ti_qspi_readl(qspi, QSPI_INTR_ENABLE_SET_REG);
> > >>+
> > >>+	if (stat&&  mask)
> > >>+		ret =3D IRQ_WAKE_THREAD;
> > >>+
> > >>+	spin_unlock(&qspi->lock);
> > >>+
> > >>+	return ret;
>=20
> > >According to the above code we might interrupt for masked events...
> > >that's a bit worrying isn't it?
>=20
> > Yes, there is WC interrupt enable bit which enables the interrupt.
> > This interrupt
> > gets disabled by writing to the CLEAR reg in the threaded irq.
>=20
> So why do we report that we handled the interrupt then?  Shouldn't we at
> least warn if we're getting spurious IRQs?

not spurious. OMAP has two sets of IRQ status registers. One is call
IRQSTATUS$n (n =3D 0, 1, ...) and IRQSTATUS_RAW$n.

IRQSTATUS$n will only enable the bits which fired IRQs and aren't
masked while IRQSTATUS_RAW$n will also enable the bits which are masked.
I could never come up with a use case where we would need to handle IRQs
which we decided to mask, but perhaps there might be some cases, I don't
know.

Based on that, I believe Sourav is reading IRQSTATUS_RAW$n, then he need
to clear the masked bits.

--=20
balbi

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR5+5OAAoJEIaOsuA1yqREC3oP/1JMFGVDgtocw9+tkQ8PjAJK
8FTZepYulE+n4xdK9DOzlpOTG86NeRj/yKDbnCc08sUlbl98atbbo2XYtcA0R5eJ
U9LtlCDetFODqW9MYAglJ0i9whzjMfnY8ieVqOpih3zvvrkoVZi6kER00TtoTj6E
sAYRUJSEpwy+V7NV0WxC+y+mYTTxmzsj8SAY8UFSyCfQm5hlTmmBPrLz80f/U7TT
vT+lEIHF1FJd2TRwtWvmWYBimrNWsHgs5eUEifRS2YEL6sR0p/tvZJ+5ZOzUAC78
RuF1Bv7EN4398+dVC2ghwoWbj1KJI0TcstBO7URnBdVEo4zbXmSpMhZ9yulRbeRI
yEhKx/69HtiNCv8gxNE+7aX6mVhsOkVJdPTqxp9Whs95hjfHseTF9QTsNTSIzqd4
3Jj9NXzH5LP75SOF915WpBToXJ457QJYhTRcA7cqNnIG/s/IjXPTt0Nl4jljDbJ0
WD1D4zb9kyemOUWtgbygzSdvYIB+WbSzrzw6WJh2GpPLg8DTNQlsRE39L5oGXVDF
881hL84IWdPV44ZRBUdb8DO9FX512GJXwb8NjB1obDt+ki8HeGaNHBLSGzCrUnIY
W4pJ9Tw8V8cjhsVo+7vEgl7g5NXE1V5fzUOWWfGpAwJBlkRHUQcy4wbWuVirSOAP
89k2MZ57pC2lKObviv7S
=zaXD
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
