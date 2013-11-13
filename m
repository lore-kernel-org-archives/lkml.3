Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab3KMLXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:23:40 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42382 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab3KMLXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:23:38 -0500
Date: Wed, 13 Nov 2013 16:53:29 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Preeti Murthy <preeti.lkml@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        mikey@neuling.org, linux-tip-commits@vger.kernel.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] sched: Check sched_domain before computing group
 power.
Message-ID: <20131113112329.GC543@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
 <20131112105547.GA27310@linux.vnet.ibm.com>
 <20131112115736.GO5056@laptop.programming.kicks-ass.net>
 <20131112164126.GF2559@linux.vnet.ibm.com>
 <CAM4v1pNMn=5oZDiX3fUp9uPkZTPJgk=vEKEjevzvpwn=PjTzXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAM4v1pNMn=5oZDiX3fUp9uPkZTPJgk=vEKEjevzvpwn=PjTzXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111311-0320-0000-0000-000001B51A19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Preeti Murthy <preeti.lkml@gmail.com> [2013-11-13 16:22:37]:

> Hi Srikar,
> 
> update_group_power() is called only during load balancing during
> update_sg_lb_stats().
> Load balancing begins at the base domain of the CPU,rq(cpu)->sd. This is
> checked for
> NULL. So how can update_group_power() be called in a scenario where the
> base domain
> of the CPU is not initialized? I say 'initialized' since you check for NULL
> on rq(cpu)->sd.
> 

update_group_power() also gets called from init_sched_groups_power().
And if you see the oops message, we know that the oops happens from that
path. In build_sched_domains(), we do cpu_attach_domain() what updates
rq->sd after the call to init_sched_groups_power(). So by the time
init_sched_groups_power() is called rq->sd is not yet initialized. 

We only hit oops case, when the sd->flags has SD_OVERLAP set.



> In the changelog, you say 'updated'. Are you saying that it has a stale
> value?

I said, "before the sched_domain for a cpu is updated", so its not yet
updated or has stale value. As I said earlier in this mail, the
initialization happens after we do a update_group_power().

> Please do elaborate on how you observed this.
> 

Does this clarify?

-- 
Thanks and Regards
Srikar Dronamraju

