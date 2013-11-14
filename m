Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3KNJ2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:28:30 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:46127 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3KNJ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:28:27 -0500
Message-ID: <52849706.3010309@huawei.com>
Date: Thu, 14 Nov 2013 17:25:26 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-metag@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: metag: kernel: dma.c: check 'pud' whether is NULL
 in dma_alloc_init()
References: <528485A9.5050509@asianux.com>
In-Reply-To: <528485A9.5050509@asianux.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/14 16:11, Chen Gang wrote:

> Like another p?d_alloc(), pud_alloc() also may fail, so need check it.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/metag/kernel/dma.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/metag/kernel/dma.c b/arch/metag/kernel/dma.c
> index db589ad..e6cf39b 100644
> --- a/arch/metag/kernel/dma.c
> +++ b/arch/metag/kernel/dma.c
> @@ -398,6 +398,11 @@ static int __init dma_alloc_init(void)
>  		int offset = pgd_index(CONSISTENT_START);
>  		pgd = pgd_offset(&init_mm, CONSISTENT_START);
>  		pud = pud_alloc(&init_mm, pgd, CONSISTENT_START);
> +		if (!pud) {
> +			pr_err("%s: no pud tables\n", __func__);
> +			ret = -ENOMEM;
> +			break;
> +		}

It looks fine to me.

Thanks,
Xishi Qiu

>  		pmd = pmd_alloc(&init_mm, pud, CONSISTENT_START);
>  		if (!pmd) {
>  			pr_err("%s: no pmd tables\n", __func__);


