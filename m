Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3ITETY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 00:19:24 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:54970 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3ITETW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 00:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <523B3E4B.6080003@linux.vnet.ibm.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
	<523AF50E.1040502@linux.vnet.ibm.com>
	<523B3E4B.6080003@linux.vnet.ibm.com>
Date: Fri, 20 Sep 2013 09:49:21 +0530
Message-ID: <CAKohpoktxF5U4MyNprGF-=GjYf3M_ji_H-LfsEdi=VLd7_-0=w@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 September 2013 23:41, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> But there was no code to set the per-cpu values to -1 to begin with. Since
> the per-cpu variable was defined as static, it would have been initialized
> to zero. Thus, we would never actually hit the BUG_ON() condition, since
> policy_cpu didn't turn out to be -1.

Really!! Or I have turned blind (and there is very strong chance of that,
considering the amount of silly mistakes I do :) )...

I picked it up from 474deff7 only:

@@ -2148,10 +2125,8 @@ static int __init cpufreq_core_init(void)
        if (cpufreq_disabled())
                return -ENODEV;

-       for_each_possible_cpu(cpu) {
-               per_cpu(cpufreq_policy_cpu, cpu) = -1;
+       for_each_possible_cpu(cpu)
                init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
-       }

        cpufreq_global_kobject = kobject_create();
        BUG_ON(!cpufreq_global_kobject);
