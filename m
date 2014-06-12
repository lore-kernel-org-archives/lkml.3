Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbaFLKCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:02:46 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:65170 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885AbaFLKCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:02:43 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 04/10] DMA, CMA: support alignment constraint on cma region
In-Reply-To: <1402543307-29800-5-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-5-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140612:linux-kernel@vger.kernel.org::u4db67u3fs8DOLTY:0000000000000000000000000000000000KeC
X-Hashcash: 1:20:140612:kvm-ppc@vger.kernel.org::DXNN9m6LibNmyV7c:000000000000000000000000000000000000001AwV
X-Hashcash: 1:20:140612:paulus@samba.org::YgOR88nMCQmDAFJA:01BaI
X-Hashcash: 1:20:140612:agraf@suse.de::iutFH72jnWSyS+cs:00001VRe
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::Ov4zc27ld0WTz5vB:0000000000000000000000000000000000000001CYw
X-Hashcash: 1:20:140612:linux-arm-kernel@lists.infradead.org::t8fy0C2igwIH30kJ:00000000000000000000000001Wsa
X-Hashcash: 1:20:140612:minchan@kernel.org::jGURMyBc4jxNhQmt:00000000000000000000000000000000000000000001nMi
X-Hashcash: 1:20:140612:akpm@linux-foundation.org::QW5VdIUQupic6M2h:0000000000000000000000000000000000001q5e
X-Hashcash: 1:20:140612:m.szyprowski@samsung.com::2tODIWEPA2L1qqz4:00000000000000000000000000000000000001fUR
X-Hashcash: 1:20:140612:pbonzini@redhat.com::bM07xPGCA3sF4osE:0000000000000000000000000000000000000000004lCm
X-Hashcash: 1:20:140612:benh@kernel.crashing.org::apVufpm+S7QNNtcL:000000000000000000000000000000000000056B+
X-Hashcash: 1:20:140612:linux@arm.linux.org.uk::v8iN6u/whHVmfrhl:00000000000000000000000000000000000000057iw
X-Hashcash: 1:20:140612:linuxppc-dev@lists.ozlabs.org::lC1jgdOtuuoqpObA:000000000000000000000000000000004gXz
X-Hashcash: 1:20:140612:gregkh@linuxfoundation.org::VWWe2V6g23aoz4fK:000000000000000000000000000000000006QP6
X-Hashcash: 1:20:140612:linux-mm@kvack.org::yW7b2v7cmdlRwDeB:00000000000000000000000000000000000000000005zLx
X-Hashcash: 1:20:140612:aneesh.kumar@linux.vnet.ibm.com::4Ix0hZHb+KPq/1JN:0000000000000000000000000000006ELM
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::SjxyKidsi+B8VFYt:0000000000000000000000000000000000000007CyE
X-Hashcash: 1:20:140612:kvm@vger.kernel.org::XR53/s4aw6utKivT:0000000000000000000000000000000000000000007zQU
X-Hashcash: 1:20:140612:gleb@kernel.org::xyj7qvhRY5I0zycz:00DTEm
Date: Thu, 12 Jun 2014 12:02:38 +0200
Message-ID: <xa1t8up2jvi9.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> ppc kvm's cma area management needs alignment constraint on

I've noticed it earlier and cannot seem to get to terms with this.  It
should IMO be PPC, KVM and CMA since those are acronyms.  But if you
have strong feelings, it's not a big issue.

> cma region. So support it to prepare generalization of cma area
> management functionality.
>
> Additionally, add some comments which tell us why alignment
> constraint is needed on cma region.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 8a44c82..bc4c171 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -219,6 +220,7 @@ core_initcall(cma_init_reserved_areas);
>   * @size: Size of the reserved area (in bytes),
>   * @base: Base address of the reserved area optional, use 0 for any
>   * @limit: End address of the reserved memory (optional, 0 for any).
> + * @alignment: Alignment for the contiguous memory area, should be
>  	power of 2

“must be power of 2 or zero”.

>   * @res_cma: Pointer to store the created cma region.
>   * @fixed: hint about where to place the reserved area
>   *
> @@ -233,15 +235,15 @@ core_initcall(cma_init_reserved_areas);
>   */
>  static int __init __dma_contiguous_reserve_area(phys_addr_t size,
>  				phys_addr_t base, phys_addr_t limit,
> +				phys_addr_t alignment,
>  				struct cma **res_cma, bool fixed)
>  {
>  	struct cma *cma = &cma_areas[cma_area_count];
> -	phys_addr_t alignment;
>  	int ret = 0;
>  
> -	pr_debug("%s(size %lx, base %08lx, limit %08lx)\n", __func__,
> -		 (unsigned long)size, (unsigned long)base,
> -		 (unsigned long)limit);
> +	pr_debug("%s(size %lx, base %08lx, limit %08lx align_order %08lx)\n",
> +		__func__, (unsigned long)size, (unsigned long)base,
> +		(unsigned long)limit, (unsigned long)alignment);

Nit: Align with the rest of the arguments, i.e.:

+	pr_debug("%s(size %lx, base %08lx, limit %08lx align_order %08lx)\n",
+		 __func__, (unsigned long)size, (unsigned long)base,
+		 (unsigned long)limit, (unsigned long)alignment);

>  
>  	/* Sanity checks */
>  	if (cma_area_count == ARRAY_SIZE(cma_areas)) {

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
