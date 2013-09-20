Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab3ITKRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 06:17:53 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:35230 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab3ITKRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 06:17:52 -0400
Message-ID: <523C1FDC.80805@linux.vnet.ibm.com>
Date: Fri, 20 Sep 2013 15:43:48 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression on cpufreq in v3.12-rc1
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com> <45987104.t6r4hvPgQn@vostro.rjw.lan>	<523AF22F.1010909@linux.vnet.ibm.com> <CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com> <523AF50E.1040502@linux.vnet.ibm.com>	<523B3E4B.6080003@linux.vnet.ibm.com> <CAKohpoktxF5U4MyNprGF-=GjYf3M_ji_H-LfsEdi=VLd7_-0=w@mail.gmail.com>
In-Reply-To: <CAKohpoktxF5U4MyNprGF-=GjYf3M_ji_H-LfsEdi=VLd7_-0=w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092010-2674-0000-0000-00000AB9CB6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 09:49 AM, Viresh Kumar wrote:
> On 19 September 2013 23:41, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> But there was no code to set the per-cpu values to -1 to begin with. Since
>> the per-cpu variable was defined as static, it would have been initialized
>> to zero. Thus, we would never actually hit the BUG_ON() condition, since
>> policy_cpu didn't turn out to be -1.
> 
> Really!! Or I have turned blind (and there is very strong chance of that,
> considering the amount of silly mistakes I do :) )...
> 
> I picked it up from 474deff7 only:
> 
> @@ -2148,10 +2125,8 @@ static int __init cpufreq_core_init(void)
>         if (cpufreq_disabled())
>                 return -ENODEV;
> 
> -       for_each_possible_cpu(cpu) {
> -               per_cpu(cpufreq_policy_cpu, cpu) = -1;
> +       for_each_possible_cpu(cpu)
>                 init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
> -       }
> 
>         cpufreq_global_kobject = kobject_create();
>         BUG_ON(!cpufreq_global_kobject);
> 


Heh, looks like it was me who was blind then :-/

Regards,
Srivatsa S. Bhat

