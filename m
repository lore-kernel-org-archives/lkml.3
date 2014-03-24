Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaCXOLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:11:53 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:64632 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaCXOLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:11:51 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Laura Abbott <lauraa@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Circular locking dependency - DRM/CMA/MM/hotplug/...
In-Reply-To: <532C8941.4090104@codeaurora.org>
Organization: http://mina86.com/
References: <20140211183543.GK26684@n2100.arm.linux.org.uk> <52FB9602.1000805@samsung.com> <20140212163317.GQ26684@n2100.arm.linux.org.uk> <53036D51.2070502@samsung.com> <xa1t8ut8wc2f.fsf@mina86.com> <532C8941.4090104@codeaurora.org>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140324:airlied@linux.ie::wJLgfxNi6okF16PC:00F6m
X-Hashcash: 1:20:140324:linux@arm.linux.org.uk::E7uYnj000hMAzt73:0000000000000000000000000000000000000000K//
X-Hashcash: 1:20:140324:dri-devel@lists.freedesktop.org::P4dqQLOKZ8zjysyG:0000000000000000000000000000002rJu
X-Hashcash: 1:20:140324:linux-kernel@vger.kernel.org::oVveyJEF1lQT5bXe:0000000000000000000000000000000004muY
X-Hashcash: 1:20:140324:lauraa@codeaurora.org::EYt7jaeV5hdwpYnc:00000000000000000000000000000000000000008bKU
X-Hashcash: 1:20:140324:m.szyprowski@samsung.com::McPJczc16j2+JeO5:00000000000000000000000000000000000008OQb
X-Hashcash: 1:20:140324:linux-arm-kernel@lists.infradead.org::tPejXEhipxkttbgC:0000000000000000000000000CecE
Date: Mon, 24 Mar 2014 15:11:41 +0100
Message-ID: <xa1tlhvzn0te.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 21 2014, Laura Abbott wrote:
> From: Laura Abbott <lauraa@codeaurora.org>
> Date: Tue, 25 Feb 2014 11:01:19 -0800
> Subject: [PATCH] cma: Remove potential deadlock situation
>
> CMA locking is currently very coarse. The cma_mutex protects both
> the bitmap and avoids concurrency with alloc_contig_range. There
> are several situations which may result in a deadlock on the CMA
> mutex currently, mostly involving AB/BA situations with alloc and
> free. Fix this issue by protecting the bitmap with a mutex per CMA
> region and use the existing mutex for protecting against concurrency
> with alloc_contig_range.
>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

Furthermore, since CMA regions are always MAX_ORDER-page or pageblock
(whichever is bigger) aligned, we could use two mutexes per CMA region:
one protecting the bitmap and the other one protecting calls to
alloc_contig_range touching given region.

On the other hand, we could also go the other way and have two global
mutexes: one protecting all the bitmaps in all the regions and another
protecting calls to alloc_contig_range.

Either way, I think the below patch should work and fix the problem.

> ---
>  drivers/base/dma-contiguous.c | 32 +++++++++++++++++++++++++-------
>  1 file changed, 25 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 165c2c2..dfb48ef 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -37,6 +37,7 @@ struct cma {
>  	unsigned long	base_pfn;
>  	unsigned long	count;
>  	unsigned long	*bitmap;
> +	struct mutex	lock;
>  };
>=20=20
>  struct cma *dma_contiguous_default_area;
> @@ -161,6 +162,7 @@ static int __init cma_activate_area(struct cma *cma)
>  		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
>  	} while (--i);
>=20=20
> +	mutex_init(&cma->lock);
>  	return 0;
>  }
>=20=20
> @@ -261,6 +263,13 @@ err:
>  	return ret;
>  }
>=20=20
> +static void clear_cma_bitmap(struct cma *cma, unsigned long pfn, int cou=
nt)
> +{
> +	mutex_lock(&cma->lock);
> +	bitmap_clear(cma->bitmap, pfn - cma->base_pfn, count);
> +	mutex_unlock(&cma->lock);
> +}
> +
>  /**
>   * dma_alloc_from_contiguous() - allocate pages from contiguous area
>   * @dev:   Pointer to device for which the allocation is performed.
> @@ -294,30 +303,41 @@ struct page *dma_alloc_from_contiguous(struct devic=
e *dev, int count,
>=20=20
>  	mask =3D (1 << align) - 1;
>=20=20
> -	mutex_lock(&cma_mutex);
>=20=20
>  	for (;;) {
> +		mutex_lock(&cma->lock);
>  		pageno =3D bitmap_find_next_zero_area(cma->bitmap, cma->count,
>  						    start, count, mask);
> -		if (pageno >=3D cma->count)
> +		if (pageno >=3D cma->count) {
> +			mutex_unlock(&cma_mutex);
>  			break;
> +		}
> +		bitmap_set(cma->bitmap, pageno, count);
> +		/*
> +		 * It's safe to drop the lock here. We've marked this region for
> +		 * our exclusive use. If the migration fails we will take the
> +		 * lock again and unmark it.
> +		 */
> +		mutex_unlock(&cma->lock);
>=20=20
>  		pfn =3D cma->base_pfn + pageno;
> +		mutex_lock(&cma_mutex);
>  		ret =3D alloc_contig_range(pfn, pfn + count, MIGRATE_CMA);
> +		mutex_unlock(&cma_mutex);
>  		if (ret =3D=3D 0) {
> -			bitmap_set(cma->bitmap, pageno, count);
>  			page =3D pfn_to_page(pfn);
>  			break;
>  		} else if (ret !=3D -EBUSY) {
> +			clear_cma_bitmap(cma, pfn, count);
>  			break;
>  		}
> +		clear_cma_bitmap(cma, pfn, count);
>  		pr_debug("%s(): memory range at %p is busy, retrying\n",
>  			 __func__, pfn_to_page(pfn));
>  		/* try again with a bit different memory target */
>  		start =3D pageno + mask + 1;
>  	}
>=20=20
> -	mutex_unlock(&cma_mutex);
>  	pr_debug("%s(): returned %p\n", __func__, page);
>  	return page;
>  }
> @@ -350,10 +370,8 @@ bool dma_release_from_contiguous(struct device *dev,=
 struct page *pages,
>=20=20
>  	VM_BUG_ON(pfn + count > cma->base_pfn + cma->count);
>=20=20
> -	mutex_lock(&cma_mutex);
> -	bitmap_clear(cma->bitmap, pfn - cma->base_pfn, count);
>  	free_contig_range(pfn, count);
> -	mutex_unlock(&cma_mutex);
> +	clear_cma_bitmap(cma, pfn, count);
>=20=20
>  	return true;
>  }
> --=20
> Code Aurora Forum chooses to take this file under the GPL v 2 license onl=
y.
> --=20
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation

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

iQIcBAEBAgAGBQJTMD0eAAoJECBgQBJQdR/0gMoQAIqIZlRiMMcEhChqbALBmpXn
keL8pq1VOJ7fuNVhaNzqj9QBw5XfvWt5y+QxeJDWt1wpOASj+vCj7forAz6cpd5Q
yL6PUmwIYFVPiiLN6Wg/Id+2eyiAx/Cr6IGX9sf0ARocN+8A4BOmr14bb8XTuVSw
m7VwndD6PWjPk1ubW61MQATvIZqhMvd8Qjp3EQ6aqZjZJVKqQm5FeIsamXkXYrB+
Y8068hr1MsPPvWiE1Rqd1E2vrh/hWVJCVl7f1soE58M36T3cWSyZcn/s1w+qiM2k
u8TxGyunjM6fLv5K77U0miPfu185PnO7RVmPHWchZ5sCLHKSAozgwbPF8cjeS3TL
5YMz6geTrwZtGGgd+J1hOHVWqA5lJqZu6u9c+yBpELGLsc/tDU7qUctqseu6T0Yl
U5nbrP3Q/oFWDDTNHhZ+i//3ctVx2vvCjjElwC9bHRRzA2iMXnUs+yUHfvPjqHSz
as5Lq+LM5/NEhOoTpCDCcd/wTGdynTNQs7+ghK8AjBRqohyO5R8xCmkLOSMicDgo
6mh4Dgvw5PL6HAluBqDQaYNWqDv3UyIp9sj76cxbSnBl0StdNh6jLQZ5mB3Vlcja
ymUmHnSTg2gveQt1/plKOk+0rAEeZOerbJr+AxFYh8D1eqqhQOFBXYqDGLQ37I9l
4eZ9MO7+iPslQFjaVBRe
=LudM
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
