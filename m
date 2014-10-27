Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaJ0QvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:51:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44963 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbaJ0QvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:51:07 -0400
Date: Mon, 27 Oct 2014 11:49:50 -0500
From: Felipe Balbi <balbi@ti.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
CC: <balbi@ti.com>, Lucas Stach <l.stach@pengutronix.de>,
        Romain Perier <romain.perier@gmail.com>, <devicetree@vger.kernel.org>,
        <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <robh@kernel.org>, <mark.rutland@arm.com>, <johan@kernel.org>,
        <linux-pm@vger.kernel.org>, <linux@roeck-us.net>,
        <lee.jones@linaro.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <gnurou@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 06/10] mfd: tps65910: Use the standard DT property
 system-power-controller
Message-ID: <20141027164950.GK14253@saruman>
Reply-To: <balbi@ti.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
 <1414427749.2421.5.camel@pengutronix.de>
 <20141027164153.GE14253@saruman>
 <5506459.umvW5Ff7a7@diego>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yr6OvWOSyJed8q4v"
Content-Disposition: inline
In-Reply-To: <5506459.umvW5Ff7a7@diego>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yr6OvWOSyJed8q4v
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 05:49:34PM +0100, Heiko St=FCbner wrote:
> Am Montag, 27. Oktober 2014, 11:41:53 schrieb Felipe Balbi:
> > On Mon, Oct 27, 2014 at 05:35:49PM +0100, Lucas Stach wrote:
> > > Am Montag, den 27.10.2014, 16:26 +0000 schrieb Romain Perier:
> > > > No longer use custom property to define poweroff capability, use the
> > > > standard DT property instead.
> > > >=20
> > > > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > > > ---
> > > >=20
> > > >  drivers/mfd/tps65910.c | 3 +--
> > > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > >=20
> > > > diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> > > > index 7612d89..a7faff2 100644
> > > > --- a/drivers/mfd/tps65910.c
> > > > +++ b/drivers/mfd/tps65910.c
> > > > @@ -423,8 +423,7 @@ static struct tps65910_board
> > > > *tps65910_parse_dt(struct i2c_client *client,> >=20
> > > >  	board_info->irq =3D client->irq;
> > > >  	board_info->irq_base =3D -1;
> > > >=20
> > > > -	board_info->pm_off =3D of_property_read_bool(np,
> > > > -			"ti,system-power-controller");
> > > > +	board_info->pm_off =3D of_is_system_power_controller();
> > > >=20
> > > >  	return board_info;
> > > > =20
> > > >  }
> > >=20
> > > You are breaking compatibility with older DTs here. This is not
> > > acceptable.
> > >=20
> > > You may change all in-tree DTs to use the new property and also patch
> > > the driver to understand it, but you must make sure that the driver
> > > still understands the old, custom property. And especially in this ca=
se
> > > it isn't really hard to do.
> >=20
> > correct, it should be simple to hide that under
> > of_is_system_power_controller() itself.
>=20
> If I'm reading patch 1 correctly, it already does handle the generic "sys=
tem-
> power-controller", as well as any foo,system-power-controller properties.

that's very true, but it doesn't handle poweroff-source which, one way
or another, will be merged into Linus' tree creating a bisection point
where things won't work.

The best solution would be for those patches to be removed from
whichever tree they are, otherwise there will always be a commit in the
mainline kernel with that binding and, even if unlikely, there will
always be the possibility of people using that commit or a developer
having to bisect an issue only to find a few commits where things don't
even build.

--=20
balbi

--yr6OvWOSyJed8q4v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUTneuAAoJEIaOsuA1yqRELrsP/R9YUDNU4bGwfdQos4FVBmjS
BXl7orLx7p3p9o7d3m5/RO84VHuBwFQHk9jWsnpPcIXC+wwYpaKvY1U4f5/pPxxs
/qSUko09foZVRh3Y7XlCDpJ0VMuyZDdlKr1O7He1xEwPEtBD3L+xTaJ67vak6K9g
Q1GZlG5zPBB8U3KuizgZVOF4WRMt5mIIz3QSjTEYETjJVc23kGHB2IoOnlRu+isa
DMMsiW6Y/Wka9pYnLqtC51Qp4ywF5rdjR1U6iCziRZW2OTV3EDoB/grXy58YIaKO
4z9FUfwnEtqcM05pWlnBoXE4w2fg/j0M4TmSNURM+XRYnmkMccPGcdOyY3VLbHuS
TLC/GT6rml+m0pEtH43JeMEPf2yIZk19ZTSTvxi/9Y++fJs7M9210hEgiSVjNukv
AlJ7mKo1XFuDASmtwc/vLfBldbIvwPLLmFGFWeVNQJkt6GxiesumVh2jXu5SJ0Tw
8pNWLy8o87rwobZlj8zdpb22g38cKd0BjQnWtVzhd79hbp+wu8Wq3Eev5WJ4zUta
8g2LoTxE3XmqZY7i5SEGAKrIbOsgj5DxYhzZvMYjqfJjX/g7d3rMXvt0VFxDpY9B
0wTQpA/TO0Bbo0JQV3ZeQU6DiTySK7yRN/CRVry6tEleZTwokERw64ZoQ5NZbWiO
buhludXmlVWKj35Za+gS
=WSdR
-----END PGP SIGNATURE-----

--yr6OvWOSyJed8q4v--
