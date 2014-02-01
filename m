Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbaBAUOF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 15:14:05 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:59731 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbaBAUOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 15:14:02 -0500
Date: Sat, 1 Feb 2014 15:13:59 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: "Brown, Len" <len.brown@intel.com>
cc: Arjan van de Ven <arjan@linux.intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Preeti Murthy <preeti.lkml@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: RE: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
In-Reply-To: <1A7043D5F58CCB44A599DFD55ED4C948452D3706@FMSMSX106.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.11.1402011502070.2312@knanqh.ubzr>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org> <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org> <20140130153150.GD5002@laptop.programming.kicks-ass.net> <52EA7D8A.6080604@linaro.org> <20140130163501.GG5002@laptop.programming.kicks-ass.net>
 <52EA8B07.6020206@linaro.org> <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com> <20140131090230.GM5002@laptop.programming.kicks-ass.net> <52EB6F65.8050008@linux.vnet.ibm.com> <52EBBC23.8020603@linux.intel.com> <52EBC33A.6080101@linaro.org>
 <52EBC645.2040607@linux.intel.com> <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr> <1A7043D5F58CCB44A599DFD55ED4C948452D34DC@FMSMSX106.amr.corp.intel.com> <alpine.LFD.2.11.1402011028400.2312@knanqh.ubzr>
 <1A7043D5F58CCB44A599DFD55ED4C948452D3706@FMSMSX106.amr.corp.intel.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Feb 2014, Brown, Len wrote:

> > And your point is?
> 
> It is a bad idea for an individual CPU to track the C-state
> of another CPU, which can change the cycle after it was checked.

Absolutely.  And I'm far from advocating we do this either.

> We know it is a bad idea because we used to do it,
> until we realized code here can easily impact the
> performance critical path.
> 
> In general, it is the OS's job to communicate constraints
> to the HW, and the HW to act on them.  Not all HW is smart,
> so sometimes the OS has to do more hand-holding -- but
> less is more.

Less is more indeed.  I'm certainly a big fan of that principle.

Just so you understand more about the context we need to care for on 
ARM, I'd invite you to have a look at 
Documentation/arm/cluster-pm-race-avoidance.txt.

I'm advocating we do _not_ track everything at the scheduler domain 
simply because some cluster states are possible only if all the CPUs in 
a cluster are idle, and that idleness is already tracked by the 
scheduler at the scheduling domain level.  So the information we don't 
update can already be inferred indirectly and cheaply with the 
information in place today.


Nicolas
