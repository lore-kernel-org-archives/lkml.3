Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbaAIJIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:08:36 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41184 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaAIJIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:08:19 -0500
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
Subject: Re: [PATCH 1/7] mm/page_alloc: synchronize get/set pageblock
In-Reply-To: <1389251087-10224-2-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com> <1389251087-10224-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140109:iamjoonsoo.kim@lge.com::vdMEso2TwIYL6JmO:0000000000000000000000000000000000000000B6c
X-Hashcash: 1:20:140109:tangchen@cn.fujitsu.com::lVZl2N3sspvA4Vgf:000000000000000000000000000000000000000MlJ
X-Hashcash: 1:20:140109:hannes@cmpxchg.org::VghNJQ11lS4Uxhf/:00000000000000000000000000000000000000000000cgc
X-Hashcash: 1:20:140109:iamjoonsoo.kim@lge.com::6hfu/5lqbznLkcXI:0000000000000000000000000000000000000000jJV
X-Hashcash: 1:20:140109:kirill.shutemov@linux.intel.com::CL4KUT5tRDrI92Z5:00000000000000000000000000000015RN
X-Hashcash: 1:20:140109:linux-mm@kvack.org::SAx17LZ07f50Kly/:0000000000000000000000000000000000000000000155c
X-Hashcash: 1:20:140109:js1304@gmail.com::J4u+riom/A7Bi0uO:01Li7
X-Hashcash: 1:20:140109:akpm@linux-foundation.org::ux4LMFwCvtEsVxPW:0000000000000000000000000000000000001TTL
X-Hashcash: 1:20:140109:linux-kernel@vger.kernel.org::ayhJCjEfoaB/Kg6e:00000000000000000000000000000000020cM
X-Hashcash: 1:20:140109:minchan@kernel.org::1lozXqSP8EwvHxyq:0000000000000000000000000000000000000000000393u
X-Hashcash: 1:20:140109:mhocko@suse.cz::jLJAVTkWXcrhln/X:0003mhW
X-Hashcash: 1:20:140109:ak@linux.intel.com::wV75IIv3keN8v9rq:00000000000000000000000000000000000000000003tOp
X-Hashcash: 1:20:140109:cody@linux.vnet.ibm.com::ZRV/Y02rc4Iu2NAt:000000000000000000000000000000000000005F9a
X-Hashcash: 1:20:140109:jiang.liu@huawei.com::YOjGu5SPknAQdu64:000000000000000000000000000000000000000005NPR
X-Hashcash: 1:20:140109:yongjun_wei@trendmicro.com.cn::AiHZLss0/hDCMOSJ:000000000000000000000000000000005TU2
X-Hashcash: 1:20:140109:riel@redhat.com::YP80euX6OQCANVRE:006DKP
X-Hashcash: 1:20:140109:mgorman@suse.de::c8XOXZ1CGfX6YdmI:008LCQ
Date: Thu, 09 Jan 2014 10:08:10 +0100
Message-ID: <xa1teh4hbk05.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09 2014, Joonsoo Kim wrote:
> @@ -5927,15 +5928,19 @@ unsigned long get_pageblock_flags_group(struct pa=
ge *page,
>  	unsigned long pfn, bitidx;
>  	unsigned long flags =3D 0;
>  	unsigned long value =3D 1;
> +	unsigned int seq;
>=20=20
>  	zone =3D page_zone(page);
>  	pfn =3D page_to_pfn(page);
>  	bitmap =3D get_pageblock_bitmap(zone, pfn);
>  	bitidx =3D pfn_to_bitidx(zone, pfn);
>=20=20
> -	for (; start_bitidx <=3D end_bitidx; start_bitidx++, value <<=3D 1)
> -		if (test_bit(bitidx + start_bitidx, bitmap))
> -			flags |=3D value;
> +	do {

+		flags =3D 0;

> +		seq =3D read_seqbegin(&zone->pageblock_seqlock);
> +		for (; start_bitidx <=3D end_bitidx; start_bitidx++, value <<=3D 1)
> +			if (test_bit(bitidx + start_bitidx, bitmap))
> +				flags |=3D value;
> +	} while (read_seqretry(&zone->pageblock_seqlock, seq));
>=20=20
>  	return flags;
>  }

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

iQIcBAEBAgAGBQJSzmb6AAoJECBgQBJQdR/0Ew4P/RsSxW22DyEt524wSIwWSYKS
aOVMs2Qv/t5xtuW5wHh1rjxmAAIEoZItYYsYaBHr1tbY0X1Uw0OwcZz6DcKBERlm
hSiAHVbg3K62V4LTq0Dj8QXzEgzQvXh9T8Kvin6QBzZIRHWHTHQZweHyPMDCy5Ny
4ATCcT8qEvzCTjq584TC1fYPJgG0X+ZjgTpxNdPzFBVXXrZwTrt7DRrlrVQCtdYb
3OQktscAGv4HlImUJQWRn2pn61eKqoJk4/OcmHQX5EHet2QUZ6Bp0nwy/V2Spyis
i1+e4OFc245eMTitDeNR6duI7K/n4IOmgsTePmj7C8uVp1XqdToW2Oic9BxN3td6
4NUw8pIz+f6Fj3BMxYPD5rvBXMAeZ9lxctXT/NTy2EYVWQvVeVN4NApj/WJZ9lD8
lVxb1f8relKG3xdj73juDaZUg9w/fV3b2fuJAKiybEYa5g23Rm5Xk5elZzT8NZKy
K5pGBsm18Chr1IZewBfQlVP/MR/M2LO2Dar3q2cTNo+VQJA3a11+gzd9u18hog+m
BCn4wazugDfhwLIpMNvKPQJbwKgbTRsrzbibSYt6kRUr6DL86Gh6IYcu0PwUivJK
t+x1yYttyZQAgRxosxkTGxMbqyOXEwo7ux56E1VCHQv9yPfEia9KHv1SiBp12HGT
D7vD5QTb9GkAlUDykK0o
=mRRG
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
