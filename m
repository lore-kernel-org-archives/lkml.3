Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaJMAZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 20:25:46 -0400
Received: from ozlabs.org ([103.22.144.67]:48744 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbaJMAZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 20:25:44 -0400
Date: Mon, 13 Oct 2014 11:25:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: linux-next: manual merge of the percpu tree with the ext4 tree
Message-ID: <20141013112533.120fd6e6@canb.auug.org.au>
In-Reply-To: <20140908164114.262bb178@canb.auug.org.au>
References: <20140908164114.262bb178@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.VPFbVHQ1KNZ=.UUNc1E/bT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.VPFbVHQ1KNZ=.UUNc1E/bT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ted,

On Mon, 8 Sep 2014 16:41:14 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the percpu tree got a conflict in
> fs/ext4/super.c between commit eb68d0e2fc5a ("ext4: track extent status
> tree shrinker delay statictics") from the ext4 tree and commit
> 908c7f1949cb ("percpu_counter: add @gfp to percpu_counter_init()") from
> the percpu tree.
>=20
> I fixed it up (the former removed a reference to percpu_counter_init)
> and can carry the fix as necessary (no action is required).
>=20
> That commit also added two references in fs/ext4/extents_status.c (thus
> proving that modifying a little used API causes it to be used
> more :-)), so I added the following merge fix patch:

This patch is now needed when I merge the ext4 tree with Linus'
tree ... so please let Linus know when you send your pull request.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 8 Sep 2014 16:25:46 +1000
> Subject: [PATCH] percpu_counter: fix for ext4 updates
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/ext4/extents_status.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 09fd57667262..3777f7eda5cf 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -13,6 +13,7 @@
>  #include <linux/list_sort.h>
>  #include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
> +#include <linux/gfp.h>
>  #include "ext4.h"
>  #include "extents_status.h"
> =20
> @@ -1189,10 +1190,10 @@ int ext4_es_register_shrinker(struct ext4_sb_info=
 *sbi)
>  	sbi->s_es_stats.es_stats_cache_misses =3D 0;
>  	sbi->s_es_stats.es_stats_scan_time =3D 0;
>  	sbi->s_es_stats.es_stats_max_scan_time =3D 0;
> -	err =3D percpu_counter_init(&sbi->s_es_stats.es_stats_all_cnt, 0);
> +	err =3D percpu_counter_init(&sbi->s_es_stats.es_stats_all_cnt, 0, GFP_K=
ERNEL);
>  	if (err)
>  		return err;
> -	err =3D percpu_counter_init(&sbi->s_es_stats.es_stats_lru_cnt, 0);
> +	err =3D percpu_counter_init(&sbi->s_es_stats.es_stats_lru_cnt, 0, GFP_K=
ERNEL);
>  	if (err)
>  		goto err1;
> =20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/.VPFbVHQ1KNZ=.UUNc1E/bT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUOxwCAAoJEMDTa8Ir7ZwVhyEQAIa7qPctp/aBAkRNX2A9DfDm
1C+JbOPwGZ28TswECoI1BHUtBO7sZxPNU2EbB4I7BWiCwmk6MTUMZyt49pdTjoJX
v6lCpREenzBPPcpuM4vlLQVToIrW2lB7ILG8fJOPCjDTJC/gIwA87chUiVMf0sQu
krR/NsYbff7v68LIWrsUXj2KpQCoaVG947MfdvqmbXa2CLdpUP3kZ9CiiqvMwMzx
UT3iQHle3lmmdtI6zvVpANIjFhXeA+ygeHwwKG5tEthhKZXuBtLkGSeGv29vJH7r
i1OgNCSwxG6acUf0gOxpS28zHdQY6rYIYuFqriEh1XK33sKUgTwDA8HcuXFjasAQ
hQwVXp3LzCpb0nw8iF8XwRbaFz6VEiemaRuotOjvgSo34Qeba5fgxrUeS4bZaKEM
VSkAMU6+7njU6w5j8rFPOt3XsXXiAWBDnLqKFOqGcTxk74cvHv4d2qRdvrV1U0GU
rdfJwT04KNmUN1IhsXoFHW2xPZR5UM0BJA+7qUugp5jVvDpsfSafFvdJkLWTxxZ9
/kwyfL1Y/0kmP5LC+wIcwano9NgIXk1d65mak4cWvqb80UVqVoZGr6I6RFZvS6l2
uUd8AWv4fOMEcrad1afdSDtpACWzbxEkHQZjm5+vTSk0h9Hj2QRCzhDCfHArPGjT
/zQPKhPjc3OvcbE9gbI6
=BOmq
-----END PGP SIGNATURE-----

--Sig_/.VPFbVHQ1KNZ=.UUNc1E/bT--
