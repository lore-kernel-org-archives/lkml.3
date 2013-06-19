Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab3FSN74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:59:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39295 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab3FSN7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:59:48 -0400
Date: Wed, 19 Jun 2013 14:59:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20130619135920.GV1403@sirena.org.uk>
References: <1371565785-31332-1-git-send-email-mika.westerberg@linux.intel.com>
 <1371565785-31332-2-git-send-email-mika.westerberg@linux.intel.com>
 <20130618180948.GP1403@sirena.org.uk>
 <20130619092508.GJ2718@n2100.arm.linux.org.uk>
 <20130619093938.GT1403@sirena.org.uk>
 <20130619100515.GK2718@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o9qiPLpykPxkk5uk"
Content-Disposition: inline
In-Reply-To: <20130619100515.GK2718@n2100.arm.linux.org.uk>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi/pxa2xx: use a flag to check if the device is
 runtime suspended
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o9qiPLpykPxkk5uk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 19, 2013 at 11:05:15AM +0100, Russell King - ARM Linux wrote:

> And that's why doing it by "read the ISR and check its value" is the
> best way, and not doing the "what state does the kernel think this
> device is in".

Not entirely, and of course that's not always an option either.

> The latter may be fine if the device is only connected to a non-shared
> interrupt, but as soon as you start sharing interrupts, it fails - what
> do you do if the device signals an interrupt on a level-sensitive input
> but the kernel's state says that it's not yet active?  The answer -
> you spin forever entering the same interrupt handler until the IRQ
> input gets disabled permanently until you reboot the system.

Or we teach the interrupt core how to handle it better - checking for
I/O failures works in the case where the device is genuinely asleep and
we can see I/O failures without undue pain but starts to fall over with
other scenarios.

> As far as device sequencing, that is where the tree topology of the
> device model is supposed to save you - the parenting of devices is
> supposed to reflect their relationship, and the way things like PM
> and runtime PM work, those relationships dictate the order in which
> PM operations occur.  For instance, with runtime PM, a parent will
> not be placed into a suspend state unless its children are already
> suspended, unless the parent signals that it is independent of the
> childs states.

This doesn't fix everything (though it's a lot better with deferred
probing since things now mostly end up in the actual dependency order),
there's still some nasty issues especially around devices which can
interrupt from suspend states.  If that can happen then you can get the
interrupt controller being awake and delivering the interrupt while the
device (or worse, the control bus for the device) is not able to
interact with it.  This is a different problem in that the interrupt
genuinely is firing, it's just that the control path isn't available
yet, but it's the same general class of things.

--o9qiPLpykPxkk5uk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwbk1AAoJELSic+t+oim979YP/2gx7Pxm6IbcteHJUSKxHVjI
3lgX3/V2YafeqnzM9SilSiM3a/zzy9+JlIZv3rvgQRMvf4lyVrGI7ZFjPKBqDe9L
94FTj2XIBGORK8NncahnP4Mk/hhnlBZ+phlWq/yMni/5Gxxrr9q7VXp59+9/PL+v
tcMwhtNAqyso3NXXlBEuF2i3kDl49SlCfpmnAzs5jItY+S76bjy8v4JUw2XV3Q5i
tGrLu6eYtwKiZBGUQXaNoCEtCcW+CnRjsrL/XlrkP8jz/U7vlEGzCntfZARAfikZ
En4DBp9iVniAbHo7Zc47ZuDX2WZ66tFTgKo8ofNutDGJpo0+oMTWx+EB2wRtG7qt
lSS4bhrne7Gf2NmrPhXbnxtboY2MM0Js96qw4o+6WPe7VxyqlZUwWc5yTS6mkoDP
2T3SzI+7HF3nBe9O6wOoT1BMUNZOV20I5AUc+6i/nFvi4BsMuBHcind3a03vVDpI
pQVIqhgYIKEOLFm/8PsbB6a9CVAu9s/4wUQMsp7jvkiXgBICrVbULgbztJ4gxN0k
Erv2vHhJIASyxuXfbK4kzTr96IpEjcLdQuQKxrr0rhFfYHdgJjUDJU9Kr8zTzbE7
+bNUm+ftRerrIajVWkPev345S8YjFTiBH5L6L5HBWqYn9qHZuVNzS/+3R/g4nDv5
dF4rkVcEIStiq10D/FuL
=y7s0
-----END PGP SIGNATURE-----

--o9qiPLpykPxkk5uk--
