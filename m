Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbaH1Asl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 20:48:41 -0400
Received: from ozlabs.org ([103.22.144.67]:47857 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756867AbaH1Asj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 20:48:39 -0400
Date: Thu, 28 Aug 2014 10:48:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: Re: linux-next: Tree for Aug 27
Message-ID: <20140828104830.4447c5e5@canb.auug.org.au>
In-Reply-To: <20140827235809.GA9598@roeck-us.net>
References: <20140827161021.298aede6@canb.auug.org.au>
	<20140827235809.GA9598@roeck-us.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/xTCINZ9.ni3mi9YI3z7oHt3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xTCINZ9.ni3mi9YI3z7oHt3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 27 Aug 2014 16:58:09 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>
> I see a large number of build failures with this kernel.
>=20
> drivers/base/dma-mapping.c: In function 'dma_common_contiguous_remap':
> drivers/base/dma-mapping.c:294:2: error: implicit declaration of function
> 'dma_common_pages_remap' [-Werror=3Dimplicit-function-declaration]
> drivers/base/dma-mapping.c:294:6: warning: assignment makes pointer from =
integer
> without a cast [enabled by default]
> drivers/base/dma-mapping.c: At top level:
> drivers/base/dma-mapping.c:305:7: error: conflicting types for
> 'dma_common_pages_remap'
> drivers/base/dma-mapping.c:294:8: note: previous implicit declaration of
> 'dma_common_pages_remap' was here
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/base/dma-mapping.o] Error 1

Caused by commit fa44abcad042 ("common: dma-mapping: introduce common
remapping functions") from the akpm-current tree.  I will attempt to
revert that commit today, but I may need to also revert the following 2
commits as well:

arm: use genalloc for the atomic pool
arm64: add atomic pool for non-coherent and CMA allocations

though I am not sure.  Hopefully someone will let me know in the next
few hours ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/xTCINZ9.ni3mi9YI3z7oHt3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT/nxjAAoJEMDTa8Ir7ZwV00QP/jLkgxLtKf7cUVZ2xrclc7Ne
UeENBE0SWuPIbKMdd08jDctcBGl2AXU5LhjSq+P7aIuA2xM5BVzPI8siP3p3BbgK
aA4fQLLMttQ5r/GDqk0s9hWL/VNn3NvwsUSryBFIibLJIlqXsc2Ufii1QJgWZspN
k9ab26Ckvo95uMfdvYSQKafUXASiNjFkUuElKH3GLl5Gpsxbz4gaZQmI3LMV8xmb
e4EZhUPsUAkECIuW4iz+YpheX3m7hGPud6NWi5GvmQcW9xrr3C09PreZcpVR/0s5
zGJBAIVXu8rxoW4yaHZJm9DpElR/nz7ywzRRS1LvlewBvjPqNbRbm7jpVzG0ukMC
yJ4UBNjtRwBdUtC7Mn7IC73QilJFei5cbNKMKSm21gAhnihCY4VO2c31bXe0scvj
ZFrslwDR1NrWFj1N7CjnpnexQYxNckEnBZcBAPCkEcWtJ3jRhpRpgRBFgqwlMl/V
Lv1r6ZE3y3jDTM3PQbilWwCRCqLDuQWfBFL+EWDkom8/dnlwqbOxEvZg9RQGaFkG
gfjM5MvlKFlBzGLNAVhgMcaBSIJ3utDt+Wi8QrrnpKrop+b6luA3sIQJRccrZlMP
DnQCx9FZe5B5xlYwdeQC9UE1AggbMTllgyUW6Lb5Zxm9vSlsPL3L4DRm/7DhSrBr
6Qk4H+uVzsdAlbaBsYkR
=y+q/
-----END PGP SIGNATURE-----

--Sig_/xTCINZ9.ni3mi9YI3z7oHt3--
