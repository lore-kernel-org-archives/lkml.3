Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab3GBPUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:20:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53271 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3GBPT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:19:59 -0400
Date: Tue, 2 Jul 2013 18:19:47 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] drivers: spi: Add qspi flash controller
Message-ID: <20130702151947.GD7013@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com>
 <20130702093247.GY27646@sirena.org.uk>
 <20130702094404.GL3352@arwen.pp.htv.fi>
 <20130702101718.GE27646@sirena.org.uk>
 <20130702104338.GA5107@arwen.pp.htv.fi>
 <20130702110432.GJ27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ycz6tD7Th1CMF4v7"
Content-Disposition: inline
In-Reply-To: <20130702110432.GJ27646@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Ycz6tD7Th1CMF4v7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 02, 2013 at 12:04:32PM +0100, Mark Brown wrote:
> On Tue, Jul 02, 2013 at 01:43:38PM +0300, Felipe Balbi wrote:
> > On Tue, Jul 02, 2013 at 11:17:18AM +0100, Mark Brown wrote:
>=20
> > > +	/* setup command reg */
> > > +	qspi->cmd =3D 0;
> > > +	qspi->cmd |=3D QSPI_WLEN(8);
>=20
> > Sourav hardcodes wordlenght to 8-bits, and yet he enables 8, 16 and
> > 32-bits per word.
>=20
> Yeah, that's what I noticed (well first off I noticed that there were no
> constraints on bits per word at all).
>=20
> > > +	qspi->cmd |=3D QSPI_EN_CS(0);
>=20
> > he's also hardcoding the chipselect line which should be take from
> > m->spi->chip_select
>=20
> This one *can* be OK if the driver only accepts one chip select (though
> obviously supporting more is better).  I'd really only done a fairly

this controller has 6 chip selects IIRC

> high level review for framework stuff so hadn't got that far yet.
>=20
> One thing I really want to get round to doing with the SPI core is
> providing an easy to pick up GPIO chip select as standard=20

that should be fairly simple I guess. Just lack of time, I'm assuming ?

Complex will be to support up to 128-bits per word as this particular
controller supports. In fact, this controller is, IMO, overly flexible.
You can do 1, 2, 3, 4, 5, 6, ... , 128 bits per word.

The only problem is that the DATA registers which give you access to the
shift register, aren't mapped to consecutive offsets, but that should
still be ok since we will, anyway, be using readl/writel for each
register. Still, for platforms which can provide writeq/readq (not sure
if that's already supported on ARM) we could save a few cycles, no ?

anyway... it is what it is.

--=20
balbi

--Ycz6tD7Th1CMF4v7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0u+SAAoJEIaOsuA1yqREm9EQAJ+r138z4rCoBi8STfIS0NYa
om18NcTr31ycXVyrr+/RkbPcUqKVgO7bksM+cCBezbOnlyqw1qoca0xXpLbGnMmR
79+TXW13KamKMbcoEn3HuhmqcE58Ajdn7I5g8O1umt02NdA2LgTSYUFINz8I7Qz+
VFo//cTyv6Iq1OQfxZx+fU0wA5ZI4c3bLmxbQwhJnoEE9m/y+4XvKv6WgmNYs63j
uVs5GDj2WqG2gj8raPIc3xlUiL9M1rXAw6NFdMIXFlNoQRmLlcHm3AYIZs80jFcs
RKxBcL4BmrFly+XyzVCZxl9FAxv6lT/sSOCtrngqcUFAdFBxAvGM7lGORaQ2OH4q
3kQfRvaKGWI8zXMxkZnPGw4ZPRoMRWf3WdD3yiCpR4tm15SnCEbnZI8bCultYTuZ
wtUWM7H95Pe2TPXtBa5GiafSwsx1uqT/vVEznSeRBDmMNoIiGYxtNGinhjhoGb65
NtxvhGHGF4egS0aHtWuOXBBwGZAFAW94C0LkPNwWn15KFWmyJXj8uCQNnCGwxk4z
cgmvtop9W58leJqQKZrXAYcL/Lyg9oM9x3vqD4eQ40ymDBpCGoJVo53yr9FrZMHN
XvejSfD3khBNgP+mIjJvfsZ9J0lCXxcdk49R2nnvCJfJFX+i+bhYw2fIvzaB/NRK
x43POSrTnm3jId+DKfsh
=p6My
-----END PGP SIGNATURE-----

--Ycz6tD7Th1CMF4v7--
