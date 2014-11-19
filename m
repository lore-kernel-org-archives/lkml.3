Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaKSPDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:03:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbaKSPDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:03:40 -0500
Date: Wed, 19 Nov 2014 10:03:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141119150333.GB2953@redhat.com>
References: <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
 <20141118020959.GA2091@redhat.com>
 <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
 <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141118220254.GA2571@redhat.com>
 <20141119144105.GB108701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119144105.GB108701@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 09:41:05AM -0500, Don Zickus wrote:
> On Tue, Nov 18, 2014 at 05:02:54PM -0500, Dave Jones wrote:
> > On Tue, Nov 18, 2014 at 04:55:40PM -0500, Don Zickus wrote:
> > 
> >  > > So here we mangle CPU3 in and lose the backtrace for cpu0, which might
> >  > > be the real interesting one ....
> >  > 
> >  > Can you provide another dump?  The hope is we get something not mangled?
> > 
> > Working on it..
> > 
> >  > The other option we have done in RHEL is panic the system and let kdump
> >  > capture the memory.  Then we can analyze the vmcore for the stack trace
> >  > cpu0 stored in memory to get a rough idea where it might be if the cpu
> >  > isn't responding very well.
> > 
> > I don't know if it's because of the debug options I typically run with,
> > or that I'm perpetually cursed, but I've never managed to get kdump to
> > do anything useful. (The last time I tried it was actively harmful in
> > that not only did it fail to dump anything, it wedged the machine so
> > it didn't reboot after panic).

Hi Dave Jones,

Not being able to capture the dump I can understand but having wedged
the machine so that it does not reboot after dump failure sounds bad.
So you could not get machine to boot even after a power cycle? Would
you remember what was failing. I am curious to know what did kdump do
to make machine unbootable.

> > 
> > Unless there's some magic step missing from the documentation at
> > http://fedoraproject.org/wiki/How_to_use_kdump_to_debug_kernel_crashes
> > then I'm not optimistic it'll be useful.

I had a quick look at it and it basically looks fine. In fedora ideally
it is just two steps process.

- Reserve memory using crashkernel. Say crashkernel=160M
- systemctl start kdump
- Crash the system or wait for it to crash.

So despite your bad experience in the past, I would encourage you to
give it a try.

> 
> Well, I don't know when the last time you ran it, but I know the RH kexec
> folks have started pursuing a Fedora-first package patch rule a couple of
> years ago to ensure Fedora had a working kexec/kdump solution.

Yep, now we are putting everything in fedora first so it should be much
better. Hard to say the same thing about driver authors. Sometimes they
might have a driver working in rhel and not necessarily upstream. I am
not sure if you ran into one of those issues.

Also recently I have seen issues with graphics drivers too.

> 
> As for the wedging part, it was a common problem to have the kernel hang
> while trying to boot the second kernel (and before console output
> happened).  So the problem makes sense and is unfortunate.  I would
> encourage you to try again.  :-)
> 
> Though, it is transitioning to have the app built into the kernel to deal
> with the whole secure boot thing, so that might be another can of worms.

I doubt that secureboot bits will contribute to the failure.

Thanks
Vivek
