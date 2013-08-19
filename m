Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab3HSItF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:49:05 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:53258 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab3HSItD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:49:03 -0400
MIME-Version: 1.0
In-Reply-To: <1376901429.403.150.camel@smile>
References: <1376900724-9636-1-git-send-email-linus.walleij@linaro.org>
	<1376901429.403.150.camel@smile>
Date: Mon, 19 Aug 2013 01:49:01 -0700
X-Google-Sender-Auth: _lTuIq2Qp5fJWkP1cqMMm89qtn4
Message-ID: <CAA9_cmfKhdQMk7uaczOH9o8kXJQ1WNtkNSvL61pWVRrBaC6gCQ@mail.gmail.com>
Subject: Re: [PATCH v2] dmaengine: make dmatest less noisy
From: Dan Williams <djbw@fb.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 1:37 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Mon, 2013-08-19 at 10:25 +0200, Linus Walleij wrote:
>> Commit 95019c8c5 "dmatest: gather test results in the linked list"
>> started to warning whenever we add results to a test thread.
>> A warning for something completely normal? This is just cluttering
>> my terminal. Move to debug prints.
>>
>> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
>> --- a/drivers/dma/dmatest.c
>> +++ b/drivers/dma/dmatest.c
>
>> @@ -406,7 +406,7 @@ static int thread_result_add(struct dmatest_info *info,
>>       list_add_tail(&tr->node, &r->results);
>>       mutex_unlock(&info->results_lock);
>>
>> -     pr_warn("%s\n", thread_result_get(r->name, tr));
>> +     pr_debug("%s\n", thread_result_get(r->name, tr));
>
> This is the idea behind original DMATEST module logic.
> As far as I understand we would like to have them as warnings in case
> when driver is compiled in and tests are run from the beginning.
>
> Though, I sent a correction patch that moves "No error" messages to
> debug level which, I think, makes sense. I don't know why Dan still keep
> silent on my last message in the discussion [1].
>

Applying them now, and yes I agree with your patch to take this back
to the original implementation of not squawking on success.

> [1] http://www.spinics.net/lists/kernel/msg1581822.html
>
>
> --
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Intel Finland Oy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
