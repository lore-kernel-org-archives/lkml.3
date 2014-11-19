Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaKSOlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:41:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbaKSOlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:41:21 -0500
Date: Wed, 19 Nov 2014 09:41:05 -0500
From: Don Zickus <dzickus@redhat.com>
To: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>, vgoyal@redhat.com
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141119144105.GB108701@redhat.com>
References: <20141117170359.GA1382@redhat.com>
 <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
 <20141118020959.GA2091@redhat.com>
 <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
 <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141118220254.GA2571@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118220254.GA2571@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 05:02:54PM -0500, Dave Jones wrote:
> On Tue, Nov 18, 2014 at 04:55:40PM -0500, Don Zickus wrote:
> 
>  > > So here we mangle CPU3 in and lose the backtrace for cpu0, which might
>  > > be the real interesting one ....
>  > 
>  > Can you provide another dump?  The hope is we get something not mangled?
> 
> Working on it..
> 
>  > The other option we have done in RHEL is panic the system and let kdump
>  > capture the memory.  Then we can analyze the vmcore for the stack trace
>  > cpu0 stored in memory to get a rough idea where it might be if the cpu
>  > isn't responding very well.
> 
> I don't know if it's because of the debug options I typically run with,
> or that I'm perpetually cursed, but I've never managed to get kdump to
> do anything useful. (The last time I tried it was actively harmful in
> that not only did it fail to dump anything, it wedged the machine so
> it didn't reboot after panic).
> 
> Unless there's some magic step missing from the documentation at
> http://fedoraproject.org/wiki/How_to_use_kdump_to_debug_kernel_crashes
> then I'm not optimistic it'll be useful.

Well, I don't know when the last time you ran it, but I know the RH kexec
folks have started pursuing a Fedora-first package patch rule a couple of
years ago to ensure Fedora had a working kexec/kdump solution.

As for the wedging part, it was a common problem to have the kernel hang
while trying to boot the second kernel (and before console output
happened).  So the problem makes sense and is unfortunate.  I would
encourage you to try again.  :-)

Though, it is transitioning to have the app built into the kernel to deal
with the whole secure boot thing, so that might be another can of worms.

I cc'd Vivek and he can let us know how well it works with F21.

Cheers,
Don
