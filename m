Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959Ab3HSIbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:31:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59845 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750832Ab3HSIbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:31:45 -0400
Message-ID: <1376901103.26146.1.camel@joe-AO722>
Subject: Re: [PATCH v2] dmaengine: make dmatest less noisy
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Dan Williams <djbw@fb.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 19 Aug 2013 01:31:43 -0700
In-Reply-To: <1376900724-9636-1-git-send-email-linus.walleij@linaro.org>
References: <1376900724-9636-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 10:25 +0200, Linus Walleij wrote:
> Commit 95019c8c5 "dmatest: gather test results in the linked list"
> started to warning whenever we add results to a test thread.
> A warning for something completely normal? This is just cluttering
> my terminal. Move to debug prints.
[]
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
[]
> @@ -36,7 +36,7 @@ static char test_device[20];
>  module_param_string(device, test_device, sizeof(test_device), S_IRUGO);
>  MODULE_PARM_DESC(device, "Bus ID of the DMA Engine to test (default: any)");
>  
> -static unsigned int threads_per_chan = 1;
> +static unsigned int threads_per_chan = 8;
>  module_param(threads_per_chan, uint, S_IRUGO);
>  MODULE_PARM_DESC(threads_per_chan,
>  		"Number of threads to start per channel (default: 1)");

This is unrelated and makes the MODULE_PARAM_DESC below
it have the incorrect default.

> @@ -406,7 +406,7 @@ static int thread_result_add(struct dmatest_info *info,
>  	list_add_tail(&tr->node, &r->results);
>  	mutex_unlock(&info->results_lock);
>  
> -	pr_warn("%s\n", thread_result_get(r->name, tr));
> +	pr_debug("%s\n", thread_result_get(r->name, tr));
>  	return 0;
>  }
>  

This bit is sensible though.


