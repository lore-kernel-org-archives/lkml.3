Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaIWE5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:57:19 -0400
Received: from ozlabs.org ([103.22.144.67]:45152 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaIWE5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:57:17 -0400
Date: Tue, 23 Sep 2014 14:57:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the tiny tree
Message-ID: <20140923145711.5c1ca775@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/sJTJKn5x2GuFqwRuZYNwNpB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sJTJKn5x2GuFqwRuZYNwNpB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Josh,

After merging the tiny tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

mm/built-in.o: In function `.isolate_migratepages_range':
(.text+0x2fbd8): undefined reference to `.balloon_page_isolate'
mm/built-in.o: In function `.putback_movable_pages':
(.text+0x713c4): undefined reference to `.balloon_page_putback'
mm/built-in.o: In function `.migrate_pages':
(.text+0x72a00): undefined reference to `.balloon_page_migrate'

Caused by commit b37a3fee8450 ("mm: Disable mm/balloon_compaction.c
completely when !CONFIG_VIRTIO_BALLOON").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/sJTJKn5x2GuFqwRuZYNwNpB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUIP2rAAoJEMDTa8Ir7ZwV8bIP/1T/So44K6wcjoUDEzOnIgsH
djiW9wS7M5mks2tbv2OL/hP1WDQXs2UtWypJ7qAkvxOvI9wckoKHzHF3fk85aZVC
KTb5yMZmF2qqBedU5lYw/8aUIeAIx47PbrBHKoWxETDGE7ADx0fCRtm8p1d7Lhjx
JM85eYD0IG1BBQK7kh+7+Pn4m9MBk71+lofFLqppeGo6Kcab6ud9Pf5oPjag1W3y
4k0bnb/nYT3xSgtOcfBwMtmLyN+LSanotfgUZ99K6ps0AIM7CgdqeFtXXPg+X3rQ
KzeH8lEXn/GaNaxKCoBBU3cjyZRVgboeNAVEKeoci1J05jxko3+Q9BNyRlM51eqX
q57romp8xDEYIr0A7JcXnRSgm/qykeRgXVvJ+hnyY2GUYb6JcWfDdhObEJKjA+H0
Jgh/hlB2zjENBVyOGjghpSUfQbHH1YIm9kaDZnsG2spIA/o0KMbkdiIbBzUqnq6I
fk2AqbSx95j7+ykzC/YmqSFVQbTcwQI7BdTZGIZP6lHvWfgLwgKNWf63xHAr+KqN
UB08mCBXAYE1v54/Ps+hry6/U9sXkQOApj+YTsRt8ZRfc3DWEQgfJAwJptqIBgIe
6v93FiHo35sBjh3biV5MrSM3phNFmkAJ1NdLNGn0drgqichRKWIdd1qcaoxfwQOa
bmYCibljQvX0yWi3AQxO
=djqu
-----END PGP SIGNATURE-----

--Sig_/sJTJKn5x2GuFqwRuZYNwNpB--
