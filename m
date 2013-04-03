Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335Ab3DCGmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:42:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55596 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab3DCGma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:42:30 -0400
Date: Wed, 3 Apr 2013 17:42:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Subject: linux-next: build failure after merge of the final tree (nfsd tree
 related)
Message-Id: <20130403174219.0786d27109633a30d89b38bf@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Apr_2013_17_42_19_+1100_bf1RPF65+WHvsVRm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Apr_2013_17_42_19_+1100_bf1RPF65+WHvsVRm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (arm defconfig)
failed like this:

fs/built-in.o: In function `nfsd_reply_cache_stats_show':
super.c:(.text+0x87308): undefined reference to `__udivdi3'

Probably caused by commit 187da2f90879 ("nfsd: keep track of the max and
average time to search the cache") which adds a divide by u64
(num_searches).

I have reverted that commit and the following one for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Apr_2013_17_42_19_+1100_bf1RPF65+WHvsVRm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRW89LAAoJEECxmPOUX5FE1XEQAIOv1tXX/4oOh7ImoAiFDa08
06mtbZmXkQ7QNA0V15KiS6kv8/xNIdn32vdvyxqSr+SeqdAcp7BzC3tFCv2IgXDz
jLhsvwXvanWM7n1NsDloL3H6HNNCQNpedyopfniHn6q70LR7uB1u4ddHrK/1LiKM
fLWh85e+d7YI5ikEdarKWYgTdXOwJgdQViZV2DPqlGIppZTMGDwKuLmuVmsQOAa4
Hbp3i5zyA+fRiasPJ24ENyWraPoKlVkkwzACCEMeSTbDSIGmsc60Z0SN7qLvDOVv
N0hF4OAOdfNQcHqeh54EsmwShuKockTUBCNFux1MuDaVvMYF0L5rWMsDk29hyfFp
8TscKvyuLbpu5t7gfYVGFCUh3CIfRHYrwtC+fF7sPsEs3cONyIk9VXLny8ALtnBe
uCyei7pOSkEOOoauv9ayJP3OwPRCm4jwQv9VE98L1rjujnDNbohxW2OdkipYfSMb
IxTSDefaa5uIUqjCgAxHRN7cEULDtvc23s0j9b9K0cEqgmk7bl2hm2zV1E9sB88J
hnIKMethcqv2QcF7n16A8gHeNw782NhzBF8B3dhyblE4LXyMwSb/honVefCKrUD4
fKu1zWLxPMtlCBl5ekIc81JkVFVX1j4ANCFK2exdgEqXG6Tm1Y8zTVOYBb0p8HGy
v1HQqn8X6HZ0wK51RxnZ
=8blL
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Apr_2013_17_42_19_+1100_bf1RPF65+WHvsVRm--
