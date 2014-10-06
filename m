Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaJFK14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:27:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22156 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaJFK1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:27:54 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-a3-54326ea8e6e3
Message-id: <54326EAF.8060004@samsung.com>
Date: Mon, 06 Oct 2014 19:27:59 +0900
From: Heesub Shin <heesub.shin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Pintu Kumar <pintu.k@samsung.com>, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, john.stultz@linaro.org,
        rebecca@android.com, ccross@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: pintu_agarwal@yahoo.com, vishnu.ps@samsung.com, iqbal.ams@samsung.com
Subject: Re: [PATCH 1/1] [ion]: system-heap use PAGE_ALLOC_COSTLY_ORDER for
 high order
References: <1412584263-22531-1-git-send-email-pintu.k@samsung.com>
In-reply-to: <1412584263-22531-1-git-send-email-pintu.k@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zTd0VeUYhBlemGVjMWb+GzWL7xm+s
	Fi8PaVrsOfOL3aJ58Xo2i4OzlzBZzP41icnizG9di8u75rBZ9H0/zG7x7e1tdosbkwstpvTd
	ZXTg9di2exurx719h1k87lzbw+ZxYsZvFo/9c9ewe/RtWcXo8XmTnMesWYeZAjiiuGxSUnMy
	y1KL9O0SuDJW979jL/jFV7Hk5RTmBsYpPF2MHBwSAiYSZ1ZWdjFyApliEhfurWfrYuTiEBJY
	xigx430HK0TCROLJmRYmiMR0RonmR39ZQBJCAm8YJZY+kQQZxCugJfH2rSBImEVAVeLQp3ss
	IGE2AW2JQ9uCQcKiAhESB/qegY3kFRCU+DEZpISLQ0TgNqPEuxOPwBLMAp4SEy+vZgaxhYEa
	Xh/azgqxylli+pMfYDM5BVwk5n+vhyi3llg5aRsjhC0vsXnNW2aQmRICvRwSHU9PMUHcIyDx
	bfIhFoh/ZSU2HWCGeEtS4uCKGywTGMVmITlpFpKxs5CMXcDIvIpRNLUguaA4Kb3IRK84Mbe4
	NC9dLzk/dxMjJIon7GC8d8D6EKMAB6MSD2/kDsMQIdbEsuLK3EOMpkBXTGSWEk3OB6aKvJJ4
	Q2MzIwtTE1NjI3NLMyVx3tdSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MPruOTy5YHHe
	t+9f2075rDz8jF+l4enef5Jakmp3FXU/X9mxIipinfcVHvWrB3PmXE8UuiPlqMY/YY+88LW+
	SddNtPIa5vpxzNJxOF3ZckB+Zs98A/aHv0p3SG4rnMe+dPLq/Vsn3/MuO1Gm8cVpQ6HYxwV/
	dwZd3qPMdHzGvyMhocE/H4idrPFVYinOSDTUYi4qTgQA/f7Zdt0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQd0VeUYhBj3XtC3mrF/DZrF94zdW
	i5eHNC32nPnFbtG8eD2bxcHZS5gsZv+axGRx5reuxeVdc9gs+r4fZrf49vY2u8WNyYUWU/ru
	MjrwemzbvY3V496+wywed67tYfM4MeM3i8f+uWvYPfq2rGL0+LxJzmPWrMNMARxRDYw2GamJ
	KalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKymUJeaUAoUC
	EouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzVve/Yy/4xVex5OUU5gbGKTxdjJwcEgIm
	Ek/OtDBB2GISF+6tZ+ti5OIQEpjOKNH86C8LSEJI4A2jxNInkl2MHBy8AloSb98KgoRZBFQl
	Dn26xwISZhPQlji0LRgkLCoQIXGg7xkriM0rICjxYzJICReHiMBtRol3Jx6BJZgFPCUmXl7N
	DGILAzW8PrSdFWKVs8T0Jz/AZnIKuEjM/14PUW4tsXLSNkYIW15i85q3zBMYBWYhWTELSdks
	JGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQniWfSOxhXNVgcYhTgYFTi4Y3YYRgi
	xJpYVlyZe4hRgoNZSYQ3Ps0oRIg3JbGyKrUoP76oNCe1+BCjKTAAJjJLiSbnAxNYXkm8obGJ
	mZGlkZmxibmxsZI478FW60AhgfTEktTs1NSC1CKYPiYOTqkGRhlhy8Sv178efnxiR/zET1y/
	VtSeYxFfc8e1wIP/Ns/ti61rzx9y65mX+Nr2jnOU2e3uVdwCCxX6fiZqrfCIUDbr1vRxtip9
	zbjZ+cY+k7sygpyrFgV2lHQsOZOx4I0pz8RVh/dE+TY/UWP6HahqnmbX9VBiC/MywVfzV506
	Iz3vh6hwE3PzGyWW4oxEQy3mouJEAFm2NiwoAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kumar,

On 10/06/2014 05:31 PM, Pintu Kumar wrote:
> The Android ion_system_heap uses allocation fallback mechanism
> based on 8,4,0 order pages available in the system.
> It changes gfp flags based on higher order allocation request.
> This higher order value is hard-coded as 4, instead of using
> the system defined higher order value.
> Thus replacing this hard-coded value with PAGE_ALLOC_COSTLY_ORDER
> which is defined as 3.
> This will help mapping the higher order request in system heap with
> the actual allocation request.

Quite reasonable.

Reviewed-by: Heesub Shin <heesub.shin@samsung.com>

BTW, Anyone knows how the allocation order (8,4 and 0) was decided? I 
think only Google guys might know the answer.

regards,
heesub

>
> Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
> ---
>   drivers/staging/android/ion/ion_system_heap.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
> index da2a63c..e6c393f 100644
> --- a/drivers/staging/android/ion/ion_system_heap.c
> +++ b/drivers/staging/android/ion/ion_system_heap.c
> @@ -65,7 +65,7 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
>   	} else {
>   		gfp_t gfp_flags = low_order_gfp_flags;
>
> -		if (order > 4)
> +		if (order > PAGE_ALLOC_COSTLY_ORDER)
>   			gfp_flags = high_order_gfp_flags;
>   		page = alloc_pages(gfp_flags | __GFP_COMP, order);
>   		if (!page)
> @@ -276,7 +276,7 @@ struct ion_heap *ion_system_heap_create(struct ion_platform_heap *unused)
>   		struct ion_page_pool *pool;
>   		gfp_t gfp_flags = low_order_gfp_flags;
>
> -		if (orders[i] > 4)
> +		if (orders[i] > PAGE_ALLOC_COSTLY_ORDER)
>   			gfp_flags = high_order_gfp_flags;
>   		pool = ion_page_pool_create(gfp_flags, orders[i]);
>   		if (!pool)
>
