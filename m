Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaIZMkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:40:04 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:48411 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaIZMkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:40:02 -0400
MIME-Version: 1.0
In-Reply-To: <54246ACE.1080502@arm.com>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org>
 <542303DF.8010606@arm.com> <CAKfTPtB3-M+pXaurDeWkWGNJ3_mU-FN+EnshGE-eg_r41Hppag@mail.gmail.com>
 <54246ACE.1080502@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 26 Sep 2014 14:39:41 +0200
Message-ID: <CAKfTPtAHP_U=C4s6MO-zcJkaEwJB_0VuZ=D6JnTYTeEt_EtBXQ@mail.gmail.com>
Subject: Re: [PATCH v6 5/6] sched: replace capacity_factor by usage
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2014 21:19, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> On 25/09/14 09:35, Vincent Guittot wrote:

[snip]

>>>
>>> In case sgs->group_type is group_overloaded you could set
>>> sgs->group_out_of_capacity to 1 without calling group_is_overloaded again.
>>
>> I prefer to keep sgs->group_out_of_capacity = group_is_overloaded(sgs,
>> env) and use it in group_classify in case of future changes in the
>> classification order
>
> Ok, but than group_is_overloaded is called twice at the end of
> update_sg_lb_stats with exactly the same result. Looks weird in my traces.

sorry i don't catch your point.
group_is_overloaded() is called once for group_out_of_capacity which
is then used in group_classify so it should be called only once

>
>>
> [...]
>
>
