Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab3CVTBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:01:17 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53148 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab3CVTBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:01:16 -0400
From: Kevin Hilman <khilman@linaro.org>
To: paulmck@linux.vnet.ibm.com
Cc: Christoph Lameter <cl@linux.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, geoff@infradead.org,
        tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
	<1363636794.15703.32@driftwood>
	<CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
	<20130318222548.GG3656@linux.vnet.ibm.com>
	<1363822338.6345.33.camel@gandalf.local.home>
	<20130320235545.GL3637@linux.vnet.ibm.com>
	<0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com>
	<20130321171518.GW3637@linux.vnet.ibm.com>
	<0000013d8e3f58ce-0f6ea95f-780a-49c1-a633-5aa0cf3e5040-000000@email.amazonses.com>
	<20130321185821.GF3637@linux.vnet.ibm.com>
Date: Fri, 22 Mar 2013 12:01:12 -0700
In-Reply-To: <20130321185821.GF3637@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Thu, 21 Mar 2013 11:58:21 -0700")
Message-ID: <87ehf7b6o7.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

>> >
>> > In the meantime, one approach is to bind all these SCHED_OTHER tasks
>> > to designated housekeeping CPU(s) that don't run your main workload.
>> 
>> One cannot bind kevent threads and other per cpu threads to another
>> processor. So right now there is no way to avoid this issue.
>
> Yep, my approach works only for those threads that are free to migrate.
> Of course, in some cases, you can avoid per-CPU threads running by pinning
> interrupts, avoiding certain operations in your workload, and so on.

Speaking of threads that are not free to migrate, you might add a bit to
the doc explaining that these various kernel threads that cannot migrate
are also potential sources of jitter and also reasons why a CPU may exit
(or not enter) full nohz mode.

And thanks a ton for writing up this detailed doc.  Speaking as someone
trying to get full nohz working on a new arch (ARM), getting my head
around all of this has been challenging, and your doc is a great help.

Kevin
