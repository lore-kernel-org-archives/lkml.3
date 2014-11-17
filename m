Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaKQL5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:57:49 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40794 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaKQL5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:57:47 -0500
Date: Mon, 17 Nov 2014 12:57:44 +0100
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
Message-ID: <20141117115743.GG25699@ulmo>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-6-git-send-email-l.majewski@samsung.com>
 <5465DDC5.6090301@kapsi.fi>
 <20141114122437.6742ea68@amdc2363>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V32M1hWVjliPHW+c"
Content-Disposition: inline
In-Reply-To: <20141114122437.6742ea68@amdc2363>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V32M1hWVjliPHW+c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 12:24:37PM +0100, Lukasz Majewski wrote:
> Hi Mikko,
>=20
> > Tested-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
>=20
> Thanks for testing.
>=20
> >=20
> > One potential issue I can see is that if the cpufreq driver fails to=20
> > probe then you'll never get the thermal driver either. For example,=20
> > Tegra124 currently has no cpufreq driver, so if CONFIG_CPU_THERMAL
> > was enabled, then the soctherm driver would never be able to probe.
>=20
> Yes, this is a potential issue. However, this option in tegra_defconfig
> is by default disabled when thermal is enabled.

Not everybody uses tegra_defconfig for their kernel builds. In fact I'd
imagine that the majority of kernels use a variant of multi_v7_defconfig
and therefore CPU_THERMAL might get enabled irrespective of any Tegra
support.

I think a better solution would be to add this check only when proper
support for CPU frequency based cooling is added. That is, when a call
to cpufreq_cooling_register() (or a variant thereof) is added.

But while at it, why not make it so that cpufreq_cooling_register()
detects if a cpufreq driver has been registered yet and propagate
-EPROBE_DEFER if necessary?

Thierry

--V32M1hWVjliPHW+c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUaeK3AAoJEN0jrNd/PrOhc9YP/1Z+eoCMOIhl1S9h2NW3KgUn
uFOm7ZQAe3eqUyWeRW5intBYSlkEMeQ8Xb1zjY5yZStehNa/MMW7TLfTCDa1NbQl
5NO5G4jBD+yY/AXZx9szFkJAa0mhnhJMKQ01DPvczgj9JwK8qiS1YmfRGMt4cKE0
FhG7S3sm5Q7isyyJ59TBD+izUELEY6SYgCF9H+Z3AtLDWdDM2UwniL46wo7dMsn7
Xukux/IXuYS18QBsFQCJhVip9w31D7H8gfs6ucT97FuXSXxAIfGOLQqJqyIY2hH0
lMAjb6dT/01eDWQRs2sX52jQmjUw5nu4fypCIoe0eJAG56uE0cp0F3WUzotVYVCZ
5oREgjJ2SBbSvDEa8yrFsn2pT8Ccm1m2fZrAPMWzAmB31JOrVULS7G4d7YtUEIiS
x5CZPTp7j2v2SMOO0P0OmvuxuwuiBiHra3uZVD1usdvh95WkZe49BXsoKYig4Sva
WiATqJXCN06CCUgFOmP3qORJiAZfEh0TavTnreyfB390tWpWhX4j52Toacw2PU35
MT7H5NpnV4O5anjU0PdtJycQ+2cCMVWZ5mAw0PtUID092nSPLu9GIbRfmXVihQ9E
krJeDHnlYp8/47fnRKyworyquGYTIi0gL3RyDY2vPIb6Zjxk+41YT7Q5zK4TkxIv
V4smEiRHLt93j/FDRN4C
=nWc+
-----END PGP SIGNATURE-----

--V32M1hWVjliPHW+c--
