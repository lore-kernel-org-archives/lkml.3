Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbaDWKhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:37:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42516 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaDWKhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:37:12 -0400
Date: Wed, 23 Apr 2014 11:36:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Zi Shen Lim <zlim@broadcom.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20140423103648.GM12304@sirena.org.uk>
References: <1398217214-12204-1-git-send-email-zlim@broadcom.com>
 <1398217214-12204-3-git-send-email-zlim@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GCRsFJgCXLwWUB5N"
Content-Disposition: inline
In-Reply-To: <1398217214-12204-3-git-send-email-zlim@broadcom.com>
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


--GCRsFJgCXLwWUB5N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2014 at 06:40:14PM -0700, Zi Shen Lim wrote:

> +		/* Multiprocessor system */
> +		if (mpidr & MPIDR_MT_BITMASK) {
> +			/* Multi-threads per core */
> +			cpuid_topo->thread_id  =3D MPIDR_AFFINITY_LEVEL(mpidr, 0);
> +			cpuid_topo->core_id    =3D MPIDR_AFFINITY_LEVEL(mpidr, 1);
> +			cpuid_topo->cluster_id =3D MPIDR_AFFINITY_LEVEL(mpidr, 2);
> +		} else {
> +			/* Single-thread per core */
> +			cpuid_topo->thread_id  =3D -1;
> +			cpuid_topo->core_id    =3D MPIDR_AFFINITY_LEVEL(mpidr, 0);
> +			cpuid_topo->cluster_id =3D MPIDR_AFFINITY_LEVEL(mpidr, 1);
> +		}
> +	}

This means that we ignore affinity level 3 and on non-MT cores we ignore
affinity level 2.  That means that if it runs on some system where we do
have multiple levels of clustering (for example some future multi socket
server) or if for some reason the hardware engineers have decided to use
one of the higher affinity levels then we will incorrectly report cores
=66rom several clusters as being part of a single cluster.

I had been intending to just combine all the bits from affinitly levels
above the CPU number into a single number until we know what to do with
them individually.  We shouldn't just ignore them.

> +	pr_info("CPU%u: cluster %d core %d thread %d mpidr %llx\n",
> +		cpuid, cpuid_topo->cluster_id, cpuid_topo->core_id,
> +		cpuid_topo->thread_id, mpidr);
> +

Catalin or Lorenzo asked for stuff like that to be taken out.

--GCRsFJgCXLwWUB5N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTV5e9AAoJELSic+t+oim9AA8P/jW2ZXOPa/H+KV6eW77QKYah
cKHwkdSqXuLL1xnQl1nqK7SyeN8w8ItyjFzBN0rrRNtce7mC3cVVQMecWPAv8mo3
OO9j5NOtUWRHXUJICyhufeDb7pt5grRgGgbHytB73AWI6/8Pyu4dkvbaYIvYlxAp
2vF4XZwhnvmzBx8LW+LriqgL2KSG4bY++e+W+fsQUYZjCpO4/QA1o0YoyT9dffND
sI1OCo/dQlztbr7GQSKAcotIRjNkOarqqmH7GqrIguF1XX+qfljA4FcGOlxW8I39
kNf4IEaIYJDcwYHwt09ymjIeNlTrzCXuWzEKMG8EuwdVZfEl8fhmoXBu31k6WpYm
IsTx/M4GrFCshexofmlLPYich24U5D15u+EIXKm37tVw0XCqKutTe1NvrMKwwgCl
5YCdWZubvPHjYGUv7jHceAlhu/fMooJ1fKgl7HVNy55QdlRjB8L/ZQ/fK0JX5dq9
KvnCsa73vptItWs9bnDbmswr2dQEADiIm/IP8QfT+xNIKAKIKAfJ75LgJPZFiuJr
LXTKJSg042RQvQiC4iS4M+hoi+CuETCjo0P9o2fglJFsxX60GWtyha4bSiWFHFhK
D5jq1mmpf+E2wwJW4lx0WwXeEtjWG4edjz4kcssdp/YtGqiDo1h4Y7+aN2t6DYaq
CbHo8v9lZn0xoMxhWevv
=ACTC
-----END PGP SIGNATURE-----

--GCRsFJgCXLwWUB5N--
