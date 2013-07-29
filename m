Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3G2TtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:49:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49339 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3G2TtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:49:07 -0400
Date: Mon, 29 Jul 2013 20:48:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Dave Martin <Dave.Martin@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130729194829.GG9858@sirena.org.uk>
References: <2469263.vMN09Q7Tzi@flatron>
 <20130729150124.GS29916@titan.lakedaemon.net>
 <20130729164905.GB2280@localhost.localdomain>
 <20130729172339.GT29916@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ux295LQi5R3PD/XN"
Content-Disposition: inline
In-Reply-To: <20130729172339.GT29916@titan.lakedaemon.net>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Ksummit-2013-discuss] Defining schemas for Device Tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ux295LQi5R3PD/XN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 29, 2013 at 01:23:39PM -0400, Jason Cooper wrote:

> true, the answer to this problem may be to create a depgraph of the
> nodes based on phandles and child status, then init.  However, if the
> goal is to accelerate boot times, then that should not be calculated
> during each boot, especially since it doesn't likely change from boot to
> boot.

FWIW this is broadly speaking what deferred probing is supposed to do -
it seemed too complex and fragile to make the graph for board files so
Grant came up with the idea of deferred probing which aims to sidestep
the problem and work it out dynamically, also providing a fallback in
case something that has actually optimised the ordering misses some case
(cleaning up after the effects of parallel probes for example).

--Ux295LQi5R3PD/XN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9scJAAoJELSic+t+oim9CUAP/2OU00gUAC1PDqf6SbbOVFPi
ryYzHYnowCGHXAONfYUDBg2YHmNBMqxP8qTbxY+ryuxK4q9keXy8x8g/3T1bsNhZ
yngIeioeUDI5BLH3dxAEHvu2CpQnryM//sWCk69ghqIxK/3kNgeOzLzTzj0BNMJW
aQwtKuYZf7MfB1Qf20JWpmIWS30UhkcwcyNDevL6wU+DBAynEg9ba5cLC6AEIVmy
Ksl9bSZrvjqKL+PePaXSswVTuSRUicpsiFkY7WrPmtBCWPjSz8N+KHNu2eJCc9Yk
CZvBbjxcjSJyQyH7yb3dxhCczQVI3PzoFoS5mXuyCooKhGdx9FXztkhAMgbOcyXE
YkslCvQuMwkW7h6s6xRpcEHMbm1LJj/+h4LqOV5JVODqN6fZTPjcY+5K4rd9L390
rRedBp2eqH3t2l7PcetLhFuwEcvoF3wn9znzmyFYoBcT95QQzqi4LMAPblcMSxb0
ock2C1rIA2V15wQli4TZY7F8fgE39NaoijWg3COawBsmWkc7q/vxBeD0Pvg5NPdi
wpfd4KaTIzPSjDr377/DeMrLhfwQQ4qcx8C9P2i6HCuUPwVrpJb+nhQMZ+qnIsZ5
gUThuQ+dDHU2C+0MJ0UYzcuUqwnkilDS6PBez1TRSXM48jzGELXTUQYDorKpc66k
ndpTsyHRi4E5cXcQuGTH
=Rq3Q
-----END PGP SIGNATURE-----

--Ux295LQi5R3PD/XN--
