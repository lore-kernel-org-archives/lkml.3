Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbaFLIa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:30:57 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:2193 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752154AbaFLIaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:30:55 -0400
X-IronPort-AV: E=Sophos;i="5.00,694,1396972800"; 
   d="scan'208";a="31804586"
Message-ID: <53996544.2050401@cn.fujitsu.com>
Date: Thu, 12 Jun 2014 16:31:00 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kvm@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 08/10] mm, cma: clean-up cma allocation error path
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-9-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1402543307-29800-9-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 11:21 AM, Joonsoo Kim wrote:
> We can remove one call sites for clear_cma_bitmap() if we first
> call it before checking error number.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 1e1b017..01a0713 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -282,11 +282,12 @@ struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
>  		if (ret == 0) {
>  			page = pfn_to_page(pfn);
>  			break;
> -		} else if (ret != -EBUSY) {
> -			clear_cma_bitmap(cma, pfn, count);
> -			break;
>  		}
> +
>  		clear_cma_bitmap(cma, pfn, count);
> +		if (ret != -EBUSY)
> +			break;
> +
>  		pr_debug("%s(): memory range at %p is busy, retrying\n",
>  			 __func__, pfn_to_page(pfn));
>  		/* try again with a bit different memory target */
> 


-- 
Thanks.
Zhang Yanfei
