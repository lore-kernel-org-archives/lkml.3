Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaKFXsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:48:36 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:40846 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaKFXsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:48:33 -0500
Date: Thu, 6 Nov 2014 19:48:15 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH v3] thermal: Add QPNP PMIC temperature alarm driver
Message-ID: <20141106234812.GB8176@developer>
References: <1412178817-20371-1-git-send-email-iivanov@mm-sol.com>
 <20141027201602.GC6088@developer>
 <1414596776.32383.2.camel@mm-sol.com>
 <1414677345.12674.1.camel@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <1414677345.12674.1.camel@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 03:55:45PM +0200, Ivan T. Ivanov wrote:
>=20
> On Wed, 2014-10-29 at 17:32 +0200, Ivan T. Ivanov wrote:
> >=20
> +
> > > > +       chip->tz_dev =3D thermal_zone_device_register(node->name, T=
RIP_NUM, 0,
> > > > +       chip, &qpnp_tz_ops, NULL,
> > >=20
> > > Have you considered using of-thermal instead of doing your own specif=
ic thermal
> > > zone registration? Having a glance look in this driver, most of the
> > > operation are covered by of-thermal. Ahy concerns using of-thermal in
> > > your case?
> > >=20
> >=20
> > I just followed implementation found in "armada_thermal", "db8500-therm=
al",
> > "dove_thermal", "imx_thermal", "kirkwood_thermal"...
> >=20
> > Will look at of-thermal.
> >=20
>=20
> Hm, the 15 drivers, which register its own thermal zone, against 4, which=
=20

Yes, and the reasoning is pretty simple: of-thermal is not imposed
standard, and not all platform have decided to move to using it.
However, DT is being used more and more frequently. So, given you
already have DT support, considering using of-thermal is a good thing to do=
=2E=20

Besides, you are with hands on your driver, might make sense to add its
support while you are there.=20

> use of-thermal registration and one of them is OMAP, which have fallback
> to its own zone registration :-). Anyway. I am afraid that if I use just

The fallback is because non-dt booting has not been dropped from OMAP,
AFAIK.

> thermal_zone_of_sensor_register(), driver will lost ability to switch off=
=20
> hardware controlled shutdown sequence, which make it useless IMHO.

Any special sequence or callback you want to consider to improve
of-thermal support?


For instance, getting a callback for mode change events would enable you
to get a better support for hardware controlled shutdown sequence?


>=20
> I don't see how driver can benefits from nice things provided by of-therm=
al.
> There is no colling device associated with PMIC chip, pooling delays are =
of
> no use, device uses interrupt, trip pints are predefined in hardware...

I see. However, using it may make this driver even simpler, as you would
simply describe it in DT and the notification you want would be taken
care by the core part of the framework.

>=20
> Please advice.
>=20
> Regards,
> Ivan

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXAizAAoJEMLUO4d9pOJWTkwH/2XInDMeeJuIOK6CWM5WDUYV
HCjuNs3AGlNys9Z/m8BAGcMkT+KiQqWN+utfN3ltWI4YlvEmonUEksk/HRc1nyON
t6Q4UGdNf8O0e9DfuyNESCZUbaleVQEkjgdfOm6EPjna+moUJ0BAzlbAKwGb9JtI
WMT28qn000QGxVw4aSHzJiftKIEN00txLym727vtmPGebd6ci0lHQQrZ3JCvbj5z
HMogP7nV6u1ZnVAF7XXqf83WacqxBNBKTT1uYE8EE2PACC+CMFnBr1HH3p5uL+he
d3GyN2pG1F9XoV6e96G3TPYzzo9c5O6wTiPMClUQsX5XE8N6A3oEf6e7MftRaQY=
=Emhb
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
