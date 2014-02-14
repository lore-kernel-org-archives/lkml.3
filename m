Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaBNONt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:13:49 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45249 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbaBNONp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:13:45 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140121153851.GZ31570@twins.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org> <20131217123352.692059839@infradead.org>
 <CAHO5Pa3=+Zhg72tVfddSUvgirUyObir6atJVo4_16bVWB2Osgw@mail.gmail.com> <20140121153851.GZ31570@twins.programming.kicks-ass.net>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 14 Feb 2014 15:13:22 +0100
Message-ID: <CAKgNAkgw+U44SH0wd_06ZMXaCC9nCX4NZxZHkMKUdC7E7YxBhQ@mail.gmail.com>
Subject: Re: [PATCH 01/13] sched: Add 3 new scheduler syscalls to support an
 extended scheduling parameters ABI
To: Peter Zijlstra <peterz@infradead.org>, Dario Faggioli <raistlin@linux.it>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        rostedt@goodmis.org, Oleg Nesterov <oleg@redhat.com>,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, Linux Kernel <linux-kernel@vger.kernel.org>,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, Dario,

This is a little late in the day, but I think it's an important point
to just check before this API goes final.

> SYNOPSIS
>         #include <sched.h>
>
>         struct sched_attr {
>                 u32 size;
>
>                 u32 sched_policy;
>                 u64 sched_flags;
[...]
>         };
>
>         int sched_setattr(pid_t pid, const struct sched_attr *attr);
>
>         int sched_getattr(pid_t pid, const struct sched_attr *attr, unsigned int size);

So, I that there's a flags field in the structure, which allows for
some extensibility for these calls in the future. However, is it
worthwhile to consider adding a 'flags' argument in the base signature
of either of these calls, to allow for some possible extensions in the
future. (See http://lwn.net/SubscriberLink/585415/7b905c0248a158a2/ ).

Cheers,

Michael
