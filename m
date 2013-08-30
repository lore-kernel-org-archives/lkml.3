Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3H3IMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:12:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46237 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3H3IMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:12:06 -0400
Date: Fri, 30 Aug 2013 18:12:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>,
        Linus <torvalds@linux-foundation.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20130830181202.bea6400ec4d92744e05b5b9f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Aug_2013_18_12_02_+1000_hp2TxPQpV=pBdffj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Aug_2013_18_12_02_+1000_hp2TxPQpV=pBdffj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/fat/file.c: In function 'fat_file_release':
fs/fat/file.c:166:20: error: 'struct dentry' has no member named 'd_count'
      filp->f_dentry->d_count =3D=3D 1)
                    ^

Caused by commit ff121b02f7e3 ("fat: additions to support fat_fallocate")
from the akpm-current tree interacting with commit  98474236f72e ("vfs:
make the dentry cache use the lockref infrastructure") from Linus' tree.

I don't know if it is safe to read d_lockref.count without locking, and
it is late in the day, so I have just reverted that commit from the
akpm-current tree for today (along with
"fat-additions-to-support-fat_fallocate-fix").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__30_Aug_2013_18_12_02_+1000_hp2TxPQpV=pBdffj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSIFPSAAoJEECxmPOUX5FEBBMP/3EHKH6bcJfdo7MtQCsgSsuH
lAdR5LCk3xA3/SaU1P3rb0qDQOLuBh+kyX1gI4RRygh2nPrI2rYK+mWFPE8whEXz
L8+JgSLSjSkGFp1thauY0ygT1uEOm9yuZHd83itGmndaRwfp/djIxfd/+a+kGeRG
l1Sj1TEwaA93ISlK0IUKcZ5d9/tL6vZTL85bGdEicQMJ3XUpQ1vgCtVO1mlCfeEJ
DT813cmxdNGc6dVbRUVthEpi2aXaiw+ofx8LBvT0qxiHkMExgTS8E+T7alJ3AZm5
drGNp1920rksR2eqmt/coRFQk4LI8T0bIhudltkIT9jXd8uong53cQnRsD3clAL0
AlZVjH16u2WXg9qFl2wE1LKw7d9Q5xm0oRFGaCZBf0ceV3VzVtCReDjjNqnbfgZh
k7ML0k3ivr96WiFczzOTjgdpKKRSW1+0b4C0gd5C2V5argqYgttKHqeLxZmc8td9
exQ0i4YCaAd+VOl0Rl7vZgXsVpBmHj9K4Mt0DqkZsm8SwblopEosKR7WUqdhvMF2
n8VwarrTWZCZsaZ+1x/IkNtpAvy7xtQeJ99OosyDMj4Ly/KR/FQBW3LS4qFfH1xU
qTvU8JqUZp3bcqbqNdgVAjz//b59LCoCjKnR4xU2iXKnK7hEXPk+tF4XLIMi0D+S
7dHZYWyG+4y56o0/iYrX
=k3de
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Aug_2013_18_12_02_+1000_hp2TxPQpV=pBdffj--
