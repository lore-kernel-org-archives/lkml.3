Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab3KLKgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:36:36 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:62677 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3KLKgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:36:33 -0500
MIME-Version: 1.0
In-Reply-To: <20131111163859.GE26898@twins.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
	<CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com>
	<20131111163859.GE26898@twins.programming.kicks-ass.net>
Date: Tue, 12 Nov 2013 11:36:31 +0100
Message-ID: <CAKfTPtD=s-gwmT3SWHukeZE13gXZqD9fR+sZLGm-p3zFu6RwvQ@mail.gmail.com>
Subject: Re: [RFC][PATCH v5 00/14] sched: packing tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Tony Luck <tony.luck@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 November 2013 17:38, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Nov 11, 2013 at 11:33:45AM +0000, Catalin Marinas wrote:
>> My understanding from the recent discussions is that the scheduler
>> should decide directly on the C-state (or rather the deepest C-state
>> possible since we don't want to duplicate the backend logic for
>> synchronising CPUs going up or down). This means that the scheduler
>> needs to know about C-state target residency, wake-up latency (I think
>> we can leave coupled C-states to the backend, there is some complex
>> synchronisation which I wouldn't duplicate).
>>
>> Alternatively (my preferred approach), we get the scheduler to predict
>> and pass the expected residency and latency requirements down to a
>> power driver and read back the actual C-states for making task
>> placement decisions. Some of the menu governor prediction logic could
>> be turned into a library and used by the scheduler. Basically what
>> this tries to achieve is better scheduler awareness of the current
>> C-states decided by a cpuidle/power driver based on the scheduler
>> constraints.
>
> Ah yes.. so I _think_ the scheduler wants to eventually know about idle
> topology constraints. But we can get there in a gradual fashion I hope.
>
> Like the package C states on x86 -- for those to be effective the
> scheduler needs to pack tasks and keep entire packages idle for as long
> as possible.

That's the purpose of patches 12, 13 and 14. To get the current wakeup
latency of a core and use it when selecting a core

>
>
