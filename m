Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbaLAVXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:23:36 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34797 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaLAVXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:23:34 -0500
Date: Mon, 1 Dec 2014 17:23:23 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: navneet kumar <navneetk@nvidia.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] thermal: of: notify sensor driver on trip updates
Message-ID: <20141201212321.GA4142@developer>
References: <1417050989-25405-1-git-send-email-navneetk@nvidia.com>
 <1417050989-25405-3-git-send-email-navneetk@nvidia.com>
 <20141127143236.GD3342@developer>
 <547CD380.3030707@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <547CD380.3030707@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2014 at 12:45:52PM -0800, navneet kumar wrote:
> Hi Eduardo,
>=20
> On 11/27/2014 06:32 AM, Eduardo Valentin wrote:
> > * PGP Signed by an unknown key
> >=20
> > Hello Navneet,
> >=20
> > On Wed, Nov 26, 2014 at 05:16:29PM -0800, Navneet Kumar wrote:
> >> From: navneet kumar <navneetk@nvidia.com>
> >>
> >> some thermal sensor hardwares include logic which
> >> can raise interrupts at certain programmed temperature
> >> thresholds.
> >>
> >> Drivers for such sensors should be able to learn the
> >> appropriate threshold temperatures for interrupts by querying
> >> the thermal framework.
> >>
> >> This change provides a mechanism to allow a sensor driver to
> >> update it's thresholds when userspace changes a trip point
> >> temperature.
> >>
> >> While this behavior may not make sense in thermal zones
> >> with more than one sensor, no such examples exist in
> >> the kernel.
> >>
> >> Signed-off-by: navneet kumar <navneetk@nvidia.com>
> >> ---
> >>  drivers/thermal/of-thermal.c | 7 +++++++
> >>  include/linux/thermal.h      | 1 +
> >>  2 files changed, 8 insertions(+)
> >>
> >> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal=
=2Ec
> >> index 3d47a0cf3825..3568e4a586dc 100644
> >> --- a/drivers/thermal/of-thermal.c
> >> +++ b/drivers/thermal/of-thermal.c
> >> @@ -258,6 +258,9 @@ static int of_thermal_set_trip_temp(struct thermal=
_zone_device *tz, int trip,
> >>  	/* thermal framework should take care of data->mask & (1 << trip) */
> >>  	data->trips[trip].temperature =3D temp;
> >> =20
> >> +	if (data->sops.trip_update)
> >> +		data->sops.trip_update(data->sensor_data, trip);
> >> +
> >>  	return 0;
> >>  }
> >> =20
> >> @@ -285,6 +288,9 @@ static int of_thermal_set_trip_hyst(struct thermal=
_zone_device *tz, int trip,
> >>  	/* thermal framework should take care of data->mask & (1 << trip) */
> >>  	data->trips[trip].hysteresis =3D hyst;
> >> =20
> >> +	if (data->sops.trip_update)
> >> +		data->sops.trip_update(data->sensor_data, trip);
> >> +
> >>  	return 0;
> >>  }
> >> =20
> >> @@ -500,6 +506,7 @@ void thermal_zone_of_sensor_unregister(struct devi=
ce *dev,
> >> =20
> >>  	tz->sops.get_temp =3D NULL;
> >>  	tz->sops.get_trend =3D NULL;
> >> +	tz->sops.trip_update =3D NULL;
> >>  	tz->sensor_data =3D NULL;
> >>  	mutex_unlock(&tzd->lock);
> >>  }
> >> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> >> index 58341c56a01f..b93e65815175 100644
> >> --- a/include/linux/thermal.h
> >> +++ b/include/linux/thermal.h
> >> @@ -292,6 +292,7 @@ struct thermal_genl_event {
> >>  struct thermal_of_sensor_ops {
> >>  	int (*get_temp)(void *, long *);
> >>  	int (*get_trend)(void *, long *);
> >> +	int (*trip_update)(void *, int);
> >=20
> > First thing I ask you is to update your work on top of my -linus branch,
> > as I already mentioned. Reasoning is that part of the changes you are
> > sending is already there.
> will do.
> >=20
> > As for this new callback, I am fine with it as long as it is also
> > available for drivers that do not use of-thermal. Once again, of-thermal
> > is not a competitor of thermal core. It will never be. It is not a new
> > thermal API.=20
> I agree that this callback is not a part of the thermal_core functionalit=
y.
> However, when a driver registers directly with the thermal_core (doesn't =
use
> of-thermal), it 'owns' the set_trip_XX callbacks in the first place; whic=
h is
> the sole purpose of using the 'trip_update' callback in of-thermal.
>=20
> Adding an additional 'update' to the thermal_core ops would be a no-op. r=
ight?

Yes, you are right. Now I understand your point.=20

Can we then re-use the .set_trips nomenclature?

Cheers,

> >=20
> > That said, it does not make sense to have functionality in of-thermal t=
hat
> > do not belong to thermal core. Exceptions are, of course, for helping
> > doing the same operations we already have in thermal core.
> >=20
> > All the best,
> >=20
> > Eduardo Valentin
> >=20
> >>  };
> >> =20
> >>  /* Function declarations */
> >> --=20
> >> 1.8.1.5
> >>
> >=20
> > * Unknown Key
> > * 0x7DA4E256
> >=20

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfNxAAAoJEMLUO4d9pOJW0Q4H/AyNwVrFJxdhj70st2s7skEm
2u4nlFR1hqtihPXf6GM/pfpWXu716SL4PwIL485cmP1k5I8ZSxIUNAx5Wl6w0eiP
vYrEnvmXpo/NKIqi3owio8gvfmpE15Me7b+XbPdtnc1j9++aRuBvRHoq4x6QD6IR
SZnt6qABoit8rdJBAwKfnt2p+KUar/9N+NiGmwYqU+jI2n9CVDRXA3wufhAisW83
QqJU3RJbshcQFPT5CTOJAHkUPj6O+nJyF+Dvm0m5LuQ9LHQJW/1gJ5vcFXN1Y693
SSHWJwqbhre/iQhjiuTuSZ/OLcXdXf7zp/nJCZx0yh4VWCfoBaoDLYoX4tGwPR0=
=0w0T
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
