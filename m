Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbbAGJri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:47:38 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:2429 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995AbbAGJrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:47:35 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Wed, 07 Jan 2015 09:47:33 +0000
Message-ID: <54AD00AC.2030801@imgtec.com>
Date: Wed, 7 Jan 2015 09:47:24 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux-metag@vger.kernel.org>
Subject: Re: [PATCH v2 09/40] metag/uaccess: fix sparse errors
References: <1420558883-10131-1-git-send-email-mst@redhat.com> <1420558883-10131-10-git-send-email-mst@redhat.com>
In-Reply-To: <1420558883-10131-10-git-send-email-mst@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="wG9dUoEoOim5rPkFTQRge26B0AnONhSbC"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: b93fcccb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wG9dUoEoOim5rPkFTQRge26B0AnONhSbC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Machael,

On 06/01/15 15:43, Michael S. Tsirkin wrote:
> virtio wants to read bitwise types from userspace using get_user.  At t=
he
> moment this triggers sparse errors, since the value is passed through a=
n
> integer.
>=20
> Fix that up using __force.
>=20
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/metag/include/asm/uaccess.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/metag/include/asm/uaccess.h b/arch/metag/include/asm/=
uaccess.h
> index 0748b0a..c314b45 100644
> --- a/arch/metag/include/asm/uaccess.h
> +++ b/arch/metag/include/asm/uaccess.h
> @@ -135,7 +135,7 @@ extern long __get_user_bad(void);
>  ({                                                              \
>  	long __gu_err, __gu_val;                                \
>  	__get_user_size(__gu_val, (ptr), (size), __gu_err);	\
> -	(x) =3D (__typeof__(*(ptr)))__gu_val;                     \
> +	(x) =3D (__force __typeof__(*(ptr)))__gu_val;                     \

As I mentioned before, can you please adjust the position of the \ to
line up.

>  	__gu_err;                                               \
>  })
> =20
> @@ -145,7 +145,7 @@ extern long __get_user_bad(void);
>  	const __typeof__(*(ptr)) __user *__gu_addr =3D (ptr);		\
>  	if (access_ok(VERIFY_READ, __gu_addr, size))			\
>  		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
> -	(x) =3D (__typeof__(*(ptr)))__gu_val;                             \
> +	(x) =3D (__force __typeof__(*(ptr)))__gu_val;                        =
     \

same here (this one causes checkpatch error due to 80 column limit).

>  	__gu_err;                                                       \
>  })
> =20
>=20

With those changes,
Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James


--wG9dUoEoOim5rPkFTQRge26B0AnONhSbC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrQCzAAoJEGwLaZPeOHZ6ho8P/ij5ANUeelvOYnmpKda00EsN
YgLDZzZg+meMDzDoBp1jpqeJYSCPL3lV2Ln5/prbdlXXEX4CGeS8K/DfnRX4v7TL
r4Oc3u8ei2Q7MRPOB5hGuUS5Qj23QlSP599Jq7sUhF7FKGgcIJ9/xFhXlktG61GF
CE1z7QroVNhQpv2va/Xasgc07qVN+X9h105aEb9TjPi+BcCfs6Gldg2jLpxrpx8/
6RbCWXKchrVD9NILdTqzG3ZxVyZnhO5BFb9ko5/Di+7SEdQU70ZsBVYhoEoZjLqZ
8891LmYli7pqW4nFV28uQw5yVJMlSzhdIqHugDAvRaw8VPgwO6ZmoH/XovaHk4Dz
4tNoVjMkjT2Mh3tOgfJVe6B3x97g6iIIvbumnGNNUI9LEX4zlmLVhe8eiG0cs3iu
b4nxpAmZjt32PZHBBRTGjgCrj06UpZNsTSdmztKme8wSIQe+YrEWyva/PtMBLrbI
33HYra5g4HIv9oHGb5VPLf2kGhKRBAuAdrhrcz61+VdoZ72Mz20Rk5j9y+lOR7cN
Ix98BCttozR/Ik7C/YmyjKoeM80YTGri1rGgCtyB+no/F6nuhlbiH1C1obW/Wymq
lCf/JoQ2hS1FHITPMpMj+fzf+bs1PzvXRDwKIYLYCDJ5RCA4sxbclbmj2i68yneF
a4DjAMOF7+jDBqk+js4M
=Xkhs
-----END PGP SIGNATURE-----

--wG9dUoEoOim5rPkFTQRge26B0AnONhSbC--
