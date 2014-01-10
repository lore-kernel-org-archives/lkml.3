Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaAJMFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 07:05:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52049 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaAJMFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:05:13 -0500
Date: Fri, 10 Jan 2014 12:04:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: timur@tabi.org, alsa-devel@alsa-project.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, shawn.guo@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Message-ID: <20140110120439.GG29039@sirena.org.uk>
References: <1389265078-16256-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140109184453.GP12858@sirena.org.uk>
 <20140110023252.GA16467@MrMyself>
 <20140110023537.GB16467@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fCcDWlUEdh43YKr8"
Content-Disposition: inline
In-Reply-To: <20140110023537.GB16467@MrMyself>
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


--fCcDWlUEdh43YKr8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 10, 2014 at 10:35:39AM +0800, Nicolin Chen wrote:

> Resent this because of losing attached file.

I don't think your previous mail got sent at all, or at least it must've
been caught by spam filters here...

> On Fri, Jan 10, 2014 at 10:32:52AM +0800, Nicolin Chen wrote:
> > On Thu, Jan 09, 2014 at 06:44:53PM +0000, Mark Brown wrote:

> > > Why does the machine driver have to do this by hand, being able to
> > > override is fine but having sensible defaults is easier?  Or does it
> > > actually do that and the comment just needs updating?

> > The divider part of ESAI is pretty complicated due to caring about three
> > configure bits - ETO, ETI, HCKD. (I've attached a diagram to this mail.)
> > So setting sysclk() alone is not enough to take care all the configurations.
> > That's why I designed these two interfaces at the first place. And it should
> > be hard to find a default situation.

Why is the machine driver going to be able to come up with a sensible
configuration then?  It's OK to support overriding the configuration
where needed, my concern is about providing a default.

> > But there is one approach to omit this calling for machine driver is to do
> > the set_bclk_ratio() at this CPU DAI driver. And this might be a good idea
> > because we can then separate the settings between PLAYBACK and CAPTURE, even
> > though we might then need to check the Master or Slave state to apply the
> > settings accordingly.

This is about what I'd expect but then surely the next step is for the
driver to choose a defualt BCLK ratio - that's how most drivers work,
they try to generate the exact rate that is needed to clock the data.
Are the bit clock shared between playback and capture?

--fCcDWlUEdh43YKr8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSz+HUAAoJELSic+t+oim9oDYP/1b4VUYEQq2BGjz+hdjrx5XW
Tv90KklVlfXZBxkMbusrvB04uuZiHTUipz7tVsSxK4hE56Ye5M5DUavS8cUeoOqU
Lp4x0RbXGVLPncnX3Af7HXUg3Z7qXUrO+3lnX4nrll7pJJvggN0Uud7YYGvjxNZt
rm0Wh78h272Oyb4ECdUtQivX6csLqj40E3KIiZfJ/GUmh2ji07GXNwbcr4Be6Twf
bwE81FfgB1tJ0GZdl1emQTS/h7F8YQgEo72S0G5wY/XfXys+mECrfdtxXvVeLtVv
Uzd3VPPVKsnYE4ZO0sSsgG7DpJP3pjQWah5xOZ7Vrg/vQreB7Ucdfvs8FhZvJO9l
nSrGXKUwACAIsO/oedvJCaQ2zcFTGC9foGsuSNH/xaCKITdtA7RfwIJCiGf0vtF9
i0qO48wkMf+KABaWYbuVX5EZehWoZj9rrrb1j+LZNVKx5UhIKnscls9CmIiSPLEw
EwarmZ7AOovRTIgJWx6LyhXGiJzcfatugeKQVTkNFgruhlvNAfv49J5ZySBhvKI6
zwmk8OLkUszFzDbwAoyJYh7JsTQsA6u1KL4O2pQ2CTdp7tmrm7GaBX//4uNydgl6
NuVwIuHSrpl4thC9YpofAWo3bHF22zPZ8SGpLDbMQsYj809WwRWm2x71ItBPV7uT
EXyp1eDAIpXyx0Jepi3S
=vciL
-----END PGP SIGNATURE-----

--fCcDWlUEdh43YKr8--
