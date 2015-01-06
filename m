Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbbAFNI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:08:58 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:51116 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbbAFNIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:08:46 -0500
Date: Tue, 6 Jan 2015 09:08:50 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v6 5/9] thermal: extend the cooling device API to
 include power information
Message-ID: <20150106130847.GB4661@developer>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
 <1417806260-9264-6-git-send-email-javi.merino@arm.com>
 <20141223151359.GB7350@developer>
 <20150105153710.GA3042@e104805>
 <20150105210403.GC31247@developer>
 <20150106103430.GD2885@e104805>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <20150106103430.GD2885@e104805>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 10:34:31AM +0000, Javi Merino wrote:
> Hi Eduardo,
>=20
> On Mon, Jan 05, 2015 at 09:04:09PM +0000, Eduardo Valentin wrote:
> > On Mon, Jan 05, 2015 at 03:37:10PM +0000, Javi Merino wrote:
> > > On Tue, Dec 23, 2014 at 03:14:11PM +0000, Eduardo Valentin wrote:
> > > > Hi Javi
> > > >=20
> > > > On Fri, Dec 05, 2014 at 07:04:16PM +0000, Javi Merino wrote:
> > > > > Add three optional callbacks to the cooling device interface to a=
llow
> > > > > them to express power.  In addition to the callbacks, add helpers=
 to
> > > > > identify cooling devices that implement the power cooling device =
API.
> > > > >=20
> > > > > Cc: Zhang Rui <rui.zhang@intel.com>
> > > > > Cc: Eduardo Valentin <edubezval@gmail.com>
> > > > > Signed-off-by: Javi Merino <javi.merino@arm.com>
> > > > > ---
> > > > >  Documentation/thermal/power_allocator.txt | 27 +++++++++++++++++=
+++++
> > > > >  drivers/thermal/thermal_core.c            | 38 +++++++++++++++++=
++++++++++++++
> > > > >  include/linux/thermal.h                   | 12 ++++++++++
> > > > >  3 files changed, 77 insertions(+)
> > > > >  create mode 100644 Documentation/thermal/power_allocator.txt
> > > > >=20
> > > > > diff --git a/Documentation/thermal/power_allocator.txt b/Document=
ation/thermal/power_allocator.txt
> > > > > new file mode 100644
> > > > > index 000000000000..d3bb79050c27
> > > > > --- /dev/null
> > > > > +++ b/Documentation/thermal/power_allocator.txt
> > > > > @@ -0,0 +1,27 @@
> > > > > +Cooling device power API
> > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > > >=20
> > > > Readers of this file need extra context here, IMO.
> > >=20
> > > Patch 7 adds text before and after this section that provides that
> > > context.
> > >=20
> > > > > +
> > > > > +Cooling devices controlled by this governor must supply the addi=
tional
> > > >=20
> > > > What governor? the files says power allocator, and the title says,
> > > > cooling device power API...
> > >=20
> > > Correct, because that's added in the patch that introduces the power
> > > allocator governor.  Therefore, it's not a problem for the readers of
> > > this file but for the readers of the patches.  I can move this hunk to
> > > patch 7 and introduce all the documentation at once if you think
> > > that's clearer.
> > >=20
> >=20
> > Thinking of the atomicity of each patch/commit, I would prefer you to
> > move all documentation to a single patch then.
>=20
> Ok, I'll move it to the patch that introduces the power allocator.
>=20
> [...]
> > > > > diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/the=
rmal_core.c
> > > > > index 9021cb72a13a..c490f262ea7f 100644
> > > > > --- a/drivers/thermal/thermal_core.c
> > > > > +++ b/drivers/thermal/thermal_core.c
> > > > > @@ -866,6 +866,44 @@ emul_temp_store(struct device *dev, struct d=
evice_attribute *attr,
> > > > >  static DEVICE_ATTR(emul_temp, S_IWUSR, NULL, emul_temp_store);
> > > > >  #endif/*CONFIG_THERMAL_EMULATION*/
> > > > > =20
> > > > > +/**
> > > > > + * power_actor_get_max_power() - get the maximum power that a cd=
ev can consume
> > > > > + * @cdev:	pointer to &thermal_cooling_device
> > > > > + *
> > > > > + * Calculate the maximum power consumption in milliwats that the
> > > > > + * cooling device can currently consume.  If @cdev doesn't suppo=
rt the
> > > > > + * power_actor API, this function returns 0.
> > > > > + */
> > > > > +u32 power_actor_get_max_power(struct thermal_cooling_device *cde=
v)
> > > > > +{
> > > > > +	if (!cdev_is_power_actor(cdev))
> > > > > +		return 0;
> > > > > +
> > > > > +	return cdev->ops->state2power(cdev, 0);
> > > > > +}
> > > > > +
> > > > > +/**
> > > > > + * power_actor_set_power() - limit the maximum power that a cool=
ing device can consume
> > > > > + * @cdev:	pointer to &thermal_cooling_device
> > > > > + * @power:	the power in milliwatts
> > > > > + *
> > > > > + * Set the cooling device to consume at most @power milliwatts.
> > > > > + *
> > > > > + * Returns: 0 on success, -EINVAL if the cooling device does not
> > > > > + * implement the power actor API or -E* for other failures.
> > > > > + */
> > > > > +int power_actor_set_power(struct thermal_cooling_device *cdev, u=
32 power)
> > > > > +{
> > > > > +	unsigned long state;
> > > > > +
> > > > > +	if (!cdev_is_power_actor(cdev))
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	state =3D cdev->ops->power2state(cdev, power);
> > > > > +
> > > > > +	return cdev->ops->set_cur_state(cdev, state);
> > > > > +}
> > > > > +
> > > > >  static DEVICE_ATTR(type, 0444, type_show, NULL);
> > > > >  static DEVICE_ATTR(temp, 0444, temp_show, NULL);
> > > > >  static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
> > > > > diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > > > > index 2c14ab1f5c0d..1155457caf52 100644
> > > > > --- a/include/linux/thermal.h
> > > > > +++ b/include/linux/thermal.h
> > > > > @@ -142,6 +142,9 @@ struct thermal_cooling_device_ops {
> > > > >  	int (*get_max_state) (struct thermal_cooling_device *, unsigned=
 long *);
> > > > >  	int (*get_cur_state) (struct thermal_cooling_device *, unsigned=
 long *);
> > > > >  	int (*set_cur_state) (struct thermal_cooling_device *, unsigned=
 long);
> > > > > +	u32 (*get_actual_power) (struct thermal_cooling_device *);
> > > > > +	u32 (*state2power) (struct thermal_cooling_device *, unsigned l=
ong);
> > > > > +	unsigned long (*power2state) (struct thermal_cooling_device *, =
u32);
> > > > >  };
> > > > > =20
> > > > >  struct thermal_cooling_device {
> > > > > @@ -322,6 +325,15 @@ void thermal_zone_of_sensor_unregister(struc=
t device *dev,
> > > > >  }
> > > > > =20
> > > > >  #endif
> > > > > +
> > > > > +static inline bool cdev_is_power_actor(struct thermal_cooling_de=
vice *cdev)
> > > > > +{
> > > >=20
> > > > What would happen if one pass cdev =3D=3D NULL?
> > >=20
> > > Is it really worth checking it here instead of just making the caller
> > > pass a valid cdev?  There are a number of functions in the thermal
> > > framework that don't check for valid cdevs or thermal zone pointers
> > > and I don't see why this one is different.
> >=20
> > I don't know, maybe we should fix those misbehaving functions then? Can
> > you please point them out?
>=20
> This is not an exhaustive list but a quick grep only in thermal_core.c
> yields:
>   - get_tz_trend() doesn't check tz
>   - get_thermal_instance() doesn't check tz or cdev
>   - thermal_zone_device_update() doesn't check tz
>   - thermal_zone_bind_cooling_device() doesn't check tz or cdev
>   - thermal_zone_unbind_cooling_device() doesn't check tz or cdev
>   - thermal_cdev_update() doesn't check cdev


Fair enough, I think your argument holds :-). We should keep the same
pattern. That means, for now we should make sure the callers pass
correct argument, as you suggested. You may keep the function the way it
is.

>=20
> > > > > +	return cdev->ops->get_actual_power && cdev->ops->state2power &&
> > > > > +		cdev->ops->power2state;
> > > > > +}
> > > > > +
> > > > > +u32 power_actor_get_max_power(struct thermal_cooling_device *);
> > > > > +int power_actor_set_power(struct thermal_cooling_device *, u32);
> > > > >  struct thermal_zone_device *thermal_zone_device_register(const c=
har *, int, int,
> > > > >  		void *, struct thermal_zone_device_ops *,
> > > > >  		const struct thermal_zone_params *, int, int);
> > > >=20
> > > > I am assuming the above two new functions are expected to be used a=
lso
> > > > outside thermal core, right? If yes, I'd suggest exporting them.=20
> > >=20
> > > I don't expect it for the time being.  Wouldn't it be preferable to
> > > export them when its needed instead?
> >=20
> > I believe functions in this header are exported. For functions used
> > inside thermal core and code that goes builtin always, they go into
> > drivers/thermal/thermal_core.h, and are not exported.
>=20
> Ok, I'll move them to drivers/thermal/thermal_core.h .
>=20

OK.

> Cheers,
> Javi

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUq95YAAoJEMLUO4d9pOJWOoAH/3DMMzyTJWYyAykOpLKnOP/9
gi9Kx2MqDMqeCV+k2YSJfuMo5V/oQloMx3pfanXwBA9joWXPU9YNNxGx+iqREagB
Z7bTRm+tZSs9q65a1G0yi/D1uCJgBkHWS3Xu2IFQIVLliqrUY4t/J4vCVr/hlHVR
wVl93WviuFZc3G6sb/+kwQkpUnHNa2Z7uQZ8txb4hLRSYDLZXbMo35h3hulwubKX
wtY8q39a/3hCy9TnAE70T4y4wR1grnrTqpGRFQ7u5kyyXhVHD441/1BvSr4a8BWc
sCnUfmdO67RP4qxdxu6NYCKjO2zs5z5e1Q9hgErnhBbQNjTThkuoOGpGZtMyabc=
=i3xl
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
