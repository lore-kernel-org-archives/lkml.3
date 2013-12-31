Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3LaMrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 07:47:42 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57820 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3LaMrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 07:47:41 -0500
Date: Tue, 31 Dec 2013 12:47:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131231124737.GT31886@sirena.org.uk>
References: <20131231113138.102044cf@armhf>
 <20131231115927.GK31886@sirena.org.uk>
 <20131231133610.2d14bc29@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EzyTiZo8w1pFn3ee"
Content-Disposition: inline
In-Reply-To: <20131231133610.2d14bc29@armhf>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: generic: add generic compound card with DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EzyTiZo8w1pFn3ee
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 31, 2013 at 01:36:10PM +0100, Jean-Francois Moine wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > It would have been useful to have provided that feedback at the time
> > rather than waiting until after it had been merged - it was in review
> > for long enough.  It would also be good to articulate the issues with

> Sorry, I spent a lot of time on DPCM, and I was not yet ready to propose
> something when you accepted Kuninori's patch.

It'd still have been worthwhile to say that you weren't sure it'd work
even if you didn't have an alternative; you could perhaps have worked on
it together.

> > These are Linux-internal concepts which shouldn't appear in a DT binding
> > or at the very least need definition.  One thing to consider here is
> > that these things are all about the internals of a SoC and you'd
> > therefore expect that they would be defined separately from the card so
> > as to avoid having to replicate information in every card using a given
> > SoC.

> Do you mean that, as DPCM cannot be in the DT, there should be a
> specific driver for the Cubox audio card (Marvell Armada 510 + NXP HDMI
> transmitter)?

I'm not saying it can't be in the DT, I'm saying that this doesn't look
like the right way to do things.  For example we could have a way of
specifying parts of the card separately so the SoC can be referenced as
a whole by the card, or we could have the internals behind the DAI
hidden from the DT entirely so the DT just links the DAIs together and
the SoC internals come from the implementation of the DAI devices.

If you can't figure something out a more specific binding is fine, but
if you're trying to do a generic binding for everything then these
things need to be considered.

--EzyTiZo8w1pFn3ee
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwrzmAAoJELSic+t+oim9ekIP/2NFKTxQXIbe4FrUiL3x58r7
Z/Awu4SJpxrCs7/6oRnNCPH54hT8S5cRZZX0aqzLOxwnFLGDzjD9hugGTZdYlvCd
lKaVxLCFKwI/dxc/krkOi0Fmes+1itSMCmG3imBr6UWPozcHbo/gzLjb656SYtAR
X58wA5hd/0EY3lA49JDZx2KZNnMLcubA+UgOlbWU1gr2FGdplIsknOhBvtU/WIp3
KxWMbbJU/xbed02/HseOgv3CdCqx98ngt7CvwS2s5+ZZFKs4RZf+ZDW66nLRkZMC
Fe/1p2mD81Y8HGwjJNliDXt+fyfOLCrN+pfYeob6Nqz/yyUsF5rZmK/wfBYdBLr6
6eY3jHufRmw3QuoaKcoCB7UmSFZKyADX2DjKnSYOshlMEdpJf+J9SfMmI0ji60Mn
LaUUySRYy03W/2eMmT+Q5wi0BEIPB8uLqLk4SbERPIm+0r09Lz+i1HfBQDhxrnQn
7Dbf/k/uGrpDVCgdp92NsVXyiy8qrlEgjjgJlhAsCTJZl3AmI1gB2pE2yN2ksvqy
FPCWc/hWjgSIanKQXAi8tk09vWvnjoDHo45cIFEWOD6WlGK668MiZLRCdHvc+UxZ
MG/YLvSwBcyFJy9q1FRjh2znfHlXyhLbhW8CVD/sjotap4eLvWKAECKcN5kkt25P
V7c4i6aU91UJpU+rGbX4
=prZY
-----END PGP SIGNATURE-----

--EzyTiZo8w1pFn3ee--
