Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760369AbaGRHdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:33:23 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31962 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbaGRHdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:33:21 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-9a-53c8cdbdc204
Message-id: <53C8CDBC.3030600@samsung.com>
Date: Fri, 18 Jul 2014 09:33:16 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH] CMA: generalize CMA reserved area management functionality
 (fixup)
References: <53C78ED7.7030002@samsung.com>
 <1405589767-17513-1-git-send-email-m.szyprowski@samsung.com>
 <20140717150615.32c48786b6bdbc880bdc5ed4@linux-foundation.org>
In-reply-to: <20140717150615.32c48786b6bdbc880bdc5ed4@linux-foundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t/xK7p7z54INmi+y2Zx4so/Ros569ew
	WTx+PY/F4kNTK7PFl5/XGS2aF69ns1jZ3cxm8eaTtsWcqYUWmx5fY7W4vGsOm8W9Nf9ZLW5f
	5rX4/f0fq8WC4y2sFsu+vme3WHNkMbvF/m1AsUvHZzI7CHu0NPewefw/OInZo+dNC6vHplWd
	bB6bPk1i9+h6e4XJ48SM3yweDw5tZvHYP3cNu8fmJfUe52csZPRY9+cVk8f7fVfZPObu6mP0
	2Hy62uPzJrkAgSgum5TUnMyy1CJ9uwSujE0PtrAXfBCp+LD6J1sDY79gFyMnh4SAiUTH89Ns
	ELaYxIV764FsLg4hgaWMEkuO72GGcD4xSpzYOYMRpIpXQEtiytNpLCA2i4CqxPGXN8DibAKG
	El1vu8AmiQrESJzp/cwMUS8o8WPyPbB6EQFdiVXPd4HFmQXWsEq0XZAEsYUFIiV2rJ/NArFs
	FaNE28LjYA2cAt4Sk56uYoVoMJN41LIOqlleYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKppYm
	FxQnpeca6hUn5haX5qXrJefnbmKERPGXHYyLj1kdYhTgYFTi4eWYcCJYiDWxrLgy9xCjBAez
	kghv9v3jwUK8KYmVValF+fFFpTmpxYcYmTg4pRoYTUxOKP+KdE+a1Pd2geqWmrpDS1Z+WlX8
	ItrtkMTW+eo800p6qth1DhttTsgRaXprtd52Z9TyyPp88z0MgV5XE11aPOwPVT44yfvnTNb2
	L9/7d3bxMxYrR87Pf/pgPU/PvwaWA64CermcVsf0/15cPi36+YV5JhE8vLcmv56UK2W8LH6L
	6qQ3SizFGYmGWsxFxYkAyuxfbMACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-07-18 00:06, Andrew Morton wrote:
> On Thu, 17 Jul 2014 11:36:07 +0200 Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>
>> MAX_CMA_AREAS is used by other subsystems (i.e. arch/arm/mm/dma-mapping.c),
>> so we need to provide correct definition even if CMA is disabled.
>> This patch fixes this issue.
>>
>> Reported-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>   include/linux/cma.h | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/include/linux/cma.h b/include/linux/cma.h
>> index 9a18a2b1934c..c077635cad76 100644
>> --- a/include/linux/cma.h
>> +++ b/include/linux/cma.h
>> @@ -5,7 +5,11 @@
>>    * There is always at least global CMA area and a few optional
>>    * areas configured in kernel .config.
>>    */
>> +#ifdef CONFIG_CMA
>>   #define MAX_CMA_AREAS	(1 + CONFIG_CMA_AREAS)
>> +#else
>> +#define MAX_CMA_AREAS	(0)
>> +#endif
>>   
>>   struct cma;
> Joonsoo already fixed this up, a bit differently:
> http://ozlabs.org/~akpm/mmots/broken-out/cma-generalize-cma-reserved-area-management-functionality-fix.patch
>
> Which approach makes more sense?

CMA_AREAS depends on CMA being enabled, so both approaches works exactly
the same way. Please keep Joonsoo's patch and just ignore mine to avoid
confusing others by disappearing patches. I'm sorry that I've missed it
before sending mine.

> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Subject: CMA: fix ARM build failure related to MAX_CMA_AREAS definition
>
> If CMA is disabled, CONFIG_CMA_AREAS isn't defined so compile error
> happens. To fix it, define MAX_CMA_AREAS if CONFIG_CMA_AREAS
> isn't defined.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   include/linux/cma.h |    6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff -puN include/linux/cma.h~cma-generalize-cma-reserved-area-management-functionality-fix include/linux/cma.h
> --- a/include/linux/cma.h~cma-generalize-cma-reserved-area-management-functionality-fix
> +++ a/include/linux/cma.h
> @@ -5,8 +5,14 @@
>    * There is always at least global CMA area and a few optional
>    * areas configured in kernel .config.
>    */
> +#ifdef CONFIG_CMA_AREAS
>   #define MAX_CMA_AREAS	(1 + CONFIG_CMA_AREAS)
>   
> +#else
> +#define MAX_CMA_AREAS	(0)
> +
> +#endif
> +
>   struct cma;
>   
>   extern phys_addr_t cma_get_base(struct cma *cma);
> _

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

