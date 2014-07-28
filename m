Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbaG1RHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:07:23 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:51123 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaG1RHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:07:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140728164935.GA8982@core.coreip.homeip.net>
References: <1406537216-25936-1-git-send-email-pramod.gurav@smartplayin.com>
	<20140728164935.GA8982@core.coreip.homeip.net>
Date: Mon, 28 Jul 2014 22:37:18 +0530
Message-ID: <CAMf-jSmHpRLOOcmmW7qOPbwUv3oCtJMvFcqP2LVObE9qQL+D9g@mail.gmail.com>
Subject: Re: [PATCH] input: ads7846: Switch to managed version of kzalloc and cleanups
From: Pramod Gurav <pramod.gurav.etc@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mark Brown <broonie@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Dmitry for reviewing.

On Mon, Jul 28, 2014 at 10:19 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Pramod,
>
> On Mon, Jul 28, 2014 at 02:16:55PM +0530, pramod.gurav.etc@gmail.com wrote:
>> From: Pramod Gurav <pramod.gurav@smartplayin.com>
>>
>> This switches memory allocations from kzalloc to devm_kzalloc.
>> This also changes the way return checks were done on failure cases
>> of three allocations. The checks were clubbed together and hence
>> must be done seperately to avoid calling kfree on unallocated memory.
>>
>> Moreover in case of input_allocate_device failure, we were calling
>> input_free_device which is not needed.
>
> But not hurting either - like kfree() and many other "cleanup" functions
> in kernel they are happily accept NULL input (so that cleanup code is
> less branchy).
>>
Great. Good to learn.
>> input device must be released(input_free_device) when ads7846_probe_dt
>> fails hence adds a fix there as well.
>
> That is the real bug, could you send me a patch that fixes just that (by
> jumping to err_free_mem)?
Sure I will.

>
> The rest I'd like to leave as is unless you can convert _all_ resources
> to be managed ones: mixing up 2 styles (manual and automatic release) is
> bound to have issues (like we had with ads7846_probe_dt which assumed
> that since it was releasing its resources automatically the rest would
> be released automatically as well.

I thought I would use a managed input_device allocation in a separate patch.
I will convert all allocations to managed then.

This driver also registers a irq. You suggest to convert it to managed as well?
I was planning to do that?
>
> Thanks.
>
> --
> Dmitry



-- 
Thanks and Regards
Pramod
