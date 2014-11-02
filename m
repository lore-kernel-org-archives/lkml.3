Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaKBWVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 17:21:55 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaKBWVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 17:21:50 -0500
Message-ID: <5456AE72.1010409@nod.at>
Date: Sun, 02 Nov 2014 23:21:38 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>, hch@infradead.org,
        axboe@fb.com, dedekind1@gmail.com
CC: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: Block: Add blk-mq support
References: <1414933255-3795-1-git-send-email-richard@nod.at> <5456A787.5060104@free-electrons.com>
In-Reply-To: <5456A787.5060104@free-electrons.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Wllf5jDd0kOxafP5opDeAcsL8HKenMPCa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Wllf5jDd0kOxafP5opDeAcsL8HKenMPCa
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Ezequiel,

Am 02.11.2014 um 22:52 schrieb Ezequiel Garcia:
> Maybe you can explain a bit better what's this all about?

In short, blk-mq is the future and the current blk interface will be lega=
cy. :-)
Christoph asked me to convert the MTD block drivers to blk-mq.

> Both the commit that introduces blk-mq and the paper on it talk about
> high IOPS devices, multi-core, NUMA systems. I'm not sure this is the
> case for UBI-based devices.
>=20
> Probably some numbers would help us decide. Does the patch increases th=
e
> dynamic memory footprint? Is there any performance benefit?

I did a very rough micro benchmark:

root@(none):~# dd if=3D/dev/ubiblock0_0 of=3D/dev/null bs=3D1M
121+1 records in
121+1 records out
127420416 bytes (127 MB) copied, 1.59056 s, 80.1 MB/s

vs.

root@(none):~# dd if=3D/dev/ubiblock0_0 of=3D/dev/null bs=3D1M
121+1 records in
121+1 records out
127420416 bytes (127 MB) copied, 0.916117 s, 139 MB/s

So, yes there is a performance gain.

> I kind of like the negative diffstat, but the code doesn't look cleaner=

> or simpler.
>=20
> In other words, we need a good reason before we agree on making this
> "zen style" driver more complex.

After reading my patch again I think we could move ubiblock_read_to_sg()
to kapi.c or io.c. It is rather generic and maybe we can tun more UBI use=
rs to
scattergather such that less vmalloc()s are needed.

This would also make the diffstat nicer...

Thanks,
//richard


--Wllf5jDd0kOxafP5opDeAcsL8HKenMPCa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUVq54AAoJEPmeIjfg4UaaUEwP/ApyIx496TZGiSTQpPKRiAgC
XYnhlYqHiZaGGbGNZBmATGyB+wiH4Z4JvB0yh5xXemVGG+FRsWGhJ2vwocbnBHYN
Yy8MAphbybWc9lQmSfX/gBxISwxePaK5hFfcAVX7YYzm/P6dYPyIgZHpOFMDX6+/
/2nrZZGdsETi0okjc3eKYYwFf+TY0MrA/kDfQM08/dlUj9zoZirhNicaYfg1xiqt
h765OdQSu1scXcUjZBEuaMEsk13aOyviII98Ij/JW5rkS3dyADM2W2p2RW1HIowQ
SxJUF+RZcxKrN1r6itHeVr6rp5L/YY1Toi1CHU8zynByEqlQM43f3ACwt63kmbph
WvQDq7WlfzOU81MaOclGQE/Y9XO34rU+DPtTYlluZOvqQ0Mkonm1xIF3yf6jofhY
Cn/aRCj9wLqmHw9xDDlJ9rBpPIBA66rWvPhHo59dVL7BqcQsVlNpqke2mZKvfWMX
VBu+fbSRizFU+PAA1HYhu1Ncdr1lM0/R8J+gAyzzEWgq/5N97h7CiA+FY4a2xhMu
RKGpSmTracBx5kTb1dBARE1j9CQBli3o/x2U44U0Wrlv9FrLag7321P0KdYN+Uyu
uYifR24BFw3VGWTBH6W39c5Gx9A4VY6Pj5T9v31A3wZN1EzIRWPINqoLTb1Sq29E
q31G2dHoXO0YGtumLkix
=gErV
-----END PGP SIGNATURE-----

--Wllf5jDd0kOxafP5opDeAcsL8HKenMPCa--
