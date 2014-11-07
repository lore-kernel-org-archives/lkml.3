Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaKGQWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:22:24 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49674 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaKGQWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:22:22 -0500
Date: Fri, 7 Nov 2014 16:21:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141107162124.GW8509@sirena.org.uk>
References: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415365205-27630-6-git-send-email-javier.martinez@collabora.co.uk>
 <20141107154743.GT8509@sirena.org.uk>
 <545CF02A.9060500@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GkKDMoQVTmdw7ke1"
Content-Disposition: inline
In-Reply-To: <545CF02A.9060500@collabora.co.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.208
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 5/5] regulator: of: Add support for parsing initial
 and suspend modes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GkKDMoQVTmdw7ke1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 07, 2014 at 05:15:38PM +0100, Javier Martinez Canillas wrote:
> On 11/07/2014 04:47 PM, Mark Brown wrote:

> >> +	if (!of_property_read_u32(np, "regulator-initial-mode", &pval)) {
> >> +		if (desc && desc->map_modes)
> >> +			constraints->initial_mode = desc->map_modes(pval);
> >> +		else
> >> +			pr_warn("%s: failed to parse regulator-initial-mode\n",
> >> +				np->name);
> >> +	}

> > This is ignoring any error return from map_modes(), it's possible the DT
> > might have an invalid value.  The error message could also use some
> > improvement, it's more that the kernel doesn't understand how to parse
> > it even if it is valid.

> Right, as I mentioned to Krzysztof in a previous email, I'll remove the
> warning message and add an error message instead if the map mode callback
> function fails and also show the error code as you suggest.

It seems reasonable to at least warn if there's a mode specified and
there's no way of understanding it...

--GkKDMoQVTmdw7ke1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXPGEAAoJECTWi3JdVIfQtYsH+wS9ZlUP9VNA1H9gUNKilG7B
7t2uD43wjK81z4NB2HDYBrOVfL1busZpxv4I+ngPgwVGY4ijEOC+nmhU05i/tHUJ
VDl2plQe/8fX5tQ1Mi1gZ7ufNlA9XA/hQ85huoffE/dOvP4161ayPsLnQ6n561BT
Qe10u42zipIVC/BzJ3xxOspX79uBz0kaw8YTmaNEiUwV+tCKsaYr69bPBzFcR3Ls
xWc6s8oHicZW76tsih0LAFZRn9uj5NdDnuvKhKdUOocorEs4Nkwj0nt09vRomSus
T5MXMLCoPrLUsELNr13Kxz82BMEMniHo+8M8myVG8ep0l8YaBJYkmF62MXvBUcE=
=hr5M
-----END PGP SIGNATURE-----

--GkKDMoQVTmdw7ke1--
