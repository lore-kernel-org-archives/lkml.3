Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab3GZWsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:48:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53882 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab3GZWsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:48:16 -0400
Date: Fri, 26 Jul 2013 23:48:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Felipe Tonello <eu@felipetonello.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Message-ID: <20130726224813.GB9858@sirena.org.uk>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
 <1374863133-6745-2-git-send-email-eu@felipetonello.com>
 <20130726185458.GX9858@sirena.org.uk>
 <CAGrhNMy7qZ8CbAjFX5Gv8OqYkit+Eqzr2zZTYXeQ-cNO22+pTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W53HmUNQxykgUrRq"
Content-Disposition: inline
In-Reply-To: <CAGrhNMy7qZ8CbAjFX5Gv8OqYkit+Eqzr2zZTYXeQ-cNO22+pTQ@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] ALSA: Added jack detection kcontrol support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W53HmUNQxykgUrRq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 12:10:27PM -0700, Felipe Tonello wrote:
> On Fri, Jul 26, 2013 at 11:54 AM, Mark Brown <broonie@kernel.org> wrote:

> > This isn't ideal for multi-function jacks like headsets - it will report
> > a single boolean value for the jack regardless of what's plugged in
> > meaning userpace can't do things like figure out if a headset or
> > headphone is present.  It's probably OK for any realistic input button
> > since you're not going to get an input button without other things being
> > present.

> The KControl for Jack is boolean anyway. You can check it with "amixer
> contents". user-space can figure out based on the control name. At
> least PulseAudio does that way.

No, it can't do that for headset jacks - these will be created with a
single jack reporting multiple states, there's a state for headphone and
a state for microphone.  The system can generally distinguish between
having a headset or just plain headphones inserted and act accordingly
(for example, recording from the built in microphone on a phone when
used with normal headpones).

> > What I'd expect to happen here is that for multi function jacks we
> > create a control per function if the controls are valid.

> Do you mean based on snd_jack_types?

Yes.  If there's only one function supported the current code is fine
but for multiple functions it's going to discard useful information.

--W53HmUNQxykgUrRq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8vyqAAoJELSic+t+oim9oJwP/3nAEr2/H+ij1R4Lj/7IMfJF
CUSVR0G1K7zxykgHOTEHJzabbzCbqOaMWlxzaXSuoys2TYf2anOzeaxtpq3YHbrU
WIHAUD/E5w9NP5udOhqQaZEzhxk/HsLvXFwxtcU2ia1Dwt73A42DSikpdxFr2WQ8
b7DHDgTHIx+1ckekZVP+b6PmSjHUqlLnBZ/ns0co/fs6QOqLzjv2FRGFCiJOpT0Y
tB2N9uX8Ir4Ee15/lQ/MrP0YehsJwl5EbggrA4gliBFafPsddWpvtw1uS49RfeuG
YctwaE8NEMp8pkSxmcVPJbrVmE1Pt3nz6/LxD6uSNVLcuMKu/j3iRwEaRKCvb07M
2tRVGY5KbdllQXJbbRMUMQRWDXc/b1s+shamBLuy+HIKFwi6Q+IZYfMd29OMmz2a
GZV/ydKFftfhCSkfmIHSFUBkiH7LFsdvdHn0UYQEvMKwUwA0FQj9abt6yvFd2a8d
78aFfPdeSXw1UdOr7v/Ss05YCdwNeSbKMIa8Bi18aIQ2kdFZ8UYFPk6ut5jNk4YR
9k6/7AuJnp96CEOqGh7ZyrENWfStTOnZcjRtCNnqRJ411MWLRmKeQbT91EwPJSpx
Nk8UVDeYBCSMBa/ivATFQA5HzzpqUjcG9yz2JpsZ2nnHaLRVp2itFnbExJQANhSU
xGiqsIXimPvryQI0pQsN
=64Ng
-----END PGP SIGNATURE-----

--W53HmUNQxykgUrRq--
