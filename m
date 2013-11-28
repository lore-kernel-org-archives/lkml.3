Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab3K1Auo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 19:50:44 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51364 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3K1Aui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 19:50:38 -0500
Date: Thu, 28 Nov 2013 11:50:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>, Olof Johansson <olof@lixom.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Silence spurious compiler warnings
Message-Id: <20131128115020.8233b3447754df43eb36a325@canb.auug.org.au>
In-Reply-To: <20131127003949.GA21305@kmo>
References: <20131126132946.e402679788ae8269f0c5128a@canb.auug.org.au>
	<20131126143550.7a2195476ff4aa5c73db20b2@canb.auug.org.au>
	<CAOesGMiPpetDRt7dfHvcZ3LTSYyR3CBj2L2kq=pBMamkzCbb3A@mail.gmail.com>
	<5294F030.5090805@kernel.dk>
	<20131127003949.GA21305@kmo>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__28_Nov_2013_11_50_20_+1100_Q3oEXZcqogqDnH9g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Nov_2013_11_50_20_+1100_Q3oEXZcqogqDnH9g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kent,

On Tue, 26 Nov 2013 16:39:49 -0800 Kent Overstreet <kmo@daterainc.com> wrot=
e:
>
> From 46e7081430f5f483906f496733a23f8e9d898879 Mon Sep 17 00:00:00 2001
> From: Kent Overstreet <kmo@daterainc.com>
> Date: Tue, 26 Nov 2013 16:36:49 -0800
> Subject: [PATCH] block: Silence spurious compiler warnings
>=20
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>

Unfortunately, that did not work :-(

I am till getting these warnings into today's linux-next after merging
the block tree (arm multi_v7_defconfig, gcc 4.6):

block/blk-merge.c: In function 'blk_rq_map_sg':
block/blk-merge.c:135:8: warning: 'bvprv.bv_page' may be used uninitialized=
 in this function [-Wuninitialized]
block/blk-merge.c:173:23: note: 'bvprv.bv_page' was declared here
block/blk-merge.c:135:8: warning: 'bvprv.bv_len' may be used uninitialized =
in this function [-Wuninitialized]
block/blk-merge.c:173:23: note: 'bvprv.bv_len' was declared here
block/blk-merge.c:135:8: warning: 'bvprv.bv_offset' may be used uninitializ=
ed in this function [-Wuninitialized]
block/blk-merge.c:173:23: note: 'bvprv.bv_offset' was declared here
block/blk-merge.c: In function 'blk_bio_map_sg':
block/blk-merge.c:135:8: warning: 'bvprv.bv_offset' may be used uninitializ=
ed in this function [-Wuninitialized]
block/blk-merge.c:237:23: note: 'bvprv.bv_offset' was declared here
block/blk-merge.c:135:8: warning: 'bvprv.bv_len' may be used uninitialized =
in this function [-Wuninitialized]
block/blk-merge.c:237:23: note: 'bvprv.bv_len' was declared here
block/blk-merge.c:135:8: warning: 'bvprv.bv_page' may be used uninitialized=
 in this function [-Wuninitialized]
block/blk-merge.c:237:23: note: 'bvprv.bv_page' was declared here
block/blk-merge.c: In function 'attempt_merge':
block/blk-merge.c:110:7: warning: 'end_bv.bv_offset' may be used uninitiali=
zed in this function [-Wuninitialized]
block/blk-merge.c:89:17: note: 'end_bv.bv_offset' was declared here
block/blk-merge.c:110:7: warning: 'end_bv.bv_len' may be used uninitialized=
 in this function [-Wuninitialized]
block/blk-merge.c:89:17: note: 'end_bv.bv_len' was declared here
block/blk-merge.c:110:7: warning: 'end_bv.bv_page' may be used uninitialize=
d in this function [-Wuninitialized]
block/blk-merge.c:89:17: note: 'end_bv.bv_page' was declared here

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__28_Nov_2013_11_50_20_+1100_Q3oEXZcqogqDnH9g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSlpNVAAoJEMDTa8Ir7ZwVNQEP/Rr3oKnCBAXQEmSZi6PooHG4
aOXBaLlpZlpLTnZgcQi5QX63lXQN1c7cUdzrQ3Ogsj+ZkFh8jCHzXyflNQ87GoqH
GDpD6dPfDz1TYzz4IZLij8Gp6oIiws4w39QjTCqpxNKoD6rc59a5YZNhhxQhPseK
cogiOvL2YAHb1E1RKWCntS19R7zvrtTj0Ayglt9wZQAbKs31TyJrgmkWCF5d4XEq
KNUqcq1mAzHChl+OZ+LBx7qHdmuXpU/7ZKCVRzBiJCTpFZqJjE1y+8j7i4XQ6u7b
b5grp5RexHPTf7tde4zTWDQ8m5jkKZbfci02ViJqlfhWVjXTGt4gZWFwmreUII3N
+JZqY5q/hcWJ05q4jMJ0+ihlkpalW3w/2oMUyLBTurmCdORpRq21qtnotHx7AwQU
0kZkQVoeIKN+xC9Ef72ojPpTL/FfekGmNp3xi/aTYuJdprXjS3j8B/0327nUh94/
xm8I+2U96ugsvrilePVD3b9P+lHfsELPNfbcwMsFyRQ/MDwAvBjcthUYmgSACPlL
VuFbH6sbwXy8X5z54dM1bkAroCYq7HgzNpbqEIf1DAe8GKYa4Gt5JJInDtf0onbw
VoL15pU47y6aCoZRR94eAyhjpwySvRBZagAdMbugSc6J4baXK4rJDSW9duW7rzEj
ArfPmwpAruz9HnNVzbHo
=gZbW
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Nov_2013_11_50_20_+1100_Q3oEXZcqogqDnH9g--
