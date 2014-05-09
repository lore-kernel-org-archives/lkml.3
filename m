Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbaEIPoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:44:17 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53397 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaEIPoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:44:15 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] CMA: remove redundant retrying code in __alloc_contig_migrate_range
In-Reply-To: <1399509144-8898-2-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com> <1399509144-8898-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140509:iamjoonsoo.kim@lge.com::TESFHnDQVc6ItF7n:0000000000000000000000000000000000000000dZy
X-Hashcash: 1:20:140509:hannes@cmpxchg.org::gvLdQCyuEuYycmaz:00000000000000000000000000000000000000000000gQa
X-Hashcash: 1:20:140509:iamjoonsoo.kim@lge.com::xLrSo7AUpGIExFcb:0000000000000000000000000000000000000000S7H
X-Hashcash: 1:20:140509:m.szyprowski@samsung.com::BOOx9wCDJ98d7kky:000000000000000000000000000000000000015gF
X-Hashcash: 1:20:140509:riel@redhat.com::/jx7R2FDMgRaVIlv:002Hgm
X-Hashcash: 1:20:140509:linux-kernel@vger.kernel.org::EKY3qKinWEKGWGd4:0000000000000000000000000000000001/Vu
X-Hashcash: 1:20:140509:akpm@linux-foundation.org::ObeCDMIbIv3XQox6:00000000000000000000000000000000000025mA
X-Hashcash: 1:20:140509:mgorman@suse.de::H7HpknEYyVRBs4s2:002X9/
X-Hashcash: 1:20:140509:minchan@kernel.org::QpasDFc4iNPaqoer:00000000000000000000000000000000000000000002JPd
X-Hashcash: 1:20:140509:lauraa@codeaurora.org::eElI9U0wf/zVdS9w:00000000000000000000000000000000000000003S6g
X-Hashcash: 1:20:140509:heesub.shin@samsung.com::UOJ6jEmDigYNx2O4:0000000000000000000000000000000000000035Hd
X-Hashcash: 1:20:140509:linux-mm@kvack.org::sPXPBazAcS3zu/Mk:00000000000000000000000000000000000000000002wyc
Date: Fri, 09 May 2014 08:44:06 -0700
Message-ID: <xa1t7g5vx8hl.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, May 07 2014, Joonsoo Kim wrote:
> We already have retry logic in migrate_pages(). It does retry 10 times.
> So if we keep this retrying code in __alloc_contig_migrate_range(), we
> would try to migrate some unmigratable page in 50 times. There is just one
> small difference in -ENOMEM case. migrate_pages() don't do retry
> in this case, however, current __alloc_contig_migrate_range() does. But,
> I think that this isn't problem, because in this case, we may fail again
> with same reason.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

I think there was a reason for the retries in
__alloc_contig_migrate_range but perhaps those are no longer valid.

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5dba293..674ade7 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6185,7 +6185,6 @@ static int __alloc_contig_migrate_range(struct comp=
act_control *cc,
>  	/* This function is based on compact_zone() from compaction.c. */
>  	unsigned long nr_reclaimed;
>  	unsigned long pfn =3D start;
> -	unsigned int tries =3D 0;
>  	int ret =3D 0;
>=20=20
>  	migrate_prep();
> @@ -6204,10 +6203,6 @@ static int __alloc_contig_migrate_range(struct com=
pact_control *cc,
>  				ret =3D -EINTR;
>  				break;
>  			}
> -			tries =3D 0;
> -		} else if (++tries =3D=3D 5) {
> -			ret =3D ret < 0 ? ret : -EBUSY;
> -			break;
>  		}
>=20=20
>  		nr_reclaimed =3D reclaim_clean_pages_from_list(cc->zone,
> @@ -6216,6 +6211,10 @@ static int __alloc_contig_migrate_range(struct com=
pact_control *cc,
>=20=20
>  		ret =3D migrate_pages(&cc->migratepages, alloc_migrate_target,
>  				    0, MIGRATE_SYNC, MR_CMA);
> +		if (ret) {
> +			ret =3D ret < 0 ? ret : -EBUSY;
> +			break;
> +		}
>  	}
>  	if (ret < 0) {
>  		putback_movable_pages(&cc->migratepages);

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

iQIcBAEBAgAGBQJTbPfGAAoJECBgQBJQdR/0nJQP/0htX/xZxE1ePn5SBbCWts+2
Zx9ESFvp1aZEQKrPQ/u692Imj99GtbUntwK4NPH9ponpK9ErSFoONK8h1FP2hgLG
KF8IhmKSy3D2J37r/kLLmmSHJqw52uqIu1UefbUv3fDgHvULd9kKz0eRPNn4dJTv
9+Vv7AbW69v39Owwp2R84y7t5SrPGN/SlqABzii296zmGkXQrWkDwRFk17FJ/KqA
RkmMSzkR+hMmAfefd2WcFeUASJDqTDMTxBKiUmEs9/WKSbkTRVa+Z+MRvpnKBTDs
Ra6Ya13fbFDKAVXivZiU+fIJkxnCQmPUfbjoZQn6T9FwkC89aVZKnLyPldKcPKg5
BjtoX7/HWrK3ERrV+n3CjqwITZZ4kMWbY8O81PgmM0HFZKdunEdqZCj07O0og7G3
xW/zGGlpXRBeDQa6xAm08ZInl3PTt5yq89Sl6vrNmOsubjrNiP4HNfR5dSHk08Ly
69Cs3SpCrNp64IzISO8QjabCw7oGzZoMrl6bnWaHSmNllOZwkAPTGQjq4kS8kcH5
KAqtF0tgQZcqLRh8dnQI7/WS6r5ClcHnuKQpN+4XXXo6B00Dc0B7ypBMRlPYgKJ8
FoxIMP6HyFTxxEtrndpfC4q6jcleoBRSWXkOYFArFu6az9egW3wlIYCYUpGprDZh
Gt6W2uDFcn0rHqEJoXGl
=+M2V
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
