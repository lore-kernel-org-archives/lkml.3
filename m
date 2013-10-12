Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3JLStb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 14:49:31 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:56892 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3JLSta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 14:49:30 -0400
Date: Sat, 12 Oct 2013 20:49:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Len Brown <len.brown@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20131012184920.GA19065@gmail.com>
References: <20131012171553.GA17548@gmail.com>
 <CA+55aFxFu9k7xOWd8DqXx8t+PONoV5ijGJv5mshZrYeVsVp32w@mail.gmail.com>
 <52599277.3090502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52599277.3090502@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 10/12/2013 11:05 AM, Linus Torvalds wrote:
> > On Sat, Oct 12, 2013 at 10:15 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >>
> >> Ville Syrjälä (1):
> >>       x86/reboot: Add reboot quirk for Dell Latitude E5410
> > 
> > So we have a number of these quirks, and Dell seems to be one of the
> > more common factors.

I raised this with hpa when the latest round of Dell quirks were added, 
but I agree that the quirk frequency sucks (for every quirk there's likely 
5 times as many boxes still out there that we haven't applied a quirk for 
yet ...) and I agree that this needs to be discussed more widely.

> > Now, I'd suggest we just trigger it automatically for Dell, but the 
> > thing is, Dell tends to be the *least* differentiating PC maker out 
> > there, so I'm wondering if it is our default reboot order that is just 
> > plain wrong.
> > 
> > We start off trying to reboot using ACPI. Is that really sane? Is 
> > there any reason to not make the default case be to use the PCI 
> > reboot?
> 
> We tried it, it broke too many systems.  However, I'm seriously 
> considering it for the case of Dell specificall.
> 
> The problem with Dell is that they are using something unusual like the 
> KBC to reboot, *and* apparently it is broken when VT-d is enabled.  This 
> may becase the versions of Windows they're testing on aren't using it, 
> or because they "expect" the OS to disable VT-d before shutdown.

If Windows doesn't use and enable VT-d then we probably should not use it 
either, or we should _at minimum_ disable VT-d again when we shut down.

I.e. if possible we should leave the hardware roughly in the state we got 
it from the firmware, that leads probably to the least amount of 
surprises.

So I'd be tempted to just not use IRQ remapping until this is cleared up 
and fixed properly. I.e. don't quirk the reboot method, quirk VT-d ...

Thanks,

	Ingo
