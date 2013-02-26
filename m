Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757Ab3BZQlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:41:11 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:52435 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab3BZQlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:41:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAFTL4hz5OzFGfhsj2bNR+76VrpXCxyDtN6fqC1cYF3zpJpjOTg@mail.gmail.com>
References: <1361435356-28466-1-git-send-email-vincent.guittot@linaro.org>
	<20130222123213.GA17948@somewhere.redhat.com>
	<CAKfTPtBgEsEJUD+C55Tad8xi3areARQ4GV8WjTaCjncj8hONEA@mail.gmail.com>
	<CAFTL4hz5OzFGfhsj2bNR+76VrpXCxyDtN6fqC1cYF3zpJpjOTg@mail.gmail.com>
Date: Tue, 26 Feb 2013 17:41:08 +0100
Message-ID: <CAKfTPtAq4GWoc8oOaUt17ZePfa4PMq7NvPEZYrqo2cvDpGwsWQ@mail.gmail.com>
Subject: Re: [PATCH v4] sched: fix init NOHZ_IDLE flag
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, rostedt@goodmis.org,
        efault@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 February 2013 14:16, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2013/2/22 Vincent Guittot <vincent.guittot@linaro.org>:
>> I wanted to avoid having to use the sd pointer for testing NOHZ_IDLE
>> flag because it occurs each time we go into idle but it seems to be
>> not easily feasible.
>> Another solution could be to add a synchronization step between
>> rcu_assign_pointer(dom 1, NULL) and create new domain to ensure that
>> all pending access to old sd values, has finished but this will imply
>> a potential delay in the rebuild  of sched_domain and i'm not sure
>> that it's acceptable
>
> The other issue is that we'll need to abuse the fact that struct
> sched_domain is per cpu in order to store a per cpu state there.
> That's a bit ugly but at least safer.
>
> Also, are struct sched_group and struct sched_group_power shared among
> several CPUs or are they per CPUs allocated as well? I guess they
> aren't otherwise nr_cpus_busy would be pointless.

Yes they are shared between CPUs, per cpu sched_domain points to same
sched_group and sched_group_power.
