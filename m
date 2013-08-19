Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855Ab3HSFyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 01:54:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:30596 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab3HSFyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 01:54:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,910,1367996400"; 
   d="scan'208";a="382900638"
Date: Mon, 19 Aug 2013 10:41:04 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Subject: Re: [PATCH] dmaengine: make dmatest less noisy
Message-ID: <20130819051103.GS32147@intel.com>
References: <1376736160-26827-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376736160-26827-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 12:42:40PM +0200, Linus Walleij wrote:
> Commit 95019c8c5 "dmatest: gather test results in the linked list"
> started to warning whenever we add results to a test thread.
> A warning for something completely normal? This is just cluttering
> my terminal. Get rid of this.
> 
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/dma/dmatest.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index e88ded2..6bb51e2 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -406,7 +406,6 @@ static int thread_result_add(struct dmatest_info *info,
>  	list_add_tail(&tr->node, &r->results);
>  	mutex_unlock(&info->results_lock);
>  
> -	pr_warn("%s\n", thread_result_get(r->name, tr));
perhaps move to debug?

>  	return 0;
>  }
>  
> -- 
> 1.8.1.4
> 

-- 
