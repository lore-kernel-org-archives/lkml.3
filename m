Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab3HLOl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:41:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49418 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3HLOlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:41:25 -0400
Date: Mon, 12 Aug 2013 15:41:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, devicetree@kernel.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20130812144110.GA6427@sirena.org.uk>
References: <20130811190826.GH6427@sirena.org.uk>
 <CACxGe6sM8_d_omiQU=4qA207dnYMGDELN0KDbhYDsWDg7RKAKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nIPQBKNtp9w8F7mD"
Content-Disposition: inline
In-Reply-To: <CACxGe6sM8_d_omiQU=4qA207dnYMGDELN0KDbhYDsWDg7RKAKQ@mail.gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nIPQBKNtp9w8F7mD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 11, 2013 at 11:08:37PM +0100, Grant Likely wrote:

> full enumerating like that with either ACPI or FDT, but we could allow
> for sparse population of devices when something is fixed like a
> soldered down USB hub or USB Ethernet MAC.

I agree, there's no point in listing things that can be done
automatically - it's just introducing potential for error.

> To make it work would probably require a hook in the USB enumeration
> path to look for matching nodes in DT/ACPI and attach it to the struct
> device.

Yes, that was where I was heading too.  Have a mechanism for matching up
hotplugged devices with pre-registered ones which appear from firmware
or wherever if their IDs match.  It'd need some mechanism for drivers to
opt into being bound to devices that aren't physically there I think so
that normal drivers for enumerated devices don't get confused.

--nIPQBKNtp9w8F7mD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCPQDAAoJELSic+t+oim9v6kP/2Fc7NWbNJWzqDfViqQjhgrO
qNT25qplJo+7SEEcJF4pti5xwdyZQZGJoWGU76NW93a9yv4eD8G8P4pHT8gykLZX
lWBDZFGzddiQsgVrwExpRMJDF4DVh2G8kbtU7AEQf8URNmlyHS8XapJcDWM1prXF
zTA2sYMUw0YHF0SAxatPHSTSmZZ4dp5Erc4sEluaaC6hKX/h68/xLAmFkreNH+th
FbPKw+s1TdaxmmCVb9Bzz9tlsJsPQtzQFmjsePS5OrrW3Ko6Rq+DLjJ2qSIpbvy3
IdqoFpBWFHndfAg42W93Gc8nIH8p7HMwaOzuY4uQeDjoFEUqeOu7ldYBAuA2PM/K
EMz5/7J9Gn2rF+bOnoAGIbueckoJ4UNkoKiyia+RU0Dt9R1uQgiE234d0xC8WV2h
dRKw2WTvlGfYLEjTaIgfexmDN47zX2MGgAGD3oULVqwA2czSGPXiBiCIDltCB8yp
bDAVT90r8Ztk45Hczr2lrpwgif8CFbZlN2hB017Il+f+gfkSAJhp1K5WbVDmDFhZ
hBMlDZ7riFVKc0fDYNNkPtjQK+6ldVMrQ08SrNzl0c7Uq/VedAHVin7xNr/3k4Cl
me/wA95hiOxcfmm1sQCh2UZqRPpt/dp6nQNhD96gZ5StANLADw3gTr/ZqHVyDFbc
6EFju6ERfDgIteSnY1yU
=htGK
-----END PGP SIGNATURE-----

--nIPQBKNtp9w8F7mD--
