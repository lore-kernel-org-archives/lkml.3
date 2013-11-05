Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab3KEFJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 00:09:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52617 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3KEFJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 00:09:38 -0500
Date: Tue, 5 Nov 2013 16:09:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: linux-next: manual merge of the staging tree with the block tree
Message-Id: <20131105160924.4da55b7e36aa2ab93443fdda@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Nov_2013_16_09_24_+1100_aYDv+PlCruJF.kXn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Nov_2013_16_09_24_+1100_aYDv+PlCruJF.kXn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/lustre/lustre/llite/lloop.c between commit ed2d2f9a8265
("block: Abstract out bvec iterator") from the block tree and commit
de40d1209898 ("staging: lustre: fix bug with LL_MRF_RETURN in
loop_make_request") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/lustre/lustre/llite/lloop.c
index 3488bb6c44a7,e2421ea61352..000000000000
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@@ -368,10 -365,9 +367,9 @@@ static void loop_make_request(struct re
  		goto err;
  	}
  	loop_add_bio(lo, old_bio);
- 	LL_MRF_RETURN(0);
+ 	return;
  err:
 -	cfs_bio_io_error(old_bio, old_bio->bi_size);
 +	cfs_bio_io_error(old_bio, old_bio->bi_iter.bi_size);
- 	LL_MRF_RETURN(0);
  }
 =20
 =20

--Signature=_Tue__5_Nov_2013_16_09_24_+1100_aYDv+PlCruJF.kXn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSeH2MAAoJEMDTa8Ir7ZwVNOMQAIrcY6qZtW9Vp1V+tCAN2hh6
Zc2HxqEa8Kfae4ErFfAvURWQLfRPWmlIA7rRA1zrOFjdkYFM4ZmZMg47L6pcZWzh
qb9N/6I1P7wvsnAzvGjfzoU48rwpGudI8gEhNx9QB0BmyJ4oxXs5fdxTeM7m9XtK
q+ttusjRR/PnGw0zx+JydrBiWhH1Puwaa0N52lrY9TpsPMvU+rHMeaWzOAsigGDL
+yt5yS+dfYAdZO4S2Zig/Zb+kAhArqRIJuUNFkacLME2HHajnEVBbtfgWUhdswMK
lnJc7I8omPU4y/+QxhmAEHsxQfrBQ7dU9x2f0wZAAlD9wIRs6UbPxmb0vPRHZkdI
MMoDlN92qOEv8ahBjZHcspTMHTmQtc2cYFf67KyNmxa5Z5qSQWDhc3k2vEK1R+2+
iDQ9qBWtt4ppjcmmJ/98yVE+y6iNcnpeWTOhjbjzc6XknNaGqPtcdl5HLoeqdVBd
9sZlSi1V5INwSSHAT1hCsFK3qY/yl6MJeEJjslmBKFeiYzXFMXETaxUOOEgS8Dr0
DK2714sPQ9ygBh3uml55IQusSk6aHO7q28GowA0Ox5i+EyYfU2hjwg+7aMBbuDVL
lx0GJlj52tzCjeF1j2xAxmjBmfiZJRlYvDtvFjpToSSlSif4zJUyQxVk3CtNbMqw
1eU5z71Kxh/AbvxrHyn5
=+Zi+
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Nov_2013_16_09_24_+1100_aYDv+PlCruJF.kXn--
