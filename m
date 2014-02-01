Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227AbaBAPbx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 10:31:53 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:44516 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaBAPbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 10:31:51 -0500
Date: Sat, 1 Feb 2014 10:31:47 -0500 (EST)
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
In-Reply-To: <1A7043D5F58CCB44A599DFD55ED4C948452D34DC@FMSMSX106.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.11.1402011028400.2312@knanqh.ubzr>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org> <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org> <20140130153150.GD5002@laptop.programming.kicks-ass.net> <52EA7D8A.6080604@linaro.org> <20140130163501.GG5002@laptop.programming.kicks-ass.net>
 <52EA8B07.6020206@linaro.org> <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com> <20140131090230.GM5002@laptop.programming.kicks-ass.net> <52EB6F65.8050008@linux.vnet.ibm.com> <52EBBC23.8020603@linux.intel.com> <52EBC33A.6080101@linaro.org>
 <52EBC645.2040607@linux.intel.com> <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr> <1A7043D5F58CCB44A599DFD55ED4C948452D34DC@FMSMSX106.amr.corp.intel.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Feb 2014, Brown, Len wrote:

> > Right now (on ARM at least but I imagine this is pretty universal), the
> > biggest impact on information accuracy for a CPU depends on what the
> > other CPUs are doing.  The most obvious example is cluster power down.
> > For a cluster to be powered down, all the CPUs sharing this cluster must
> > also be powered down.  And all those CPUs must have agreed to a possible
> > cluster power down in advance as well.  But it is not because an idle
> > CPU has agreed to the extra latency imposed by a cluster power down that
> > the cluster has actually powered down since another CPU in that cluster
> > might still be running, in which case the recorded latency information
> > for that idle CPU would be higher than it would be in practice at that
> > moment.
> 
> That will not work.

What will not work?

> When a CPU goes idle, it uses the CURRENT criteria for entering that state.
> If the criteria change after it has entered the state, are you going
> to wake it up so it can re-evaluate?  No.

That's not what I'm saying at all.

> That is why the state must describe the worst case latency
> that CPU may see when waking from the state on THAT entry.

No disagreement there.  Isn't that what I'm saying?

> That is why we use the package C-state numbers to describe
> core C-states on IA.

And your point is?


Nicolas
