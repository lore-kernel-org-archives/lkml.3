Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbaCKN1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:27:38 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:57376 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaCKN1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:27:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140311103119.GW9987@twins.programming.kicks-ass.net>
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
 <1394003906-11630-3-git-send-email-vincent.guittot@linaro.org>
 <53175A3C.8010100@arm.com> <CAKfTPtC1_t78hvOw9u-t1BqUZj_dO3WFYp2OjX=RFZP-A7zSbg@mail.gmail.com>
 <20140311103119.GW9987@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 11 Mar 2014 14:27:12 +0100
Message-ID: <CAKfTPtDHfXxheXBoPeAxMGROroHa7YrW7y_RCB9nSoKCeTa66w@mail.gmail.com>
Subject: Re: [PATCH 2/6] sched: rework of sched_domain topology definition
To: Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 March 2014 11:31, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Mar 06, 2014 at 04:32:35PM +0800, Vincent Guittot wrote:
>> > Never got the new name DIE for CPU? Might confuse people when they use
>> > /proc/sys/kernel/sched_domain/cpuX/domainY/name or sched_domain_debug_one().
>>
>> In fact, CPU is also confusing because it's used for different things.
>> But if it makes things even more confusing, i can come back to CPU
>
> Yeah, not sure DIE is the right thing either; because there's multi-die
> packages that get classified under CPU :-)
>
> Take for example the Core 2 Quad, which was 2 dual core dies glued
> together in a single package.
>
> There's also the AMD bulldozer which glued two dies into a single
> package; but for those its not a problem because each die is a separate
> numa node, so there DIE would actually be the correct term and PACKAGE
> would be wrong.
>
> So while CPU sucks, I'm not sure we can come up with anything that's
> actually correct. That said; we could try for something less wrong than
> CPU :-)

OK

Dietmar,

Have you got another naming that DIE that could suit better ?
otherwise i will keep it

Vincent

>
> I'm not sure there are a lot of people who see/know the names of these
> domains to be bothered by a change in them; it might be limited to just
> us for all I know.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
