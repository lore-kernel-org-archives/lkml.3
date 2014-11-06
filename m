Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaKFIg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:36:29 -0500
Received: from ozlabs.org ([103.22.144.67]:43075 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaKFIg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:36:27 -0500
Date: Thu, 6 Nov 2014 19:36:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-ID: <20141106193618.461c3ae7@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/rB/JSETQz6wd1zX.xbBNuJ/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rB/JSETQz6wd1zX.xbBNuJ/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (sparc defconfig)
failed like this:

mm/slab.c: In function 'slab_alloc':
mm/slab.c:3260:4: error: implicit declaration of function 'slab_free' [-Wer=
ror=3Dimplicit-function-declaration]
    slab_free(cachep, objp);
    ^
mm/slab.c: At top level:
mm/slab.c:3534:29: warning: conflicting types for 'slab_free'
 static __always_inline void slab_free(struct kmem_cache *cachep, void *obj=
p)
                             ^
mm/slab.c:3534:29: error: static declaration of 'slab_free' follows non-sta=
tic declaration
mm/slab.c:3260:4: note: previous implicit declaration of 'slab_free' was he=
re
    slab_free(cachep, objp);
    ^

I am not sure what caused this, but it is something in the akpm-current
or akpm trees (possibly interacting with something else).

I have just left this for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/rB/JSETQz6wd1zX.xbBNuJ/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWzMIAAoJEMDTa8Ir7ZwVFLIP/0GqmhaKjUq6uEjnnqawAbPY
PwMmKR4RK8H7umY54xvs/efL2NW16lXkq5TDtcORg4kBGO2diOevqytOD0V86UvG
XIbPFdX4ybbZmrCuy6Ddtw5cq2Lb32UgEd5CHbUSdVWlV0fwBQYj8NwxcxME9ahp
LYxK8Cks1BqjHzf8910jKivMDVIYARxB59aD3/saSGG5dd0REztcg5uv4mIe7MGH
GKwXlxsibqL7NcDeI1wNCvc8lna8bVRkFn7wHPYnwOXyTkezoKrdC/kzQvVnquVw
idC+8JfPF/3b69GJAXQyMvkZ6TYcYyR3iXhWmmzjd39ey+W5GoJlu+LUMhIIZmYG
9gNC0IazVKT9EvkC6NtbCA/L+/t1V1KnpiBc71tnmZcXbxI2DpEYAAUfoY5GM4Gr
vahKm5eh9ESytXhCDo5u1myaWNMC4EOjXQCi7N+xtxoqIndunekQf/FXRjLymIIQ
vTdTkcTq+qBggTw8sd9KVUOKLKyKHQOjuW11pCatt+R33W6fSNbmO2KoPXlKhNk2
CkE5+4zFi1yWxszlwr3fr7PDyn8tXpEI+eYcqad8zzuERU3o/uH/xnL4Ik1StX7x
ppuuR8evC+oKtdvjBZBaefh417vr10EAPhWSzQbfMkaTNLq5+8Lw8oR/oSk4mkyl
g+pXnDiFYDoORlD2VSON
=qgLW
-----END PGP SIGNATURE-----

--Sig_/rB/JSETQz6wd1zX.xbBNuJ/--
