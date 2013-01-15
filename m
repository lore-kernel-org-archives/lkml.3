Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab3AOInw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 03:43:52 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:53863 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab3AOInt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 03:43:49 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v2] mm: remove MIGRATE_ISOLATE check in hotpath
In-Reply-To: <1358209006-18859-1-git-send-email-minchan@kernel.org>
Organization: http://mina86.com/
References: <1358209006-18859-1-git-send-email-minchan@kernel.org>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.5 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Tue, 15 Jan 2013 09:43:31 +0100
Message-ID: <xa1t1udmsuoc.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 15 2013, Minchan Kim wrote:
> Now mm several functions test MIGRATE_ISOLATE and some of those
> are hotpath but MIGRATE_ISOLATE is used only if we enable
> CONFIG_MEMORY_ISOLATION(ie, CMA, memory-hotplug and memory-failure)
> which are not common config option. So let's not add unnecessary
> overhead and code when we don't enable CONFIG_MEMORY_ISOLATION.
>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  include/linux/mmzone.h         |    2 ++
>  include/linux/page-isolation.h |   19 +++++++++++++++++++
>  mm/compaction.c                |    6 +++++-
>  mm/page_alloc.c                |   16 ++++++++++------
>  mm/vmstat.c                    |    2 ++
>  5 files changed, 38 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 73b64a3..4f4c8c2 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -57,7 +57,9 @@ enum {
>  	 */
>  	MIGRATE_CMA,
>  #endif
> +#ifdef CONFIG_MEMORY_ISOLATION
>  	MIGRATE_ISOLATE,	/* can't allocate from here */
> +#endif
>  	MIGRATE_TYPES
>  };
>=20=20
> diff --git a/include/linux/page-isolation.h b/include/linux/page-isolatio=
n.h
> index a92061e..3fff8e7 100644
> --- a/include/linux/page-isolation.h
> +++ b/include/linux/page-isolation.h
> @@ -1,6 +1,25 @@
>  #ifndef __LINUX_PAGEISOLATION_H
>  #define __LINUX_PAGEISOLATION_H
>=20=20
> +#ifdef CONFIG_MEMORY_ISOLATION
> +static inline bool is_migrate_isolate_page(struct page *page)
> +{
> +	return get_pageblock_migratetype(page) =3D=3D MIGRATE_ISOLATE;
> +}
> +static inline bool is_migrate_isolate(int migratetype)
> +{
> +	return migratetype =3D=3D MIGRATE_ISOLATE;
> +}
> +#else
> +static inline bool is_migrate_isolate_page(struct page *page)
> +{
> +	return false;
> +}
> +static inline bool is_migrate_isolate(int migratetype)
> +{
> +	return false;
> +}
> +#endif
>=20=20
>  bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
>  			 bool skip_hwpoisoned_pages);
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 675937c..bb2a655 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -15,6 +15,7 @@
>  #include <linux/sysctl.h>
>  #include <linux/sysfs.h>
>  #include <linux/balloon_compaction.h>
> +#include <linux/page-isolation.h>
>  #include "internal.h"
>=20=20
>  #ifdef CONFIG_COMPACTION
> @@ -215,7 +216,10 @@ static bool suitable_migration_target(struct page *p=
age)
>  	int migratetype =3D get_pageblock_migratetype(page);
>=20=20
>  	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks=
 */
> -	if (migratetype =3D=3D MIGRATE_ISOLATE || migratetype =3D=3D MIGRATE_RE=
SERVE)
> +	if (migratetype =3D=3D MIGRATE_RESERVE)
> +		return false;
> +
> +	if (is_migrate_isolate(migratetype))
>  		return false;
>=20=20
>  	/* If the page is a large free page, then allow migration */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 82117f5..319a8f0 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -665,7 +665,7 @@ static void free_pcppages_bulk(struct zone *zone, int=
 count,
>  			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
>  			__free_one_page(page, zone, 0, mt);
>  			trace_mm_page_pcpu_drain(page, 0, mt);
> -			if (likely(get_pageblock_migratetype(page) !=3D MIGRATE_ISOLATE)) {
> +			if (likely(!is_migrate_isolate_page(page))) {
>  				__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
>  				if (is_migrate_cma(mt))
>  					__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
> @@ -683,7 +683,7 @@ static void free_one_page(struct zone *zone, struct p=
age *page, int order,
>  	zone->pages_scanned =3D 0;
>=20=20
>  	__free_one_page(page, zone, order, migratetype);
> -	if (unlikely(migratetype !=3D MIGRATE_ISOLATE))
> +	if (unlikely(!is_migrate_isolate(migratetype)))
>  		__mod_zone_freepage_state(zone, 1 << order, migratetype);
>  	spin_unlock(&zone->lock);
>  }
> @@ -911,7 +911,9 @@ static int fallbacks[MIGRATE_TYPES][4] =3D {
>  	[MIGRATE_MOVABLE]     =3D { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE,   M=
IGRATE_RESERVE },
>  #endif
>  	[MIGRATE_RESERVE]     =3D { MIGRATE_RESERVE }, /* Never used */
> +#ifdef CONFIG_MEMORY_ISOLATION
>  	[MIGRATE_ISOLATE]     =3D { MIGRATE_RESERVE }, /* Never used */
> +#endif
>  };
>=20=20
>  /*
> @@ -1137,7 +1139,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned=
 int order,
>  			list_add_tail(&page->lru, list);
>  		if (IS_ENABLED(CONFIG_CMA)) {
>  			mt =3D get_pageblock_migratetype(page);
> -			if (!is_migrate_cma(mt) && mt !=3D MIGRATE_ISOLATE)
> +			if (!is_migrate_cma(mt) && !is_migrate_isolate(mt))
>  				mt =3D migratetype;
>  		}
>  		set_freepage_migratetype(page, mt);
> @@ -1321,7 +1323,7 @@ void free_hot_cold_page(struct page *page, int cold)
>  	 * excessively into the page allocator
>  	 */
>  	if (migratetype >=3D MIGRATE_PCPTYPES) {
> -		if (unlikely(migratetype =3D=3D MIGRATE_ISOLATE)) {
> +		if (unlikely(is_migrate_isolate(migratetype))) {
>  			free_one_page(zone, page, 0, migratetype);
>  			goto out;
>  		}
> @@ -1402,7 +1404,7 @@ int capture_free_page(struct page *page, int alloc_=
order, int migratetype)
>  	order =3D page_order(page);
>  	mt =3D get_pageblock_migratetype(page);
>=20=20
> -	if (mt !=3D MIGRATE_ISOLATE) {
> +	if (!is_migrate_isolate(mt)) {
>  		/* Obey watermarks as if the page was being allocated */
>  		watermark =3D low_wmark_pages(zone) + (1 << order);
>  		if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
> @@ -1425,7 +1427,7 @@ int capture_free_page(struct page *page, int alloc_=
order, int migratetype)
>  		struct page *endpage =3D page + (1 << order) - 1;
>  		for (; page < endpage; page +=3D pageblock_nr_pages) {
>  			int mt =3D get_pageblock_migratetype(page);
> -			if (mt !=3D MIGRATE_ISOLATE && !is_migrate_cma(mt))
> +			if (!is_migrate_isolate(mt) && !is_migrate_cma(mt))
>  				set_pageblock_migratetype(page,
>  							  MIGRATE_MOVABLE);
>  		}
> @@ -2911,7 +2913,9 @@ static void show_migration_types(unsigned char type)
>  #ifdef CONFIG_CMA
>  		[MIGRATE_CMA]		=3D 'C',
>  #endif
> +#ifdef CONFIG_MEMORY_ISOLATION
>  		[MIGRATE_ISOLATE]	=3D 'I',
> +#endif
>  	};
>  	char tmp[MIGRATE_TYPES + 1];
>  	char *p =3D tmp;
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 7a65e26..b0f1db1 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -628,7 +628,9 @@ static char * const migratetype_names[MIGRATE_TYPES] =
=3D {
>  #ifdef CONFIG_CMA
>  	"CMA",
>  #endif
> +#ifdef CONFIG_MEMORY_ISOLATION
>  	"Isolate",
> +#endif
>  };
>=20=20
>  static void *frag_start(struct seq_file *m, loff_t *pos)

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
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQ9RazAAoJECBgQBJQdR/0YI8P+gJOvIC2wgbZfPxTTZRn88y2
BUCtbvf8PmMe9tukoWBa9wm0ftXOLyiD0jPbJGN2wL+fTMW4oI8U4GVS2QjV7veP
RClnTr2FZRlvgPJaxSvgj42Xf6IOIlppkm5o781CULTOqDKtOBgcZ4OdBjUYSuBa
IgPISVt7Nnt43LW0PjLePQPUbIefuJZLFBnPTuCcxs333DIhOdbR3sYnykOCiFgM
Nsf8rkE8Ru8bWQ10YzcQYO1WmVFMSvApbWdFMBgiDhjl5oIIWS3IQHgBdnmYcCc7
9FyXxIR/w3lunvOLNTbb0B4lYmdL8WpNr0qsR9N6PLfloki26tz2PUrr8YfYCMkf
yQdU7D1K4nNz4xExQHcASpIArLXll0o54kuDsMIRU8uQ6mJ0xincYciP/Uo5h0GK
kvHXtC9yMpZduhS2EY9lpyzCasbDFiFXWG2HUhf4DLnFFhMuYrg+WP6tSI2fDNAg
zSPIhvvhjicGQ6dY8tUISwXPPcMD/OmN46MuYaERiXG0+JrmPy6hBc6V8YZ4LgQG
z6UnIdonpIwxNJCNsF9uUDj84MqTqEqkxxfCocqmrnHYCTUe44kBFIi1aVojdV3m
uCdzBtWxEq4POWbSzH4zdhN9oz9Wt3BfHBM1r7jMU2CBWS8HTgpTINk4nzW+T1aF
aDWZGxVbATCqF5aP6hOJ
=vhi+
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
