Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaJPJwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:52:44 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:41906 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaJPJwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:52:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAJhJPsVV74gVEMpMZfBcnm-=sHivpPZGY==tzT-rXsv82B0Scg@mail.gmail.com>
References: <CAJhJPsVV74gVEMpMZfBcnm-=sHivpPZGY==tzT-rXsv82B0Scg@mail.gmail.com>
Date: Thu, 16 Oct 2014 15:22:42 +0530
Message-ID: <CAKohpomFP5=eO7hFJyXQqM6_jOGT9gY+f3g3qqKgYwg5rgh3Ag@mail.gmail.com>
Subject: Re: [PATCH 6/6] cpufreq: Loongson1: Add cpufreq driver for Loongson1B (UPDATED)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kelvin Cheung <keguang.zhang@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 October 2014 15:00, Kelvin Cheung <keguang.zhang@gmail.com> wrote:

Just to let u know, your mails are probably generated in html whereas they
should be in text mode.

> 2014-10-16 16:23 GMT+08:00 Viresh Kumar <viresh.kumar@linaro.org>:
>>
>> This is not how we send updated versions, GIT and other tools will commit
>> the "(UPDATED)" part while applying. What you were required to do was
>> something like:
>>
>> git format-patch A..B --subject-prefix="PATCH V2"
>
>
> I use 'updated' because only one patch in the patch set need to be updated.
> If you insist, I will regenerate this patch.

Even in that case you can do what I was saying. No, you don't need to resend
for that reason now. :)

>> On 15 October 2014 12:53, Kelvin Cheung <keguang.zhang@gmail.com> wrote:
>> > +static int ls1x_cpufreq_remove(struct platform_device *pdev)
>> > +{
>> > +       cpufreq_unregister_notifier(&ls1x_cpufreq_notifier_block,
>> > +                                   CPUFREQ_TRANSITION_NOTIFIER);
>> > +       cpufreq_unregister_driver(&ls1x_cpufreq_driver);
>> > +       clk_put(ls1x_cpufreq.osc_clk);
>> > +       clk_put(ls1x_cpufreq.clk);
>> > +
>> > +       return 0;
>> > +}
>> > +
>> > +static int ls1x_cpufreq_probe(struct platform_device *pdev)
>> > +{
>> > +       struct plat_ls1x_cpufreq *pdata = pdev->dev.platform_data;
>> > +       struct clk *clk;
>> > +       int ret;
>> > +
>> > +       if (!pdata)
>> > +               return -EINVAL;
>> > +       if (!pdata->clk_name)
>> > +               return -EINVAL;
>> > +       if (!pdata->osc_clk_name)
>> > +               return -EINVAL;
>>
>> I didn't wanted you to do this, You could have done this:
>>
>>        if (!pdata || !pdata->clk_name || !pdata->osc_clk_name)
>>                return -EINVAL;
>>
>> So, just a || instead of && :)
>>
>> > +
>> > +       ls1x_cpufreq.dev = &pdev->dev;
>> > +
>> > +       clk = clk_get(NULL, pdata->clk_name);
>>
>> I believe we agreed for devm_clk_get(), isn't it ?
>
>
> In my case I think clk_get() is enough.

Obviously its enough but wouldn't it be better to use a infrastructure
which is somewhat better ?

> Moreover, most of cpufreq drivers use clk_get().

So what? Is that a good enough reason for adopting a good change?
