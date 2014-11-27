Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaK0OIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:08:22 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:41107 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaK0OIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:08:21 -0500
Date: Thu, 27 Nov 2014 10:08:06 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linux PM <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 1/1] thermal: cpu_cooling: check for the readiness of
 cpufreq layer
Message-ID: <20141127140803.GA3342@developer>
References: <1417024212-1775-1-git-send-email-edubezval@gmail.com>
 <CAKohponxUWVT1mjRfJarNtj-+=rXNOa_ONHUjmdu_+6N+=ZjPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <CAKohponxUWVT1mjRfJarNtj-+=rXNOa_ONHUjmdu_+6N+=ZjPQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello Viresh,

On Thu, Nov 27, 2014 at 09:38:39AM +0530, Viresh Kumar wrote:
> Few nits..
>=20
> On 26 November 2014 at 23:20, Eduardo Valentin <edubezval@gmail.com> wrot=
e:
>=20
> > Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
> > ---
>=20
> The normal practice is to write the non-commitable part here ...
>=20

err... normal practice by whom? hehe...

My "normal" practice is to allow people to read the diff stat before my
extra comments :-)

> >  drivers/thermal/cpu_cooling.c                      | 5 +++++
> >  drivers/thermal/db8500_cpufreq_cooling.c           | 5 -----
> >  drivers/thermal/imx_thermal.c                      | 5 -----
> >  drivers/thermal/samsung/exynos_thermal_common.c    | 2 +-
> >  drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 6 ------
> >  5 files changed, 6 insertions(+), 17 deletions(-)
> > ---
>=20
> But this works as well :)
>=20

hehe ok.

> > This is attempt to organize the cpu cooling vs. cpufreq boot sequencing.
> > The main change in this patch, as in the commit log, is to have the che=
ck
> > for the cpufreq layer in the cpu cooling device registration, instead of
> > in thermal drivers. This way, drivers don't need to bother about it, th=
ey
> > just need to propagate the error value.
> >
> > This change was tested on top of:
> > (0) - Viresh's change in cpufreq layer and cpufreq-dt (up to patch 4):
> > https://patchwork.kernel.org/patch/5384141/
> > https://patchwork.kernel.org/patch/5384151/
> > https://patchwork.kernel.org/patch/5384161/
> > https://patchwork.kernel.org/patch/5384171/
> > (1) - fix of thermal core:
> > https://patchwork.kernel.org/patch/5326991/
> >
> > After Viresh's changes, cpufreq-dt is properly sequenced with cpu cooli=
ng
> > registration. Non-of based drivers also should take advantage if these
> > changes, as now they do not need to check for cpufreq layer. The check =
is
> > where it belongs, in cpu cooling device registration.
> >
> > BR, Eduardo Valentin
> >
> >
> > diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_coolin=
g.c
> > index 1ab0018..9e6945b 100644
> > --- a/drivers/thermal/cpu_cooling.c
> > +++ b/drivers/thermal/cpu_cooling.c
> > @@ -440,6 +440,11 @@ __cpufreq_cooling_register(struct device_node *np,
> >         int ret =3D 0, i;
> >         struct cpufreq_policy policy;
> >
> > +       if (!cpufreq_get_current_driver() || !cpufreq_frequency_get_tab=
le(0)) {
>=20
> Only !cpufreq_frequency_get_table(0) is enough here.
>=20

Yeah, I thought of it too. Just combined what people had in their
drivers here. But I agree that latter is enough.

> For rest:
>=20
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Ok.

though.. "normal practice" says  ack's are oftern used by the maintainer
of the affected code (quoting Documentation/SubmittingPatches) :-)
BR, Eduardo Valenti

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdzA7AAoJEMLUO4d9pOJWX3gH/2658mc74Nu2gPLi5YK0Etp4
Av4yKKK0XKMlGdPr5bkZrn4S5864eKQTkaDM9+9dhoAoGgCToKkZfbTn11bqhUL2
WGj0JLpBvKlIYHX4nLRwrweVPWYjdzK4sKLL8H1di1WTX2os6l+plPcwutIqv4wn
Kzia+YdcvOl+O4bbIgIiyeqBoY2pHn7srlp5Adc01YppCzTbWIjcuyaeBJJ0UzvT
cI6tHg5mNX1BtKMVE/Slu/aIb4hVNoeyB00UhJ9pRL3T8wLoAEFP5mgh1xZe9mjS
xQJhamtXtGyEKzdpf2c+gZ2c/7oUN7B30jN9/3li8wrd+QxOy6W/21XsjLwZ/x0=
=5ifV
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
