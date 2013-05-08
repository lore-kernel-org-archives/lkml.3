Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3EHO3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:29:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51863 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab3EHO3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:29:51 -0400
Date: Wed, 8 May 2013 15:29:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130508142938.GS7478@sirena.org.uk>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
 <20130508105124.GA7478@sirena.org.uk>
 <20130508114216.GB29130@balto.lan>
 <20130508123225.GK7478@sirena.org.uk>
 <20130508131020.GA30503@balto.lan>
 <20130508135413.GR7478@sirena.org.uk>
 <20130508141723.GA12155@balto.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qoa3+4LHNtB0VmQh"
Content-Disposition: inline
In-Reply-To: <20130508141723.GA12155@balto.lan>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qoa3+4LHNtB0VmQh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 04:17:23PM +0200, Fabio Baltieri wrote:
> On Wed, May 08, 2013 at 02:54:13PM +0100, Mark Brown wrote:

> > But why does the rest of the code work well if the reference counting is
> > wrong, it's in the middle of a big block of code?  This all smells like
> > this change is papering over a specific symptom of some underlying issue
> > - if that's not the case then it needs to be clearer why.

> Well, the counting by itself is not wrong, it's just that the same pins
> are used by both driver instances (ux500-msp-i2s.1 and ux500-msp-i2s.3)
> but the actual counter is specific of each instance
> (msp->pinctrl_rxtx_ref, if I'm not mistaken msp is different between the
> capture and playback interfaces).

So if these pins are being shared between the instances then surely
there are other interdependencies that need to be taken care of Is that
happening?  For example if the clocks are shared then is the code
currently stopping the interfaces being configured with incompatible
sample rates or word sizes?

It seems like the code is definitely buggy here but is this really all
that's buggy or is it just the symptom you happen to have seen?

> Ok, what I'm trying to say is that the codec used in this platform
> should be able to handle sleep modes without requiring any
> reconfiguration of the digital interface on the SoC side.  In support of
> this the fact that the STE fork of the driver does not do that, and the
> same goes for all other ASoC drivers currently in mainline.

Well, most things would probably be able to get some small benefit from
doing this, it's just that we've not had any real support for managing
pin muxing - one of the goals of adding pinctrl is to make it easier to
deploy this sort of thing.

--qoa3+4LHNtB0VmQh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRimFPAAoJELSic+t+oim95S0P/AmeXItPl+0O8Pyoj2SZKUKv
F7yPyiPZtZOqrcRaKnJQgHiaxt6O4msL5JzrPA2a9SPd8m6X4yUC4Osxtp9VNoUN
l8keVitOg5MsmpK12uUeDV3dO/d3jGBYP7P8RY0tXOICnOnlQkxfc/bxeOk+Z7fs
xKG1aVUe+kCh+D8VpTVguhVITOAUeAs4S0UecRn6V5dWg3jAVZk252uy5OVMORqA
BVek8iOcRfWGnqNJ0ZXl0xTUdcpJ2aSw4RjBf0/JWcLsO3L7jTB3xxGtxbyrRkGF
p5HgsKRh45yxFBIsYJnIEVId+wK8haofDAdTbLYRmVnRIU3aZt4d2VgXcT3VQQ3F
vCv7mNqiAH62EfbrpL29Kd0+k+NXiqv6z8Hfu64nEeiwzqJYa3Mc2/0/WXHPnnzx
XyMtX9K7eVjThRWDkCWbx42io+P/gVzEu6xWavLwrG2ZbY1671yT4QPM/2MOHGeG
j0mV6vX4u+1fcnNLPfXYsZLwjspL2fBNvgH21lfteoY6neylybEmpGD8g2nQ0dgy
M+KVcCeaZvoVvIcXIib6sUldF7L+4BlfVQKtaf6ljg4EbJMGNc0i+RbeOezHhuoU
90SImSLmAfIlRVb4STT7k6BWKONLgo1Mj7IqVCVFiPDXHwOE1aQqiT9fFpfUd+/9
BvChSjPf64ym7rCJVErC
=vyPI
-----END PGP SIGNATURE-----

--qoa3+4LHNtB0VmQh--
