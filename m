Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaAVRUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:20:01 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:36122 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaAVRT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:19:59 -0500
Date: Wed, 22 Jan 2014 17:19:58 +0000 (UTC)
From: Paul Walmsley <pwalmsley@nvidia.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnd Bergmann <arnd@arndb.de>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bitops: fix signedness of compile-time hweight
 implementations
In-Reply-To: <alpine.DEB.2.02.1312180459580.30198@tamien>
Message-ID: <alpine.DEB.2.02.1401221718500.4071@utopia.booyaka.com>
References: <alpine.DEB.2.02.1312180459580.30198@tamien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-1976742745-1390411198=:4071"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-1976742745-1390411198=:4071
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi Peter, hpa, Arnd,

On Wed, 18 Dec 2013, Paul Walmsley wrote:

>=20
> Enabling '-Wsign-compare' compiler warnings on code that includes
> include/linux/bitops.h can generate the following warning:
>=20
> In file included from include/linux/kernel.h:10:0,
>                  from <random filename>:48:
> include/linux/bitops.h: In function =A1hweight_long=A2:
> include/linux/bitops.h:77:26: error: signed and unsigned type in conditio=
nal
> expression [-Werror=3Dsign-compare]
>=20
> (converted to an error with -Werror)
>=20
> This is due to the use of the logical negation operator '!' in the
> __const_hweight8 macro in include/asm-generic/bitops/const_hweight.h.
> The use of that operator here results in a signed value.
>=20
> Fix by explicitly casting the __const_hweight8 macro expansion to
> 'unsigned int'.  While here, clean up several checkpatch.pl warnings.
>=20
> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
> Intended for v3.14.

Ping.  Just checking to see if you have any comments on this one, or if=20
you're planning to send it upstream for v3.14.


- Paul

>=20
>  include/asm-generic/bitops/const_hweight.h | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>=20
> diff --git a/include/asm-generic/bitops/const_hweight.h
> b/include/asm-generic/bitops/const_hweight.h
> index fa2a50b7ee66..40966203804d 100644
> --- a/include/asm-generic/bitops/const_hweight.h
> +++ b/include/asm-generic/bitops/const_hweight.h
> @@ -5,14 +5,15 @@
>   * Compile time versions of __arch_hweightN()
>   */
>  #define __const_hweight8(w)=09=09\
> -      (=09(!!((w) & (1ULL << 0))) +=09\
> -=09(!!((w) & (1ULL << 1))) +=09\
> -=09(!!((w) & (1ULL << 2))) +=09\
> -=09(!!((w) & (1ULL << 3))) +=09\
> -=09(!!((w) & (1ULL << 4))) +=09\
> -=09(!!((w) & (1ULL << 5))) +=09\
> -=09(!!((w) & (1ULL << 6))) +=09\
> -=09(!!((w) & (1ULL << 7)))=09)
> +=09((unsigned int)=09=09\
> +=09 ((!!((w) & (1ULL << 0))) +=09\
> +=09  (!!((w) & (1ULL << 1))) +=09\
> +=09  (!!((w) & (1ULL << 2))) +=09\
> +=09  (!!((w) & (1ULL << 3))) +=09\
> +=09  (!!((w) & (1ULL << 4))) +=09\
> +=09  (!!((w) & (1ULL << 5))) +=09\
> +=09  (!!((w) & (1ULL << 6))) +=09\
> +=09  (!!((w) & (1ULL << 7)))))
>=20
>  #define __const_hweight16(w) (__const_hweight8(w)  + __const_hweight8((w=
)  >>
> 8 ))
>  #define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((=
w) >>
> 16))
> --=20
> 1.8.5.1
>=20


- Paul
--843723315-1976742745-1390411198=:4071--
