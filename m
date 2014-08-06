Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbaHFMyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbaHFMyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:54:44 -0400
Message-ID: <53E22584.6060900@redhat.com>
Date: Wed, 06 Aug 2014 14:54:28 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [RFC 0/3] zram memory control enhance
References: <1407225723-23754-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1407225723-23754-1-git-send-email-minchan@kernel.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gQDWIgWAASktMnnXsxB0XEn8ITHcbR4uS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gQDWIgWAASktMnnXsxB0XEn8ITHcbR4uS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/05/2014 10:02 AM, Minchan Kim wrote:
> Notice! It's RFC. I didn't test at all but wanted to hear opinion
> during merge window when it's really busy time for Andrew so we could
> use the slack time to discuss without hurting him. ;-)
>=20
> Patch 1 is to move pages_allocated in zsmalloc from size_class to zs_po=
ol
> so zs_get_total_size_bytes of zsmalloc would be faster than old.
> zs_get_total_size_bytes could be used next patches frequently.
>=20
> Patch 2 adds new feature which exports how many of bytes zsmalloc consu=
mes
> during testing workload. Normally, before fixing the zram's disksize
> we have tested various workload and wanted to how many of bytes zram
> consumed.
> For it, we could poll mem_used_total of zram in userspace but the probl=
em is
> when memory pressure is severe and heavy swap out happens suddenly then=

> heavy swapin or exist while polling interval of user space is a few sec=
ond,
> it could miss max memory size zram had consumed easily.
> With lack of information, user can set wrong disksize of zram so the re=
sult
> is OOM. So this patch adds max_mem_used for zram and zsmalloc supports =
it
>=20
> Patch 3 is to limit zram memory consumption. Now, zram has no bound for=

> memory usage so it could consume up all of system memory. It makes syst=
em
> memory control for platform hard so I have heard the feature several ti=
me.
>=20
> Feedback is welcome!

Hi,

I haven't really reviewed the code yet, but I like the general idea. The
third patch in particular provides a very useful feature. I'm actually
surprised no one provided it earlier.

Jerome


>=20
> Minchan Kim (3):
>   zsmalloc: move pages_allocated to zs_pool
>   zsmalloc/zram: add zs_get_max_size_bytes and use it in zram
>   zram: limit memory size for zram
>=20
>  Documentation/blockdev/zram.txt |  2 ++
>  drivers/block/zram/zram_drv.c   | 58 +++++++++++++++++++++++++++++++++=
++++++++
>  drivers/block/zram/zram_drv.h   |  1 +
>  include/linux/zsmalloc.h        |  1 +
>  mm/zsmalloc.c                   | 50 +++++++++++++++++++++++++--------=
--
>  5 files changed, 98 insertions(+), 14 deletions(-)
>=20



--gQDWIgWAASktMnnXsxB0XEn8ITHcbR4uS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT4iWEAAoJEHTzHJCtsuoCKC8IAJAxYj2/9yBQfq9iuzFOMO92
rNS4uzlklsOEaMTS287Ut/NPmT7Ke5EBLHVRxZt0qhpJ54QtjIQ5Irv90kDZiOt+
J2gqZh0r05hf1WN8/BFvCqy/q4p9/T4v0l82IgAY9wrMnnUrCGn17gU48mSm+qmQ
OjzcfcXO/xsD1U+Cs0W/RDBjcO484Tui9BdffBRPtga8I1AA/tc0y9dYFiHF+0n6
Zrlmyk46o3UdFh4Oq3F/sugrmvLe7lqV3xZ9JXPOyu3wOm8YQwaoJfJ/SATTNwUT
y24wGfjiiY3CgLhCOzrKDtjTy3l6/LSQIveKPNNKEMjHy9kiNQQsUHjsQ5G7P4k=
=dkPB
-----END PGP SIGNATURE-----

--gQDWIgWAASktMnnXsxB0XEn8ITHcbR4uS--
