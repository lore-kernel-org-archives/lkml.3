Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbaAIJXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:23:33 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61121 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaAIJWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:22:12 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        Mel Gorman <mgorman@suse.de>, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 7/7] mm/page_alloc: don't merge MIGRATE_(CMA|ISOLATE) pages on buddy
In-Reply-To: <1389251087-10224-8-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com> <1389251087-10224-8-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140109:linux-kernel@vger.kernel.org::RphoQIjoM9LV07R7:00000000000000000000000000000000001uQ
X-Hashcash: 1:20:140109:yongjun_wei@trendmicro.com.cn::tM99tOQzUZnsyqFE:000000000000000000000000000000000alT
X-Hashcash: 1:20:140109:iamjoonsoo.kim@lge.com::ntUPk1ED9BEr0jR0:0000000000000000000000000000000000000000ZlG
X-Hashcash: 1:20:140109:kirill.shutemov@linux.intel.com::7S4QXEFQuWmEKaQn:0000000000000000000000000000000uVt
X-Hashcash: 1:20:140109:mgorman@suse.de::K6Mi2fkhcTS57C41:001AxB
X-Hashcash: 1:20:140109:tangchen@cn.fujitsu.com::7Bmj3k0WMeftAk0y:000000000000000000000000000000000000000wTZ
X-Hashcash: 1:20:140109:linux-mm@kvack.org::DXFig+S22B+Met13:00000000000000000000000000000000000000000001MV5
X-Hashcash: 1:20:140109:mhocko@suse.cz::AVmyIBA53MtRjjKZ:0001dJ5
X-Hashcash: 1:20:140109:hannes@cmpxchg.org::bRNNbzh9RX3asE7l:000000000000000000000000000000000000000000028yE
X-Hashcash: 1:20:140109:riel@redhat.com::MZArinu+/RqB/MTE:002ePB
X-Hashcash: 1:20:140109:cody@linux.vnet.ibm.com::jF52nVIYGz15UdYm:000000000000000000000000000000000000002PRT
X-Hashcash: 1:20:140109:jiang.liu@huawei.com::ddw91mKCrgvO5Bt0:000000000000000000000000000000000000000003WHz
X-Hashcash: 1:20:140109:iamjoonsoo.kim@lge.com::l1gKuEYbzO9FhfBe:0000000000000000000000000000000000000005wFY
X-Hashcash: 1:20:140109:js1304@gmail.com::m9dJbwiwe0CI8+c/:092Ja
X-Hashcash: 1:20:140109:ak@linux.intel.com::7HhRCNIBMW5v05Cq:00000000000000000000000000000000000000000009QGo
X-Hashcash: 1:20:140109:akpm@linux-foundation.org::thunFytmzktdiFdK:000000000000000000000000000000000000BvWc
X-Hashcash: 1:20:140109:minchan@kernel.org::IEJyJ+tatijw71Sm:0000000000000000000000000000000000000000000Ef+u
Date: Thu, 09 Jan 2014 10:22:02 +0100
Message-ID: <xa1t61ptbjd1.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09 2014, Joonsoo Kim wrote:
> If (MAX_ORDER-1) is greater than pageblock order, there is a possibility
> to merge different migratetype pages and to be linked in unintended
> freelist.
>
> While I test CMA, CMA pages are merged and linked into MOVABLE freelist
> by above issue and then, the pages change their migratetype to UNMOVABLE =
by
> try_to_steal_freepages(). After that, CMA to this region always fail.
>
> To prevent this, we should not merge the page on MIGRATE_(CMA|ISOLATE)
> freelist.

This is strange.  CMA regions are always multiplies of max-pages (or
pageblocks whichever is larger), so MOVABLE free pages should never be
inside of a CMA region.

If what you're describing happens, it looks like an issue somewhere
else.

> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2548b42..ea99cee 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -581,6 +581,15 @@ static inline void __free_one_page(struct page *page,
>  			__mod_zone_freepage_state(zone, 1 << order,
>  						  migratetype);
>  		} else {
> +			int buddy_mt =3D get_buddy_migratetype(buddy);
> +
> +			/* We don't want to merge cma, isolate pages */
> +			if (unlikely(order >=3D pageblock_order) &&
> +				migratetype !=3D buddy_mt &&
> +				(migratetype >=3D MIGRATE_PCPTYPES ||
> +				buddy_mt >=3D MIGRATE_PCPTYPES)) {
> +				break;
> +			}
>  			list_del(&buddy->lru);
>  			zone->free_area[order].nr_free--;
>  			rmv_page_order(buddy);
> --=20
> 1.7.9.5
>

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSzmo6AAoJECBgQBJQdR/0hXcP+gNcSKtRGUP6Z1/0L4u+rMIp
oJqXjZ1M6kSzqPYeTEZhHqJLOMLYJfEmDAzUkP3xeVvnqv0HatHjcn5JDklkv9PT
gOQ1sflANnIwIw930rVLQQM5s0QhR4gic+CnJ7Sc9YPadopn1l+JQHy/93ylXruU
/+g23QCFS+uQoQZ6HqhJS2AXXworLMTi9IA/YA1PuMXLDpnlhLFh9tkeJeWIR+rX
Frr7U35NeZtWyKbHSZttULJGFAtscD0mdHP79Bnqzosyqi92HyjSoIjzOCe4ptkM
FMie0i9Rx/NiRVRNOzQrsI7ryr1RR/lXhbcmTYyvMfxBuzbXW3/r1gQEIuJvDpJ/
Us9zl2ayWpFvjgBE9m/4vawZO/+PGVsv74iVcL60KgEuftAPyYHqkYeAf8cI8WOh
CgKpR6oyUOFp81kX0GeEJ2b5JJh+lOzmufg4Ow1eLgQWpBY/u02hQ/sLyEpHgqiu
ZfgYBNP5horayy6VqIrnw1/oIBg2CUp31RQtJ5sB+AaGHTtd7cw1X8PblLWRJvsn
ErdJKRJV1fe/bnwD3EEt5iI8Y9oCOB6mTI5pHWhdIunBEG0//J8qYpqk+U9jfB6Q
BsLwO55NOyC5MzRmaXLcLGmmn+ENfPDrcugtmwqOK1SNKK2NOKN6Q0cGuu0Sa+8Z
2fcUX72K8i+6h1sDR1vt
=vPh+
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
