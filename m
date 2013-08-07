Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539Ab3HGX1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:27:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab3HGX1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:27:20 -0400
Date: Thu, 8 Aug 2013 09:27:07 +1000
From: NeilBrown <neilb@suse.de>
To: Ken Steele <ken@tilera.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] RAID: add tilegx SIMD implementation of raid6
Message-ID: <20130808092707.7149ee90@notabene.brown>
In-Reply-To: <201308072040.r77Kevx4016119@farm-0012.internal.tilera.com>
References: <201308072040.r77Kevx4016119@farm-0012.internal.tilera.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CAegtB=VD9O6G_z0EQE1w2q"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CAegtB=VD9O6G_z0EQE1w2q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Aug 2013 12:39:56 -0400 Ken Steele <ken@tilera.com> wrote:

> This change adds TILE-Gx SIMD instructions to the software raid
> (md), modeling the Altivec implementation. This is only for Syndrome
> generation; there is more that could be done to improve recovery,
> as in the recent Intel SSE3 recovery implementation.
>=20
> The code unrolls 8 times; this turns out to be the best on tilegx
> hardware among the set 1, 2, 4, 8 or 16.  The code reads one
> cache-line of data from each disk, stores P and Q then goes to the
> next cache-line.
>=20
> The test code in sys/linux/lib/raid6/test reports 2008 MB/s data
> read rate for syndrome generation using 18 disks (16 data and 2
> parity). It was 1512 MB/s before this SIMD optimizations. This is
> running on 1 core with all the data in cache.
>=20
> This is based on the paper The Mathematics of RAID-6.
> (http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf).
>=20
> Signed-off-by: Ken Steele <ken@tilera.com>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Thanks.  Looks credible and you've obviously tested it so I've added it to =
my
queue for the next merge window.

One tiny little change I made:

>  clean:
>  	rm -f *.o *.a mktables mktables.c *.uc int*.c altivec*.c tables.c raid6=
test
> +	rm tilegx*.c

I made that "rm -f" for consistency.

Thanks,
NeilBrown


--Sig_/CAegtB=VD9O6G_z0EQE1w2q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgLXyznsnt1WYoG5AQK3uA/7Biq7BxvoTdaAkqIBO8dCgmZteMoX9bSf
IPy1le3rlHF5T3jVRglFZatR8pXtZBKKBG3tqiOUhxp+9emfktKCOjlSJ5xAo83G
1iAU3TLQirPKf8L+luafXIanJdIQjjwA1bVaHBkymKBxcGgzF5/HLA0TT7E/a5T4
wW4S1JtY3cqMb9tY/NjXyz13ctD0AK0r1uuOlgZmQuTek63ja7JFkzyps15seVcJ
BBkQ+l6K2WDLIDFY/JqL6hsTDOgrbTzquDMDqW7PpQA6T2hESLKtjHk4ncVOWJ3a
sSfnpOuUIbH07oWrcNdKJZ0kb313rcY5KiNV0Els9E3UKjYsgD50KIXhNbMeBnDF
hmhWPUtZezsQni7g2J182l3WZmsGOCu+CmGFZ1ffZT62mhViDRpz5YNGMByzziFu
ftzVIR79afwex2BDmV90Epm47kw4bNMalYSPv0/aOc9KfX+T4XYO1nEGw2pOVtYQ
tUWCuauszmtgAeuKEYmTK1SzoyqxtFw/sOfkGLHjij1bpfg9Ewfl62aa8FR+36zT
vUyTbzqzol+4E0fxydmXPOvKUCloYOyBraDpwpHYwaQX+UFCp3R6sTwrkVTlw3RA
XTwxHEhSxJY6OL/lO8EBdfd8LIyHLh+qLwewQGia7YBZ1p9bozLQXSj9SmoUSgUj
3vToOqoyDTQ=
=m4Y8
-----END PGP SIGNATURE-----

--Sig_/CAegtB=VD9O6G_z0EQE1w2q--
