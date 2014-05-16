Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbaEPRYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:24:25 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:46957 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577AbaEPRYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:24:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokCBbL1OkxB3rh0Pr3yqiG1H6UsZgD-WQTRvihxJt1-Qw@mail.gmail.com>
References: <1400231366-1221-1-git-send-email-inderpal.s@samsung.com>
	<CAKohponY6Nn5kYGyps2SLm5uBbH1JWuJBpzzVD=QOc=oM7crAg@mail.gmail.com>
	<CAOqmu82GQ2qsm0c7fq8n5ovR7+4j5t_Y3=03S=nWtR+bH3yhdg@mail.gmail.com>
	<CAKohpokCBbL1OkxB3rh0Pr3yqiG1H6UsZgD-WQTRvihxJt1-Qw@mail.gmail.com>
Date: Fri, 16 May 2014 22:54:22 +0530
X-Google-Sender-Auth: 6dwxiQXB_iekVKSWfiHRbo_uVCo
Message-ID: <CAOqmu81Np91-GRe-GndjE2FnbGA-xttvu64gr=h9FaNpbBSoBw@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: Implement free_opp_table function
From: Inderpal Singh <inderpal.s@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 10:41 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 16 May 2014 22:38, Inderpal Singh <inderpal.s@samsung.com> wrote:
>>>> +       while (!list_empty(&dev_opp->opp_list)) {
>>>> +               opp = list_entry_rcu(dev_opp->opp_list.next,
>>>> +                                       struct dev_pm_opp, node);
>>>
>>> list_for_each_entry_rcu ?
>>>
>>
>> list_for_each_entry_rcu can not be used as opp is being deleted in the loop.
>
> So what? The above code can be replaced easily I think.
> This is how it is implemented:
>
> #define list_for_each_entry_rcu(pos, head, member) \
>         for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
>                 &pos->member != (head); \
>                 pos = list_entry_rcu(pos->member.next, typeof(*pos), member))

by the time "pos = list_entry_rcu(pos->member.
next, typeof(*pos), member)" is executed, the pos would have been
freed in the loop.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
