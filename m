Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3EISKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:10:10 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48528 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3EISKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:10:08 -0400
MIME-Version: 1.0
In-Reply-To: <518BD453.2010602@codeaurora.org>
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
 <1368076726-11492-2-git-send-email-skannan@codeaurora.org>
 <CACVXFVMd_iRtEM8ZLK6Ps66gZO6SCp1mXSgY6JbWtRJjJUh+ag@mail.gmail.com>
 <CACxGe6uHBNUcbD9SeRP5c3E8NN-Z2yjVV+9VAhuoJnXoBtTu2w@mail.gmail.com> <518BD453.2010602@codeaurora.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 9 May 2013 19:09:47 +0100
X-Google-Sender-Auth: 4aLwJwEUx5rICL3OtadwnGbdHZU
Message-ID: <CACxGe6vPHsyacOkyJb9UGCdqPsYbW90sGG8HcZOZ0mJrV7QWkA@mail.gmail.com>
Subject: Re: [PATCH 1/3] driver core: Add API to wait for deferred probe to
 complete during init
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Ming Lei <tom.leiming@gmail.com>, Mike Turquette <mturquette@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 5:52 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 05/09/2013 04:50 AM, Grant Likely wrote:
>>
>> On Thu, May 9, 2013 at 11:07 AM, Ming Lei <tom.leiming@gmail.com> wrote:
>>>
>>> On Thu, May 9, 2013 at 1:18 PM, Saravana Kannan <skannan@codeaurora.org>
>>> wrote:
>>>>
>>>>
>>>> The most obvious fallback of using late_initcall_sync() also doesn't
>>>> work
>>>> since the deferred probing work initated during late_initcall() is done
>>>> in
>>>> a workqueue. So, frameworks that want to wait for all devices to finish
>>>> probing during init will now have to wait for the deferred workqueue to
>>>> finish it's work. This patch adds a wait_for_init_deferred_probe_done()
>>>> API
>>>
>>>
>>> flush_workqueue() has been added in deferred_probe_initcall(), so looks
>>> it
>>> should be OK for your problem, doesn't it?
>>
>>
>> It looks like Saravana is using a kernel that already does that based
>> on object bb5645e from the diff. So if he is still having problem,
>> then there is probably another deferred probe that is triggered after
>> the deferred probe lateinitcall is executed. It would be good to know
>> what driver is getting deferred past clearing the queue. Or has this
>> been rebased from an earlier kernel? It may no longer be necessary.
>
>
> Sorry, it was mindless rebase late at night. I missed the addition of the
> flush_workqueue(). That takes care of my immediate needs. Sorry for wasting
> your time.
>
> But the other patches to move clock and regulator calls to late_init_sync
> should still be necessary. Right? Or are we going to depend on the Makefile
> ordering to determine the order of the lateinit calls? (I would rather not).

You'll need to make sure the regulator and clocks defer to after all
the late initcalls are complete. That will ensure that the deferred
queue has been processed.

g.
