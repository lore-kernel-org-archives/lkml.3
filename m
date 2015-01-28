Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764637AbbA2DqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:46:23 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38396 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbbA2BZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:34 -0500
Date: Wed, 28 Jan 2015 19:12:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Rosin <peda@lysator.liu.se>
Cc: alsa-devel@alsa-project.org, Peter Rosin <peda@axentia.se>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Lars-Peter Clausen <lars@metafoo.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150128191217.GF21293@sirena.org.uk>
References: <1422454572-7847-1-git-send-email-peda@lysator.liu.se>
 <1422454572-7847-4-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="D0SLKVBHTY2PnTRz"
Content-Disposition: inline
In-Reply-To: <1422454572-7847-4-git-send-email-peda@lysator.liu.se>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/7] ASoC: pcm512x: Change register default to match
 actual content after reset
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D0SLKVBHTY2PnTRz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2015 at 03:16:08PM +0100, Peter Rosin wrote:

> @@ -78,7 +78,7 @@ static const struct reg_default pcm512x_reg_defaults[] = {
>  	{ PCM512x_DIGITAL_VOLUME_2,  0x30 },
>  	{ PCM512x_DIGITAL_VOLUME_3,  0x30 },
>  	{ PCM512x_DIGITAL_MUTE_1,    0x22 },
> -	{ PCM512x_DIGITAL_MUTE_2,    0x00 },
> +	{ PCM512x_DIGITAL_MUTE_2,    0x02 },

The datasheet claims these have undefined values as reserved bits - what
would be a more robust change here would be to remove the register
default entirely so that we take the value the hardware has, giving
robustness against any hardware revisions.  Of course the device has
rather a lot of such reserved bits which is unfortunate.

--D0SLKVBHTY2PnTRz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyTSQAAoJECTWi3JdVIfQHbEH/2KTA7lklj4WLNDJ706ddWpj
RTieI5BM4hah+P+2UZrhufBXqTyQsg8ihJKMmNk8GWEgZ4WOYUkWr62qut7P9tXD
PLFcx8fIstV4CcHUPAn4WAd40emxED0TPZ6FEPPtr3FCpdv5Bdb4VGKU0I4uBvlB
rmClU8/c9b0krrSFv6CV+zobQCf5KjxMoCx7p+QESxm1JryeG9W2iN//kiJDT0rY
ynSL/OaCvARWY6H7qveTD0HSwSc1/YE29jJtcEzKg7W1512Kr7M7XvayBXTN0dbT
yrqAWfWbritrjjpb/izneUZoDPYBqwtQt1cgQnKNNLTZqmTP3lmeMeg5Eqbp7gQ=
=rL61
-----END PGP SIGNATURE-----

--D0SLKVBHTY2PnTRz--
