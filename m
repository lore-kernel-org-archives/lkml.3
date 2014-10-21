Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbaJUOjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:39:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932863AbaJUOjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:39:33 -0400
Message-ID: <5446690D.3000909@redhat.com>
Date: Tue, 21 Oct 2014 16:09:17 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: karam.lee@lge.com, minchan@kernel.org, ngupta@vflare.org,
        linux-kernel@vger.kernel.org
CC: matthew.r.wilcox@intel.com, seungho1.park@lge.com
Subject: Re: [PATCH v3 2/3] zram: change parameter from vaild_io_request()
References: <1413876458-19279-1-git-send-email-karam.lee@lge.com> <1413876458-19279-3-git-send-email-karam.lee@lge.com>
In-Reply-To: <1413876458-19279-3-git-send-email-karam.lee@lge.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="WR1VbgDsmpbanwpaDOAIQIgC8iHD2hfJo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WR1VbgDsmpbanwpaDOAIQIgC8iHD2hfJo
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/21/2014 09:27 AM, karam.lee@lge.com wrote:
> From: "karam.lee" <karam.lee@lge.com>
>=20
> This patch changes parameter of valid_io_request for common usage.
> The purpose of valid_io_request() is to determine if bio request is
> valid or not.
> This patch use  I/O start address and size instead of a BIO parameter
> for common usage.
>=20
> Signed-off-by: karam.lee <karam.lee@lge.com>

Acked-by: Jerome Marchand <jmarchan@redhat.com>

> ---
>  drivers/block/zram/zram_drv.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_dr=
v.c
> index 54da18a..4565fdc 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -206,19 +206,18 @@ static inline int is_partial_io(struct bio_vec *b=
vec)
>  /*
>   * Check if request is within bounds and aligned on zram logical block=
s.
>   */
> -static inline int valid_io_request(struct zram *zram, struct bio *bio)=

> +static inline int valid_io_request(struct zram *zram,
> +		sector_t start, unsigned int size)
>  {
> -	u64 start, end, bound;
> +	u64 end, bound;
> =20
>  	/* unaligned request */
> -	if (unlikely(bio->bi_iter.bi_sector &
> -		     (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
> +	if (unlikely(start & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
>  		return 0;
> -	if (unlikely(bio->bi_iter.bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
> +	if (unlikely(size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
>  		return 0;
> =20
> -	start =3D bio->bi_iter.bi_sector;
> -	end =3D start + (bio->bi_iter.bi_size >> SECTOR_SHIFT);
> +	end =3D start + (size >> SECTOR_SHIFT);
>  	bound =3D zram->disksize >> SECTOR_SHIFT;
>  	/* out of range range */
>  	if (unlikely(start >=3D bound || end > bound || start > end))
> @@ -780,7 +779,8 @@ static void zram_make_request(struct request_queue =
*queue, struct bio *bio)
>  	if (unlikely(!init_done(zram)))
>  		goto error;
> =20
> -	if (!valid_io_request(zram, bio)) {
> +	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
> +					bio->bi_iter.bi_size)) {
>  		atomic64_inc(&zram->stats.invalid_io);
>  		goto error;
>  	}
>=20



--WR1VbgDsmpbanwpaDOAIQIgC8iHD2hfJo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJURmkNAAoJEHTzHJCtsuoCoKMIAI5Q69JOxKqk5o+v0oHdlCCD
jHmA8+h2QrwNXq71YCsnRvXfdI4GvPiYFlf0iW1+8eYwz+zSNoAWbyfffSqtSzUu
HsZGrCjVAyIw8fzSeNjYpgSwMWl0ftf5tKL+N2XThLHc29xLCIldxn9rgTpb7RvX
xv/rDDSGETDi7SuUbfCuxlJYXmVXAtgxySteYgXsdZszbLRi4bPv7+Es3M82e1cW
oAXE0mHw5nVX8lwsMpFtyEnB9rTl2wjiOAFwH5eZww7M6JHVIEqG+5VMLJdrUzMi
Pn5djwYyuiqE/U4Q5OXguCybl/1n9BI3FzyogpiwCiodmLv2WeVD5P2Bu4iOy/Y=
=YsPG
-----END PGP SIGNATURE-----

--WR1VbgDsmpbanwpaDOAIQIgC8iHD2hfJo--
