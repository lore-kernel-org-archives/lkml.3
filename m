Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaK1Msj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:48:39 -0500
Received: from 6.mo6.mail-out.ovh.net ([87.98.177.69]:36448 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750901AbaK1Msi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:48:38 -0500
X-Greylist: delayed 8404 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2014 07:48:37 EST
Date: Fri, 28 Nov 2014 11:18:24 +0100
From: Lukasz Majewski <l.majewski@majess.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Eduardo Valentin <edubezval@gmail.com>
Cc: Linux PM <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCHv2 1/1] thermal: cpu_cooling: check for the readiness of
 cpufreq layer
Message-ID: <20141128111824.533c4641@jawa>
In-Reply-To: <CAKohponu_PRrqsuMdCJDznhiO_-=iCaYPhCCad8F4WS3rNxo5A@mail.gmail.com>
References: <1417097577-3548-1-git-send-email-edubezval@gmail.com>
	<CAKohponu_PRrqsuMdCJDznhiO_-=iCaYPhCCad8F4WS3rNxo5A@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2y2TlDVtawGQDt5HAADLGWz"; protocol="application/pgp-signature"
X-Ovh-Tracer-Id: 5474125348358832667
X-Ovh-Remote: 109.241.105.88 (109241105088.warszawa.vectranet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -200
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejiedrtdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdengfhvvghrhghhihhtvgdqqdetucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejiedrtdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdengfhvvghrhghhihhtvgdqqdetucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2y2TlDVtawGQDt5HAADLGWz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Nov 2014 13:35:49 +0530
Viresh Kumar <viresh.kumar@linaro.org> wrote:

> On 27 November 2014 at 19:42, Eduardo Valentin <edubezval@gmail.com>
> wrote:
> > (I'm sorry VireshK, I am still using my normal practice) :-)
>=20
> That's fine :)
>=20
> > diff --git a/drivers/thermal/cpu_cooling.c
> > b/drivers/thermal/cpu_cooling.c index 1ab0018..bed3fa2 100644
> > --- a/drivers/thermal/cpu_cooling.c
> > +++ b/drivers/thermal/cpu_cooling.c
> > @@ -440,6 +440,11 @@ __cpufreq_cooling_register(struct device_node
> > *np, int ret =3D 0, i;
> >         struct cpufreq_policy policy;
> >
> > +       if (!cpufreq_frequency_get_table(0)) {
> > +               pr_err("cpu_cooling: cpufreq layer not ready!
> > Deferring.\n");
>=20
> Throwing an error here doesn't look to be the right thing. Ultimately
> we will register the cooling dev when probed again after some time.
>=20
> So, a pr_debug() suits more here.
>=20
> Also, this breaks existing exynos thermal drivers as they don't handle
> -EPROBE_DEFER well right now.

Unfortunately Viresh is correct here. Current (before rework) Exynos
TMU driver expects that cpu_cooling device will succeed.

>=20
> I reached here, because one of my patches had something similar to
> what you wrote. Just for this file though, haven't updated any other
> drivers though.
>=20
> Will be sending you my small patchset by end of day today, please see
> if they make any sense at all..

Best regards,
=C5=81ukasz Majewski

--Sig_/2y2TlDVtawGQDt5HAADLGWz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlR4S/EACgkQf9/hG2YwgjEx1gCfRbftm8wzjq7xJwyC/PFISSNC
dloAoMnOf3s6RAA95fkGjSsfp1md5fns
=hgj5
-----END PGP SIGNATURE-----

--Sig_/2y2TlDVtawGQDt5HAADLGWz--
