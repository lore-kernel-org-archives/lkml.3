Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbbA0TAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:00:23 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36671 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbbA0TAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:00:21 -0500
Date: Tue, 27 Jan 2015 18:59:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Inha Song <ideal.song@samsung.com>
Cc: alsa-devel@alsa-project.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, s.nawrocki@samsung.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, kgene@kernel.org, sbkim73@samsung.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Message-ID: <20150127185942.GM21293@sirena.org.uk>
References: <1421989410-12490-1-git-send-email-ideal.song@samsung.com>
 <1421989410-12490-2-git-send-email-ideal.song@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7ftbJ8egIWVmlOqJ"
Content-Disposition: inline
In-Reply-To: <1421989410-12490-2-git-send-email-ideal.song@samsung.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v4 1/3] ASoC: samsung: Add machine driver
 for Trats2
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ftbJ8egIWVmlOqJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 23, 2015 at 02:03:28PM +0900, Inha Song wrote:
> This patch add the sound machine driver for Trats2 board.
> The codec operate in master mode.

This looks like (and mostly should be) a DTified copy of the littlemill
driver.  The major differences are the fact that this lacks jack
detection, the management of the clock and the fact that instead of
picking a fixed clock frequency this tries to adjust based on
hw_params().  Ideally we'd be able to merge these drivers so we're
keeping up with best practice.

The reason we pick a fixed frequency for littlemill is that the device
supports analogue bypass paths which would be broken otherwise which
will apply here also I imagine.

> +config SND_SOC_SAMSUNG_TRATS2_WM1811
> +	tristate "SoC I2S Audio support for WM1811 on Tizen Trats2 board"
> +	depends on SND_SOC_SAMSUNG
> +	select SND_SAMSUNG_I2S
> +	select MFD_WM8994

For things outside the audio subsystem it's more common to use a depends
instead of a select - the selects are there because the drivers only
work with a machine driver and if we go outside the subsystem then since
selects aren't recursive we end up breaking elsewhere.  For example here
we'll end up not selecting MFD_CORE.

--7ftbJ8egIWVmlOqJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUx+AdAAoJECTWi3JdVIfQfdUH/RvJzdlHUSRh1yWQqBGUcj6U
dUIAPq2NY7MEyC+gp1Xj5YsjnZ1da9w41wExLHLNX34+lUCDtKfb96WIxHNyrxg5
q2ZRWpKa+sN8E1kwDrqYTWSXstbtNdy86RtUva47Y+2TN0GsFpyV75rDn39E8olb
vanFXg85ZBMzQepVW2GQFCh2XyrPDfVLbpK9i4cYKPlNl5NDmDTA+7Ym7QbBqp40
Yhaycl2WlHFyd3NH8vRbCjN1+20LwF6fjos2n4u7iWdtCdMBbjvAUWGYlQORjlch
Zl3lZ5CaIRdDPar4+bEELb86n6d9wTqZd/vNGV8tcJB6iYsHoaSmo/N4KgrTXI4=
=RXj1
-----END PGP SIGNATURE-----

--7ftbJ8egIWVmlOqJ--
