Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaBKRjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:39:43 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40484 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaBKRjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:39:41 -0500
Date: Tue, 11 Feb 2014 17:39:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20140211173933.GW13533@sirena.org.uk>
References: <1392114599-481-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CpBQqYjq/d0HQTAP"
Content-Disposition: inline
In-Reply-To: <1392114599-481-1-git-send-email-linus.walleij@linaro.org>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: dbx500/abx500: root out hardcoded IRQ assignments
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CpBQqYjq/d0HQTAP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 11, 2014 at 11:29:59AM +0100, Linus Walleij wrote:

> I've been ambivalent on how to look up the IRQ resource for the
> AB8500 from the device tree (as it is hanging off the main GIC
> interrupt controller rather than the PRCMU) and eventually ended
> up with this solution. I experimented with modifying mfd-core.c
> to add resources from the device tree, but I didn't like the
> result, it seems MFD cells should get their resources exclusively
> from the parent instantiating the cell, so I ended up with this.

> Maybe Broonie has ideas about this too?

This looks reasonably sensible to me.  The way irqdomains seem to want
you to encapsulate this stuff is that the internal interrupts of the
chip get an irqdomain and then the children get their resources relative
to that, normally using the MFD helpers to map the hwirqs in the domain
to Linux interrupt numbers.

--CpBQqYjq/d0HQTAP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+mBSAAoJELSic+t+oim94z8QAJ2pz6XLRoHqFV/fBRVuI2ko
94L3jl7bhczJcO0BjalGYVlNYop5q7ND9J1LRYP8xRE3k6CmXsQ/ZGSc7ybgDOSt
vU1Gg2TygPjbUQ9PZQhxnOWe7ZbR31F2BnQ2qEoAtgPp71C09FgbhrT0zehcqmcA
qwS+BI5cAzdtwmUbiAeXh4q6U0y5O+vhtCyEgdZ9nU2M8Zv/CkObpeD6EHI9xJJP
AVyAIO8u74Aqs5V4f9AdfyIVjq++w8FXiD87YDnUV0Y2R0nTX8p2RYpMjGudcFhz
84XzzCJwPjAuCfbzfevetT+OI2/JkcDagtztb8W4jLVoUsTW74KUjNFIukI5oSWK
PIXvOi2lXzKqRLR7FmcofCQeDV6fsJfcrBZRKh2SRgKhjjk1T9dPApKnCMkN/ZsI
Vfi066qIJgtDB198rJdrWoYFADd82thm0rQtLTj7LQf9ouS2kNJcK62k8N0PgtbP
5YNFE4kS4DVDT6vmvhrR0nFBPIOCqZcjOHqO5jpVMTNKgXypZOnSDBL0KUGDwQbz
3pHQ8/WJANlvxL5sjEW2VJCUWCJxnKdjKnjuOgVjslCwFgFPJ14V7LyOkGp1hA4O
/tj72QyXDuxEc2SYpu4/GpAfIAtqjrSLo7s+F3RAQE6/76z8se7y/EPP8WGHa4+6
EXW0Y6Yf+78DvjPbOy30
=GofM
-----END PGP SIGNATURE-----

--CpBQqYjq/d0HQTAP--
