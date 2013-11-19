Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3KSHDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 02:03:48 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:56566 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab3KSHDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 02:03:44 -0500
Date: Tue, 19 Nov 2013 08:03:39 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Adam Williamson <awilliam@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Peter Anvin <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>,
        Robin Holt <holt@sgi.com>, davej@fedoraproject.org,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/ACPI: Make Sony Vaio Z1 series to use "reboot=pci"
 default
Message-ID: <20131119070339.GC32367@gmail.com>
References: <1382719652.2445.1.camel@adam.happyassassin.net>
 <CA+55aFyZEZp3CSFEcxzKt0c_7Q9_juGWiqb7VH214Fjcs3wUkQ@mail.gmail.com>
 <1382750841.19471.72.camel@adam.happyassassin.net>
 <1382754015.19471.80.camel@adam.happyassassin.net>
 <20131026031759.GA8513@redhat.com>
 <1382772154.3604.1.camel@adam.happyassassin.net>
 <20131026091501.GE14237@gmail.com>
 <1382857589.2447.0.camel@adam.happyassassin.net>
 <20131101140223.GJ17455@8bytes.org>
 <1384818204.2584.2.camel@adam.happyassassin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384818204.2584.2.camel@adam.happyassassin.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adam Williamson <awilliam@redhat.com> wrote:

> On Fri, 2013-11-01 at 15:02 +0100, Joerg Roedel wrote:
> > On Sun, Oct 27, 2013 at 12:06:29AM -0700, Adam Williamson wrote:
> > > On Sat, 2013-10-26 at 11:15 +0200, Ingo Molnar wrote:
> > > >   CONFIG_IRQ_REMAP=y
> > > 
> > > Agh, sorry - I had this down in my mind as a boot time 
> > > parameter, not a compile time option. I'm off on vacation for a 
> > > week in the morning, and it's too late to wait around for a 
> > > kernel compile tonight :/ So I'll have to check this one when I 
> > > get back. Sorry again.
> > 
> > Note, instead of recompiling the kernel, you can also pass 
> > 'intremap=off' on the kernel cmdline to disable interrupt 
> > remapping and test with that.
> 
> Sorry for the delay, folks - just got back to this. Booting with 
> 'intremap=off' results in a slow reboot, i.e., doesn't fix the bug. 
> Is that a sufficient test, Ingo, or do you still want me to build 
> with CONFIG_IRQ_REMAP=n and try that?

That should be a sufficient boot I suspect.

Can you disable virtualization in the BIOS - does that affect reboot 
speed?

I'm just shooting into the dark here - if you can make your system 
boot bzImages then you might as well be better off trying to bisect 
it.

On Fedora booting bzImages of vanilla kernels is reasonably 
straightforward: a 'make localconfig' done while you are booted into a 
Fedora kernel ought to pick up everything into your .config and you 
won't need any modules to be able to boot up to userspace. That should 
ease bisection.

Thanks,

	Ingo
