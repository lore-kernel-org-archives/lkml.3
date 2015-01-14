Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbbANS2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:28:52 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:44527 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbbANS2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:28:49 -0500
Date: Wed, 14 Jan 2015 14:28:37 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: Re: [PATCH v2 2/8] thermal: Provide stub for thermal_cdev_update()
 function
Message-ID: <20150114182835.GA3672@developer>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-3-git-send-email-l.majewski@samsung.com>
 <20150102184028.GA12371@developer>
 <20150114160753.48f903da@amdc2363>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20150114160753.48f903da@amdc2363>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2015 at 04:07:53PM +0100, Lukasz Majewski wrote:
> Hi Eduardo,
>=20
> > On Mon, Dec 22, 2014 at 05:27:42PM +0100, Lukasz Majewski wrote:
> > > Odroid U3 fan can work without being registered as OF cooling device
> > > (with CONFIG_THERMAL_OF disabled).
> > > In this situation it can be controlled via PWM entry at
> > > /sys/class/hwmon/hwmon0/pwm1.
> > >=20
> > > Therefore, the thermal_cdev_update() function needs a stub
> > > to allow clean compilation.
> >=20
> > I am not sure I understand what you are attempting to do here. What is
> > the relation that you see between CONFIG_OF_THERMAL and
> > thermal_cdev_update?=20
>=20
> It should be CONFIG_THERMAL, not CONFIG_OF_THERMAL.
>=20
> The thermal_cdev_update() is necessary since pwm-fan code can be
> run without THERMAL subsystem (and such configuration is perfectly
> valid).

OK. Now I understand. Then, please resend this one using CONFIG_THERMAL.


Thanks,


Eduardo Valentin

>=20
> >=20
> > >=20
> > > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > > ---
> > > Changes for v2:
> > > - New patch
> > > ---
> > >  include/linux/thermal.h | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > > index 871123c..b3515b5 100644
> > > --- a/include/linux/thermal.h
> > > +++ b/include/linux/thermal.h
> > > @@ -332,6 +332,7 @@ struct thermal_cooling_device *
> > >  thermal_of_cooling_device_register(struct device_node *np,
> > >  				   char *type, void *devdata,
> > >  				   const struct
> > > thermal_cooling_device_ops *); +void thermal_cdev_update(struct
> > > thermal_cooling_device *); #else
> > >  static inline struct thermal_zone_device *
> > >  thermal_zone_of_sensor_register(struct device *dev, int id, void
> > > *data, @@ -353,6 +354,10 @@
> > > thermal_of_cooling_device_register(struct device_node *np, {
> > >  	return NULL;
> > >  }
> > > +
> > > +static inline void thermal_cdev_update(struct
> > > thermal_cooling_device *cdev) +{
> > > +}
> > >  #endif
> > >  struct thermal_zone_device *thermal_zone_device_register(const
> > > char *, int, int, void *, struct thermal_zone_device_ops *,
> > > @@ -375,7 +380,6 @@ int thermal_zone_get_temp(struct
> > > thermal_zone_device *tz, unsigned long *temp); int
> > > get_tz_trend(struct thermal_zone_device *, int); struct
> > > thermal_instance *get_thermal_instance(struct thermal_zone_device
> > > *, struct thermal_cooling_device *, int); -void
> > > thermal_cdev_update(struct thermal_cooling_device *); void
> > > thermal_notify_framework(struct thermal_zone_device *, int);=20
> > >  #ifdef CONFIG_NET
> > > --=20
> > > 2.0.0.rc2
> > >=20
>=20
>=20
> --=20
> Best regards,
>=20
> Lukasz Majewski
>=20
> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUtrVIAAoJEMLUO4d9pOJWQRYH/1A0R6BYwPWkVKEViu3ASgNK
sHO81csXMk9Z5p9OUpRixD2WuaL1Z8k8vH1bR7mp76bLmBF5V6xBfat2OrSeeWLI
wfQC4EZIp7OtT2nd80mm2Gb6RocmcjVTecqxex7QY7oM9grDyGRlRmsuYptEDrMg
Gjco7nwSvbK/R3OyZ1ZwHOlKFAdOIWhT4aqzr56xcOibDoC7gl6PzozTm3M5wzxT
zqffWgztZ2ccklteYLPbRjCscX++pPGS3089Ti6Nc7ojsOns9cPRy4eJmnwGxL0U
R4DZ1vlDYmO1dMNh3YgW8BuwoARRGzn03pcPo3VUuaEEhsNtzDTsx45vlO0VW28=
=rOL+
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
