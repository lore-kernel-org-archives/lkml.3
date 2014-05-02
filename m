Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaEBUFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:05:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55575 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaEBUE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:04:59 -0400
Date: Fri, 2 May 2014 13:04:33 -0700
From: Mark Brown <broonie@kernel.org>
To: Zi Shen Lim <zlim@broadcom.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140502200433.GX3245@sirena.org.uk>
References: <1398814573-27389-1-git-send-email-zlim@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zppk1xGhJD+Z6rqE"
Content-Disposition: inline
In-Reply-To: <1398814573-27389-1-git-send-email-zlim@broadcom.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3] arm64: topology: add MPIDR-based detection
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zppk1xGhJD+Z6rqE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 04:36:13PM -0700, Zi Shen Lim wrote:

This looks good to me, modulo a couple of really tiny nitpicks.

Reviwed-by: Mark Brown <broonie@linaro.org>

I'm just doing some brief testing now, I'll repost my series with this
and Lorenzo's changes included shortly assuming no issues.

>  	if (cpuid_topo->cluster_id =3D=3D -1) {
> -		/*
> -		 * DT does not contain topology information for this cpu.
> -		 */
> +		/* No topology information for this cpu ?! */
>  		pr_debug("CPU%u: No topology information configured\n", cpuid);
>  		return;
>  	}

Now that we have MPIDR support (well, will with this patch) this should
probably be raised to a pr_err() since we've got ourselves confused
somehow if it ever happens - we should always be able to get topology
=66rom MPIDR.  I'll tweak this when I repost.

> +	pr_debug("CPU%u: cluster %d core %d thread %d mpidr %llx\n",
> +		 cpuid, cpuid_topo->cluster_id, cpuid_topo->core_id,
> +		 cpuid_topo->thread_id, mpidr);

I do wonder if we should print this either unconditionally or not at
all (rather than only if using MPIDR), I know Catalin and/or Lorenzo
weren't keen on noise but it is just at debug level and it's nice and
easy to refer to.

--Zppk1xGhJD+Z6rqE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTY/pOAAoJELSic+t+oim9JBgP/1iYjzLoStbXnJq2E98LIkm9
BMzrA7t93hb9hq8rYlKmjIpDo8SYk0cTZC1AlSF/LsVZnbpKW4zpqd9VvRkuDOqc
g0S6Zf1IKUT0vbHgz7ULd9KEjvDIxoVHmJngQ7kmkxDPlsNBCavmkKhvvjcQPZUO
8x2tMT+EyhmwkX5U0V3m1XENvX3/aP2ofySATqjzyKt78zeaGGBZovwiTVPw3VtW
8sDdKGoKQxlA0YJwNevtsCBqH031h6S3PaBr4g3Yc9EfWWgcUCPLR2aGUGiRoBcb
AL6p0yqordD3jLAdD90ot7vpLjcgPj59ETaV7NN8IxIhdmAzB0qmcSadUnQewzmb
Qb2zWbY0LeYJVACU8DGsNykEA7PvaEL6tgx14mM1QOO4eRcSW3uGSseUb0rR2bCm
poTGEfqjUexC5GPLdBJtkVNXhwiPCvuGHLr7PiZp4XBfuLZtrPqXmmeP1+vWlQ1P
xPwOd1cKUMxyeosk4yA2Cnm5j+8AjmlGxa0jGrPJaY+4fJzV7oWEQvKSX73IQp3B
r0Jn5I7DQfmvLCu1dP6WEztA4qCslULcoU/1H3xa9Tro096a6oqI9nNbV6RHBbtq
F2tDYJivrCOAxbUxEQ1AjkP8s31AdjjDXm2vqf0JwEqUk6zPMQES/ZAYwIaI8h31
tGqWKXg1cTxHseSnTziP
=8wUB
-----END PGP SIGNATURE-----

--Zppk1xGhJD+Z6rqE--
