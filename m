Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaKXVpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:45:16 -0500
Received: from 7.mo1.mail-out.ovh.net ([87.98.158.110]:56372 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750791AbaKXVpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:45:14 -0500
X-Greylist: delayed 4517 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2014 16:45:13 EST
Date: Mon, 24 Nov 2014 21:28:30 +0100
From: Lukasz Majewski <l.majewski@majess.pl>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH v2] thermal:core:fix: Check return code of the
 ->get_max_state() callback
Message-ID: <20141124212830.0d7bec69@jawa>
In-Reply-To: <20141124180222.GA1449@developer>
References: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
	<1416305790-27746-1-git-send-email-l.majewski@samsung.com>
	<20141121180826.GA3331@developer>
	<20141124113854.36975fb2@amdc2363>
	<20141124180222.GA1449@developer>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zbsm6d0D6/bb_MtzePe6t3f"; protocol="application/pgp-signature"
X-Ovh-Tracer-Id: 10733203813489230586
X-Ovh-Remote: 109.241.105.88 (109241105088.warszawa.vectranet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -200
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrleejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdengfhvvghrhghhihhtvgdqqdetucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrleejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdengfhvvghrhghhihhtvgdqqdetucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zbsm6d0D6/bb_MtzePe6t3f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Nov 2014 14:02:25 -0400
Eduardo Valentin <edubezval@gmail.com> wrote:

>=20
> Hello Lukasz,
>=20
> On Mon, Nov 24, 2014 at 11:38:54AM +0100, Lukasz Majewski wrote:
> > Hi Eduardo,
> >=20
> > >=20
> > > Lukasz,
> > >=20
> > > On Tue, Nov 18, 2014 at 11:16:30AM +0100, Lukasz Majewski wrote:
> > > > The return code from ->get_max_state() callback was not checked
> > > > during binding cooling device to thermal zone device.
> > > >=20
> > > > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > > > ---
> > > > Changes for v2:
> > > > - It turned out that patches from 1 to 6 from v1 are not needed,
> > > > since they either already solve the problem (like
> > > > imx_thermal.c) or not use cpufreq as a thermal cooling device.
> > > > - The patch 7 from v1 is also not needed since this patch on
> > > > error exits this function without using max_state variable.
> > > > - In thermal driver probe the cpufreq_cooling_register() method
> > > > presence is crucial to evaluate if the thermal driver needs any
> > > > actions with -EPROBE_DEFER.
> > >=20
> > > Have you tried this patch with of-thermal based systems?
> >=20
> > Yes. I did try it with Exynos (after the rework). And there weren't
> > any regressions.
> >=20
> > To be precise - do you refer to of_cpufreq_cooling_register() [1] or
> > cpufreq_cooling_register() [2]?
> >=20
>=20
> [1]
>=20
> > For the latter [2] - drivers like imx_thermal.c are fully prepared
> > for -EDEFER_PROBE.
> >=20
> > For the former [1] - only cpufreq-dt.c uses it (and Exynos SoC after
> > the rework).
> >=20
> > >=20
> > > The above proposal works if the thermal driver is dealing with
> > > loading cpu_cooling. But for of-thermal based drivers, the idea
> > > is to leave to cpufreq code to load it.=20
> >=20
> > I assume, that you mean case [1]?
> >=20
>=20
> yup
>=20
> > >=20
> > > As an example, I am taking the ti-soc-thermal, but we already have
> > > other of-thermal based drivers. Booting with this patch
> > > ti-soc-thermal (of-based boot) loads fine, but the cpu_cooling
> > > never gets bound to the thermal zone.
> >=20
> > Could you share the exact SoC/board/_defconfig setup to reproduce
> > this behavior? I possess Beagle Bone Black, but it doesn't have
> > thermal support (perhaps because its lack of accuracy).
> >
>=20
> Well, it may happen any system a driver with of-thermal + cpufreq-dt.
>=20
> One board that is easily available is OMAP4460 panda board (tried
> myself, the problem is there).
>=20
> > With my Exynos setup I didn't experience any problems with this
> > patch.
> >=20
> > >=20
> > > The thing is that the bind may happen before cpufreq-dt code
> > > loads the cpufreq driver, and when cpu_cooling is checking what
> > > is the max freq, by using cpufreq table, it won't be able to do
> > > it, as there is no table.
> >=20
> > As I look into the cpufreq-dt.c driver - in the cpufreq_init()
> > function, the call to of_cpufreq_cooling_register() is performed
> > just before cpufreq_table_validate_and_show().
> > It looks like a mistake in the cpufreq-dt.c code.
> >=20
>=20
> Well, I believe for our case, better would be if the cpu_cooling could
> be done after cpufreq driver registration call.
>=20
>=20
> > >=20
> > > While, without the patch, it will use wrong in the binding, but
> > > after it gets bound, and cpufreq loads, the max will be used
> > > correctly.
> >=20
> > Correct. Such _wrong_ behavior was the original motivation to
> > prepare this patch.
> >=20
> > >=20
> > > And in this case, the system still works besides this bug.=20
> >=20
> > Unfortunately there is also a "window" in which the driver is not
> > properly configured and can cause system crash, although it is
> > unlikely.
> >=20
>=20
> Agreed.
>=20
> >=20
> > > The
> > > reasoning is because the max state comes from DT (2) and lower and
> > > upper wont be equal to THERMAL_NO_LIMIT. Then, the following check
> > > will use the parameter, instead of max_state:
> > >=20
> > >         cdev->ops->get_max_state(cdev, &max_state);
> > >=20
> > > 	/* lower default 0, upper default max_state */
> > > 	lower =3D lower =3D=3D THERMAL_NO_LIMIT ? 0 : lower;
> > > 	upper =3D upper =3D=3D THERMAL_NO_LIMIT ?
> > > 				max_state : upper;
> > >=20
> > > In summary, introducing this patch, although it fix a problem,
> > > will introduce regressions, in of-thermal based drivers.
> >=20
> > To be more precise - it will affect systems, which use of-thermal.c
> > and cpufreq-dt.c in the same time, due to wrong ordering in the
> > latter file.
> >=20
>=20
> Exactly.
>=20
> > Could you give me a hint about the exact affected system? I've
> > grep'ed for CPUFREQ_DT in the ./arch/arm/configs with no success.
> >=20
>=20
> Yeah, the grepping is correct. But well, just because it is not in
> defconfigs does not mean it won't be used.=20
>=20
> > >=20
> > > I believe, to have this fix, you need to provide a way to have
> > > probing deferring also in cpu_cooling. That needs also the change
> > > in the cpufreq driver, as I mentioned in the other thread.
> >=20
> > I will think about possible solution and refer to previous
> > discussion.=20
> >=20
>=20
> Good. For your patch, it is still sane to have it. But needs to be
> taken after fixing the ordering between cpufreq-dt and cpu_cooling.

Such fix has been already prepared by Viresh. Could you test if it
works on your Panda Board (unfortunately I don't have one)?
>=20
>=20
> > >=20
> > > Cheers,
> > >=20
> > > > ---
> > > >  drivers/thermal/thermal_core.c | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > >=20
> > > > diff --git a/drivers/thermal/thermal_core.c
> > > > b/drivers/thermal/thermal_core.c index 43b9070..8567929 100644
> > > > --- a/drivers/thermal/thermal_core.c
> > > > +++ b/drivers/thermal/thermal_core.c
> > > > @@ -928,7 +928,7 @@ int thermal_zone_bind_cooling_device(struct
> > > > thermal_zone_device *tz, struct thermal_zone_device *pos1;
> > > >  	struct thermal_cooling_device *pos2;
> > > >  	unsigned long max_state;
> > > > -	int result;
> > > > +	int result, ret;
> > > > =20
> > > >  	if (trip >=3D tz->trips || (trip < 0 && trip !=3D
> > > > THERMAL_TRIPS_NONE)) return -EINVAL;
> > > > @@ -945,7 +945,9 @@ int thermal_zone_bind_cooling_device(struct
> > > > thermal_zone_device *tz, if (tz !=3D pos1 || cdev !=3D pos2)
> > > >  		return -EINVAL;
> > > > =20
> > > > -	cdev->ops->get_max_state(cdev, &max_state);
> > > > +	ret =3D cdev->ops->get_max_state(cdev, &max_state);
> > > > +	if (ret)
> > > > +		return ret;
> > > > =20
> > > >  	/* lower default 0, upper default max_state */
> > > >  	lower =3D lower =3D=3D THERMAL_NO_LIMIT ? 0 : lower;
> > > > --=20
> > > > 2.0.0.rc2
> > > >=20
> >=20
> >=20
> > --=20
> > Best regards,
> >=20
> > Lukasz Majewski
> >=20
> > Samsung R&D Institute Poland (SRPOL) | Linux Platform Group

Best regards,
Lukasz Majewski

--Sig_/zbsm6d0D6/bb_MtzePe6t3f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRzlO4ACgkQf9/hG2YwgjE54ACfReVRP6PXbjlarQtiw4GY+/7K
Z/AAnjuI6Qv9L1UlhLO5yFoygsfZIoZy
=DW9J
-----END PGP SIGNATURE-----

--Sig_/zbsm6d0D6/bb_MtzePe6t3f--
