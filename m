Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbaLASgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:36:18 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54743 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaLASgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:36:16 -0500
Message-ID: <547CB51F.1070305@codeaurora.org>
Date: Mon, 01 Dec 2014 10:36:15 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Zeng Tao <prime.zeng@huawei.com>, gregkh@linuxfoundation.org,
        john.stultz@linaro.org, ccross@android.com,
        benjamin.gaignard@linaro.org, rebecca@android.com,
        fabio.estevam@freescale.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ion : ion_cma_heap: fix bug for highmem cma
References: <1417224717-203170-1-git-send-email-prime.zeng@huawei.com>
In-Reply-To: <1417224717-203170-1-git-send-email-prime.zeng@huawei.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2014 5:31 PM, Zeng Tao wrote:
> when cma is located in highmem, virt_to_page will not
> work the right way, use pfn_to_page instead.
>
> Signed-off-by: Zeng Tao <prime.zeng@huawei.com>
> ---
>   drivers/staging/android/ion/ion_cma_heap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
> index f8cabcb..cc45fc0 100644
> --- a/drivers/staging/android/ion/ion_cma_heap.c
> +++ b/drivers/staging/android/ion/ion_cma_heap.c
> @@ -47,7 +47,7 @@ struct ion_cma_buffer_info {
>   static int ion_cma_get_sgtable(struct device *dev, struct sg_table *sgt,
>   			       void *cpu_addr, dma_addr_t handle, size_t size)
>   {
> -	struct page *page = virt_to_page(cpu_addr);
> +	struct page *page = pfn_to_page(handle >> PAGE_SHIFT);

There's a comment right above this that notes this function could be replaced
with dma_common_get_sgtable when it's available. That function is now
present in drivers/base/dma-mapping.c although it has the same bug. I'd
suggest fixing the bug in dma_common_get_sgtable and switching Ion to use
that function instead.

>   	int ret;
>
>   	ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
>

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
