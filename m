Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab3FMORL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 10:17:11 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:45255 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab3FMORH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 10:17:07 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Tang Chen <tangchen@cn.fujitsu.com>, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Part3 PATCH v2 1/4] bootmem, mem-hotplug: Register local pagetable pages with LOCAL_NODE_DATA when freeing bootmem.
In-Reply-To: <1371128636-9027-2-git-send-email-tangchen@cn.fujitsu.com>
Organization: http://mina86.com/
References: <1371128636-9027-1-git-send-email-tangchen@cn.fujitsu.com> <1371128636-9027-2-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.10 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:130613:jiang.liu@huawei.com::Is7M7ITRGsSjX0tS:000000000000000000000000000000000000000000GSv
X-Hashcash: 1:20:130613:akpm@linux-foundation.org::8d4glBN25AqmPDSa:00000000000000000000000000000000000009oU
X-Hashcash: 1:20:130613:jweiner@redhat.com::P7fqu8Oua5yXn+WK:00000000000000000000000000000000000000000001k4h
X-Hashcash: 1:20:130613:riel@redhat.com::/ST+q/w9ieJc5xHr:001qyt
X-Hashcash: 1:20:130613:gong.chen@linux.intel.com::gEcG3dHAU5lAslnB:0000000000000000000000000000000000000Ntb
X-Hashcash: 1:20:130613:mgorman@suse.de::rSOneEzB0ASJIbpz:001+5J
X-Hashcash: 1:20:130613:isimatu.yasuaki@jp.fujitsu.com::7yH1eduMmUyk6dgZ:00000000000000000000000000000000TaH
X-Hashcash: 1:20:130613:laijs@cn.fujitsu.com::YY0fX58bb7jfKmMo:000000000000000000000000000000000000000000Sgl
X-Hashcash: 1:20:130613:hpa@zytor.com::dWYjwPxuzbRsMizT:00001hsJ
X-Hashcash: 1:20:130613:wency@cn.fujitsu.com::/GGdfLx7nKqKxzgx:000000000000000000000000000000000000000002J0K
X-Hashcash: 1:20:130613:prarit@redhat.com::F4sar5vNxgAlIDJj:000000000000000000000000000000000000000000002HKp
X-Hashcash: 1:20:130613:tj@kernel.org::N3NErBRhNIgCsWOv:00002Qde
X-Hashcash: 1:20:130613:linux-doc@vger.kernel.org::lTVvmDzrlcsrDr4y:0000000000000000000000000000000000002chg
X-Hashcash: 1:20:130613:trenn@suse.de::7ScL+3WWfNkWNc/z:00002uBm
X-Hashcash: 1:20:130613:linux-kernel@vger.kernel.org::02+FltXg2NTfqZMk:0000000000000000000000000000000002iz+
X-Hashcash: 1:20:130613:vasilis.liaskovitis@profitbricks.com::C2Z4qb8OTgpGJpMM:000000000000000000000000037G0
X-Hashcash: 1:20:130613:tangchen@cn.fujitsu.com::avFJua3NdL8MxXw7:000000000000000000000000000000000000003jUA
X-Hashcash: 1:20:130613:x86@kernel.org::TXWekbe2xSTC9+ip:00042vi
X-Hashcash: 1:20:130613:tglx@linutronix.de::FfxcDviKhy04z8aS:00000000000000000000000000000000000000000005w5a
X-Hashcash: 1:20:130613:lwoodman@redhat.com::nnb0PNb7SRajHCgs:0000000000000000000000000000000000000000004FzZ
X-Hashcash: 1:20:130613:mingo@elte.hu::TPsljwnc1q6mkrhe:00006HC7
X-Hashcash: 1:20:130613:linux-mm@kvack.org::GzK79FxSBU9mbcy9:00000000000000000000000000000000000000000008jJB
X-Hashcash: 1:20:130613:yinghai@kernel.org::H2+hYPzY+HWeDBwV:00000000000000000000000000000000000000000008xsU
X-Hashcash: 1:20:130613:minchan@kernel.org::TMUtHYfE8RQXK9lM:0000000000000000000000000000000000000000000Gp+k
Date: Thu, 13 Jun 2013 16:16:58 +0200
Message-ID: <xa1tli6ef63p.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13 2013, Tang Chen wrote:
> As Yinghai suggested, even if a node is movable node, which has only
> ZONE_MOVABLE, pagetables should be put in the local node.
>
> In memory hot-remove logic, it offlines all pages first, and then
> removes pagetables. But the local pagetable pages cannot be offlined
> because they are used by kernel.
>
> So we should skip this kind of pages in offline procedure. But first
> of all, we need to mark them.
>
> This patch marks local node data pages in the same way as we mark the
> SECTION_INFO and MIX_SECTION_INFO data pages. We introduce a new type
> of bootmem: LOCAL_NODE_DATA. And use page->lru.next to mark this type
> of memory.
>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  arch/x86/mm/init_64.c          |    2 +
>  include/linux/memblock.h       |   22 +++++++++++++++++
>  include/linux/memory_hotplug.h |   13 ++++++++-
>  mm/memblock.c                  |   52 ++++++++++++++++++++++++++++++++++=
++++++
>  mm/memory_hotplug.c            |   26 ++++++++++++++++++++
>  5 files changed, 113 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index bb00c46..25de304 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1053,6 +1053,8 @@ static void __init register_page_bootmem_info(void)
>=20=20
>  	for_each_online_node(i)
>  		register_page_bootmem_info_node(NODE_DATA(i));
> +
> +	register_page_bootmem_local_node();
>  #endif
>  }
>=20=20
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index a85ced9..8a38eef 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -131,6 +131,28 @@ void __next_free_mem_range_rev(u64 *idx, int nid, ph=
ys_addr_t *out_start,
>  	     i !=3D (u64)ULLONG_MAX;					\
>  	     __next_free_mem_range_rev(&i, nid, p_start, p_end, p_nid))
>=20=20
> +void __next_local_node_mem_range(int *idx, int nid, phys_addr_t *out_sta=
rt,
> +				 phys_addr_t *out_end, int *out_nid);

Why not make it return int?

> +
> +/**
> + * for_each_local_node_mem_range - iterate memblock areas storing local =
node
> + *                                 data
> + * @i: int used as loop variable
> + * @nid: node selector, %MAX_NUMNODES for all nodes
> + * @p_start: ptr to phys_addr_t for start address of the range, can be %=
NULL
> + * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
> + * @p_nid: ptr to int for nid of the range, can be %NULL
> + *
> + * Walks over memblock areas storing local node data. Since all the loca=
l node
> + * areas will be reserved by memblock, this iterator will only iterate
> + * memblock.reserve. Available as soon as memblock is initialized.
> + */
> +#define for_each_local_node_mem_range(i, nid, p_start, p_end, p_nid)	   =
 \
> +	for (i =3D -1,							    \
> +	     __next_local_node_mem_range(&i, nid, p_start, p_end, p_nid);   \
> +	     i !=3D -1;							    \
> +	     __next_local_node_mem_range(&i, nid, p_start, p_end, p_nid))
> +

If __next_local_node_mem_range() returned int, this would be easier:

+#define for_each_local_node_mem_range(i, nid, p_start, p_end, p_nid)	     =
 \
+	for (i =3D -1;
+	     (i =3D __next_local_node_mem_range(i, nid, p_start, p_end, p_nid)) !=
=3D -1; )

>  #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
>  int memblock_set_node(phys_addr_t base, phys_addr_t size, int nid);
>=20=20
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplu=
g.h
> index 0b21e54..c0c4107 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h

> +/**
> + * __next_local_node_mem_range - next function for
> + *                               for_each_local_node_mem_range()
> + * @idx: pointer to int loop variable
> + * @nid: node selector, %MAX_NUMNODES for all nodes
> + * @out_start: ptr to phys_addr_t for start address of the range, can be=
 %NULL
> + * @out_end: ptr to phys_addr_t for end address of the range, can be %NU=
LL
> + * @out_nid: ptr to int for nid of the range, can be %NULL
> + */
> +void __init_memblock __next_local_node_mem_range(int *idx, int nid,
> +					phys_addr_t *out_start,
> +					phys_addr_t *out_end, int *out_nid)
> +{
> +	__next_flag_mem_range(idx, nid, MEMBLK_LOCAL_NODE,
> +			      out_start, out_end, out_nid);
> +}

static inline in a header file perhaps?

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRudRaAAoJECBgQBJQdR/0WPwP/1dgJxcQSzLTWaUb1P4pkJA9
SMs6dBSola+wGugLvaLxZ6IQXmpMUZj+lXZiO0H1iXo+A9WVLbDae8BTUGgjLVAD
MAi0nMfcbjzxuVQAB53xV0N2Yoc1uuZf6eUlCD8WAEdrH3vn4DR3o8XRVNAvVY+S
WmLDWk8LdSsF78mqR0NRyT8YvmpdnKTZTu5ffI/0/BVwhJu+8Jz/GtC4QB5v8red
CJNrLIQmuAS+mIi6721RsvuYjaqYDfd3r4gIJjhxw5pMv97tHFgEXfZOuvO3RuBy
zg0NzLbJ8q6uD8BVxQPA559tMJ5rmFneksnhHkFIuAI3imuw+B2gQt8vRbz06EZL
VdiRzp6THTp8GDK+BmdxtvjDRblD6g83/kxeLTbIEoGLg+5qzXuBePpoQfTeK4+H
ThxLTkW59Xs1s+xc0bqiDiTBzKmBrUDojcrAq2DFFuUR7ub9TU6WhOv1FDygZRB1
ZNctpc0EyNkm++cYS5/ARCMA5v6vRPwdFI9TgbOXiRC/uIjhksalsBz839NDCbxG
0fy84YJPdXTImxyRdfgl+ECaDDrIMpFK5Jrvc6MCiV/YM57AYdBToHZ0/zJ6Tq1i
7Q0vdotsVZ2vgNlh0rXBwlTV6Si0NIqZuwe6ezWzLHUPP0e5kE197TGokpCp5k3U
kG1Sd3zHCdgF7OVBvNFB
=udWL
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
