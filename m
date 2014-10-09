Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbaJIOgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:36:32 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42626 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbaJIOgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:36:21 -0400
Date: Thu, 9 Oct 2014 16:36:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] timers/nohz updates for v3.18
Message-ID: <20141009143614.GD25790@lerouge>
References: <20141009064813.GA20517@gmail.com>
 <CA+55aFy5RDVOy79J-XkKVgpZhh8ph42pPeSFtFmWjFhyx-G8Yw@mail.gmail.com>
 <20141009125721.GA25790@lerouge>
 <20141009135004.GA13089@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009135004.GA13089@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 06:50:04AM -0700, Greg KH wrote:
> On Thu, Oct 09, 2014 at 02:57:25PM +0200, Frederic Weisbecker wrote:
> > On Thu, Oct 09, 2014 at 06:34:26AM -0400, Linus Torvalds wrote:
> > > Hmm..
> > > 
> > > On Thu, Oct 9, 2014 at 2:48 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > > >
> > > > Please pull the latest timers-nohz-for-linus git tree from:
> > > >
> > > >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-nohz-for-linus
> > > >
> > > >    # HEAD: 9b01f5bf3999a3db5b1bbd9fdfd80d8d304e94ee nohz: nohz full depends on irq work self IPI support
> > > >
> > > > Main changes:
> > > >
> > > >  - Fix the deadlock reported by Dave Jones et al
> > > >  - Clean up and fix nohz_full interaction with arch abilities
> > > >  - nohz init code consolidation/cleanup
> > > 
> > > Ok, pulled. But none of these are marked for stable, yet the deadlock
> > > people are seeing is in 3.17. Is there a separate line of minimal
> > > fixes just for that? Or was the lack of stable tags just an oversight?
> > 
> > It was first intended because the patchset is quite invasive and nohz full has
> > no known users, or perhaps there is one... So I thought that backporting
> > could be more dangerous than anything.
> > 
> > Now thinking more about it I could isolate the following patches for
> > stable:
> > 
> >       irq_work: Introduce arch_irq_work_has_interrupt()
> >       irq_work: Force raised irq work to run on irq work interrupt
> >       x86: Tell irq work about self IPI support
> >       arm: Tell irq work about self IPI support
> > 
> > Sending these to stable@vger.kernel.org would catch up, right? I
> > can still do that.
> 
> If I can just pick those patches directly, that's all I need for the
> stable trees.  What are the git ids in Linus's tree for these patches,
> so that I know I got this correct?

Awesome, here we go in order:

_ c5c38ef3d70377dc504a6a3f611a3ec814bc757b: irq_work: Introduce arch_irq_work_has_interrupt()
_ 76a33061b9323b7fdb220ae5fa116c10833ec22e: irq_work: Force raised irq work to run on irq work interrupt
_ 3010279f0fc36f0388872203e63ca49912f648fd: x86: Tell irq work about self IPI support
_ 09f6edd424218eb69078551b2ecfada1f2d098eb: arm: Tell irq work about self IPI support

Only 3.17 should be concerned.

Thanks a lot Greg!
 
> thanks,
> 
> greg k-h
