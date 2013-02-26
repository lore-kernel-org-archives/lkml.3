Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab3BZNQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 08:16:41 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41733 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852Ab3BZNQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 08:16:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAKfTPtBgEsEJUD+C55Tad8xi3areARQ4GV8WjTaCjncj8hONEA@mail.gmail.com>
References: <1361435356-28466-1-git-send-email-vincent.guittot@linaro.org>
	<20130222123213.GA17948@somewhere.redhat.com>
	<CAKfTPtBgEsEJUD+C55Tad8xi3areARQ4GV8WjTaCjncj8hONEA@mail.gmail.com>
Date: Tue, 26 Feb 2013 14:16:38 +0100
Message-ID: <CAFTL4hz5OzFGfhsj2bNR+76VrpXCxyDtN6fqC1cYF3zpJpjOTg@mail.gmail.com>
Subject: Re: [PATCH v4] sched: fix init NOHZ_IDLE flag
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, rostedt@goodmis.org,
        efault@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/22 Vincent Guittot <vincent.guittot@linaro.org>:
> I wanted to avoid having to use the sd pointer for testing NOHZ_IDLE
> flag because it occurs each time we go into idle but it seems to be
> not easily feasible.
> Another solution could be to add a synchronization step between
> rcu_assign_pointer(dom 1, NULL) and create new domain to ensure that
> all pending access to old sd values, has finished but this will imply
> a potential delay in the rebuild  of sched_domain and i'm not sure
> that it's acceptable

The other issue is that we'll need to abuse the fact that struct
sched_domain is per cpu in order to store a per cpu state there.
That's a bit ugly but at least safer.

Also, are struct sched_group and struct sched_group_power shared among
several CPUs or are they per CPUs allocated as well? I guess they
aren't otherwise nr_cpus_busy would be pointless.
