Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761093Ab3BLP6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:58:02 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:45243 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab3BLP6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:58:00 -0500
MIME-Version: 1.0
In-Reply-To: <1360666720-19006-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1360666720-19006-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1360666720-19006-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 12 Feb 2013 21:27:59 +0530
Message-ID: <CAKohpok8K_GTTO1mT_1yF39gHZKWKwuH=tHBd1-K8ewDpFFUew@mail.gmail.com>
Subject: Re: [PATCH 3/6] dma: coh901318_lli: avoid unbalanced locking
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 February 2013 16:28, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> I have not checked the code but there is a possibility that custom pool->lock
> is not needed at all due to dma_pool contains it's own lock.

Your viewpoint is fine, but we wanted the reason behind this patch
here. Please add appropriate stuff in only in logs.

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  drivers/dma/coh901318_lli.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/dma/coh901318_lli.c b/drivers/dma/coh901318_lli.c
> index 3e96610..702112d 100644
> --- a/drivers/dma/coh901318_lli.c
> +++ b/drivers/dma/coh901318_lli.c
> @@ -61,7 +61,7 @@ coh901318_lli_alloc(struct coh901318_pool *pool, unsigned int len)
>         dma_addr_t phy;
>
>         if (len == 0)
> -               goto err;
> +               return NULL;
>
>         spin_lock(&pool->lock);
>
> --
> 1.7.10.4
>
