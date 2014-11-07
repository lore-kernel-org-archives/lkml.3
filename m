Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaKGQVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:21:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49663 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaKGQVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:21:52 -0500
Date: Fri, 7 Nov 2014 15:47:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141107154743.GT8509@sirena.org.uk>
References: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415365205-27630-6-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KqDMOJtxr760r6Zu"
Content-Disposition: inline
In-Reply-To: <1415365205-27630-6-git-send-email-javier.martinez@collabora.co.uk>
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


--KqDMOJtxr760r6Zu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 07, 2014 at 02:00:05PM +0100, Javier Martinez Canillas wrote:

> +	if (!of_property_read_u32(np, "regulator-initial-mode", &pval)) {
> +		if (desc && desc->map_modes)
> +			constraints->initial_mode = desc->map_modes(pval);
> +		else
> +			pr_warn("%s: failed to parse regulator-initial-mode\n",
> +				np->name);
> +	}

This is ignoring any error return from map_modes(), it's possible the DT
might have an invalid value.  The error message could also use some
improvement, it's more that the kernel doesn't understand how to parse
it even if it is valid.

--KqDMOJtxr760r6Zu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXOmbAAoJECTWi3JdVIfQVwgH/i69PJNgT4gFLJ1OK6Ims5eD
8ApPWA/beNRKRC2y1hDuBukoBSdx+0PVJwRDHw2w+6LL7NkyUEJ1ae3bo24bFA2H
X1rdryZkhMv9qhgnzgJIK94x8RnLhciByLEmir4g5WkEh34mGKbVjaIxfLdIV8sw
w6ry9mhj0HwBWHuYpGaFgGzp88v7ddYrRBYP3CYlMSaU2meXmCL+mzzeC1jB7ly3
I3l7W3eu2KUNdbW/7E/J2Q6lAhDLPCm/mCwZ3Pl24COGOWyVpev8q3Ql26JuAsQv
WAXMuaBcW35hdrqBcvia91PomVANPq9EN81kSKljKl5HBUXyKMce40Ky4Hbiprw=
=Z5gl
-----END PGP SIGNATURE-----

--KqDMOJtxr760r6Zu--
