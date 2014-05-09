Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbaEIPs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:48:29 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38784 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995AbaEIPs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:48:26 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 1/2] mm/compaction: do not count migratepages when unnecessary
In-Reply-To: <1399464550-26447-1-git-send-email-vbabka@suse.cz>
Organization: http://mina86.com/
References: <alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com> <1399464550-26447-1-git-send-email-vbabka@suse.cz>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140509:hughd@google.com::GpYMkW2ohQ1he1PY:0037a
X-Hashcash: 1:20:140509:mgorman@suse.de::KbeKT+oKZNoyjFDy:000MZt
X-Hashcash: 1:20:140509:minchan@kernel.org::rEboEk9pP8l0/JQ3:00000000000000000000000000000000000000000000Gx1
X-Hashcash: 1:20:140509:riel@redhat.com::YEgiUlPdzlreBDc3:000+Re
X-Hashcash: 1:20:140509:akpm@linux-foundation.org::yRTOabealNra9dP0:0000000000000000000000000000000000000XCA
X-Hashcash: 1:20:140509:vbabka@suse.cz::Ncsebieqdbnh2T8W:0001//N
X-Hashcash: 1:20:140509:iamjoonsoo.kim@lge.com::X2gS3wH+aaBagiLK:0000000000000000000000000000000000000002gmm
X-Hashcash: 1:20:140509:gthelen@google.com::IMTae28G39rSElji:00000000000000000000000000000000000000000003JhO
X-Hashcash: 1:20:140509:vbabka@suse.cz::K9CarhtrWcmxwwj0:0004Z4o
X-Hashcash: 1:20:140509:linux-kernel@vger.kernel.org::eImvUiEG95333uFj:0000000000000000000000000000000005WQk
X-Hashcash: 1:20:140509:linux-mm@kvack.org::YnQXxH7buQWQPe3H:00000000000000000000000000000000000000000006Nz1
X-Hashcash: 1:20:140509:rientjes@google.com::lg+O9gZ6M+8wn1wl:0000000000000000000000000000000000000000006eX3
X-Hashcash: 1:20:140509:cl@linux.com::DDCdJkJLsgFrN6Y+:000007pqX
X-Hashcash: 1:20:140509:b.zolnierkie@samsung.com::2sRDgL1j86cCmgcj:00000000000000000000000000000000000006hBN
Date: Fri, 09 May 2014 08:48:19 -0700
Message-ID: <xa1ty4ybvtq4.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, May 07 2014, Vlastimil Babka wrote:
> During compaction, update_nr_listpages() has been used to count remaining
> non-migrated and free pages after a call to migrage_pages(). The freepages
> counting has become unneccessary, and it turns out that migratepages coun=
ting
> is also unnecessary in most cases.
>
> The only situation when it's needed to count cc->migratepages is when
> migrate_pages() returns with a negative error code. Otherwise, the non-ne=
gative
> return value is the number of pages that were not migrated, which is exac=
tly
> the count of remaining pages in the cc->migratepages list.
>
> Furthermore, any non-zero count is only interesting for the tracepoint of
> mm_compaction_migratepages events, because after that all remaining unmig=
rated
> pages are put back and their count is set to 0.
>
> This patch therefore removes update_nr_listpages() completely, and change=
s the
> tracepoint definition so that the manual counting is done only when the
> tracepoint is enabled, and only when migrate_pages() returns a negative e=
rror
> code.
>
> Furthermore, migrate_pages() and the tracepoints won't be called when the=
re's
> nothing to migrate. This potentially avoids some wasted cycles and reduce=
s the
> volume of uninteresting mm_compaction_migratepages events where "nr_migra=
ted=3D0
> nr_failed=3D0". In the stress-highalloc mmtest, this was about 75% of the=
 events.
> The mm_compaction_isolate_migratepages event is better for determining th=
at
> nothing was isolated for migration, and this one was just duplicating the=
 info.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

One tiny comment below:

> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> ---
>  v2: checkpack and other non-functional fixes suggested by Naoya Horiguchi
>
>  include/trace/events/compaction.h | 26 ++++++++++++++++++++++----
>  mm/compaction.c                   | 31 +++++++------------------------
>  2 files changed, 29 insertions(+), 28 deletions(-)
>
> diff --git a/include/trace/events/compaction.h b/include/trace/events/com=
paction.h
> index 06f544e..aacaf0f 100644
> --- a/include/trace/events/compaction.h
> +++ b/include/trace/events/compaction.h
> @@ -58,7 +61,22 @@ TRACE_EVENT(mm_compaction_migratepages,
>  	),
>=20=20
>  	TP_fast_assign(
> -		__entry->nr_migrated =3D nr_migrated;
> +		unsigned long nr_failed =3D 0;
> +		struct page *page;
> +
> +		/*
> +		 * migrate_pages() returns either a non-negative number
> +		 * with the number of pages that failed migration, or an
> +		 * error code, in which case we need to count the remaining
> +		 * pages manually
> +		 */
> +		if (migrate_rc >=3D 0)
> +			nr_failed =3D migrate_rc;
> +		else
> +			list_for_each_entry(page, migratepages, lru)
> +				nr_failed++;

list_for_each would suffice here.

> +
> +		__entry->nr_migrated =3D nr_all - nr_failed;
>  		__entry->nr_failed =3D nr_failed;
>  	),
>=20=20

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

iQIcBAEBAgAGBQJTbPjDAAoJECBgQBJQdR/0GgEP/2EgRhABRtUzNDgExK4GRmlW
ttL0MduqhASbq/uAfWAoWsiJAL8PgY1Yay8qGuHEUpYBoNEsRTktKAs4fR2qTatj
aCJ/PfLcBVamoxjsEbf4IF8DipWP7/+hoQrnw+FoRym5YrrGjHuOg6PHjQAsWQzm
Ob0lbLvFOP65Td2Wstyg5mk/WHmvOfh3DTsVfrKwE5mb4zsrZfebJxkF0vQ6p0C0
bvREQHBRbmTJa8kLi1InRkwcNXZ0JBEwFpt2IqBIM7IVTuMt/9kJ1AyimMkwxoI8
s0vqYFZ/WdzoivkyCP7n4H9kPa2CbFQ4kPnu6/cDAtfh/jkGZ8wXVuE64QsBttLp
ePphsQ9aWThm+9qNWF+UutoVvYnaGKiu2xMIdz1voRoWqh0mhBw8dnCZbLgmPqms
JKnWg7Cvk21XdApO2QJwfsYvEDAh6j+LMif5qtGJq0FBg0tlYDyJ4ivo4BeRyCEJ
86yDB88HeYaBqleD/06bFuqWx6Tq8YS/q4fdgc4Le84AngfyDakk6zydbfcLYWwr
T0uQLngIyH9useRwBL2yFzrwihygL1rdLP8gk67SpKjGue0p9CbWkKBjpnzDmZyi
sp6coruo0VgK/BOue5fyH43OtRn5CeMPs5f3zb6mVAaE5j4NVQuy85kwVTkehVxH
s4K2N26bPa98ZUypoVEU
=90Yo
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
