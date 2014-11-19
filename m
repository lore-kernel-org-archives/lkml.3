Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaKSApr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 19:45:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17300 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbaKSApq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 19:45:46 -0500
Message-ID: <546BE7F2.3070009@oracle.com>
Date: Tue, 18 Nov 2014 19:44:34 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
CC: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 00/11] Kernel address sanitizer - runtime memory debugger.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>	<1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>	<546BD866.5050101@oracle.com> <CAPAsAGxYF27pbNEgsr3PgNJ=uNFzR2qcviLB_7bp=nM3ZD5Jgw@mail.gmail.com>
In-Reply-To: <CAPAsAGxYF27pbNEgsr3PgNJ=uNFzR2qcviLB_7bp=nM3ZD5Jgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 07:09 PM, Andrey Ryabinin wrote:
> Yes with CONFIG_KASAN_INLINE you will get GPF instead of kasan report.
> For userspaces addresses we don't have shadow memory. In outline case
> I just check address itself before checking shadow. In inline case compiler
> just checks shadow, so there is no way to avoid GPF.
> 
> To be able to print report instead of GPF, I need to treat GPFs in a special
> way if inline instrumentation was enabled, but it's not done yet.

I went ahead and tested it with the test module, which worked perfectly. No
more complaints here...

>> > I remembered that one of the biggest changes in kasan was the introduction of
>> > inline instrumentation, so I went ahead to disable it and see if it helps. But
>> > the only result of that was having the boot process hang pretty early:
>> >
>> > [...]
>> > [    0.000000] IOAPIC[0]: apic_id 21, version 17, address 0xfec00000, GSI 0-23
>> > [    0.000000] Processors: 20
>> > [    0.000000] smpboot: Allowing 24 CPUs, 4 hotplug CPUs
>> > [    0.000000] e820: [mem 0xd0000000-0xffffffff] available for PCI devices
>> > [    0.000000] Booting paravirtualized kernel on KVM
>> > [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:24 nr_cpu_ids:24 nr_node_ids:1
>> > [    0.000000] PERCPU: Embedded 491 pages/cpu @ffff8808dce00000 s1971864 r8192 d31080 u2097152
>> > *HANG*
>> >
> This hang happens only with your error patch above or even without it?

It happens even without the patch.


Thanks,
Sasha
