Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaAQAtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 19:49:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55825 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAQAtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 19:49:49 -0500
Date: Fri, 17 Jan 2014 00:49:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@lists.codethink.co.uk,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linus SH list <linux-sh@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20140117004935.GP17314@sirena.org.uk>
References: <1389445589-21502-1-git-send-email-ben.dooks@codethink.co.uk>
 <2820428.J065BbN1jW@avalon>
 <4441342.H8MHOLBobb@avalon>
 <52D38B90.1060002@codethink.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X78YbkCBd9ye7Cvs"
Content-Disposition: inline
In-Reply-To: <52D38B90.1060002@codethink.co.uk>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ARM: shmobile: compile drivers/sh for
 CONFIG_ARCH_SHMOBILE_MULTI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X78YbkCBd9ye7Cvs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 13, 2014 at 06:45:36AM +0000, Ben Dooks wrote:

> - If pm-runtime is not enabled then we need something to manage the
>   clocks for the driver. If we put that code in the driver then there
>   is not a lot of point in having the pm-runtime clock code here as
>   the driver really only needs a helper to turn them on and off at
>   the right place.

Last time I looked at the code the runtime PM stuff was also being used
to manage actual power domains in at least some of those SoCs (which is
the more common use for power domains).  This was a while ago while I
was doing power domain support for s3c64xx though.

> When discussing this on freenode's #armkernel channel, several people
> including Mark Brown wanted to keep this as it made driver's handling
> of clocks much easier (there was no longer any need to deal with the
> clk code when writing a simple driver). My view is it is a pain as we
> now have a mix of drivers which expect to do their own clock work and
> some that do not. (It is possible there are even some shmobile drivers
> that still do their own clock management).

I don't massively care one way or another but it is a totally reasonable
decision for a platform to do this especially if the clocks are tied to
the power domains in some way, for example a single functional clock
shared over the domain.

The arguments people have for doing this have been more about removing
knowledge of the SoC integration from the driver - having the functional
clocks for the IP visible in the kernel can make IPs harder to share
with platforms that lack meaningful clock management - and factoring out
boilerplate code that just acquires, enables and disables clocks.

> Personally I do not like hiding the implementation of this, as it ends
> up confusing people when they first come to it.

It wouldn't do that if we did it all the time of course; there is an
argument for consistency.

--X78YbkCBd9ye7Cvs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2H4bAAoJELSic+t+oim9uwYP/R/2lRfagtBrC3Cj50lbNV3f
0sxZtPXL3quTCaR7lt1bejEko5IS5/2wkrR9bO0vqv0CMeblfTXZykE+byGcdh4O
Dy+D3DCCqhf1pLZ92YCAkbeD//6FcebGGicuAXlFrmDUAoTHh1jpfB0dVAp5XGl+
2Tclq3jS0fgftvxLA7A0fWJRL4X8okAmmew6yyarBOIUprfcXtheQDnPqdt721gv
edjB4m59Wv6CLpvxStSFQXlec3SfjCK6/pN4A2h6dfWh7nebw5INumSBg8iUEii0
XvTZ4dEMk7FmRnmhVIDgY8JNoNljoEUG1t++WQDJI0caF6yXi6jgQ3Z49n24xdiH
iAkEjUnd6tTGFG1Rh3a7ZYx8EYa9Ot38zZEO+jjJyNXArnaaQPxVQGgcUf7uql2r
n83WSW70QRs5eD82MhmMLVJTdBccYd2f43Bjfo0eZXWVnOWb+ZBBpvywuWBYm6SW
0PJRgNWazqy4+4zZuL2pc5+phN6FieMudvA6rM1zMkQzzFJvxCwQ6Nw2WmVuEfBa
tTfUiSuNcSGCGhRLF42Omimk6GFwC4OS9/FEmQsXpKxzWmXVpU1Vj41BGDHtrwHE
AvASNvvaojNYPnjA6rNp+pTrn6lRXOOl5Wq1hZLRwLVltD3+5NXVyPv3IC/HJLH4
1IoQVUgekN3jSvaglphT
=zu3N
-----END PGP SIGNATURE-----

--X78YbkCBd9ye7Cvs--
