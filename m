Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaKQNSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:18:12 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33757 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaKQNSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:18:10 -0500
Date: Mon, 17 Nov 2014 14:18:05 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Eduardo Valentin <edubezval@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] thermal:cpu cooling:tegra: Provide deferred probing
 for tegra driver
Message-ID: <20141117131804.GC18767@ulmo>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-6-git-send-email-l.majewski@samsung.com>
 <5465DDC5.6090301@kapsi.fi>
 <20141114122437.6742ea68@amdc2363>
 <20141117115743.GG25699@ulmo>
 <20141117135142.6692c9d5@amdc2363>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
Content-Disposition: inline
In-Reply-To: <20141117135142.6692c9d5@amdc2363>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 01:51:42PM +0100, Lukasz Majewski wrote:
> Hi Thierry,
>=20
> > On Fri, Nov 14, 2014 at 12:24:37PM +0100, Lukasz Majewski wrote:
> > > Hi Mikko,
> > >=20
> > > > Tested-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
> > >=20
> > > Thanks for testing.
> > >=20
> > > >=20
> > > > One potential issue I can see is that if the cpufreq driver fails
> > > > to probe then you'll never get the thermal driver either. For
> > > > example, Tegra124 currently has no cpufreq driver, so if
> > > > CONFIG_CPU_THERMAL was enabled, then the soctherm driver would
> > > > never be able to probe.
> > >=20
> > > Yes, this is a potential issue. However, this option in
> > > tegra_defconfig is by default disabled when thermal is enabled.
> >=20
> > Not everybody uses tegra_defconfig for their kernel builds. In fact
> > I'd imagine that the majority of kernels use a variant of
> > multi_v7_defconfig and therefore CPU_THERMAL might get enabled
> > irrespective of any Tegra support.
>=20
> I see your point.=20
>=20
> >=20
> > I think a better solution would be to add this check only when proper
> > support for CPU frequency based cooling is added. That is, when a call
> > to cpufreq_cooling_register() (or a variant thereof) is added.
>=20
> For the above reason the code is only compiled in when user enable
> CONFIG_CPU_THERMAL.

Like I said, CPU_THERMAL is a kernel-wide configuration option and not
tied to the specific SoC. Therefore if an SoC, say Exynos, gains full
support for cooling via cpufreq then somebody may decide to enable the
CPU_THERMAL option in multi_v7_defconfig. At that point every thermal
driver that you're patching in this way but for which no cpufreq driver
is registered will indefinitely defer probing.

So I see two options:

  1) make sure that we defer probing only on devices where a cpufreq
     driver is available
  2) not rely on deferred probing at all but allow a cooling device to
     be registered after the thermal driver has finished probing

1) seems impossible to do because cpufreq simply doesn't provide enough
infrastructure to deal with that situation.

Thierry

--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUafWMAAoJEN0jrNd/PrOhwogP/3x9D+ojhKcnf7me0GJ8q2xw
AUDt+LFPk/uW3ScchoWUPBl1YTvmUjG81DwJ68BI11l4B3ON1evkKdTw+27Hd3WB
0OzadeTnT2EnEskaSWmrONAk3KJ503mUZj0EJ8amVQL9Svm82aicUDOvpY2Mgmhv
VqGdhMgnYtVGMiTKXJcyH5YnWdhJLEsdBRW0d5VlodQ+ZBnx0NW2sxZaiFjGvv+X
IU30BcAXcmb2D4sVx/fSepmCcSxCDbGphX0vSyy2McP3wwCT6eh6ehzRnXu+JKzR
ySr2ls3N3ycuDf+GzntTSLkue8TcdsUZV4m1O+VTMauD5GaRqwlTNqx906F1hKis
Achohy0BR+s2qkzRTUrNKFZ9lEwjdF1JN+KoKspm0hoX0Ygl3XEbz5Q0vfJ9hRKM
RauvjHFOiFSok1h5Sns6h39qs0+ti0kgS+WuEcSm6lpjYskilTMhzcaBcJIIiUEu
eyb9LnC4ChvpBQEWC6Ht9QxWIB/gQNF+STF6fLk24TqEQWTnQAz31jwn45ItlqTe
py50C9w+B7q++nEwzzrCVvGacRmQNm4hjbgErygyBAZz/Swv/H4BYrc8sz9AGiUP
m3gX2x56C/nKACas4d4cQ0SFt48swzFgzwM4OIr0U6oHty6E/nHsUX0JpcsdB0gk
VomTYUFA+vrpUZgnw6to
=VRYY
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--
