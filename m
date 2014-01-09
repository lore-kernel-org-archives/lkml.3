Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaAIJUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:20:11 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49498 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbaAIJTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:19:52 -0500
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
Subject: Re: [PATCH 6/7] mm/page_alloc: store freelist migratetype to the page on buddy properly
In-Reply-To: <1389251087-10224-7-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com> <1389251087-10224-7-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140109:akpm@linux-foundation.org::nOfiZZ8sAIoK9VKk:0000000000000000000000000000000000000NrE
X-Hashcash: 1:20:140109:iamjoonsoo.kim@lge.com::C8cA1JndooMzlZNf:0000000000000000000000000000000000000000LJH
X-Hashcash: 1:20:140109:cody@linux.vnet.ibm.com::eLZwybb9p0UCsTxO:000000000000000000000000000000000000000hEJ
X-Hashcash: 1:20:140109:jiang.liu@huawei.com::4YOkIM02d5H0Kelv:000000000000000000000000000000000000000000be1
X-Hashcash: 1:20:140109:hannes@cmpxchg.org::t0XS05NfB2L7ALjW:0000000000000000000000000000000000000000000113+
X-Hashcash: 1:20:140109:mgorman@suse.de::nx3bcKS0Arthvent:001OCO
X-Hashcash: 1:20:140109:tangchen@cn.fujitsu.com::n01I2HEYvwKGzPp+:000000000000000000000000000000000000001kMn
X-Hashcash: 1:20:140109:iamjoonsoo.kim@lge.com::zGu1htoMJcLNKvhJ:0000000000000000000000000000000000000002409
X-Hashcash: 1:20:140109:js1304@gmail.com::N32SsdDCUpDrTuq3:02k+M
X-Hashcash: 1:20:140109:riel@redhat.com::HZXlzmTPEcxku6Ku:002Wc4
X-Hashcash: 1:20:140109:minchan@kernel.org::z8qSBk51A3Uqfbpi:000000000000000000000000000000000000000000034JH
X-Hashcash: 1:20:140109:mhocko@suse.cz::Nk2QnXsPmLFPTewt:0003O9D
X-Hashcash: 1:20:140109:linux-kernel@vger.kernel.org::+PabEAW+4ogx9x8L:0000000000000000000000000000000004LTL
X-Hashcash: 1:20:140109:kirill.shutemov@linux.intel.com::eQt10G0Z0sk0Tjxw:0000000000000000000000000000005R4f
X-Hashcash: 1:20:140109:yongjun_wei@trendmicro.com.cn::Arv6jTCJVrC1SGnT:000000000000000000000000000000009HVg
X-Hashcash: 1:20:140109:ak@linux.intel.com::VhKHBdFRnplJ870G:0000000000000000000000000000000000000000000CuZw
X-Hashcash: 1:20:140109:linux-mm@kvack.org::ZaNIdRj3WOZFZ3Dy:000000000000000000000000000000000000000000099p3
Date: Thu, 09 Jan 2014 10:19:44 +0100
Message-ID: <xa1t8uupbjgv.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09 2014, Joonsoo Kim wrote:
> To maintain freelist migratetype information on buddy pages, migratetype
> should be set again whenever the page order is changed. set_page_order()
> is the best place to do, because it is called whenever the page order is
> changed, so this patch adds set_buddy_migratetype() to set_page_order().
>
> And this patch makes set/get_buddy_migratetype() only enabled if it is
> really needed, because it has some overhead.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>


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

iQIcBAEBAgAGBQJSzmmwAAoJECBgQBJQdR/01c4P/Ane1F6g9Fyos/HioQHFOTyT
qElpv05RKxm+fQ6zBraYsXxqtybmVeaxm9CLV3ara5lgyFbRlsWYuLGNeVPrs7P9
4GzdiK1Cd16f6F7ljLQ3SdZO0JgumR0hItG1eV5pR32XGmgZkTPJTfAKBtDNnsO+
QDW6WqNL4GAK5k5m9PGpj9h0RAdQK/FhiiK00rjiPkCm+tqsHw4rJrBusOwUKPrv
rRSsLRUTPhFLXM6EEL6+BrrdZ6ONjCci9Gq6PImIElz2+QTkNg5qcEMHeIE7phLQ
n0LKZ4ojcdTzfRE5vu3w9iCzl8LLlww48HgRcru0faitpNcrs3cVU/h/i4kJ1YWM
gWx2l+qwi30C5Rxlx6Kg9wJq/rBw+ZZSe/HE3ndbsL55JyQhJFSDkD0JR4OSbJ/d
nLNJPsU3u0X5stHeDSfNakc2S/drDvNsR0JOWtLmme2ruUBjz2MrYNWqGDAaYcNf
RkEpln08lsKrNpOdHZK9bUdzVxnADW3nZaJGYu0s1ZNgfg7Ug/CqGg0Mr+uSznW/
YZSeruDxaMFGlckkkwIkYc7IKRz6/wh3jQ2YxPepPOEw5a6uUxIPXoM19EcsKTh+
KL7bEp96FhnH1Us3N/cYLqacRlsIARQVXYx7ydLzsRB5UiKnVu/3pDgJDoGVd29c
ozr6HnxHAPC2a7AaX+js
=CZkg
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
