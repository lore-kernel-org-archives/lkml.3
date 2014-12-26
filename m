Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaLZQKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 11:10:54 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46007 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaLZQKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 11:10:52 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: "Stefan I. Strogin" <s.strogin@partner.samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <d.safonov@partner.samsung.com>,
        s.strogin@partner.samsung.com, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        SeongJae Park <sj38.park@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>,
        Minchan Kim <minchan@kernel.org>, Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Subject: Re: [PATCH 3/3] cma: add functions to get region pages counters
In-Reply-To: <dfddb08aba9a05e6e7b43e9861ab09b7ac1c89cd.1419602920.git.s.strogin@partner.samsung.com>
Organization: http://mina86.com/
References: <cover.1419602920.git.s.strogin@partner.samsung.com> <dfddb08aba9a05e6e7b43e9861ab09b7ac1c89cd.1419602920.git.s.strogin@partner.samsung.com>
User-Agent: Notmuch/0.19~rc1+1~g03aea4f (http://notmuchmail.org) Emacs/25.0.50.3 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141226:iamjoonsoo.kim@lge.com::vYawfzYauFf7ftaq:0000000000000000000000000000000000000000eLx
X-Hashcash: 1:20:141226:weijie.yang@samsung.com::vK6Jq2bsVnzj4BzW:000000000000000000000000000000000000000Nwz
X-Hashcash: 1:20:141226:sj38.park@gmail.com::uzpdwtV/hPDn+kbP:00000000000000000000000000000000000000000001LC
X-Hashcash: 1:20:141226:m.szyprowski@samsung.com::OrQdCMoaTLgr4y29:00000000000000000000000000000000000000AFr
X-Hashcash: 1:20:141226:linux-kernel@vger.kernel.org::32wlMpFr7RhOIV0i:0000000000000000000000000000000001GVa
X-Hashcash: 1:20:141226:d.safonov@partner.samsung.com::Vmwx7b/SaNxnVFiW:0000000000000000000000000000000017Tt
X-Hashcash: 1:20:141226:s.dyasly@samsung.com::Z2Kfp97h76Y/mnfl:000000000000000000000000000000000000000001CsA
X-Hashcash: 1:20:141226:lauraa@codeaurora.org::oax+Nk4svG1Xd7JA:00000000000000000000000000000000000000002SCg
X-Hashcash: 1:20:141226:aneesh.kumar@linux.vnet.ibm.com::TeVWh43ZcpsjSaB5:0000000000000000000000000000002DbD
X-Hashcash: 1:20:141226:s.strogin@partner.samsung.com::yumoduF2/6e659wT:000000000000000000000000000000002fE3
X-Hashcash: 1:20:141226:s.strogin@partner.samsung.com::/vzhlVaVFddMDV5M:000000000000000000000000000000003wW1
X-Hashcash: 1:20:141226:linux-mm@kvack.org::5Vhst/rokq6HOyw6:00000000000000000000000000000000000000000004bem
X-Hashcash: 1:20:141226:pintu.k@samsung.com::676VfNZHqqVsgP6G:0000000000000000000000000000000000000000005KPX
X-Hashcash: 1:20:141226:minchan@kernel.org::OHCSqldYJpV2ZhlL:000000000000000000000000000000000000000000050MP
X-Hashcash: 1:20:141226:akpm@linux-foundation.org::gfAH23R1fPeE8TlF:00000000000000000000000000000000000067hG
X-Hashcash: 1:20:141226:zhuhui@xiaomi.com::xK/FwmzzS4uFCx+Z:000000000000000000000000000000000000000000005Q0A
X-Hashcash: 1:20:141226:v.tyrtov@samsung.com::CkngX9f3nZKmco8n:000000000000000000000000000000000000000007Zqg
X-Hashcash: 1:20:141226:laurent.pinchart@ideasonboard.com::+oh9CVNhnubU/HON:00000000000000000000000000009Zn3
Date: Fri, 26 Dec 2014 17:10:47 +0100
Message-ID: <xa1twq5ez914.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26 2014, "Stefan I. Strogin" <s.strogin@partner.samsung.com> wrote:
> From: Dmitry Safonov <d.safonov@partner.samsung.com>
>
> Here are two functions that provide interface to compute/get used size
> and size of biggest free chunk in cma region.
> Added that information in cmainfo.
>
> Signed-off-by: Dmitry Safonov <d.safonov@partner.samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  include/linux/cma.h |  2 ++
>  mm/cma.c            | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+)
>
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 9384ba6..855e6f2 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -18,6 +18,8 @@ struct cma;
>  extern unsigned long totalcma_pages;
>  extern phys_addr_t cma_get_base(struct cma *cma);
>  extern unsigned long cma_get_size(struct cma *cma);
> +extern unsigned long cma_get_used(struct cma *cma);
> +extern unsigned long cma_get_maxchunk(struct cma *cma);
>  
>  extern int __init cma_declare_contiguous(phys_addr_t base,
>  			phys_addr_t size, phys_addr_t limit,
> diff --git a/mm/cma.c b/mm/cma.c
> index ffaea26..5e560ed 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -78,6 +78,36 @@ unsigned long cma_get_size(struct cma *cma)
>  	return cma->count << PAGE_SHIFT;
>  }
>  
> +unsigned long cma_get_used(struct cma *cma)
> +{
> +	unsigned long ret = 0;
> +
> +	mutex_lock(&cma->lock);
> +	/* pages counter is smaller than sizeof(int) */
> +	ret = bitmap_weight(cma->bitmap, (int)cma->count);
> +	mutex_unlock(&cma->lock);
> +
> +	return ret << (PAGE_SHIFT + cma->order_per_bit);
> +}
> +
> +unsigned long cma_get_maxchunk(struct cma *cma)
> +{
> +	unsigned long maxchunk = 0;
> +	unsigned long start, end = 0;
> +
> +	mutex_lock(&cma->lock);
> +	for (;;) {
> +		start = find_next_zero_bit(cma->bitmap, cma->count, end);
> +		if (start >= cma->count)
> +			break;
> +		end = find_next_bit(cma->bitmap, cma->count, start);
> +		maxchunk = max(end - start, maxchunk);
> +	}
> +	mutex_unlock(&cma->lock);
> +
> +	return maxchunk << (PAGE_SHIFT + cma->order_per_bit);
> +}
> +
>  static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
>  {
>  	if (align_order <= cma->order_per_bit)
> @@ -591,6 +621,10 @@ static int s_show(struct seq_file *m, void *p)
>  	struct cma_buffer *cmabuf;
>  	struct stack_trace trace;
>  
> +	seq_printf(m, "CMARegion stat: %8lu kB total, %8lu kB used, %8lu kB max contiguous chunk\n\n",
> +		   cma_get_size(cma) >> 10,
> +		   cma_get_used(cma) >> 10,
> +		   cma_get_maxchunk(cma) >> 10);
>  	mutex_lock(&cma->list_lock);
>  
>  	list_for_each_entry(cmabuf, &cma->buffers_list, list) {
> -- 
> 2.1.0
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
