Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaL2Pt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 10:49:56 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54219 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaL2Ptw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 10:49:52 -0500
Date: Mon, 29 Dec 2014 15:49:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, linux-ide@vger.kernel.org
Message-ID: <20141229154935.GK17800@sirena.org.uk>
References: <1419614799-5770-1-git-send-email-gregory.clement@free-electrons.com>
 <1419614799-5770-3-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s7CsBtDqQs5UqHUm"
Content-Disposition: inline
In-Reply-To: <1419614799-5770-3-git-send-email-gregory.clement@free-electrons.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: core: Add the device tree version to the
 regulator_get family
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s7CsBtDqQs5UqHUm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 26, 2014 at 06:26:39PM +0100, Gregory CLEMENT wrote:

> This patch adds the device tree version (of_) for each member of the
> regulator_get family: normal, exclusive, optional and all of the
> manageable version.

I'm really not keen on this - this sort of firmware specific interface
is just going to encourage the sort of problematic Linux MFD in DT stuff
people seem so enthusiastic about and needlessly DT specific code.

> The of_regulator_get* functions allow using a device node to get the
> regulator instead using the device object. It is needed for the
> regulator associated to a child node which is not a device, it is the
> case of the SATA ports of an ahci controller for instance.

It would be much better to provide a way of mapping the supplies to the
regulator using the normal APIs, for example by making the child nodes
devices (I'm not seeing anything that says why that's not possible and
it sounds like they're supposed to be physically separate devices which
sound like good candidates for being struct device) or by providing some
other alternative mapping mechanism which isn't DT specific.

Or take another look at what the bindings are doing to avoid the
requirement for this, I'd have expected these new bindings to be part of
the review here...

--s7CsBtDqQs5UqHUm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoXgPAAoJECTWi3JdVIfQLAYH/RWxUNFJeP2CxjBrLYh+B2/F
3fy1+sgt64B4haypbJz5TReezpsLKGSz0GEOekryqT7O8gD8ootbLOG8liNlYDHN
8EkBqjrNDKhR+GMJ/QppuLvB0C1aD2+j/Tw+jkMuz/u8GB7v2pyvk24cspU4IHR2
/Zihp8w1AJdXn6l6VFapUGueRyFSda8M84YCOg1qVN/FuPXg0ZgfWmek93ZRnPwm
ZI+Ka85JEa/XFPuOjWeuI1lAXf1wlaKql+TS9C8RGrsF88oncQNpiF5HuFswZyA0
o1QySoGEVKbW2whhtiMX1by9bnH5uU1lLEOAGRIQefti01v+//nQtZz53D3wnb8=
=btaQ
-----END PGP SIGNATURE-----

--s7CsBtDqQs5UqHUm--
