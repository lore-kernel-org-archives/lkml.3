Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab3GYTLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:11:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60014 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab3GYTLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:11:07 -0400
Date: Thu, 25 Jul 2013 20:10:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20130725191059.GO9858@sirena.org.uk>
References: <20130725111357.7c976963@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R/XXzwRD6iKUjf7i"
Content-Disposition: inline
In-Reply-To: <20130725111357.7c976963@armhf>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] ASoc: kirkwood: simplify probe error
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R/XXzwRD6iKUjf7i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 11:13:57AM +0200, Jean-Francois Moine wrote:
> The function kirkwood_i2s_dev_remove() may be used when probe fails.

This seems fine but doesn't apply against current code but otherwise
seems fine.

> +	if (!IS_ERR(priv->extclk)) {
> +		clk_disable_unprepare(priv->extclk);
> +		clk_put(priv->extclk);
> +	}

Could use devm_clk_get() for extclk.

--R/XXzwRD6iKUjf7i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8XhAAAoJELSic+t+oim9KYYP/j95q2OJ5ln4rd8L3tjyAzfM
rWsJN/Z5ZzCPd2jYY72gO1dzZoe8iQ/HS+BB+UkP5zFIPi3qveR7GN5rAQYawDEK
G7DeZwgZfEONfa0YRA97j++pRpW2GLhi6eY1gxpSGPnRNkFElZ+Y86C3c0oBkjmf
1JGCpGwAj0Y89zcUDcBve8FlLM9M8l6qaXjB6UWPwenFPPaKGvfIoWyIGpt3Q1kd
FIGWRxG4MjkZMIPDnFIW5t75F0nequfZrElQmbfcqfuUAl5d1dqoyZdyjHEN5O5H
hQ2LJmqkxCi+2kGMr9a81RedKPcy+y/BkwwSY6NytAtXfYrADrebfiYuU2VY17wL
dz2P6TctSkdDv6cAKYlBDT2Ds2QnyrdjEyE+iqRzdyFqMCuQO8x/FAERugUWEGTN
b0p9HBysGpBzqjrDygBkUcsS/4Sd48SAM0rm5OfwmFmiD9c0ArRvga43b60wB3dA
NjtKSaNhDSudn2NIksflX13qTSo9QgcxJ/Tqszo96X7dFO7lTyjPx5q/CYTgBgDG
Pm09m3+728k66oAh3X70xmofYAIoxywkaaKqzH6/zm+uSGCy7CY8F99ihQdf2ule
yBQhybcxJ8ptD+6D+l4OyURVIg27nsVtu7FbfHFJN17+ydt6cB7JLs2lKabdSWZg
aUu8MUZ5nlyy93+0l1dB
=IVlb
-----END PGP SIGNATURE-----

--R/XXzwRD6iKUjf7i--
