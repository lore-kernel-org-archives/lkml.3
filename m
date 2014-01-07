Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbaAGIXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:23:07 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:48601 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaAGIXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:23:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140106162145.GL31570@twins.programming.kicks-ass.net>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org> <20140106162145.GL31570@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 7 Jan 2014 09:22:40 +0100
Message-ID: <CAKfTPtAhSL99gTx8=wvaq=1ENzB9DQ697DQsOMqWMaj6o31LMg@mail.gmail.com>
Subject: Re: [RFC] sched: CPU topology try
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jon Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 January 2014 17:21, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Dec 18, 2013 at 02:13:51PM +0100, Vincent Guittot wrote:
>> This patch applies on top of the two patches [1][2] that have been proposed by
>> Peter for creating a new way to initialize sched_domain. It includes some minor
>> compilation fixes and a trial of using this new method on ARM platform.
>> [1] https://lkml.org/lkml/2013/11/5/239
>> [2] https://lkml.org/lkml/2013/11/5/449
>>
>> Based on the results of this tests, my feeling about this new way to init the
>> sched_domain is a bit mitigated.
>
> Yay :-)
>
>> We can add more levels that will describe other dependency/independency like
>> the frequency scaling dependency and as a result the final sched_domain
>> topology will have additional levels (if they have not been removed during
>> the degenerate sequence)
>
> Yeah, this 'creative' use of degenerate domains is pretty neat ;-)

thanks :-)

>
>> My concern is about the configuration of the table that is used to create the
>> sched_domain. Some levels are "duplicated" with different flags configuration
>> which make the table not easily readable and we must also take care of the
>> order  because parents have to gather all cpus of its childs. So we must
>> choose which capabilities will be a subset of the other one. The order is
>> almost straight forward when we describe 1 or 2 kind of capabilities
>> (package ressource sharing and power sharing) but it can become complex if we
>> want to add more.
>
> I think I see what you're saying, although I hope that won't actually
> happen in real hardware -- that said, people do tend to do crazy with
> these ARM chips :/

it should be ok for ARM chip because the cores in a cluster share the
same clock but it doesn't mean that it will not be possible in a near
future or on other arch.

>
> We should also try and be conservative in the topology flags we want to
> add, which should further reduce the amount of pain here.

yes, i see a interest for powerdomain sharing and clock sharing flags
so it should minimize the complexity

>
> For now I do think this is a viable approach.. Yes its a bit cumbersome
> for these asymmetric systems but it does give us enough to start
> playing.

ok

Vincent
>
> I yet have to read Morton's emails on the P and C states, will try to
> have a look at those tomorrow with a hopefully fresher brain -- somehow
> its the end of the day already..
