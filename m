Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaJWQz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:55:28 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:46753 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaJWQz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:55:26 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 2/4] mm: cma: Always consider a 0 base address reservation as dynamic
In-Reply-To: <1414074828-4488-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Organization: http://mina86.com/
References: <1414074828-4488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1414074828-4488-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141023:m.szyprowski@samsung.com::Yak2/BZ4i7H9hkjb:00000000000000000000000000000000000000b46
X-Hashcash: 1:20:141023:linux-sh@vger.kernel.org::c/LK/iNQf1+jxekA:00000000000000000000000000000000000000loa
X-Hashcash: 1:20:141023:iamjoonsoo.kim@lge.com::0yH5vmDFb6PCyEBY:0000000000000000000000000000000000000001eWz
X-Hashcash: 1:20:141023:linux@arm.linux.org.uk::Z4krijdJuzuzZRXz:0000000000000000000000000000000000000001yxd
X-Hashcash: 1:20:141023:linux-mm@kvack.org::Ger2UqDVt6l+O9y9:00000000000000000000000000000000000000000001eeg
X-Hashcash: 1:20:141023:linux-kernel@vger.kernel.org::bAq4whz533kSglU7:0000000000000000000000000000000001xSg
X-Hashcash: 1:20:141023:laurent.pinchart@ideasonboard.com::A26SDSJp+auhufvJ:00000000000000000000000000004bt9
X-Hashcash: 1:20:141023:linux-arm-kernel@lists.infradead.org::DzhO8vnhB+L3zYsD:0000000000000000000000000Aery
Date: Thu, 23 Oct 2014 18:55:20 +0200
Message-ID: <xa1tk33qlo93.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23 2014, Laurent Pinchart wrote:
> The fixed parameter to cma_declare_contiguous() tells the function
> whether the given base address must be honoured or should be considered
> as a hint only. The API considers a zero base address as meaning any
> base address, which must never be considered as a fixed value.
>
> Part of the implementation correctly checks both fixed and base != 0,
> but two locations check the fixed value only. Set fixed to false when
> base is 0 to fix that and simplify the code.
>
> Signed-off-by: Laurent Pinchart
> <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

And like before, this should also probably also go to stable.

> ---
>  mm/cma.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index 16c6650..6b14346 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -239,6 +239,9 @@ int __init cma_declare_contiguous(phys_addr_t base,
>  	size = ALIGN(size, alignment);
>  	limit &= ~(alignment - 1);
>  
> +	if (!base)
> +		fixed = false;
> +
>  	/* size should be aligned with order_per_bit */
>  	if (!IS_ALIGNED(size >> PAGE_SHIFT, 1 << order_per_bit))
>  		return -EINVAL;
> @@ -262,7 +265,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
>  	}
>  
>  	/* Reserve memory */
> -	if (base && fixed) {
> +	if (fixed) {
>  		if (memblock_is_region_reserved(base, size) ||
>  		    memblock_reserve(base, size) < 0) {
>  			ret = -EBUSY;
> -- 
> 2.0.4
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
