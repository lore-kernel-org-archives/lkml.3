Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbaLIAUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 19:20:13 -0500
Received: from 2.mo2.mail-out.ovh.net ([188.165.53.149]:45513 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751103AbaLIAUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 19:20:11 -0500
X-Greylist: delayed 4590 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2014 19:20:10 EST
Date: Tue, 9 Dec 2014 00:02:30 +0100
From: Lukasz Majewski <l.majewski@majess.pl>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Caesar Wang <caesar.wang@rock-chips.com>,
        navneet kumar <navneetk@nvidia.com>
Subject: Re: [PATCH v3 1/5] thermal: of: Extend of-thermal.c to provide
 number of trip points
Message-ID: <20141209000230.09137628@jawa>
In-Reply-To: <20141208195247.GA31126@developer>
References: <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
	<1418058261-25251-1-git-send-email-l.majewski@samsung.com>
	<1418058261-25251-2-git-send-email-l.majewski@samsung.com>
	<20141208195247.GA31126@developer>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/7zPJfoKwlFbyhNxm801e07S"; protocol="application/pgp-signature"
X-Ovh-Tracer-Id: 3319997351533134586
X-Ovh-Remote: 109.241.105.88 (109241105088.warszawa.vectranet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -200
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejiedrfeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdengfhvvghrhghhihhtvgdqqdetucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejiedrfeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdengfhvvghrhghhihhtvgdqqdetucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7zPJfoKwlFbyhNxm801e07S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Dec 2014 15:52:49 -0400
Eduardo Valentin <edubezval@gmail.com> wrote:

Hi Eduardo,

> On Mon, Dec 08, 2014 at 06:04:17PM +0100, Lukasz Majewski wrote:
> > This patch extends the of-thermal.c to provide information about
> > number of available trip points.
> >=20
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > ---
> > Changes for v3:
> > - Exporting of_thermal_get_ntrips symbol as a GPL
> > - Fix build error when CONFIG_THERMAL_OF is disabled
> >=20
> > Changes for v2:
> > - Provide detailed (doxygen like) description of the
> > of_thermal_get_ntrips() method
> > - Check for data pointer not being NULL
> > ---
> >  drivers/thermal/of-thermal.c   | 21 +++++++++++++++++++++
> >  drivers/thermal/thermal_core.h |  5 +++++
> >  2 files changed, 26 insertions(+)
> >=20
> > diff --git a/drivers/thermal/of-thermal.c
> > b/drivers/thermal/of-thermal.c index b7982f0..7facd23 100644
> > --- a/drivers/thermal/of-thermal.c
> > +++ b/drivers/thermal/of-thermal.c
> > @@ -112,6 +112,27 @@ static int of_thermal_get_temp(struct
> > thermal_zone_device *tz, return
> > data->ops->get_temp(data->sensor_data, temp); }
> > =20
> > +/**
> > + * of_thermal_get_ntrips - function to export number of available
> > trip
> > + *			   points.
> > + * @tz: pointer to a thermal zone
> > + *
> > + * This function is a globally visible wrapper to get number of
> > trip points
> > + * stored in the local struct __thermal_zone
> > + *
> > + * Return: number of available trip points, -ENODEV when data not
> > available
> > + */
> > +int of_thermal_get_ntrips(struct thermal_zone_device *tz)
> > +{
> > +	struct __thermal_zone *data =3D tz->devdata;
> > +
> > +	if (!data || IS_ERR(data))
> > +		return -ENODEV;
> > +
> > +	return data->ntrips;
> > +}
> > +EXPORT_SYMBOL_GPL(of_thermal_get_ntrips);
> > +
> >  static int of_thermal_get_trend(struct thermal_zone_device *tz,
> > int trip, enum thermal_trend *trend)
> >  {
> > diff --git a/drivers/thermal/thermal_core.h
> > b/drivers/thermal/thermal_core.h index d15d243..1cc5041 100644
> > --- a/drivers/thermal/thermal_core.h
> > +++ b/drivers/thermal/thermal_core.h
> > @@ -89,9 +89,14 @@ static inline void
> > thermal_gov_user_space_unregister(void) {} #ifdef CONFIG_THERMAL_OF
> >  int of_parse_thermal_zones(void);
> >  void of_thermal_destroy_zones(void);
> > +int of_thermal_get_ntrips(struct thermal_zone_device *);
>=20
> Lukasz,
>=20
> Here is a question that applies to all patches in this series adding
> functions in this header.
>=20
> i suppose you intend to use these new functions in driver code, right?

Yes, right.

> Add them here, will limit their usage to code inside drivers/thermal.

This is my intention - at least for now the use case is to configure the
thermal driver (i.e. Exynos TMU). Other drivers (e.g. TI) can benefit
from this code too.

>=20
> Shouldn't these new APIs be declared under include/linux/thermal.h?

I'd prefer to leave this API in ./drivers/thermal and move them to
./include/linux/thermal.h only when other parts of the kernel require
it.

>=20
> This way, they can be be available to other parts of the kernel too.
>=20
>=20
> >  #else
> >  static inline int of_parse_thermal_zones(void) { return 0; }
> >  static inline void of_thermal_destroy_zones(void) { }
> > +static inline int of_thermal_get_ntrips(struct thermal_zone_device
> > *tz) +{
> > +	return 0;
> > +}
> >  #endif
> > =20
> >  #endif /* __THERMAL_CORE_H__ */
> > --=20
> > 2.0.0.rc2
> >=20

Best Regards,

Lukasz Majewski

--Sig_/7zPJfoKwlFbyhNxm801e07S
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlSGLg0ACgkQf9/hG2YwgjHDwgCgxTg7KjcrOaNAdtjFpILBBb47
318AoKOtgES5YxmeLzRLcBB9sKKKwWUJ
=N+Nc
-----END PGP SIGNATURE-----

--Sig_/7zPJfoKwlFbyhNxm801e07S--
