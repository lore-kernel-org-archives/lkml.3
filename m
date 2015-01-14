Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbbANT1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:27:19 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57454 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbANT1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:27:18 -0500
Date: Wed, 14 Jan 2015 19:27:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Zidan Wang <zidan.wang@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, lars@metafoo.de,
        ckeepax@opensource.wolfsonmicro.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Zidan Wang <b50113@freescale.com>
Message-ID: <20150114192703.GH3043@sirena.org.uk>
References: <1420615905-4078-1-git-send-email-zidan.wang@freescale.com>
 <1420615905-4078-2-git-send-email-zidan.wang@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qM81t570OJUP5TU/"
Content-Disposition: inline
In-Reply-To: <1420615905-4078-2-git-send-email-zidan.wang@freescale.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel][PATCH v2 2/2] ASoC: wm8960: Let wm8960 driver
 configure its bit clock and frame clock
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qM81t570OJUP5TU/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 07, 2015 at 03:31:45PM +0800, Zidan Wang wrote:

> +	for (i = 0; i < ARRAY_SIZE(dac_divs); ++i) {
> +		if (wm8960->sysclk == lrclk * dac_divs[i]) {
> +			for (j = 0; j < ARRAY_SIZE(bclk_divs); ++j) {
> +				if (wm8960->sysclk ==  wm8960->bclk *
> +						bclk_divs[j] / 10) {
> +					goto config_clock;
> +				}
> +			}
> +		}
> +	}
> +
> +	dev_err(codec->dev, "Unsupported sysclk %d\n", wm8960->sysclk);
> +	return;

It's a bit awkward using the goto like this.  A more common way of
writing this is to change the above block to be

	if (i == ARRAY_SIZE(dac_divs))
		/* return error */

rather than skipping over the error.  Otherwise this looks good.

--qM81t570OJUP5TU/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUtsMGAAoJECTWi3JdVIfQBeIIAIApk5/8lxqW70m4OHwYO63P
0fcxNQlfwlVV+Koc72loUnT066+21KLrbGU7kz43VPvH298OLWVNv+Htk9f007Gu
2BU2B4S1cVNlC156FvMVzZnK1lZL4TvMGdsbCFwYBNhbkjIY6+KlE8TW/QM+QaDR
2SFMSW7Bqi/TcKb2RJID62i8gDePFyJvwyp5nfXfW5uzES6dVmnl2p5GdztUrRQn
AeJ4t261pvJXlbPC8FPIMg3X6HvIA7QM/yVuYu77OuwxixiMOjFdSZoLUz9IixRj
phXYwadnQqd1KsX9dnwb8+69nJ4yQ8soC48SDS2J/zeCgpnpTHohO8pzKBZNW2E=
=bhPf
-----END PGP SIGNATURE-----

--qM81t570OJUP5TU/--
