Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaCAEfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 23:35:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53925 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaCAEfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 23:35:04 -0500
Date: Sat, 1 Mar 2014 13:34:58 +0900
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lars@metafoo.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140301043458.GR29849@sirena.org.uk>
References: <1393578267-18255-1-git-send-email-Li.Xiubo@freescale.com>
 <1393578267-18255-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RpDyejMaDGJhP2PU"
Content-Disposition: inline
In-Reply-To: <1393578267-18255-3-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.238
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 2/3] ASoC: io: New signature for
 snd_soc_codec_set_cache_io()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RpDyejMaDGJhP2PU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 28, 2014 at 05:04:26PM +0800, Xiubo Li wrote:
> Now that all users have been converted to regmap and the config.reg_bits
> and config.val_bits can be setted by each user through regmap core API.
> So these two params are redundant here.

Actually, I think the way to fix the issue with CODECs doing I/O in
probe is to provide a way for drivers to specify a regmap when
registering the CODEC (rather than during probe) and then move the
initialisation of the regmap before the probe function is called.  That
would make set_cache_io() go away entirely.

--RpDyejMaDGJhP2PU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTEWNqAAoJELSic+t+oim9c4QP/jL6yuE+Yh4zOeu80Y46621C
rd4gXZjXrXpNwYtKILLFQbiaMcRw8+Y4RM8fB2ysyOCYG5nadHOg7Oo81pP5AOVU
QQS6Z9cbsq6GGxeRfz9XDzGPUyHCEuDstGQBgodYC+fYRpthlvXafCeDWaxIYhqX
F5d4W7gKqGNWFcE2fmztCg2gLw3945Cn7wTjLzmftvb9yIpFcvJaqNV2sohe5Wo6
wQ69Ym73FN6fs+uQrjxxaC+lJe79K2xtrk8kzTCVHd1dMkSzp7/Pv18XtCMXBrin
BWGHUfQcgjzAoz3cx4gTNrllUsMG8jGRtdqx+NHjcE5dvhitD8MMk3JD/hHw/ANM
7HOcQeG8/h1eq/3nqMy+cP2IB96eKrWeLPi92/5YZpsWvd59vOOAOUNj5bYUW78Y
D84PbLBAcDUPpioRVLZEtDTLr0kc5Hf2AAGQoOGddjia8k3DEc3hNZCzUiQ2FZv2
b0cIvYvyU2HuWQenbb+GIjKgcAPFJHVVPVmbm0TjRAqPOkw0Hqd2hzZJCC/d6K4E
azYuzyptVmRAc4vcwYk5yq3YKxKojxvhh09sIiaCIP3ff2rV3tO2ra4NliHILxDs
05+sHFaK+IGXQ+3laL4nQI/7ACnitvWVue/L/H9o/vLvo+orNp9oSdsPzbEVqEik
6woyF/tasx+VsSw7vRms
=6X7Z
-----END PGP SIGNATURE-----

--RpDyejMaDGJhP2PU--
