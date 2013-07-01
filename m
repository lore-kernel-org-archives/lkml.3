Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3GANkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:40:45 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:2971 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3GANkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:40:43 -0400
Message-ID: <51D186CD.9030302@hp.com>
Date: Mon, 01 Jul 2013 09:40:29 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com> <1372268603-46748-2-git-send-email-Waiman.Long@hp.com> <CA+55aFzo5Jy064pbvEZh5cg_RJiSxe1R+tSgByQTs4rc=4SN3Q@mail.gmail.com> <51CF422E.7030803@hp.com> <CA+55aFyVOSa7gOVuBVQqK+wQkgc_2+KZ3Ejx9gPYF=o_Lc3sqg@mail.gmail.com> <CA+55aFxxUoJYXbN4yqeAbKNKEYpcVMLwopmDuh7sPhT5jnqOEw@mail.gmail.com>
In-Reply-To: <CA+55aFxxUoJYXbN4yqeAbKNKEYpcVMLwopmDuh7sPhT5jnqOEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2013 06:47 PM, Linus Torvalds wrote:
> On Sat, Jun 29, 2013 at 2:58 PM, Linus Torvalds
> <torvalds@linux-foundation.org>  wrote:
>> STEP 1:
>>
>>   - create a new set of config option (say
>> "CONFIG_[ARCH_]SPINLOCK_REFCOUNT") that defaults to 'y' and isn't
>> actually asked about anywhere.
> That "defauls to 'y'" was incomplete/misleading. The
> ARCH_SPINLOCK_REFCOUNT config option should default to 'n' (the
> example code snippet did that correctly: a bool config option defaults
> to 'n' unless stated otherwise).
>
> The SPINLOCK_REFCOUNT in turn _should_ have a "default y" (the sample
> snippet I posted didn't have that), but that 'y' is then obviously
> normally disabled by the "depends on" logic, so it only takes effect
> when ARCH_SPINLOCK_REFCOUNT is set, and none of the spinlock debug
> things are enabled.
>
> I hope that was all fairly obvious from the concept (and the real
> examples of us already doing things like this with the whole
> CONFIG_GENERIC_STRNLEN_USER and CONFIG_DCACHE_WORD_ACCESS examples),
> but I thought I'd follow up with an explicit correction, since both
> the explanation and sample snippets were somewhat misleading.
>
>                  Linus

Thank for the clarification, but I had already understood the 
implication of your suggestion. Each architecture has to explicitly 
opt-in by defining an ARCH_SPINLOCK_REFCOUNT in its Kconfig file to have 
this lockref feature enabled. In this way, each architecture can take 
its time to verify it works before enabling it. My patch will enable 
enable the x86 as I don't have test machines for the other architectures.

Regards,
Longman
