Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab3IBCbD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:31:03 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:57439 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758035Ab3IBCaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:30:52 -0400
Message-ID: <5223F855.8070503@linaro.org>
Date: Mon, 02 Sep 2013 10:30:45 +0800
From: zhangfei <zhangfei.gao@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Vinod Koul'" <vinod.koul@intel.com>, "'Dan Williams'" <djbw@fb.com>,
        linux-kernel@vger.kernel.org, "'Kai Yang'" <jean.yangkai@huawei.com>
Subject: Re: [PATCH 2/2] dma: k3dma: use devm_ioremap_resource() instead of
 devm_request_and_ioremap()
References: <004c01cea77a$ffd30030$ff790090$%han@samsung.com> <005101cea77b$6fe297a0$4fa7c6e0$%han@samsung.com>
In-Reply-To: <005101cea77b$6fe297a0$4fa7c6e0$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-09-02 09:26 AM, Jingoo Han wrote:
> Use devm_ioremap_resource() because devm_request_and_ioremap() is
> obsoleted by devm_ioremap_resource().
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Thanks Jingoo for point out.

Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>

> ---
>   drivers/dma/k3dma.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
> index ef7bc85..a2c330f 100644
> --- a/drivers/dma/k3dma.c
> +++ b/drivers/dma/k3dma.c
> @@ -673,9 +673,9 @@ static int k3_dma_probe(struct platform_device *op)
>   	if (!d)
>   		return -ENOMEM;
>
> -	d->base = devm_request_and_ioremap(&op->dev, iores);
> -	if (!d->base)
> -		return -EADDRNOTAVAIL;
> +	d->base = devm_ioremap_resource(&op->dev, iores);
> +	if (IS_ERR(d->base))
> +		return PTR_ERR(d->base);
>
>   	of_id = of_match_device(k3_pdma_dt_ids, &op->dev);
>   	if (of_id) {
>

