Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaLCRjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:39:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47300 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaLCRjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:39:15 -0500
Date: Wed, 3 Dec 2014 17:38:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Message-ID: <20141203173854.GE7712@sirena.org.uk>
References: <547F3CB2.5070306@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qRudkE5L6XDjsdFd"
Content-Disposition: inline
In-Reply-To: <547F3CB2.5070306@arm.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] ASoC: dwc: Ensure FIFOs are flushed to prevent
 channel swap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qRudkE5L6XDjsdFd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2014 at 04:39:14PM +0000, Andrew Jackson wrote:
> If the FIFOs aren't flushed, the left/right channels may be swapped:
> this may occur if the FIFOs are not empty when the streams start.

>  	/* Iterate over set of channels - independently controlled. */
>  	do {
>  		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
> +			i2s_write_reg(dev->i2s_base, TXFFR, 1);

This is an example of the problem with putting fixes at the end of the
series - this can't be applied without your previous change to add the
support for more channels (which is a new feature).

--qRudkE5L6XDjsdFd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUf0qtAAoJECTWi3JdVIfQRAsH/27TgFyUrg50dPyNwTQcAJ92
cSi9jkTbAZM+j6Q78f1ExylGk7yPksydf80TaBY26kjwpFC2tHQ9QIv0wpGqC7lw
wMlMkBpmFAcRE572Rou/t2wt4XYJcy0g+cXtmbRNdr/faLzTudumrO9c4tQcYmFE
tlSu7kyHRnw6Mi+4i0rGbtXxJTN34cpXk3/dv7o3z2GvykJgZhOdJMjO5ds5gZAz
KqQkLYGmzqw7/ZX83umNx3psVQsk8lfyjL3fWSMvG+W0/4hJXzXmvgLXWRZmHCJC
cE4Fj/7Qhlz687RyLD3q7tpWH+ahKjZppsWcHIb4X7T5OMtxkYZ6EHANmdaeoLE=
=GnW3
-----END PGP SIGNATURE-----

--qRudkE5L6XDjsdFd--
