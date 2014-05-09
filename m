Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbaEIN6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 09:58:45 -0400
Received: from [217.156.133.130] ([217.156.133.130]:15493 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932271AbaEIN6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 09:58:42 -0400
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Fri, 09 May 2014 14:58:41 +0100
Message-ID: <536CDF09.9030200@imgtec.com>
Date: Fri, 9 May 2014 14:58:33 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>, <linux-metag@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] metag: fix memory barriers
References: <alpine.LRH.2.02.1405081546110.4346@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1405081546110.4346@file01.intranet.prod.int.rdu2.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="Efc6jWFu2gcLRXLclHtVsiMj9OHFuNmh4"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: 2110538f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Efc6jWFu2gcLRXLclHtVsiMj9OHFuNmh4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/05/14 20:51, Mikulas Patocka wrote:
> Volatile access doesn't really imply the compiler barrier. Volatile acc=
ess
> is only ordered with respect to other volatile accesses, it isn't order=
ed
> with respect to general memory accesses. Gcc may reorder memory accesse=
s
> around volatile access, as we can see in this simple example (if we
> compile it with optimization, both increments of *b will be collapsed t=
o
> just one):
>=20
> void fn(volatile int *a, long *b)
> {
> 	(*b)++;
> 	*a =3D 10;
> 	(*b)++;
> }
>=20
> Consequently, we need the compiler barrier after a write to the volatil=
e
> variable, to make sure that the compiler doesn't reorder the volatile
> write with something else.
>=20
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

Applied for v3.15, thanks!

Cheers
James

>=20
> ---
>  arch/metag/include/asm/barrier.h |    3 +++
>  1 file changed, 3 insertions(+)
>=20
> Index: linux-3.15-rc4/arch/metag/include/asm/barrier.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-3.15-rc4.orig/arch/metag/include/asm/barrier.h	2014-05-08 16:=
23:17.000000000 +0200
> +++ linux-3.15-rc4/arch/metag/include/asm/barrier.h	2014-05-08 16:24:01=
=2E000000000 +0200
> @@ -15,6 +15,7 @@ static inline void wr_fence(void)
>  	volatile int *flushptr =3D (volatile int *) LINSYSEVENT_WR_FENCE;
>  	barrier();
>  	*flushptr =3D 0;
> +	barrier();
>  }
> =20
>  #else /* CONFIG_METAG_META21 */
> @@ -35,6 +36,7 @@ static inline void wr_fence(void)
>  	*flushptr =3D 0;
>  	*flushptr =3D 0;
>  	*flushptr =3D 0;
> +	barrier();
>  }
> =20
>  #endif /* !CONFIG_METAG_META21 */
> @@ -68,6 +70,7 @@ static inline void fence(void)
>  	volatile int *flushptr =3D (volatile int *) LINSYSEVENT_WR_ATOMIC_UNL=
OCK;
>  	barrier();
>  	*flushptr =3D 0;
> +	barrier();
>  }
>  #define smp_mb()        fence()
>  #define smp_rmb()       fence()
>=20


--Efc6jWFu2gcLRXLclHtVsiMj9OHFuNmh4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTbN8QAAoJEGwLaZPeOHZ6nzUP/RolDjwpFi3Rh2lPBw65aYcE
uyJX3jNCMKgbm4zk+fybGyVd39VItVy57nTDys2i128nXi46ecHIbdW53QcMDOzK
N2pxtwApsJg/6D8jqCGNBPwyKjSu99njEf9A1Bwjof1VR4H60IW6d9xI/q1dExDW
le/8C/5DcrlHHeJ6fiBB+gxC6xHV9DTiBz5wtDTbWPbR2/tCx7pg5E27/K3S/5ad
LY88EYsf+lH2jvUKMVz5Kgiwa/jd+IR7WT/e94PXhcVi+aYzF6u4BF4GlX3Zo1yn
bsVz/JhuZ6E8kycD8CdA7qTIbTRSj4cHn/If52rO4/YoK7ABdYG0dFo6Zs+ZyttS
44hB6rN42TAG/RZt9/GuCuN10l/zWY4xNhc7e23ICkWaW7XYA84TQQ2BcsfsjO/+
vYznfNhkAvdsesFGje8N2z5UUKCFz6M041hXlXaW3vA9ocDPyb9F85qDq6R8/CE7
UVrHpmDSMiDrLdUbsnSPvnLumObu8vaqE4jWYGPxCQSp3ORl/wZmfOJVTPJ3zN9a
+GxQAbnQv2GeQlxE/FOJ6zoGnQN6lwXUf2sWql8/aS+ZXnoFHwBeYGpUwXjDaYpI
sNW9Mo6CY4svcXg7b5GAEWtDS8ByHnnMjYaj/BkKxw+MX9BqINrEZjQoBsBsuyHV
d9wnP2qubgKiIpGvPWW/
=vBp7
-----END PGP SIGNATURE-----

--Efc6jWFu2gcLRXLclHtVsiMj9OHFuNmh4--
