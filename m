Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3ITIlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 04:41:04 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:54194 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3ITIlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:41:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
	<CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com>
	<CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com>
Date: Fri, 20 Sep 2013 10:41:01 +0200
Message-ID: <CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 10:39 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 20 September 2013 14:03, Linus Walleij <linus.walleij@linaro.org> wrote:
>> I suspect this hunk from the patch may be the cause:
>>
>> +       if (cpufreq_driver) {
>> +               /* get the CPU */
>> +               policy = per_cpu(cpufreq_cpu_data, cpu);
>> +               if (policy)
>> +                       kobject_get(&policy->kobj);
>> +       }
>>
>> -       /* get the CPU */
>> -       policy = per_cpu(cpufreq_cpu_data, cpu);
>>
>> As you see we *always* set a policy pointer before this patch,
>> but after this patch we only do it if we have a cpufreq driver
>> registered!
>
> Not really!! See this few lines above:
>
> -       if (!cpufreq_driver)
> -               goto err_out_unlock;

Hm that's true...

Any other idea why this patch is causing the issue?

It's not the same patch pointed out by Srivatsa...

Yours,
Linus Walleij
