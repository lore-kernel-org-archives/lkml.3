Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaKGXlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:41:35 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:37064 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaKGXlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:41:32 -0500
Date: Fri, 7 Nov 2014 19:39:58 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Caesar Wang <caesar.wang@rock-chips.com>, heiko@sntech.de,
        rui.zhang@intel.com, zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com, fzf@rock-chips.com
Subject: Re: [PATCH v17 1/5] thermal: rockchip: add driver for thermal
Message-ID: <20141107233956.GA27665@developer>
References: <1414809873-32227-1-git-send-email-caesar.wang@rock-chips.com>
 <1414809873-32227-2-git-send-email-caesar.wang@rock-chips.com>
 <20141107013017.GA10180@developer>
 <20141107015728.GF34214@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20141107015728.GF34214@dtor-ws>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Dmitry,

On Thu, Nov 06, 2014 at 05:57:28PM -0800, Dmitry Torokhov wrote:
> Hi Eduardo,
>=20
> On Thu, Nov 06, 2014 at 09:30:20PM -0400, Eduardo Valentin wrote:
> > Hello Caesar,
> >=20
> > On Sat, Nov 01, 2014 at 10:44:29AM +0800, Caesar Wang wrote:
> > > Thermal is TS-ADC Controller module supports
> > > user-defined mode and automatic mode.
> > >=20
> > > User-defined mode refers,TSADC all the control signals entirely by
> > > software writing to register for direct control.
> > >=20
> > > Automaic mode refers to the module automatically poll TSADC output,
> > > and the results were checked.If you find that the temperature High
> > > in a period of time,an interrupt is generated to the processor
> > > down-measures taken;If the temperature over a period of time High,
> > > the resulting TSHUT gave CRU module,let it reset the entire chip,
> > > or via GPIO give PMIC.
> > >=20
> >=20
> > First thing, very good progress in this driver!=20
> >=20
> > > Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
> > > Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> > > Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> >=20
> > Just for the sake of code / documentation history, this patch, which
> > adds the driver, should come after patch 2, which adds dt documentation.
> >=20
> > > ---
> > >  drivers/thermal/Kconfig            |   9 +
> > >  drivers/thermal/Makefile           |   1 +
> > >  drivers/thermal/rockchip_thermal.c | 711 +++++++++++++++++++++++++++=
++++++++++
> > >  3 files changed, 721 insertions(+)
> > >  create mode 100644 drivers/thermal/rockchip_thermal.c
> >=20
> > <big cut>
> >=20
> > > +static int
> > > +rockchip_thermal_register_sensor(struct platform_device *pdev,
> > > +				 struct rockchip_thermal_data *thermal,
> > > +				 struct rockchip_thermal_sensor *sensor,
> > > +				 enum sensor_id id)
> > > +{
> > > +	const struct rockchip_tsadc_chip *tsadc =3D thermal->chip;
> > > +	int error;
> > > +
> > > +	tsadc->set_tshut_mode(id, thermal->regs, thermal->tshut_mode);
> > > +	tsadc->set_tshut_temp(id, thermal->regs, thermal->tshut_temp);
> > > +
> > > +	sensor->thermal =3D thermal;
> > > +	sensor->id =3D id;
> > > +	sensor->tzd =3D thermal_zone_of_sensor_register(&pdev->dev, id, sen=
sor,
> > > +						rockchip_thermal_get_temp,
> > > +						NULL,
> > > +						rockchip_thermal_set_trips);
> >=20
> > So, did I miss something here? Looks like you have extended the of
> > thermal, and I haven't seen the patch.
> >   CC [M]  drivers/thermal/rockchip_thermal.o
> >   drivers/thermal/rockchip_thermal.c: In function
> >   `rockchip_thermal_register_sensor':
> >   drivers/thermal/rockchip_thermal.c:482:7: error: too many arguments to
> >   function `thermal_zone_of_sensor_register'
> >          rockchip_thermal_set_trips);
>=20
> Yes, it relies on patch by Mikko Perttunen adding support for
> hardware-supported trip points. It allows us to reduce polling frequency
> while still being able to react when we cross the tripping point.
>=20
> See https://lkml.org/lkml/2014/6/27/76
>=20

Yeah, that thread needs to be re-taken. Today I merged nvidia's driver,
but only a simpler version of it. I expect that they take the missing
parts through after updating / refreshing the patches.

And on that front, as I requested, there must be also equivalent mapping
in the thermal core, to avoid spreading / growing of-thermal as a
secondary thermal API.

One thing for sure that must be done is a little refactoring in the
of-thermal registration functions. I had a similar discussion about this
with Lukasz, who is also interested in improving the of-thermal
callbacks.

Cheers,

> Thanks.
>=20
> --=20
> Dmitry

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXVhBAAoJEMLUO4d9pOJWRvsH/36hPhZiMhL7T98JOCZckL4B
svYwwczBS9ka+q3PihKLdI8Sez7KkiEpse5HyrQEUXdDxDAnBmiQOiIxL9sjWRin
pDzZrfEXYclPW5NBz4HyJ3Z3kS4IlSdZthsVmCTL7YfUHrbgHey5c8I97TlBeua5
yupt0sYiZQrFJgEImxXz4tQV3sH9R7rbBIQeNhuYYz3FJX3XG3dSrNCJPwOUG4hg
a4NMcTicRVkPKCeGP/x0eb+bUXvLw+Y+Ezx1XaJRmkNK+xBK70BFtxcUJ9HgqSi0
vfi43FwXaP+zCWeA1UsMzaIUvDEcfnZfvUL1y2JANcm6UUzkAkd/qia7wwCmgK8=
=238s
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
