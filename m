Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbaAJN1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:27:15 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52106 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaAJN1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:27:11 -0500
Date: Fri, 10 Jan 2014 13:26:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: timur@tabi.org, alsa-devel@alsa-project.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, shawn.guo@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Message-ID: <20140110132642.GM29039@sirena.org.uk>
References: <1389265078-16256-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140109184453.GP12858@sirena.org.uk>
 <20140110023252.GA16467@MrMyself>
 <20140110023537.GB16467@MrMyself>
 <20140110120439.GG29039@sirena.org.uk>
 <20140110130338.GA17392@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x38akuY2VS0PywU3"
Content-Disposition: inline
In-Reply-To: <20140110130338.GA17392@MrMyself>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: fsl_esai: Add ESAI CPU DAI driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x38akuY2VS0PywU3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2014 at 09:03:39PM +0800, Nicolin Chen wrote:
> On Fri, Jan 10, 2014 at 12:04:39PM +0000, Mark Brown wrote:

> > This is about what I'd expect but then surely the next step is for the
> > driver to choose a defualt BCLK ratio - that's how most drivers work,
> > they try to generate the exact rate that is needed to clock the data.

> Does that mean I should call set_bclk() once in the startup() when !active
> to set a default bit clock rate to suit a common sample rate like 44100Hz?
> I'm a bit confused if so. Because the driver would call set_bclk() any way
> in the hw_params().

Right, any choice here needs to be deferred to hw_params() as you say.

> But your suggestion just reminds me of the slave mode in SSI driver as
> default mode. And I should patch ESAI to slave mode for default as well,
> shouldn't I?

master/slave selection is kind of orthogonal here - the two bits of
information that are normally needed are the MCLK to use (and its rate)
and the sample rate/format (which give you the BCLK that is needed).
Normally it's then possible to caculate a divider which generates BCLK
=66rom MCLK.  Overriding is normally only needed if there are additional
constraints on BCLK due to something like limitations in one of the
devices or sample rates for the opposite direction if the BCLK is shared
but LRCLK isn't.

> > Are the bit clock shared between playback and capture?

> Only shared in synchronous mode and totally individual in asynchronous mo=
de.
> Each of them can have their own HCK(MCLK) from different sources and deri=
ve
> their own SCK(BCLK).

OK, so in asynchronous mode there should be a good chance of a a default
choice working since it won't restrict the other direction.

--x38akuY2VS0PywU3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSz/UPAAoJELSic+t+oim9+M8QAImXq8LRXn58WvYsyM3+jGlV
2FuqBmOjiDlEyiNIha5E+X5tkBM6ZY7mULBBMx1EV+cJZm4ZiIdpWIyZANp+wv2w
O0+woCXXQ41D+FAdpBE+qVN1HmuESwEkUqufCC2E8aiFEy29mNg3O181fFF25Cbm
0hr26w+9oJDLEDGN2nVCR568ooBuaCF0yY0xhzCZSb/+8eMJUZUTqbjntCLZ07pQ
oCiMQ/JosR9UE4DPOvrqaH/3bssf9GO0fI9VeCTjJk9JFyARIXI1D8m1knYMs47U
5g8xM8VxrBJaoFzv6m7xyCMniHhJwfgCrEkhdp4+vpUUeR1yoXMJ6yVP9QEbZV8j
ScBmE9IoM7PVYCmw2LYNlgtmT+x27trB81JzHxKe60ZXOhmXhDKS+vwq0rqW3SQA
pnvt12qjTAaju88wmyANNPACOgMMr7g+uYiVplFCQmjFPUalEz/3FveyHrnaocwt
WCqDo0stNUyT74pq3YW7DEsWFJFZp8v9B870Xe5DoKeQ3RdaoH2ukF8W/Y61/7uw
BnsA4ZZLFj15roFcJZG7NdvvdRUwdABAdNEu8qxUZ1wzARaX9CsoTfxhGZfVPbfT
DvBZO+CV5zQDKaFBKRS/UY9EuporY5Crx3G3xi0HUEqjzNGgk5cuF5X8G4La/q5t
uiETXXSvhw9g+hGdsBGY
=W7uy
-----END PGP SIGNATURE-----

--x38akuY2VS0PywU3--
