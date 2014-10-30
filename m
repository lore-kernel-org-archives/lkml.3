Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbaJ3NN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:13:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759391AbaJ3NNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:13:25 -0400
Message-ID: <5452395C.6030500@redhat.com>
Date: Thu, 30 Oct 2014 09:13:00 -0400
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Weijie Yang <weijie.yang@samsung.com>,
        "'Minchan Kim'" <minchan@kernel.org>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Nitin Gupta'" <ngupta@vflare.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] zram: avoid kunmap_atomic a NULL pointer
References: <000001cff409$bf7bfa50$3e73eef0$%yang@samsung.com>
In-Reply-To: <000001cff409$bf7bfa50$3e73eef0$%yang@samsung.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="aNCk04KK8cB7B5LaiQrSCXbd3MMSeB3rj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aNCk04KK8cB7B5LaiQrSCXbd3MMSeB3rj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/30/2014 02:20 AM, Weijie Yang wrote:
> zram could kunmap_atomic a NULL pointer in a rare situation:
> a zram page become a full-zeroed page after a partial write io.
> The current code doesn't handle this case and kunmap_atomic a
> NULL porinter, which panic the kernel.
>=20
> This patch fixes this issue.
>=20
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Acked-by: Jerome Marchand <jmarchan@redhat.com>

> ---
>  drivers/block/zram/zram_drv.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_dr=
v.c
> index 2ad0b5b..3920ee4 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -560,7 +560,8 @@ static int zram_bvec_write(struct zram *zram, struc=
t bio_vec *bvec, u32 index,
>  	}
> =20
>  	if (page_zero_filled(uncmem)) {
> -		kunmap_atomic(user_mem);
> +		if (user_mem)
> +			kunmap_atomic(user_mem);
>  		/* Free memory associated with this sector now. */
>  		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
>  		zram_free_page(zram, index);
>=20



--aNCk04KK8cB7B5LaiQrSCXbd3MMSeB3rj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUUjlcAAoJEHTzHJCtsuoC0aQIAKvyIPhInikRYcPf6TpYxmxk
N5+v4eP306EGErJ7vwMgPEGZLc/wuWrVxayv9vQZpH9y1T+nPn03NvUT6yvS8Wld
6PrgcdxUlUGqzb3l8KJqOAmTtwElLdmLEnYSnzTGp+QJ7opAKZGZ/l0n+N5dlwtZ
fWY7iVMuSX0xFu5l7+aNiiyTyT2ojqoj9IIjV3qMQnf2tLNKj0GDbSbA9ZSy+Uet
n/EQixaer0+voHyNSUZeyNawgI/EP81AGrd9bOHn5U8+JBI1EuT5YaHSkVR0h9S7
tH9Zsj19wAwdvPMvhQyCD/ez3P/FVvMdrcVejFylDvM7/7aEucvOE/MfysyZDS8=
=bB3h
-----END PGP SIGNATURE-----

--aNCk04KK8cB7B5LaiQrSCXbd3MMSeB3rj--
