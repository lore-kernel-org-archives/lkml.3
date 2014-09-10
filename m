Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaIJOXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:23:49 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:65120 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaIJOUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:20:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140910135339.GQ3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-7-git-send-email-vincent.guittot@linaro.org> <20140910135339.GQ3190@worktop.ger.corp.intel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 10 Sep 2014 16:19:56 +0200
Message-ID: <CAKfTPtAmUe3GUL51Ow24pVq4Q2pMKJO5A7wG1Mic+akg=ozkjg@mail.gmail.com>
Subject: Re: [PATCH v5 06/12] sched: add per rq cpu_capacity_orig
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
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

On 10 September 2014 15:53, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Aug 26, 2014 at 01:06:49PM +0200, Vincent Guittot wrote:
>> This new field cpu_capacity_orig reflects the available capacity of a CPUs
>> unlike the cpu_capacity which reflects the current capacity that can be altered
>> by frequency and rt tasks.
>>
>
> No real objection to the patch as such, but the Changelog fails to tell
> us why you want this.

the cpu_capacity_orig  is used in several places in the following
patches to detect when a CPU's capacity has been noticeably reduced so
we can trig load balance to look for a CPU with full capacity.
As an example, we can detect when a CPU handles a significant amount
of irq (with CONFIG_IRQ_TIME_ACCOUNTING) but is seen as an idle CPU by
scheduler whereas really idle CPU are available
