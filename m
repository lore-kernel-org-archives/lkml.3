Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaKEV5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:57:45 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:60657 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaKEV5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:57:40 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Gregory Fong <gregory.0xf0@gmail.com>, linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org, f.fainelli@gmail.com,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Masanari Iida <standby24x7@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] lib: bitmap: Added alignment offset for bitmap_find_next_zero_area()
In-Reply-To: <1415218078-10078-1-git-send-email-gregory.0xf0@gmail.com>
Organization: http://mina86.com/
References: <1415218078-10078-1-git-send-email-gregory.0xf0@gmail.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141105:gregory.0xf0@gmail.com::lUcO64+mPMzZ1n7V:0000000000000000000000000000000000000000EuR
X-Hashcash: 1:20:141105:standby24x7@gmail.com::G9SzxzkKwAY5zvE5:00000000000000000000000000000000000000000zEy
X-Hashcash: 1:20:141105:f.fainelli@gmail.com::NhMbFuWO5RZCPMdf:000000000000000000000000000000000000000001ART
X-Hashcash: 1:20:141105:akpm@linux-foundation.org::hJb4T0y4fPnErowD:0000000000000000000000000000000000001UgV
X-Hashcash: 1:20:141105:jack@suse.cz::qlpgtmqUn7V/9upC:000002mXa
X-Hashcash: 1:20:141105:linux-mm@kvack.org::8U3WWDeqxTWsqHwY:00000000000000000000000000000000000000000002rmc
X-Hashcash: 1:20:141105:m.nazarewicz@samsung.com::hJvZu535AF80wb7U:00000000000000000000000000000000000003Odl
X-Hashcash: 1:20:141105:m.szyprowski@samsung.com::rxXan3ZEJiKKKEaF:00000000000000000000000000000000000004Gdx
X-Hashcash: 1:20:141105:gregory.0xf0@gmail.com::Xtvacjra0tBzRJM1:0000000000000000000000000000000000000006ZCv
X-Hashcash: 1:20:141105:kyungmin.park@samsung.com::SEHSVvekb1TeLwO2:0000000000000000000000000000000000006BhO
X-Hashcash: 1:20:141105:linux-arm-kernel@lists.infradead.org::d8ILv7nVZSyx0ATE:00000000000000000000000009Q3V
X-Hashcash: 1:20:141105:linux-kernel@vger.kernel.org::jut901aRF33M29qs:0000000000000000000000000000000008rSH
X-Hashcash: 1:20:141105:linux@rasmusvillemoes.dk::1CiKhe8335dqmlpO:00000000000000000000000000000000000009qTm
Date: Wed, 05 Nov 2014 22:57:34 +0100
Message-ID: <xa1ty4rpwbsh.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05 2014, Gregory Fong wrote:
> From: Michal Nazarewicz <m.nazarewicz@samsung.com>

Please change to mina86@mina86.com.  My Samsung address is no longer
valid.  Ditto on signed-off-by line.

>
> This commit adds a bitmap_find_next_zero_area_off() function which
> works like bitmap_find_next_zero_area() function expect it allows an
> offset to be specified when alignment is checked.  This lets caller
> request a bit such that its number plus the offset is aligned
> according to the mask.
>
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: Michal Nazarewicz <mina86@mina86.com>
> [gregory.0xf0@gmail.com: Retrieved from
> https://patchwork.linuxtv.org/patch/6254/ and updated documentation]
> Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
> ---
>  include/linux/bitmap.h | 36 +++++++++++++++++++++++++++++++-----
>  lib/bitmap.c           | 24 +++++++++++++-----------
>  2 files changed, 44 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index e1c8d08..34e020c 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -45,6 +45,7 @@
>   * bitmap_set(dst, pos, nbits)			Set specified bit area
>   * bitmap_clear(dst, pos, nbits)		Clear specified bit area
>   * bitmap_find_next_zero_area(buf, len, pos, n, mask)	Find bit free area
> + * bitmap_find_next_zero_area_off(buf, len, pos, n, mask)	as above
>   * bitmap_shift_right(dst, src, n, nbits)	*dst = *src >> n
>   * bitmap_shift_left(dst, src, n, nbits)	*dst = *src << n
>   * bitmap_remap(dst, src, old, new, nbits)	*dst = map(old, new)(src)
> @@ -114,11 +115,36 @@ extern int __bitmap_weight(const unsigned long *bitmap, unsigned int nbits);
>  
>  extern void bitmap_set(unsigned long *map, unsigned int start, int len);
>  extern void bitmap_clear(unsigned long *map, unsigned int start, int len);
> -extern unsigned long bitmap_find_next_zero_area(unsigned long *map,
> -					 unsigned long size,
> -					 unsigned long start,
> -					 unsigned int nr,
> -					 unsigned long align_mask);
> +
> +extern unsigned long bitmap_find_next_zero_area_off(unsigned long *map,
> +						    unsigned long size,
> +						    unsigned long start,
> +						    unsigned int nr,
> +						    unsigned long align_mask,
> +						    unsigned long align_offset);
> +
> +/**
> + * bitmap_find_next_zero_area - find a contiguous aligned zero area
> + * @map: The address to base the search on
> + * @size: The bitmap size in bits
> + * @start: The bitnumber to start searching at
> + * @nr: The number of zeroed bits we're looking for
> + * @align_mask: Alignment mask for zero area
> + *
> + * The @align_mask should be one less than a power of 2; the effect is that
> + * the bit offset of all zero areas this function finds is multiples of that
> + * power of 2. A @align_mask of 0 means no alignment is required.
> + */
> +static inline unsigned long
> +bitmap_find_next_zero_area(unsigned long *map,
> +			   unsigned long size,
> +			   unsigned long start,
> +			   unsigned int nr,
> +			   unsigned long align_mask)
> +{
> +	return bitmap_find_next_zero_area_off(map, size, start, nr,
> +					      align_mask, 0);
> +}
>  
>  extern int bitmap_scnprintf(char *buf, unsigned int len,
>  			const unsigned long *src, int nbits);
> diff --git a/lib/bitmap.c b/lib/bitmap.c
> index b499ab6..969ae8f 100644
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -326,30 +326,32 @@ void bitmap_clear(unsigned long *map, unsigned int start, int len)
>  }
>  EXPORT_SYMBOL(bitmap_clear);
>  
> -/*
> - * bitmap_find_next_zero_area - find a contiguous aligned zero area
> +/**
> + * bitmap_find_next_zero_area_off - find a contiguous aligned zero area
>   * @map: The address to base the search on
>   * @size: The bitmap size in bits
>   * @start: The bitnumber to start searching at
>   * @nr: The number of zeroed bits we're looking for
>   * @align_mask: Alignment mask for zero area
> + * @align_offset: Alignment offset for zero area.
>   *
>   * The @align_mask should be one less than a power of 2; the effect is that
> - * the bit offset of all zero areas this function finds is multiples of that
> - * power of 2. A @align_mask of 0 means no alignment is required.
> + * the bit offset of all zero areas this function finds plus @align_offset
> + * is multiple of that power of 2.
>   */
> -unsigned long bitmap_find_next_zero_area(unsigned long *map,
> -					 unsigned long size,
> -					 unsigned long start,
> -					 unsigned int nr,
> -					 unsigned long align_mask)
> +unsigned long bitmap_find_next_zero_area_off(unsigned long *map,
> +					     unsigned long size,
> +					     unsigned long start,
> +					     unsigned int nr,
> +					     unsigned long align_mask,
> +					     unsigned long align_offset)
>  {
>  	unsigned long index, end, i;
>  again:
>  	index = find_next_zero_bit(map, size, start);
>  
>  	/* Align allocation */
> -	index = __ALIGN_MASK(index, align_mask);
> +	index = __ALIGN_MASK(index + align_offset, align_mask) - align_offset;
>  
>  	end = index + nr;
>  	if (end > size)
> @@ -361,7 +363,7 @@ again:
>  	}
>  	return index;
>  }
> -EXPORT_SYMBOL(bitmap_find_next_zero_area);
> +EXPORT_SYMBOL(bitmap_find_next_zero_area_off);
>  
>  /*
>   * Bitmap printing & parsing functions: first version by Nadia Yvette Chambers,
> -- 
> 1.9.1
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
