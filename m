Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbaGNSBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:01:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37231 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaGNSBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:01:34 -0400
Date: Mon, 14 Jul 2014 19:01:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, milo.kim@ti.com,
        support.opensource@diasemi.com, patches@opensource.wolfsonmicro.com,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20140714180114.GJ6800@sirena.org.uk>
References: <1405333997-28764-1-git-send-email-ldewangan@nvidia.com>
 <20140714115718.GA18724@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOmey7/79ja+7F5w"
Content-Disposition: inline
In-Reply-To: <20140714115718.GA18724@opensource.wolfsonmicro.com>
X-Cookie: Above all else -- sky.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: drivers: fix return value of get_mode callback
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOmey7/79ja+7F5w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 14, 2014 at 12:57:18PM +0100, Charles Keepax wrote:
> On Mon, Jul 14, 2014 at 04:03:17PM +0530, Laxman Dewangan wrote:

> > The function get_mode() should return 0 on error and REGULATOR_MODE_*
> > on success. The return type of this function is defined as unsigned int.

> Looks like _regulator_get_mode in core.c would need updated too.
> I can't help but wonder if it might be better to just make
> get/set mode use an int instead, although I don't know for what
> reasons an unsigned int was choosen in the first place so I might
> be missing something.

It's because it's returning something defined as a bitmask, though since
we don't even have enough modes for 8 bits that's not really a strong
reason and we should just be returning an error code as everyone is
clearly already assuming we do.

--BOmey7/79ja+7F5w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxBrnAAoJELSic+t+oim9i78P/irCqOj6A6OOfdj8+ESZUHlY
D1RAEvVLWTnCgaQUSqPz1R4W4X8cw3yjaIvqcw+fqa3XohOrYuiFm0POXv8daGke
ZuY/D2F9mlq/I0w7fbqqqlme6QD+jHkyp0Hiy29dHhBcvUbrwt7TYiP5keEay7HW
23DhEBds3MZ8ii6fcjnB3VE5xUxfkGB3oF/j/NqWXrbbXNC9L5ODqufGFw2m+F0r
lUPpfarjoyBspSs/xJ/hVrS/udvz3W8sy5LeIZxDiFoNGlG7+H2AkTGoVP1pxmFm
FYz/5s/y4AFtPzZ5mKohPZKq+2QlQ9AGcrwQFvo+zf14Um0bsw0TX6DVa/Id5vt6
W/sI95dKGn9Sohno5Ohjqrjk3Pymh04yR1e/hX9ihQA8oSyd/WNMup08+HRuxmLk
xGuo1uwUljCwM6Yj1xs0VTLCnw/aiF9X0cS0E7/QrNDRRdtPh8VFD4IaCD2TI75t
VUg9zFMe3LhbgoId8TJ7j2vpuDNScGe2bVpYPvZ2Vvb/defw2RbETFErl6/tP5q2
i4wh5V+rWp4K52Qap9piSCG4aCwZ3VuPpM3DRrG7mXcPqTLhBHjMbCFTG1jHDivr
bJnkcTdM/cETW+iNZ1xr0l+1EfJTzemP1JUBJ5YjADwcJkF0cOhMA6TZz6BUgALU
MJUp5dJ3xKyLUZTLrv9C
=uPmd
-----END PGP SIGNATURE-----

--BOmey7/79ja+7F5w--
