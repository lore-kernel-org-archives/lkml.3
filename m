Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab3J3GNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 02:13:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab3J3GNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 02:13:09 -0400
Date: Wed, 30 Oct 2013 17:12:57 +1100
From: NeilBrown <neilb@suse.de>
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UAPI: include <asm/byteorder.h> in linux/raid/md_p.h
Message-ID: <20131030171257.0e3060ee@notabene.brown>
In-Reply-To: <1383049738-26107-1-git-send-email-aurelien@aurel32.net>
References: <1383049738-26107-1-git-send-email-aurelien@aurel32.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jwRhcS=TxtnYaveIZdi7mK8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jwRhcS=TxtnYaveIZdi7mK8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Oct 2013 13:28:58 +0100 Aurelien Jarno <aurelien@aurel32.net>
wrote:

> linux/raid/md_p.h is using conditionals depending on endianess and fails
> with an error if neither of __BIG_ENDIAN, __LITTLE_ENDIAN or
> __BYTE_ORDER are defined, but it doesn't include any header which can
> define these constants. This make this header unusable alone.
>=20
> This patch adds a #include <asm/byteorder.h> at the beginning of this
> header to make it usable alone. This is needed to compile klibc on MIPS.
>=20
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> ---
>  include/uapi/linux/raid/md_p.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_=
p.h
> index fe1a540..f7cf7f3 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -16,6 +16,7 @@
>  #define _MD_P_H
> =20
>  #include <linux/types.h>
> +#include <asm/byteorder.h>
> =20
>  /*
>   * RAID superblock.

Makes sense.  Applied.  Thanks.

NeilBrown

--Sig_/jwRhcS=TxtnYaveIZdi7mK8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnCjaTnsnt1WYoG5AQJn1g/+KHSaFmoel94ccudWS8FJrc1FlDwN305g
iZbJBBgVn+AY+ibAsC8YAg3jx24zmguup5e59Xueb6VYCxuccT2GTo39aO8BCtyt
1FHLidaFGjVQ4aWRTHu8a3ueI9Zf4ejb21voSdMaTpJ0lTHaRwiaTYSpQoVvdsDL
ExbrLBQldYL7T8MmvqfLzE8vC32x9fLNMpPuUSOPzMakr9ohRh73E7Wq66cvtnEn
3YDgf0OOrd/xBVyrU2+m+CarTkInTq8EsFPxHmP0bBvlBMRWMN/sgc9KBAGsiFvp
6rftPedXQdbWo0huDnD14wDZgOZnMPznqXrDQ5OGzkhP/qN6Ubwy4QT+Q65C7r+C
BdLYU/5SLfIsxRztanRM0Zfzdk1c3JHI0Bv8qKXz2APgHiwFUFW3WH2b25tlGirU
RoDJCmUC8KaTfY1cOZqOGdVTf3F9liibjB0WSP661hcfwydfXZliUywtvxw9j+vf
499kPg1t2nO89s8/1A/90srfbJFpXZq8/nfVPKdFKxhSK7yQBWC8XT+wk/11C2EK
xHNVLarWEUvIt/znZw+iZcAA8BDh31wihrwlhsSFwDnlSL0bXZ7S5Ta/9ypICnRb
W8l4pwyu76houElLImqrOM8X+E/X+T9Jfmr1R8TpyiU7r+w/rlI/dDArzyd6I1g4
Ur7Y69aN/SM=
=GMPK
-----END PGP SIGNATURE-----

--Sig_/jwRhcS=TxtnYaveIZdi7mK8--
