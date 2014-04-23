Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbaDWS0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:26:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43123 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbaDWS0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:26:35 -0400
Date: Wed, 23 Apr 2014 19:26:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Zi Shen Lim <zlim@broadcom.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20140423182611.GF12304@sirena.org.uk>
References: <1398217214-12204-1-git-send-email-zlim@broadcom.com>
 <1398217214-12204-3-git-send-email-zlim@broadcom.com>
 <20140423103648.GM12304@sirena.org.uk>
 <20140423172720.GA18588@lc-sj1-5012.sj.broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7v9iR3M+zmFtWrmF"
Content-Disposition: inline
In-Reply-To: <20140423172720.GA18588@lc-sj1-5012.sj.broadcom.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] arm64: topology: add MPIDR-based detection
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7v9iR3M+zmFtWrmF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 10:27:20AM -0700, Zi Shen Lim wrote:

> Or is it likely that some folks may opt to skip aff2, and simply use aff3?
> Mark, is there precedence for such usage of affinity levels?

Not that I'm aware of at the minute myself but of course this code may
end up running on some enterprise distribution with an extended support
time with hardware that isn't even on the drawing board now.

> > I had been intending to just combine all the bits from affinitly levels
> > above the CPU number into a single number until we know what to do with
> > them individually.  We shouldn't just ignore them.

> I agree we shouldn't ignore aff3 if someone is already using it.

> I'm not sure how combining them into a single number helps with topology.
> We already started out with a cpuid, no?

It will at least ensure that all clusters get assigned a unique ID and
we don't end up discarding some of the information and coming out with
two identically numbered clusters which then have identically numbered
CPUs inside of them which doesn't seem clever.

When I was looking at this it wasn't sufficiently clear to me that the
cluster clustering would be well modelled by sockets as the scheduler
currently assumes them, nor what to do with additional levels of that
(the DT binding allows for infinite levels).  Punting and just putting
all clusters at the same level avoids active bugs and seems fairly
conservative.

> Perhaps we should just add a new 'socket_id' and that will accommodate
> all cases (up to aff3).

Not in the non-MT case where we've got two levels above the cluster ID
in affinity level 1 unless we just combine 2 and 3 (which would be
reasonable enough of course).

--7v9iR3M+zmFtWrmF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWAXAAAoJELSic+t+oim9NZsP/1Ba3SPl/LRNVu+TfhCz4SbI
kpiJxO7i9ixvCj/1S3gBbBOrwyPDEO4388Dasen+FAEq4WroXS68JYZSENK/8O5g
TDabI7qNb0pdFpWa9CsG8ATVH+a+2Sv3WrOh3kKpgfaBr9O817mK5SBiDGysQ/5z
Q+rGbpX1jGOqNB6Xh6mUy/datJqzXz4r7CKWP8vQwXf7Xt0bbI48fyos1TJ1LpHv
hcVA4uAowgtaKbLU+aB+bFMdOPk6zTtOlXPsmyxS1PlO7rWM4miN7/xNr3FxiXmH
4iCdWiKBbwdWSRQdPgAgTjAPNxjxn3JNNmmwX/LZrRnPgBbPIjpc+MB6ldYiIGcO
loVMxoVexGQSkU3EK+ljb/Dgx4Mvr043S9z7Z9yGhNmbg01sTvVclPZBLTG4fIH5
GaQauJ0Ndsox9eOjy+wQYYeFaev+en30lE3OmbYMyZ0voGyBGXWfU9MdkYg8GITf
k24n/YJSA77rDCDwgKADftO8Q3uDX2DwCnF5KhsS4E4/rfwsaa5e4etoHlhctu0J
uPpsQ2a/3v7Wz13jTmPHBeVOs5bSgouybSKsnTFn6RPl1Ozi4HyJ/HauzfrWIW8K
YLepTNsKpnfA+8Im5wzN0QxDeMmXDY9t37ZKqtXHETfcjct4KlQrwwAMWabblGCx
t7AguNAnLUB98OL4RKjO
=3a6q
-----END PGP SIGNATURE-----

--7v9iR3M+zmFtWrmF--
