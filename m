Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaJ1RHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:07:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53507 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaJ1RH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:07:29 -0400
Date: Tue, 28 Oct 2014 17:06:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>, alsa-devel@alsa-project.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, linux-xtensa@linux-xtensa.org,
        Takashi Iwai <tiwai@suse.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20141028170644.GC18557@sirena.org.uk>
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
 <544FBD20.5000604@metafoo.de>
 <20141028160414.GY18557@sirena.org.uk>
 <544FC6B1.1060002@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n2RoZOfqketZuWCG"
Content-Disposition: inline
In-Reply-To: <544FC6B1.1060002@metafoo.de>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: add xtensa xtfpga I2S interface and
 platform
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n2RoZOfqketZuWCG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 28, 2014 at 05:39:13PM +0100, Lars-Peter Clausen wrote:
> On 10/28/2014 05:04 PM, Mark Brown wrote:

> >Is that going to play nicely with the fact that the interrupt can be
> >shared and the desire to (AFAICT) do NAPI style stuff with the interrupt
> >disabled for long periods?

> Threaded interrupts got support for interrupt sharing a while ago, so I
> guess yes. I think it will even work better than the tasklet approach. You
> can configure the IRQ to disable itself as long as the thread is running.

I know you *can* share threaded interrupts, I'm just not sure that
hogging the threaded handler plays nicely with other users.  Though now
I look at this again tx_fifo_high is a "constant" so it's not actually
trying to do a NAPI type mitigation thing and this is really just an
open coded threaded interrupt as you say.

--n2RoZOfqketZuWCG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUT80jAAoJECTWi3JdVIfQgUgH/1FAr8h7Ttski6CahzubwkA+
Unp3ehJ36F2UR4Gwcr8pFbKJ88oFi9WmLqJ4ZQ+TRDg8axEKJW5rKfO9Ho8Y1UGn
h1wTSxYKNJlzNK9H0r85k5lrhdZlqoPtC8DDXyv4/nJCnwAEwgezEcaaqdsnqS0p
pp4giA1N4oKGEZD3dfzvdlk6S+m9mfL9DGnddDZy8EJGFDyIv8tzVg1RirTWok/u
mAquqw6cX9eWThcvwTWKQ545JcfZUBEDwnZOGMWy9778HR+I4g0qZI8n1iM3TIxn
R721beh5f3Bqkw4Ewgpj+A0A/h8peueLU0afxHkxxMSheF/HvyFqOYP8K2QlS/w=
=briD
-----END PGP SIGNATURE-----

--n2RoZOfqketZuWCG--
