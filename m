Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaIISPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:15:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59583 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaIISPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:15:52 -0400
Date: Tue, 9 Sep 2014 19:15:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: Shengjiu Wang <shengjiu.wang@freescale.com>, timur@tabi.org,
        Li.Xiubo@freescale.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Message-ID: <20140909181516.GI2601@sirena.org.uk>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
 <20140909112750.GS2601@sirena.org.uk>
 <20140909180309.GA6784@Asurada>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8lKUOMLFs7xrer6k"
Content-Disposition: inline
In-Reply-To: <20140909180309.GA6784@Asurada>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.132.114.70
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8lKUOMLFs7xrer6k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 09, 2014 at 11:03:10AM -0700, Nicolin Chen wrote:
> On Tue, Sep 09, 2014 at 12:27:50PM +0100, Mark Brown wrote:
> > On Tue, Sep 09, 2014 at 05:18:07PM +0800, Shengjiu Wang wrote:
> > > -	ssi_private->clk = devm_clk_get(&pdev->dev, NULL);
> > > +	ssi_private->clk = devm_clk_get(&pdev->dev, "ipg");

> > Why is this change being made?  It wasn't mentioned in the commit log
> > and doesn't seem relevant to moving where the enable and disable are
> > done which is what the patch is supposed to be doing...

> I think Shengjiu is trying to keep the clock disabled while SSI's idle.
> The current driver enables ipg clock anyway even if there's no stream
> running.

> Apparently, these should be put into the comment log.

I got that bit.  However as well as changing where the enable and
disable take place this is also changing from requesting a clock with a
NULL to requesting one called "ipg".

--8lKUOMLFs7xrer6k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUD0OsAAoJECTWi3JdVIfQbgwH/20teJPh6rqrGN8svTU/E6r4
mZir/1YdrwwoMgjT0h7TmC5D+v5CoV4fo12fpPuXPzLjVSoGpmCxnoQH/89X92g/
86BxCIZSh1haKI9YxNlysOgO9wO6OHvz6N1C+4hnWhWMSZ03SP97XEtzLcuYXwEu
PZMq376RA1UAJUi72UFhdUGwSXK+dUlskBOo1OG3Lqh3XXjYdJT889Kt22o6dXJD
/uFnSf4TDnVKmWRfFkmcTtapjNuhp4KFbxXB4ttQgymvHvUusscltgxdn2pDb/gz
n75lx26dlHsRAnkp7uJd5FmPQDSZxRaE/bBx+bODPEIX9pKvwUsyEKWN5mtMpss=
=4PvN
-----END PGP SIGNATURE-----

--8lKUOMLFs7xrer6k--
