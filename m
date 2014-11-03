Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaKCQAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:00:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35661 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaKCQAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:00:30 -0500
Date: Mon, 3 Nov 2014 15:59:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141103155909.GX3815@sirena.org.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415025649-8119-4-git-send-email-javier.martinez@collabora.co.uk>
 <20141103153303.GQ3815@sirena.org.uk>
 <5457A3D2.1090602@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwU9tsYnHnYeRAKj"
Content-Disposition: inline
In-Reply-To: <5457A3D2.1090602@collabora.co.uk>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 03/14] regulator: of: Add regulator desc param to
 of_get_regulator_init_data()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wwU9tsYnHnYeRAKj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 03, 2014 at 04:48:34PM +0100, Javier Martinez Canillas wrote:
> On 11/03/2014 04:33 PM, Mark Brown wrote:
> > On Mon, Nov 03, 2014 at 03:40:38PM +0100, Javier Martinez Canillas wrote:

> >>  		if (!of_node_cmp(np->name, info->desc.name)) {
> >>  			config->init_data =
> >> -				of_get_regulator_init_data(&pdev->dev, np);
> >> +				of_get_regulator_init_data(&pdev->dev, np,
> >> +							   NULL);

> > This looks buggy, we're not passing in a descriptor.

> The descriptor is only used when extracting the init_data to map the
> modes and since it was not a parameter before, some drivers needs to
> be refactored to pass that information.

No, it's only *currently* used for that.  If we don't bother passing the
descriptor in then future additions which make use of it (including
adding mode operations to existing drivers) won't work and it might not
be obvious why.

> I thought that instead of adding intrusive changes in drivers that I
> don't have hw to test, that parameter could be optional so the patch
> that use that information check if the descriptor and the map_modes
> function pointer are not NULL.

You're already going through and modifying every single driver and all
of those I looked at already had references to the descriptor in
adjacent code or a global descriptor for the one regulator supported by
the driver.

--wwU9tsYnHnYeRAKj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV6ZMAAoJECTWi3JdVIfQpnIH/2ELsHglxNemBdNBvlYIZRR8
krsswG75WFonKz0pkm+7w6O44sMk015dhbuHAGY/CLV1Q/sfsbkdKhwGKhFX92NY
uEf7t50VihcjZ4InzluW4zbvaMJtmuJRAWC5EfxWarTNR+z+mxZJRUCZ2D4YhTPI
5suvjRGCPSR2GsrMPGTgoQDOmfGkIY4KLbYKtDFTZlzB24TNKfvW82fEWgznoB/x
alS+NuGfgWoVFc/oqZLyqCiHkczEyIHysh+zJGjQE4nvWI0EfvhZBMoIOFf+whfR
926L/NPwtNpB0wITHd6SynndeZAfa5elgsTX5nVoAM1KsyPl7wgCpAK+4o0skXo=
=elGm
-----END PGP SIGNATURE-----

--wwU9tsYnHnYeRAKj--
