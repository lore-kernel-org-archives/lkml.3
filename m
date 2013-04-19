Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab3DSIcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 04:32:45 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:43671 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3DSIcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 04:32:42 -0400
Message-ID: <5171006D.40600@linux.vnet.ibm.com>
Date: Fri, 19 Apr 2013 13:59:33 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Robin Holt <holt@sgi.com>,
        Ingo Molnar <mingo@redhat.com>, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [Patch -v4 1/4] Migrate shutdown/reboot to boot cpu.
References: <20130416095827.GJ3672@sgi.com> <20130416113256.GA10452@gmail.com> <20130416120624.GO3658@sgi.com> <20130416140101.GS3658@sgi.com> <20130417074653.GA31607@gmail.com> <20130417092737.GA12402@pd.tnic> <20130419075629.GE20897@gmail.com>
In-Reply-To: <20130419075629.GE20897@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041908-1618-0000-0000-000003B9CF12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 01:26 PM, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@alien8.de> wrote:
> 
>> On Wed, Apr 17, 2013 at 09:46:53AM +0200, Ingo Molnar wrote:
>>
>>> What you mention here should indeed already be handled by the architecture 
>>> hotplug code (for example on x86 the boot CPU cannot be hot-removed).
>>
>> Supposedly, some new Intels (I think Ivybridge or so) can actually be 
>> hot-removed.
> 
> There are WIP patches in existence that remove the limitations on the kernel side, 
> but they are not upstream yet, so currently the constraint exists upstream.
> 

I thought Fenghua Yu's upstream commits were supposed to handle that. Don't they?

a71c8bc x86, topology: Debug CPU0 hotplug
6f5298c x86/i387.c: Initialize thread xstate only on CPU0 only once
8d966a0 x86, hotplug: Handle retrigger irq by the first available CPU
30242aa x86, hotplug: The first online processor saves the MTRR state
27fd185 x86, hotplug: During CPU0 online, enable x2apic, set_numa_node.
e1c467e x86, hotplug: Wake up CPU0 via NMI instead of INIT, SIPI, SIPI
3e2a0cc x86-32, hotplug: Add start_cpu0() entry point to head_32.S
42e78e9 x86-64, hotplug: Add start_cpu0() entry point to head_64.S
6e32d47 kernel/cpu.c: Add comment for priority in cpu_hotplug_pm_callback
209efae x86, hotplug, suspend: Online CPU0 for suspend or hibernate
30106c1 x86, hotplug: Support functions for CPU0 online/offline
4d25031 x86, topology: Don't offline CPU0 if any PIC irq can not be migrated out of it
80aa1df x86, Kconfig: Add config switch for CPU0 hotplug
f78cff4 doc: Add x86 CPU0 online/offline feature
 
Regards,
Srivatsa S. Bhat

