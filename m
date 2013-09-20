Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3ITIjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 04:39:17 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:35232 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3ITIjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:39:16 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
	<CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com>
Date: Fri, 20 Sep 2013 14:09:15 +0530
Message-ID: <CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 September 2013 14:03, Linus Walleij <linus.walleij@linaro.org> wrote:
> I suspect this hunk from the patch may be the cause:
>
> +       if (cpufreq_driver) {
> +               /* get the CPU */
> +               policy = per_cpu(cpufreq_cpu_data, cpu);
> +               if (policy)
> +                       kobject_get(&policy->kobj);
> +       }
>
> -       /* get the CPU */
> -       policy = per_cpu(cpufreq_cpu_data, cpu);
>
> As you see we *always* set a policy pointer before this patch,
> but after this patch we only do it if we have a cpufreq driver
> registered!

Not really!! See this few lines above:

-       if (!cpufreq_driver)
-               goto err_out_unlock;
-
