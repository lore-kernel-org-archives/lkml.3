Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaLDLZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:25:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48051 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbaLDLZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:25:37 -0500
Date: Thu, 4 Dec 2014 11:25:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Zidan Wang <b50113@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, lars@metafoo.de,
        ckeepax@opensource.wolfsonmicro.com, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141204112512.GS7712@sirena.org.uk>
References: <1417681425-4360-1-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6jbJE0PFwegn7S6c"
Content-Disposition: inline
In-Reply-To: <1417681425-4360-1-git-send-email-b50113@freescale.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel][PATCH v2] ASoC: wm8960: Let wm8960 codec driver
 manage its own MCLK
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6jbJE0PFwegn7S6c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 04, 2014 at 04:23:45PM +0800, Zidan Wang wrote:

> If we use PLL to generate sysclk, wm8960_set_dai_pll() will enable PLL. But
> PLL doesn't power down after using codec. So power down PLL in suspend().

That would be a bug in the machine driver, the machine driver should be
disabling the PLL when it suspends since the startup and shutdown of the
PLL need to be coordinated with the input clocks.  Besides, if we were
doing this in the CODEC driver then as I said last time the PLL needs to
be restored on resume since the machine driver should be able to expect
that settings it has made are preserved (eg, if it sets things up on
init).

--6jbJE0PFwegn7S6c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgESXAAoJECTWi3JdVIfQw9MH/A0OeNQyJsQ7PrtyEcAxizRt
A8+y/S4gjduYNIOfGTaNfz+U7UVnU0YI2EaCTlJ0JzVetMcADfspe3/LYs53s+PR
K/eJwDOQX54FpDXR8oEOCdOgMkSYl4NunlaP+Yhc0FdjX5WmpawS6D0R3IZIeqdC
tFXxvrC1U41FVcVkzbSapbX1oMq0Kautlm3Yy5jZcAJoeRCIaOMolJ2RgYNYAITu
Q4PBHKnYvs/GAsZD20cIsbyHV+bggwN2T0YXXKajknH0GH3Zd743LALAqGkpYz8k
LZ2D16ZmH0xrJugTUM7fEjXH27cioJ9m3jIo1x2ltXXcZbHfit/IRSnlNYZvbRg=
=wYSk
-----END PGP SIGNATURE-----

--6jbJE0PFwegn7S6c--
