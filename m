Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3AUGIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:08:15 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37668 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab3AUGIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:08:13 -0500
Date: Mon, 21 Jan 2013 17:08:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20130121170804.8b6eec010e00a6cbbcbad66f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Jan_2013_17_08_04_+1100_=kCXM5GvNlC4eDXd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jan_2013_17_08_04_+1100_=kCXM5GvNlC4eDXd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (arm defconfig)
failed like this:

mm/memblock.c: In function 'memblock_find_in_range_node':
mm/memblock.c:104:2: error: invalid use of undefined type 'struct movableco=
re_map'
mm/memblock.c:123:4: error: invalid use of undefined type 'struct movableco=
re_map'
mm/memblock.c:130:7: error: invalid use of undefined type 'struct movableco=
re_map'
mm/memblock.c:131:4: error: invalid use of undefined type 'struct movableco=
re_map'

Caused by commit "page_alloc: bootmem limit with movablecore_map" from
the akpm tree.  The definition of struct movablecore_map is protected by
CONFIG_HAVE_MEMBLOCK_NODE_MAP but its use is not.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_Jan_2013_17_08_04_+1100_=kCXM5GvNlC4eDXd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/NtEAAoJEECxmPOUX5FE7AUP/jZoCtC9Q5N6ExZBGWvMYJQ6
JzVD4DNZywoL3VfKktDvLHz+i7cWTjZ1STlTB2+RHld1Usski6BFWpZYI/zZCkv9
zO6xKKMkilhxstcCutiX5NV6C3nlpnR4iQp+uVRWX53ALPvkO7QTebE8KQWTvRN7
OYotyPituqzn5rWcu7hiJQ3KXiPcg0S3WS1FFTxZzYk/YG84YVB4rjtYXKqAtALU
pINiDmQt/cLSlUPLpAIeRouqEMPRKe0uA9rHcklV9otGkAbumSGKc+IfKALz9pYl
ziG+qpa94mkTXXWLIXV0ZChCHz6hjERcrTbuCAulFZl1JpzJ5GPMxaMigS+WDTlm
ZYx5uzS38PfePxeXJZMICqk56QrxBzUU4ZjmJzEGbrgdoe4yJnZg5RpOFwbzYS5w
FPm5YKOZW1Dolrmu1WPi7Lk+9eVCjDnm2Lmi09m/+XoT1xKI8MP9FE1ggSEhCtVV
wO91Yqwyd3VzcdcAG56aCYumxzhag498x5shnAIvqqC8Ei8RJoDDULnko8t3EvLt
aY2obknglYBKy3thmDZLUs663fza5D4MNurPl/fIXH+t1MfksLtU3vuowb3lePGo
dxNGYRVSiUF7PYOelpx7GxCrGDqivSUBbF9bBwx42yxGJHW6oVSNKB+JUXcRNkmf
cmB5R0NSWkI/QIavt2Sg
=PCWr
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jan_2013_17_08_04_+1100_=kCXM5GvNlC4eDXd--
