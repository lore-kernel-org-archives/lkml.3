Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab3J3ODv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:03:51 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:40106 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3J3ODt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:03:49 -0400
Message-ID: <527111BD.9010803@gmail.com>
Date: Wed, 30 Oct 2013 08:03:41 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, yoshihiro.yunomae.ez@hitachi.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: RFC: paravirtualizing perf_clock
References: <526DBD7F.1010807@gmail.com> <20131028131556.GN19466@laptop.lan> <526F2440.9030607@gmail.com> <5270A03F.8020301@hitachi.com>
In-Reply-To: <5270A03F.8020301@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/13 11:59 PM, Masami Hiramatsu wrote:
> (2013/10/29 11:58), David Ahern wrote:
>> To back out a bit, my end goal is to be able to create and merge
>> perf-events from any context on a KVM-based host -- guest userspace,
>> guest kernel space, host userspace and host kernel space (userspace
>> events with a perf-clock timestamp is another topic ;-)).
>
> That is almost same as what we(Yoshihiro and I) are trying on integrated
> tracing, we are doing it on ftrace and trace-cmd (but perhaps, it eventually
> works on perf-ftrace).

I thought at this point (well, once perf-ftrace gets committed) that you 
can do everything with perf. What feature is missing in perf that you 
get with trace-cmd or using debugfs directly?


>> And then for the cherry on top a design that works across architectures
>> (e.g., x86 now, but arm later).
>
> I think your proposal is good for the default implementation, it doesn't
> depends on the arch specific feature. However, since physical timer(clock)
> interfaces and virtualization interfaces strongly depends on the arch,
> I guess the optimized implementations will become different on each arch.
> For example, maybe we can export tsc-offset to the guest to adjust clock
> on x86, but not on ARM, or other devices. In that case, until implementing
> optimized one, we can use paravirt perf_clock.

So this MSR read takes about 1.6usecs (from 'perf stat kvm live') and 
that is total time between VMEXIT and VMENTRY. The time it takes to run 
perf_clock in the host should be a very small part of that 1.6 usec. 
I'll take a look at the TSC path to see how it is optimized (suggestions 
appreciated).

Another thought is to make the use of pv_perf_clock an option -- user 
can knowingly decide the additional latency/overhead is worth the feature.

David

