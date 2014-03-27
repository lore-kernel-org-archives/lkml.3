Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbaC0NGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 09:06:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49424 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbaC0NGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 09:06:16 -0400
Date: Thu, 27 Mar 2014 13:05:29 +0000
From: Mark Brown <broonie@kernel.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Nicolin Chen'" <Guangyu.Chen@freescale.com>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140327130529.GK30768@sirena.org.uk>
References: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6E958E@AcuExch.aculab.com>
 <20140327011424.GB30768@sirena.org.uk>
 <063D6719AE5E284EB5DD2968C1650D6D0F6EA538@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huBJOJF9BsF479P6"
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6EA538@AcuExch.aculab.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.45.252.252
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huBJOJF9BsF479P6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 27, 2014 at 09:41:20AM +0000, David Laight wrote:
> From: Mark Brown

> > The trace is already conditional?  I'd also expect to see the driver
> > only acknowledging sources it knows about and only reporting that the
> > interrupt was handled if it saw one of them - right now all interrupts
> > are unconditionally acknowleged.

> The traces are separately conditional on their own bits.
> That is a lot of checks that will normally be false.

Oh, I see what you mean.  I'm not sure that level of optimisation is
worth it, the overhead of taking an interrupt in the first place is
going to dwarf the optimisation and the indentation probably won't help
writing clear messages.

> Also the driver may need to clear all the active interrupt
> bits in order to make the IRQ go away.
> It should trace that bits it doesn't expect to be set though.

The interrupt core will eventually take care of it if the interrupt is
left screaming with nothing handling it (and provide diagnostics).  I
would *hope* that this is only happening for unmasked interrupt sources
we explicitly unmask anyway, we really don't want interrupts on FIFO
level changes.

--huBJOJF9BsF479P6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTNCIWAAoJELSic+t+oim9N08P/RbG8PG42Ry0SGuTIf+g8zrJ
5cxkqJM+V71MzkQLkKEWINMJ/Ac4tg42pwr9EAuHA+7pQ9HBEjHk/LDwBTuUvXea
1aIugHlrrXHEdQs2Itvl+8w73tkgEpazZbjJ6LgskS3j4wDPvcauAU07e2E6nT7O
18fQxFeLyFrjzuGAzsd8nPyrl1DpxlhgpYWTtijRNQp1014d+Er+LcEa8HIuGh1I
Sco1bk7FqSNRt2Vrp7lBpu6qcQzFO4JwoWG9IWqURHpZ9oWPCWYo6K1GGJIDUl79
P3OUtfMxET7COc62dYwxnJwWW0mGwojISXphef919xVeV6VhxQ7RxHjfBUszZY9x
wRZqGPHW0mXP/FNsPY3D0briew7mTLyBH8iI9IivwUwtQBmC933FRFLyMTwjJG4K
l8E+ge5u0TmwFiLvHviinjvAy7peDRL5cWqxb/fq+RLpmqZCjbOVCd7jryoOqMIl
oRDgJnk7tRoxjLUmagWzCja+OxRkR6eu8+47LZM10AbPG3aUG0IwmabSPcnD5RS6
bbFkFcmGUGxMDJ6wxfkOFbnqCltjX4vFv8mh72fYMjRFVtkxFozRh+m3oeNWb2Kc
PeelqzCYCVtLJ7WYxBQ1X0eJ3BBqSke+/Mcfu8XzIeHF07CtYSH6uzhl5JdZLM2G
cmV+eaaHub+Vb9QOYjLV
=Xkew
-----END PGP SIGNATURE-----

--huBJOJF9BsF479P6--
