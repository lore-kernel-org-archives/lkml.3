Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaEOQMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:12:44 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:43001 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaEOQMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:12:42 -0400
Date: Thu, 15 May 2014 12:12:40 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 6/6] sched: final power vs capacity cleanup
In-Reply-To: <20140515072929.GZ30445@twins.programming.kicks-ass.net>
Message-ID: <alpine.LFD.2.11.1405151207170.17310@knanqh.ubzr>
References: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org> <1400101030-17717-7-git-send-email-nicolas.pitre@linaro.org> <20140515072929.GZ30445@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Peter Zijlstra wrote:

> On Wed, May 14, 2014 at 04:57:10PM -0400, Nicolas Pitre wrote:
> > It is better not to think about compute capacity as being equivalent to
> > "CPU power".  The upcoming "power aware" scheduler may create confusion
> > with the notion of energy consumption if "power" is used too liberally.
> > 
> > This contains the architecture visible changes.  Incidentally, only ARM
> > takes advantage of the available pow^H^H^Hcapacity scaling hooks and
> > therefore those changes outside kernel/sched/ are confined to one ARM
> > specific file.  The default arch_scale_smt_power() hook is not overridden
> > by anyone.
> > 
> > Replacements are as follows:
> > 
> > 	arch_scale_freq_power  --> arch_scale_freq_capacity
> > 	arch_scale_smt_power   --> arch_scale_smt_capacity
> > 	SCHED_POWER_SCALE      --> SCHED_CAPA_SCALE
> > 	SCHED_POWER_SHIFT      --> SCHED_POWER_SHIFT
> 
> The patch seems to actually make that CAPA_SHIFT

Huh... right, of course.

> > The local usage of "power" in arch/arm/kernel/topology.c is also changed
> > to "capacity" as appropriate.
> 
> For some reason every time I read: 'capa' I think of some south American
> monster -- http://en.wikipedia.org/wiki/Chupacabra, I'm not at all sure
> why my brain links them.

:-)

capa != paca

I chose that not to make this much longer than "POWER", and since there 
are already "LOAD" related constants, I thought there was some symetry 
to another 4-letter identifier.  Do you have other suggestions?


Nicolas
