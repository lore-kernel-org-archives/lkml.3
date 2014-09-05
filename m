Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaIEP3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:29:33 -0400
Received: from smtp-out-239.synserver.de ([212.40.185.239]:1041 "EHLO
	smtp-out-239.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaIEP3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:29:31 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1095
Message-ID: <5409D6D8.2020802@metafoo.de>
Date: Fri, 05 Sep 2014 17:29:28 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/3] dmaengine: pl330: Do not dereference pl330_thread
 pointer before non-NULL check
References: <1409929466-29506-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1409929466-29506-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 05:04 PM, Krzysztof Kozlowski wrote:
> Do not dereference the 'struct pl330_thread *thrd' before the check for
> non-NULL value.
>
> This fixes following warning:
> drivers/dma/pl330.c:1376 pl330_submit_req() warn: variable dereferenced before check 'thrd' (see line 1367)

I think we can just drop that whole line of checks, none of them will ever 
be true.

>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>   drivers/dma/pl330.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index d5149aacd2fe..47d82070848d 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -1364,7 +1364,7 @@ static inline u32 _prepare_ccr(const struct pl330_reqcfg *rqc)
>   static int pl330_submit_req(struct pl330_thread *thrd,
>   	struct dma_pl330_desc *desc)
>   {
> -	struct pl330_dmac *pl330 = thrd->dmac;
> +	struct pl330_dmac *pl330;
>   	struct _xfer_spec xs;
>   	unsigned long flags;
>   	void __iomem *regs;
> @@ -1376,6 +1376,7 @@ static int pl330_submit_req(struct pl330_thread *thrd,
>   	if (!desc || !thrd || thrd->free)
>   		return -EINVAL;
>
> +	pl330 = thrd->dmac;
>   	regs = thrd->dmac->base;
>
>   	if (pl330->state == DYING
>

