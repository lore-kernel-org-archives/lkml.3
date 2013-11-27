Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab3K0OJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:09:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:12390 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755540Ab3K0OIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:08:50 -0500
Date: Wed, 27 Nov 2013 09:08:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>, svaidy@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, bitbucket@online.de,
        benh@kernel.crashing.org, anton@samba.org, Morten.Rasmussen@arm.com,
        pjt@google.com, mikey@neuling.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] in sched fair on v3.13-rc1+ doing hotplug
Message-ID: <20131127090845.0d728946@gandalf.local.home>
In-Reply-To: <20131127132243.GD10022@twins.programming.kicks-ass.net>
References: <20131127081345.0cab8b15@gandalf.local.home>
	<20131127132243.GD10022@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013 14:22:43 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Nov 27, 2013 at 08:13:45AM -0500, Steven Rostedt wrote:
> >         atomic_inc(&sd->groups->sgp->nr_busy_cpus);  <<---- BUG
> > unlock:
> >         rcu_read_unlock();
> > }
> 
> tip/sched/urgent has this one:
> 
> ---
> commit 42eb088ed246a5a817bb45a8b32fe234cf1c0f8b
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Tue Nov 19 16:41:49 2013 +0100
> 
>     sched: Avoid NULL dereference on sd_busy

After applying this patch, the bug does go away.

Thanks!

-- Steve
