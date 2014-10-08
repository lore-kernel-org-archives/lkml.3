Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbaJHVlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:41:05 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61508 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753607AbaJHVlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:41:03 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lan Tianyu <tianyu.lan@intel.com>, mingo@kernel.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, ktkhai@parallels.com, fabf@skynet.be,
        laijs@cn.fujitsu.com, srivatsa.bhat@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, srivatsa@mit.edu, viresh.kumar@linaro.org,
        todd.e.brandt@linux.intel.com, tipbot@zytor.com,
        wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH V3 0/3] PM/CPU: Parallel enalbing nonboot cpus with resume devices
Date: Thu, 09 Oct 2014 00:01:07 +0200
Message-ID: <4197503.BlOq2OYB1L@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141008205441.GJ4750@worktop.programming.kicks-ass.net>
References: <1411633925-9018-1-git-send-email-tianyu.lan@intel.com> <20141008205441.GJ4750@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 08, 2014 10:54:41 PM Peter Zijlstra wrote:
> On Thu, Sep 25, 2014 at 04:32:02PM +0800, Lan Tianyu wrote:
> > This patchset is to parallel enabling nonboot cpus with resuming devices
> > during system resume in order to accelerate S2RAM. From test result on
> > a 8 logical core Haswell machine, system resume time reduces from 347ms
> > to 217ms with this patchset.
> > 
> > In the current world, all nonboot cpus are enabled serially during system
> > resume. System resume sequence is that boot cpu enables nonboot cpu one by
> > one and then resume devices. Before resuming devices, there are few tasks
> > assigned to nonboot cpus after they are brought up. This wastes cpu usage.
> > 
> > This patchset is to allow boot cpu to go forward to resume devices after
> > bringing up one nonboot cpu and starting a thread. The thread will be in
> > charge of bringing up other frozen cpus. The thread will be scheduled to
> > the first online cpu to run . This makes enabling cpu2~x parallel with
> > resuming devices.
> 
> So I feel we should really clean up hotplug before doing anything like
> this. Its a trainwreck and just piling more and more hacks ontop isn't
> going to help any.

Agreed.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
