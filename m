Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaGJN77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:59:59 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:63363 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaGJN76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:59:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140710112441.GZ3935@laptop>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-9-git-send-email-vincent.guittot@linaro.org> <20140710112441.GZ3935@laptop>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 10 Jul 2014 15:59:37 +0200
Message-ID: <CAKfTPtC5pGr=0g=1ODT=fQL+XFXzU8nG6Fs8o2G3OYUFovvnfw@mail.gmail.com>
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

On 10 July 2014 13:24, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jun 30, 2014 at 06:05:39PM +0200, Vincent Guittot wrote:
>> +             if ((sd->flags & SD_SHARE_PKG_RESOURCES)
>> +              && ((capacity_orig_of(src_cpu) * 100) > (capacity_of(src_cpu) *
>> +                                                     sd->imbalance_pct)))
>
>
>> +             if ((rq->cfs.h_nr_running >= 1)
>> +              && ((rq->cpu_capacity * sd->imbalance_pct) <
>> +                                     (rq->cpu_capacity_orig * 100))) {
>
> That's just weird indentation and operators should be at the end not at
> the beginning of a line-break.

Ok, i'm going to fix it
