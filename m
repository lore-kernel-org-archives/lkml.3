Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbaBURFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:05:31 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:41641 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbaBURF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:05:29 -0500
MIME-Version: 1.0
In-Reply-To: <530786A2.6080406@hp.com>
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
	<53029167.4060109@zytor.com>
	<20140218073111.GW27965@twins.programming.kicks-ass.net>
	<5303B4C4.2040907@hp.com>
	<20140218212827.GR14089@laptop.programming.kicks-ass.net>
	<5303FDEC.9060001@hp.com>
	<20140219085107.GG27965@twins.programming.kicks-ass.net>
	<53050501.3070101@hp.com>
	<CA+55aFwyVgLJq2OgKZBK7g+T5-_M4o+dnEAr+qtYxA5t_=HSvA@mail.gmail.com>
	<5306413F.3010106@hp.com>
	<53065838.90102@linux.vnet.ibm.com>
	<530786A2.6080406@hp.com>
Date: Fri, 21 Feb 2014 09:05:27 -0800
X-Google-Sender-Auth: uirMyeN8X7agj2i-N-TpBdTokIM
Message-ID: <CA+55aFwiHdFUnGRnYr_mXR0ga=exMiK0Xg8CcDXWyOWC7Vw9JQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] qspinlock: Introducing a 4-byte queue spinlock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 9:02 AM, Waiman Long <waiman.long@hp.com> wrote:
> On 02/20/2014 02:32 PM, Raghavendra K T wrote:
>>
>> On 02/20/2014 11:24 PM, Waiman Long wrote:
>>
>>> Now the key is how to detect if a kernel is really running in a PV
>>> environment. I need to ask some virtualization experts on that.
>>>
>>
>> For kvm you could just follow,
>> kvm_spinlock_init_jump() and KVM_FEATURE_* encoding in cpuid
>> part __do_cpuid_ent().
>>
>
> I saw that in the arch/x86/kernel/kvm.c file. So I think I can use the
> returned value of kvm_para_available() to decide if it is running in a KVM
> guest. However, I am not so sure of what to use in xen.

Just use that 'paravirt_ticketlocks_enabled' static key. Xen enables it too.

            Linus
