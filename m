Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaLDKvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:51:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48007 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaLDKvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:51:45 -0500
Date: Thu, 4 Dec 2014 10:51:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Message-ID: <20141204105121.GQ7712@sirena.org.uk>
References: <547F3C9F.8080102@arm.com>
 <20141203172526.GC7712@sirena.org.uk>
 <548022B3.8050105@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LAiFTeWIOasiK8aw"
Content-Disposition: inline
In-Reply-To: <548022B3.8050105@arm.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] ASoC: dwc: Don't allow negative use counts
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LAiFTeWIOasiK8aw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 04, 2014 at 09:00:35AM +0000, Andrew Jackson wrote:
> On 12/03/14 17:25, Mark Brown wrote:
> > On Wed, Dec 03, 2014 at 04:38:55PM +0000, Andrew Jackson wrote:

> >>  	case SNDRV_PCM_TRIGGER_STOP:
> >>  	case SNDRV_PCM_TRIGGER_SUSPEND:
> >>  	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> >> -		dev->active--;
> >> +		if (dev->active > 0)
> >> +			dev->active--;

> > How is this triggering - this sounds like you're papering over some
> > other bug somewhere?

> When I looked at the code paths I couldn't convince myself that STOP
> wouldn't be called more than once.  Then actuve would be negative and
> the device might not be restartable.  I didn't have a problem per se,
> it was just that it seemed to be something of a loophole.

If you're just adding the check on the off chance that it might fire you
need to add a warning message as well - what your change does is make
the code look like it's supposed to have broken reference counting since
it has a check to silently fix up and ignore problems.

--LAiFTeWIOasiK8aw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgDyoAAoJECTWi3JdVIfQfc0H/0H5QpvvaNkaDK5Oq85Z9OMi
C6DtQwIUqGy7NpjNCW/Poo0+08qVOu/tfWPfpOogtI1nX7R/aUnHID/YzaMdtyNb
nUpwEQD1Z3UOjrQ38R/otGAOQSCnkeohZjMnrcjsIgFN8WuLLeDadMBWIBSgT72d
QNVKvdLMSczCwYfLFkWh35ixB6YUc9+Th3Ypw8pMD8agwyYVF24C9ZBdop2z4cLY
VguuB8bFJ+WTfvMeEt4EE5o0QgmafqjUBsFxBS3Y8zHiEkoKjhE0GUALFniSa1iV
ftkOate+mJE8FQX7rFTNFwHdMKZuLBkAS7HeB7CjeEQaqqlg7KR/etFDYBtc+rU=
=jXAI
-----END PGP SIGNATURE-----

--LAiFTeWIOasiK8aw--
