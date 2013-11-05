Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014Ab3KEF3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 00:29:35 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58368 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3KEF3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 00:29:34 -0500
Date: Tue, 5 Nov 2013 16:29:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IkrDtnJuIEVuZ2VsIg==?= <joern@logfs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Takashi Iwai <tiwai@suse.de>
Subject: linux-next: build failure after merge of the bcon tree
Message-Id: <20131105162922.441f612bd17f6fa977c39e89@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Nov_2013_16_29_22_+1100_MFLx2n5_.mINc.TO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Nov_2013_16_29_22_+1100_MFLx2n5_.mINc.TO
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi J=C3=B6rn,

After merging the bcon tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/block/blockconsole.c: In function 'sync_read':
drivers/block/blockconsole.c:184:5: error: 'struct bio' has no member named=
 'bi_idx'
  bio.bi_idx =3D 0;
     ^
drivers/block/blockconsole.c:185:5: error: 'struct bio' has no member named=
 'bi_size'
  bio.bi_size =3D SECTOR_SIZE;
     ^
drivers/block/blockconsole.c:187:5: error: 'struct bio' has no member named=
 'bi_sector'
  bio.bi_sector =3D ofs >> SECTOR_SHIFT;
     ^
drivers/block/blockconsole.c: In function 'bcon_erase_segment':
drivers/block/blockconsole.c:215:6: error: 'struct bio' has no member named=
 'bi_size'
   bio->bi_size =3D PAGE_SIZE;
      ^
drivers/block/blockconsole.c:218:6: error: 'struct bio' has no member named=
 'bi_idx'
   bio->bi_idx =3D 0;
      ^
drivers/block/blockconsole.c:219:6: error: 'struct bio' has no member named=
 'bi_sector'
   bio->bi_sector =3D (bc->write_bytes + i * PAGE_SIZE) >> 9;
      ^
drivers/block/blockconsole.c: In function 'bcon_writesector':
drivers/block/blockconsole.c:338:5: error: 'struct bio' has no member named=
 'bi_size'
  bio->bi_size =3D SECTOR_SIZE;
     ^
drivers/block/blockconsole.c:343:5: error: 'struct bio' has no member named=
 'bi_idx'
  bio->bi_idx =3D 0;
     ^
drivers/block/blockconsole.c:344:5: error: 'struct bio' has no member named=
 'bi_sector'
  bio->bi_sector =3D bc->write_bytes >> 9;
     ^

Caused by changes in the block tree.  Thierry Reding mentioned that you
didn't think that the bcon tree was linux-next material any more, so I
just dropped your tree.  If that is incorrect, please let me know and I
will reinstate it and fix this merge conflict.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__5_Nov_2013_16_29_22_+1100_MFLx2n5_.mINc.TO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSeII4AAoJEMDTa8Ir7ZwV1ZUQAIhze1BAYz6kTOJWA+agEVEo
AKUEaZkphIXh35P3kmj69UeQGXstGJ9v/Cnsi4AWfgdIMxTy4FuiWnJPLep72egJ
AyhoKY+zTdAxLWXkJv4EE0ZnVLwQBAt5sD5roHe3Gk1t7Qz4x54E1PXjFyfzOgJq
yLHY5RxMprmbvrQIGY2JHy1q1cnCphKsAzq29g2GU1exuUu8+NxDOvZH+mMYJQyy
7TPbtcYejHvQ+O0Y1xOFFV9AbP4XdsKDe6CFLE4aN1OuN9lPoOXxA9mdfOAph692
chFISreV8VOJ44BGgoR+wsZ6PfaMuwJUHil3CPvVJLEhdMHDmQcU1SrW9NfhqmtW
LF4Kz3jKaaAaWibgciMlQ84yMnFzidMOFomzQOva1CFHeSqzntxWmVSNLllUWLvG
594yHxBKrKxAjHU7EvLMTW3FWYoUz5zMYSB/ZPgNWUh1LOVUNM23W6sHk2vkabE1
kjrVSj6pTfC5cOU54ELOw6utVHKA7e3mFWHG1/lTs/mPR54vT44EbObF/BEYrVdY
vmRjkArXhC6qSuF4YaxAIG5qtVRH+ivGJwY4Z/eVoNv6UfVH/9b8nZi509Ehsznl
rKwDa2sWiHzz6Nwr4w1Vxbf3U++z7eiLzs4Sqv8nhBgJrJmUOoL0W7fUYIkeVrX2
PlvOjXvZ/+R+JxDWrqyC
=FMyI
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Nov_2013_16_29_22_+1100_MFLx2n5_.mINc.TO--
