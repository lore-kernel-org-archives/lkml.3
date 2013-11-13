Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab3KMPrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:47:20 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39710 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab3KMPrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:47:17 -0500
Message-ID: <52839F04.60702@arm.com>
Date: Wed, 13 Nov 2013 15:47:16 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [RFC][PATCH v5 01/14] sched: add a new arch_sd_local_flags for
 sched_domain init
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org> <1382097147-30088-2-git-send-email-vincent.guittot@linaro.org> <20131105140626.GP31370@twins.programming.kicks-ass.net> <CAKfTPtCYHKRv=w3b4tZV-2BW_a_T+tkO9Qpc0PhLD=uZY1yvfw@mail.gmail.com> <20131105222752.GD16117@laptop.programming.kicks-ass.net> <20131106145344.448d7733@mschwide> <20131106140807.GM10651@twins.programming.kicks-ass.net> <528268C8.8010501@arm.com> <20131112180844.GF21461@twins.programming.kicks-ass.net>
In-Reply-To: <20131112180844.GF21461@twins.programming.kicks-ass.net>
X-OriginalArrivalTime: 13 Nov 2013 15:47:12.0826 (UTC) FILETIME=[9EB609A0:01CEE087]
X-MC-Unique: 113111315471402201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13 18:08, Peter Zijlstra wrote:
> On Tue, Nov 12, 2013 at 05:43:36PM +0000, Dietmar Eggemann wrote:
>> This patch removes the sched_domain initializer macros
>> SD_[SIBLING|MC|BOOK|CPU]_INIT in core.c and in archs and replaces them
>> with calls to the new function sd_init().  The function sd_init
>> incorporates the already existing function sd_numa_init().
> 
> Your patch retains far too much of the weird behavioural variations we
> have, nor does it create a proper separation between topology and
> behaviour.

Could you please explain a little bit further on the weird behavioural
variations. Are you referring to the specific SD_ flags or sd_domain levels?
I agree that this patch doesn't separate behaviour and topology and I
will consider this going forward.

> 
> We might indeed have to have a single arch_() function that adds
> SD_flags, but please restrict the flags it can set -- never allow it to
> set behavioural flags.

Understood. Simply exporting an sd_domain pointer is a no-go.

> 
> Furthermore, I think we want to allow the arch to override the base
> topology; we've had desire to add per arch level in the past.. eg. add
> an L2 level for some x86 variants.

I quite don't understand this one. Are you saying that one idea for the
topology side of things is to have an extra arch specific sd level which
would be the only sd_domain level which could be then overridden by the
arch?

Thanks,

-- Dietmar

> 
> 
> 


