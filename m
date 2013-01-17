Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399Ab3AQJer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:34:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40746 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab3AQJep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:34:45 -0500
Date: Thu, 17 Jan 2013 11:34:31 +0200
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Luciano Coelho <coelho@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport
 power functions
Message-ID: <20130117093417.GH10814@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358372702-13102-1-git-send-email-coelho@ti.com>
 <50F7C4A7.5060202@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ofZMSlrAVk9bLeVm"
Content-Disposition: inline
In-Reply-To: <50F7C4A7.5060202@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ofZMSlrAVk9bLeVm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 10:30:15AM +0100, Peter Ujfalusi wrote:
> Hi Luca,
>=20
> On 01/16/2013 10:45 PM, Luciano Coelho wrote:
> > The code to enable and disable the WiLink shared transport has been
> > removed from the TI-ST driver, so it must be implemented in the board
> > files instead.  Add the relevant operations to Panda's board file.
> >=20
> > Additionally, add the UART2 muxing data, so it's properly configured.
> >=20
> > Cc: stable <stable@vger.kernel.org> [3.7]
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> >=20
> > In v2: use gpio_request_one() instead of gpio_request() and
> > gpio_direction_output(). (Thanks Fabio!)
> >=20
> >  arch/arm/mach-omap2/board-omap4panda.c |   50 ++++++++++++++++++++++++=
+++++---
> >  1 file changed, 46 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-oma=
p2/board-omap4panda.c
> > index 5c8e9ce..f44fccf 100644
> > --- a/arch/arm/mach-omap2/board-omap4panda.c
> > +++ b/arch/arm/mach-omap2/board-omap4panda.c
> > @@ -51,18 +51,50 @@
> >  #define GPIO_HUB_NRESET		62
> >  #define GPIO_WIFI_PMENA		43
> >  #define GPIO_WIFI_IRQ		53
> > +#define GPIO_BT_EN		46
> > =20
> >  /* wl127x BT, FM, GPS connectivity chip */
> > +static int plat_kim_chip_enable(struct kim_data_s *kim_data)
> > +{
> > +	gpio_set_value(GPIO_BT_EN, GPIO_LOW);
> > +	mdelay(5);
> > +	gpio_set_value(GPIO_BT_EN, GPIO_HIGH);
> > +	mdelay(100);
> > +
> > +	return 0;
> > +}
> > +
> > +static int plat_kim_chip_disable(struct kim_data_s *kim_data)
> > +{
> > +	gpio_set_value(GPIO_BT_EN, GPIO_LOW);
> > +	mdelay(1);
> > +	gpio_set_value(GPIO_BT_EN, GPIO_HIGH);
> > +	mdelay(1);
> > +	gpio_set_value(GPIO_BT_EN, GPIO_LOW);
> > +
> > +	return 0;
> > +}
> > +
> >  static struct ti_st_plat_data wilink_platform_data =3D {
> > -	.nshutdown_gpio	=3D 46,
> >  	.dev_name	=3D "/dev/ttyO1",
> >  	.flow_cntrl	=3D 1,
> >  	.baud_rate	=3D 3000000,
> > -	.chip_enable	=3D NULL,
> > -	.suspend	=3D NULL,
> > -	.resume		=3D NULL,
> > +	.chip_enable	=3D plat_kim_chip_enable,
> > +	.chip_disable	=3D plat_kim_chip_disable,
>=20
> I just wonder how this is going to work with DT... You are not going to h=
ave
> the ability to use callback in this form.
> I think the GPIO handling should be done in the driver itself rather than=
 in
> the board file.

that can (should ?) be moved to ti-st eventually. In fact I don't know
why it was removed in the first place, we would need Pavan to help us
with that query.

Still, for -rc, the minimal patch had to be cooked, right ?

--=20
balbi

--ofZMSlrAVk9bLeVm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ98WnAAoJEIaOsuA1yqRECY4QAIG9mahjr7Qs8VaG6zCQKcxS
9xVjxmYgRm+kQuaIAz71sJexC/KA5zvlf0C9BfBN3d8JCDeXqAVppIYEVVTEZ6BY
zN1/WH0juMuAG0D26NnHtr70GGHi5bsPmQJtMXtsE3qtp64lRxmUmwdti8EezsZ5
9SKrqJFmw93i6URyYI11c9wGhVeNar7cT7EFp5Teic46E/NowFdlWaLaVLxJ5fKM
ba+CZm9LlD9r0LDsIaV7GRJSM+MN5G3M1lI0Gy5S91m0Y/OjwrNDati1+0/jdjSQ
zZcEAH5hsEY6L5dR5sddAshEOw2waHQzlRyY7oyZc40ddQlf3o/LQogbY1VQNvAo
vjhfgn3vmT0lEDyxcLiBlTezTEy/gqOE2UTTwUt1CfSHVdl5hVQmN52EFaWTrtaq
4aSfGcR9fDlPADe+usNH1GS4Zs6wAaPJHt3+uV2fcZFMf9d6ue/YPXVA+VnnQt4N
jsenFZIIYweSPl8WdE7Sog+8lnFsvW3KsJ1tLGngJXOogLpCck0h+qy9NksrzEUa
w1R4Gkp1HbTxaMb6Ejtgl2y5OBlHrqFniZtDTC0FYcTy7cmfkmAjSrrE+RPPXG6K
xxjuVR3ojrO+2woS3tJ/P+BdBkA7Ke1uDqOrFLLDvg9/ym4ndSFSwn+EvGRBcA6g
F5JW1ZAuYayc/ho02KwL
=lgyu
-----END PGP SIGNATURE-----

--ofZMSlrAVk9bLeVm--
