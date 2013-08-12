Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab3HLGJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 02:09:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47773 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3HLGJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 02:09:12 -0400
Date: Mon, 12 Aug 2013 16:09:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20130812160911.50722d217a4912d68b62d5bd@canb.auug.org.au>
In-Reply-To: <20130812160733.b14fa70ef8ab575a3e42cd1b@canb.auug.org.au>
References: <20130812160733.b14fa70ef8ab575a3e42cd1b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Aug_2013_16_09_11_+1000_kJ3AzJJgfnQdN8Iv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Aug_2013_16_09_11_+1000_kJ3AzJJgfnQdN8Iv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Just adding some missed ccs]

On Mon, 12 Aug 2013 16:07:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi Andrew,
>=20
> After merging the akpm-current tree, today's linux-next build
> (x86_64 allmodconfig) failed like this:
>=20
> mm/memcontrol.c: In function '__mem_cgroup_iter_next':
> mm/memcontrol.c:982:4: error: 'prev_cgroup' undeclared (first use in this=
 function)
>     prev_cgroup =3D next_cgroup;
>     ^
> mm/memcontrol.c:982:18: error: 'next_cgroup' undeclared (first use in thi=
s function)
>     prev_cgroup =3D next_cgroup;
>                   ^
>=20
> I applied this patch:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 12 Aug 2013 16:04:36 +1000
> Subject: [PATCH] memcontrol: further merge fix patch
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 624d69e..a367145 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -979,7 +979,7 @@ skip_node:
> =20
>  		switch (mem_cgroup_filter(mem, root, cond)) {
>  		case SKIP:
> -			prev_cgroup =3D next_cgroup;
> +			prev_css =3D next_css;
>  			goto skip_node;
>  		case SKIP_TREE:
>  			if (mem =3D=3D root)
> @@ -998,7 +998,7 @@ skip_node:
>  			if (css_tryget(&mem->css))
>  				return mem;
>  			else {
> -				prev_cgroup =3D next_cgroup;
> +				prev_css =3D next_css;
>  				goto skip_node;
>  			}
>  			break;
> --=20
> 1.8.4.rc0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__12_Aug_2013_16_09_11_+1000_kJ3AzJJgfnQdN8Iv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCHwHAAoJEECxmPOUX5FELFMP/1n/WtDRMOfhCRuZR0QtcWn/
Xhpma1LNQrVT3n0AgwRKIHIFYkxYqWCnoL8D827ms1O9UJAv5zRzR6BBPIl0/1dS
nTagd4DSdEA+w76/sW+RupD5B0nz4M4u2CUd6pq/q8r4EhLnaVhCubdTQIM+beHC
TXcxBI/mp291R72Jy35RZLLpClI6jZaotkjwhdWRdtGeDXsElJzcdBJ0E+d6HEsj
XzJ0fy5lIlPID04nWRyylGFK10RJr2xmLX6Ev2eeGpxggqLjPOUVoVVYP8vwKMlX
WG5gMq683U9VccI0/wRrezOu6vzGGL6tA4LUtkiEjwRgT2D5k+MMNQrz1bbXtcm+
GR2XkGL7oCUU2nUoH/LDl9VUZPbKJCUz6oI43Rpqtguila4X2bHTWvUchSLrzaWV
DribJX9bTx9vOWP2/9inzSEEU0rNT58XUvNvUn4K8k1TxQ+sCxQUBTMCAHOXQwbq
8pm5p9dhkR/fhUJpcjZZtpxA5mzwdlOh2yVeSFVGgZEO7NaeIBNkY6/+4Q9hC++o
0k+YqBTGwYnNLhmBl16hICLsR4Z7sDWe4V6Yi2UkkKN7H5146hujSfRmGz5Z6Pur
xRPawBY/vyaPG2M3N4yEb66tgN9bTvVdSKlFsbc3CgPB4pAPo6wpy0k1M6ZijmeB
sCjMpzTcKvGl4u+jWafe
=2alc
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Aug_2013_16_09_11_+1000_kJ3AzJJgfnQdN8Iv--
