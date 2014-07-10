Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbaGJOEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:04:13 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42477 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaGJOEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140710111833.GY3935@laptop>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-9-git-send-email-vincent.guittot@linaro.org> <20140710111833.GY3935@laptop>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 10 Jul 2014 16:03:51 +0200
Message-ID: <CAKfTPtD=TiURcppZ+oVUmhMf6Ofxbp4BPA0SCFViu0SDb05oRw@mail.gmail.com>
Subject: Re: [PATCH v3 08/12] sched: move cfs task on a CPU with higher capacity
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2014 13:18, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jun 30, 2014 at 06:05:39PM +0200, Vincent Guittot wrote:
>> +             /*
>> +              * If the CPUs share their cache and the src_cpu's capacity is
>> +              * reduced because of other sched_class or IRQs, we trig an
>> +              * active balance to move the task
>> +              */
>> +             if ((sd->flags & SD_SHARE_PKG_RESOURCES)
>> +              && ((capacity_orig_of(src_cpu) * 100) > (capacity_of(src_cpu) *
>> +                                                     sd->imbalance_pct)))
>>                       return 1;
>
> Why is this tied to shared caches?

It's just to limit the change of the policy to a level that can have
benefit without performance regression. I'm not sure that we can do
that at any level without risk
