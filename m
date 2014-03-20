Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbaCTSh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:37:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49020 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759411AbaCTSg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:36:57 -0400
Date: Thu, 20 Mar 2014 18:36:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Arun Shamanna Lakshmi <aruns@nvidia.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Songhee Baek <sbaek@nvidia.com>
Message-ID: <20140320183638.GI11706@sirena.org.uk>
References: <1395186692-11735-1-git-send-email-aruns@nvidia.com>
 <20140318235941.GT11706@sirena.org.uk>
 <781A12BB53C15A4BB37291FDE08C03F3A05CB21E46@HQMAIL02.nvidia.com>
 <20140320114829.GC11706@sirena.org.uk>
 <532B3161.6080808@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IhIaZVN2IAk2Kxn9"
Content-Disposition: inline
In-Reply-To: <532B3161.6080808@wwwdotorg.org>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Add support for multi register mux
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IhIaZVN2IAk2Kxn9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 20, 2014 at 12:20:17PM -0600, Stephen Warren wrote:
> On 03/20/2014 05:48 AM, Mark Brown wrote:
> > On Wed, Mar 19, 2014 at 04:44:00PM -0700, Arun Shamanna Lakshmi wrote:

> >> If each bit of a 32 bit register maps to an input of a mux, then with
> >> the current 'soc_enum' structure we cannot have more than 64 inputs
> >> for the mux (because of reg and reg2 only).

> > What makes you say that?  We currently have devices in mainline which
> > have well over 32 inputs to muxes.

> I think their register layout is different.

> I found a number of large muxes where the register stores a 'integer'
> indicating which mux input to select, e.g. Arizona, WM2200, etc. In this
> case, an N-bit register could support up to 2^N inputs.

> However, the registers in the Tegra AHUB use 1 bit position per input,
> and require you to set one single bit at a time. Hence, an N bit
> register (or string of registers) can support up to N inputs. In more
> recent Tegra chips, we have at least >32 inputs and I think Arun was
> saying even >64 inputs. That requires 2 or 3 or more .reg fields in
> struct soc_enum.

Right, that was my guess too (the mail wasn't terribly clear with the
formatting, references to unpublished documents and so on) but that's
not a straight mux, it's a value mux, and the limit with the current
code is much lower on 32 bit systems (like at least some of the K1s)
since muxes only use one of the current register fields.

--IhIaZVN2IAk2Kxn9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKzUzAAoJELSic+t+oim9SgMP/iF/Rp5xyAQzHOOu243rVPuF
I1fKFTvXQw+1Rj8LB+rGiOukPlnI/l7DDfOzvrJeotw1fStpAr4MBZO3KV4ypEyk
N4N4BrTEtk0tyUoOFaNpN9FYfeGtkTFTw9Qwt9chVZWfzlzyHfxCnJx/CyOnV8J1
30+MTXGQc2zVBgCNpuMWGUfPGnPm9AJtgkDGSBNL7q1VyU/OQgdkYPhBmYjBSHbg
BEassiZaXsdPNOVsbRUK8YqNztJSu7mFsZ3cebZ2nAhk49MlOdlWDxC1IOWlIyLd
mjPQ+G8dQiFeErIs9wx/2HzRrRXq+P0rlfzLTne8D3ydgB27/tviHY+3wptjbV1d
oBT8K0kQBeg5fhr+CSKNjgQNe8nITMVM22CE8ODH5IPQUNRgSz5NzJZMxMa5Qgfr
J+GNFse6HTR5o/dV2Dh3X+IeLsVyBN7FqYqP2mt1AqInTOMre0avu4uPlCO7/pdo
q3QpJEG1HDNhZASnk59Y5nVRStKeSU//C89KwutdgPNX9Z4ShVtEreW3V5JGmTa6
JEDklXwTXxx6q1X4NnPVyN0oSnmGLNPcte2GzYdbMXS382SjexbYQTlPp8pOSnXs
d1dWYjHLNqhQGZehcNjQKGG2EK9xKD7gF+6wCS/fWTlOJdazO5hDF7yfPiym5nIe
vWw3x/uM6p0j38jnlQka
=nCaR
-----END PGP SIGNATURE-----

--IhIaZVN2IAk2Kxn9--
