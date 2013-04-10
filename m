Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029Ab3DJJDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:03:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49037 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab3DJJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:03:37 -0400
Date: Wed, 10 Apr 2013 19:03:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <Yuantian.Tang@freescale.com>
Cc: <grant.likely@secretlab.ca>, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com
Subject: Re: [PATCH] of: remove the unnecessary of_node_put for
 of_parse_phandle_with_args()
Message-Id: <20130410190327.a70d4c3798509d664aef2f13@canb.auug.org.au>
In-Reply-To: <1365490569-32455-1-git-send-email-Yuantian.Tang@freescale.com>
References: <1365490569-32455-1-git-send-email-Yuantian.Tang@freescale.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Apr_2013_19_03_27_+1000_9m892t2Uqn+3AqyV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Apr_2013_19_03_27_+1000_9m892t2Uqn+3AqyV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 9 Apr 2013 14:56:09 +0800 <Yuantian.Tang@freescale.com> wrote:
>
> From: Tang Yuantian <yuantian.tang@freescale.com>
>=20
> As the function itself says it is caller's responsibility to call the
> of_node_put().  So, remove it on success to keep the reference count
> correct.
>=20
> Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
> ---
>  drivers/of/base.c | 3 ---
>  1 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 321d3ef..e8b4c28 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1168,9 +1168,6 @@ static int __of_parse_phandle_with_args(const struc=
t device_node *np,
>  					out_args->args[i] =3D be32_to_cpup(list++);
>  			}
> =20
> -			/* Found it! return success */
> -			if (node)
> -				of_node_put(node);

Actually, if out_args is NULL, you should do the of_node_put(node), so
probably the correct fix is to add an "else" before the above "if" (and
move the comment).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Apr_2013_19_03_27_+1000_9m892t2Uqn+3AqyV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJRZSrfAAoJEECxmPOUX5FEshsP9j/SviOKe9soG62CzsCGGtr3
6sIf7zvVuQmdb/AIrhzxwGOdESRn8MWqPjIoAHZUpAnStrkPF5q3dBVUx+aMERJD
185Dmz3OoU0lpZHwNu5fNYAqVbNc/8hoU+EJc9unh/6zVTcBoxjSg4aTHj/tXbJt
Z9pfCggA/hiKHrreO8wHLxt4XEYpyp+t6DYhNVM7PBiz21Of7Ve21SWQ4etxjRip
geleVMs4ruyZ/QmnWld32ac9EwuiD+XeVKtT0fjofG5islE3xwLLPTdpJKB56wNm
D2UfWu4yaZkXzRXdVdagChKCfCbOBMDfhrnJHQ5hGKJvPEfDBek1UN5tu30CDqJZ
p9BtjaUbr+k4dKmsBX1sJCmWBuKK+b5N6BwJVu4BJCo5na00xVP8NY/5qyW0oMVL
7djeLLv0c6NXXWMWRjvBvuTyB63V5/f9vQlksThX2WlJs7h21V56eq4gzjQps3Ur
TkHFEfB7xtWdPDRmdH1+pKqXwId2lmWFcMlhVKcAC1sY3VMRtc9wUl3t8yb0SDCF
k3taNF+DycVXb3KAF5+8/PRvs92nk7EhKEXa0ocK+l98R74U9TKSPMMiP5vByQvH
RIjid/6TmAOPxYHPEl1ZHqam1V69YThHl76SFC+jnbGsiPfTtmrLsVNvS3R6bKnf
xmU/r+9YRMZZHGH4agw=
=QBxe
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Apr_2013_19_03_27_+1000_9m892t2Uqn+3AqyV--
