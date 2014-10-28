Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbaJ1QFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:05:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53412 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaJ1QE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:04:59 -0400
Date: Tue, 28 Oct 2014 16:04:14 +0000
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
Message-ID: <20141028160414.GY18557@sirena.org.uk>
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
 <544FBD20.5000604@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bLzFIlwpOfW+4Y/z"
Content-Disposition: inline
In-Reply-To: <544FBD20.5000604@metafoo.de>
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


--bLzFIlwpOfW+4Y/z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 28, 2014 at 04:58:24PM +0100, Lars-Peter Clausen wrote:
> On 10/27/2014 08:07 PM, Max Filippov wrote:

> >+	if (tx_active) {
> >+		if (i2s->tx_fifo_high < 256)
> >+			xtfpga_i2s_refill_fifo(i2s);
> >+		else
> >+			tasklet_hi_schedule(&i2s->refill_fifo);

> Maybe use threaded IRQs instead of IRQ + tasklet.

Is that going to play nicely with the fact that the interrupt can be
shared and the desire to (AFAICT) do NAPI style stuff with the interrupt
disabled for long periods?

--bLzFIlwpOfW+4Y/z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUT759AAoJECTWi3JdVIfQB8EH+gPB7Aw0ccJppeaG9EnsnvlA
AP7CSMwz+XSZPgHeYFJEZt1/adzlrGF3rmjT5EFZHx7Sc8OtKBmrntQT850iw/iZ
6ju53/DKyzXspepZgs6wv1X1VueMC05F5kMMlO2EW79H/GSX1CpJL/wWQ/RXI/A/
1X13J9oOOEkiMxoD3a9BCb2VqXS0M+160wkCqLKerbiqoSQSG6/62DrztYI0UY1B
0bk6cSpiLQmGBOlapor2dJY0JntTuTG7Lwgt4NemAFhyW9OiwgXBrk7i2NXu4mLk
mj483xwwzbG5RTDCfPy6n4BmzQRKDCmPVWNTAFAIBLvi9zCCmIrfWUUKCJ6NveY=
=RcMg
-----END PGP SIGNATURE-----

--bLzFIlwpOfW+4Y/z--
