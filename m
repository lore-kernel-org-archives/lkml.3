Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaKBW3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 17:29:32 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50079 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbaKBW3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 17:29:31 -0500
Message-ID: <5456AFEA.6000507@free-electrons.com>
Date: Sun, 02 Nov 2014 19:27:54 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, hch@infradead.org, axboe@fb.com,
        dedekind1@gmail.com
CC: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: Block: Add blk-mq support
References: <1414933255-3795-1-git-send-email-richard@nod.at> <5456A787.5060104@free-electrons.com> <5456AE72.1010409@nod.at>
In-Reply-To: <5456AE72.1010409@nod.at>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Qvr84SANbplAjMT5TTSU366g6UNl3g592"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Qvr84SANbplAjMT5TTSU366g6UNl3g592
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/02/2014 07:21 PM, Richard Weinberger wrote:
> Ezequiel,
>=20
> Am 02.11.2014 um 22:52 schrieb Ezequiel Garcia:
>> Maybe you can explain a bit better what's this all about?
>=20
> In short, blk-mq is the future and the current blk interface will be le=
gacy. :-)
> Christoph asked me to convert the MTD block drivers to blk-mq.
>=20

Ah, OK. That makes sense then.

>> Both the commit that introduces blk-mq and the paper on it talk about
>> high IOPS devices, multi-core, NUMA systems. I'm not sure this is the
>> case for UBI-based devices.
>>
>> Probably some numbers would help us decide. Does the patch increases t=
he
>> dynamic memory footprint? Is there any performance benefit?
>=20
> I did a very rough micro benchmark:
>=20
> root@(none):~# dd if=3D/dev/ubiblock0_0 of=3D/dev/null bs=3D1M
> 121+1 records in
> 121+1 records out
> 127420416 bytes (127 MB) copied, 1.59056 s, 80.1 MB/s
>=20
> vs.
>=20
> root@(none):~# dd if=3D/dev/ubiblock0_0 of=3D/dev/null bs=3D1M
> 121+1 records in
> 121+1 records out
> 127420416 bytes (127 MB) copied, 0.916117 s, 139 MB/s
>=20
> So, yes there is a performance gain.
>=20

Wow. Where did you run this and on top of what storage device?

I'm still interested in the memory footprint, UBI is already heavy enough=
=2E

>> I kind of like the negative diffstat, but the code doesn't look cleane=
r
>> or simpler.
>>
>> In other words, we need a good reason before we agree on making this
>> "zen style" driver more complex.
>=20
> After reading my patch again I think we could move ubiblock_read_to_sg(=
)
> to kapi.c or io.c. It is rather generic and maybe we can tun more UBI u=
sers to
> scattergather such that less vmalloc()s are needed.
>=20
> This would also make the diffstat nicer...
>=20

Yes, any additional effort to make the current patch any simpler would
be great. In its current form it seems rather cumbersome to me.

If you can re-submit something better and put a more verbose commit log,
I'd really appreciate it :)
--=20
Ezequiel Garc=EDa, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com


--Qvr84SANbplAjMT5TTSU366g6UNl3g592
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUVq/qAAoJEIOKbhOEIHKiipIP/iYINobyYChU2L5xbeTBpDy+
3x1tICiCooQI8hdqBsQ5X7AMGZo5UzuHeXfxHOWZ7vFwWgeh0su77I9+Xjw4mQ3a
nNXGxbmS35ySWnaica44Mj5nAKg6T6D0WEMkHYHInjbiz8IyQh0NCVQTTzwg7nLF
beCvjTgftEABvaMGsTZRcor0i9cOGwZzGuktD0V1dwX5o6M2eh36Obg85uXhABzR
n9VkC2DJqRKsoRMLNLHcH8y2s6gOPybIDp4c9wY7nbJcf4yNTcxNZs09dho4AICq
KS2WKQW6A8mtJNx4YwYGciKWkYZCwJ8c6Vyoq/hTMeGcmqrd9lZ96YwRUo6kl//h
aEA4yAAMgjYtxVj9jm5ykKAgxy3wo2eq7fw2c2hyft1VPkrho5tDZc4/uN1Y670g
DBx6rc+M3Cehu+OJ+zb4CclITJ0Xr0ehdJbPYhjLUkedzzc59Z2S639Op8M9L1T+
NWTRKX1QNP4GrZo9pyegyi9c00n35h7N3Bzki5oO77AeRfZ+1PKCwOl3dWPenCA3
Uk8KH4ezgl/V1E+gkA9o93F54cR7lgNu8bndv3QSYdADHXV3zb5MlM5rwbvEdftv
mjOeUu0L0cOhiiZe5Q3ObPqFbq0HBJFhNj1trDCgLOGTzT5/MosOoms+kvdmu/GH
6Z/HHUL8GxKQFxWcop4Z
=QLe7
-----END PGP SIGNATURE-----

--Qvr84SANbplAjMT5TTSU366g6UNl3g592--
