Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbaIIL2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:28:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58816 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbaIIL2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:28:11 -0400
Date: Tue, 9 Sep 2014 12:27:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: timur@tabi.org, nicoleotsuka@gmail.com, Li.Xiubo@freescale.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140909112750.GS2601@sirena.org.uk>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NKys6zTV8iyMJiwY"
Content-Disposition: inline
In-Reply-To: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.152.174.147
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NKys6zTV8iyMJiwY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 09, 2014 at 05:18:07PM +0800, Shengjiu Wang wrote:

> +	if (ssi_private->soc->imx)
> +		clk_prepare_enable(ssi_private->clk);
> +

We're ignoring the error code here.

> -	ssi_private->clk = devm_clk_get(&pdev->dev, NULL);
> +	ssi_private->clk = devm_clk_get(&pdev->dev, "ipg");
>  	if (IS_ERR(ssi_private->clk)) {
>  		ret = PTR_ERR(ssi_private->clk);
> -		dev_err(&pdev->dev, "could not get clock: %d\n", ret);
> -		return ret;

Why is this change being made?  It wasn't mentioned in the commit log
and doesn't seem relevant to moving where the enable and disable are
done which is what the patch is supposed to be doing...

Please don't make different changes in the same patch.

--NKys6zTV8iyMJiwY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUDuQ1AAoJECTWi3JdVIfQRFUH/A+c1fwfvIqcmYIlaJcAiWkO
Uuq0EjAEHWoUitSMxR1m/fvZ/UYttYAxEv/hl6HjFyhUlVyVklJ8jmtOlWpGfpIX
ZlisKPVpCFiE2bUdjjNxNvuVxu53MRUC6hmyDWiMN43UUNiBlYRpJrm+WKf0j8PB
o1nGbFVrfp5xOUAly951EFXBgC5PDPMZIY8XgL3pH6HesIv3URAxlL8JeguIuSWM
eM0i3O90aPHcfjKNT89fMru4Jhcw1jARkF9lE63EHXhbOnq+TDbWfIZKeYpNLoem
mB38k6NQH9IoFvr9kIoVqa9xLgP/c6da1w+3as8s40YPNfFVFeoKikKhBNsQuNQ=
=R1az
-----END PGP SIGNATURE-----

--NKys6zTV8iyMJiwY--
