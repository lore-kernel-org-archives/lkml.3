Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090Ab3HSIv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:51:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:27821 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab3HSIv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:51:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,912,1367996400"; 
   d="scan'208";a="364763551"
Message-ID: <1376902266.403.152.camel@smile>
Subject: Re: [PATCH v2] dmaengine: make dmatest less noisy
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Aug 2013 11:51:06 +0300
In-Reply-To: <CAA9_cmfKhdQMk7uaczOH9o8kXJQ1WNtkNSvL61pWVRrBaC6gCQ@mail.gmail.com>
References: <1376900724-9636-1-git-send-email-linus.walleij@linaro.org>
	 <1376901429.403.150.camel@smile>
	 <CAA9_cmfKhdQMk7uaczOH9o8kXJQ1WNtkNSvL61pWVRrBaC6gCQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 01:49 -0700, Dan Williams wrote: 
> On Mon, Aug 19, 2013 at 1:37 AM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > On Mon, 2013-08-19 at 10:25 +0200, Linus Walleij wrote:
> >> Commit 95019c8c5 "dmatest: gather test results in the linked list"
> >> started to warning whenever we add results to a test thread.
> >> A warning for something completely normal? This is just cluttering
> >> my terminal. Move to debug prints.
> >>
> >> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >
> >> --- a/drivers/dma/dmatest.c
> >> +++ b/drivers/dma/dmatest.c
> >
> >> @@ -406,7 +406,7 @@ static int thread_result_add(struct dmatest_info *info,
> >>       list_add_tail(&tr->node, &r->results);
> >>       mutex_unlock(&info->results_lock);
> >>
> >> -     pr_warn("%s\n", thread_result_get(r->name, tr));
> >> +     pr_debug("%s\n", thread_result_get(r->name, tr));
> >
> > This is the idea behind original DMATEST module logic.
> > As far as I understand we would like to have them as warnings in case
> > when driver is compiled in and tests are run from the beginning.
> >
> > Though, I sent a correction patch that moves "No error" messages to
> > debug level which, I think, makes sense. I don't know why Dan still keep
> > silent on my last message in the discussion [1].
> >
> 
> Applying them now, and yes I agree with your patch to take this back
> to the original implementation of not squawking on success.

Thank you!

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
