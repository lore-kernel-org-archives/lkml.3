Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3DUSr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 14:47:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50494 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab3DUSry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 14:47:54 -0400
Date: Sun, 21 Apr 2013 11:47:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        tiwai@suse.de
Subject: Re: irq 16: nobody cared
Message-ID: <20130421184749.GC3509@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130420185330.GA4654@pd.tnic>
 <20130420235206.GA3509@linux.vnet.ibm.com>
 <20130421103403.GA4594@pd.tnic>
 <20130421163002.GB3509@linux.vnet.ibm.com>
 <20130421165653.GA4623@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421165653.GA4623@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042118-2398-0000-0000-0000138DA733
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 06:56:54PM +0200, Borislav Petkov wrote:
> On Sun, Apr 21, 2013 at 09:30:02AM -0700, Paul E. McKenney wrote:
> > Thank you for the info!  Now to figure out what the heck is causing this.
> > 
> > I am also guessing that your system does have hardware that could do an
> > irq 16.  Of course, if removing or disabing this hardware is an option,
> > it would be interesting to see what happens.
> 
> Onboard sound chip so only BIOS disable should help, if present. Let me
> check. Oh, I can take out the laser and cut it out of the silicon. :-)
> 
> What about not enabling any sound support and thus not using this IRQ
> handler? Would that tell us something?

Using a laser to cut out the silicon would be more entertaining, but
either BIOS disable or compiling out sound support should work.  ;-)

> > Especially given that at the very bottom of the .jpg, there is a
> > chopped-off line that appears to read "Disabling IRQ #16". Which of
> > course leads me to wonder whether we hit a race between the last
> > interrupt arriving and the device being disabled.
> 
> Well, the "Disabling IRQ..." line comes from note_interrupt() down the
> do_IRQ() path. It looks like
> 
> 	if (unlikely(desc->irqs_unhandled > 99900)) {
> 
> we hit some high number of unhandled interrupts, issue the message about
> the bad IRQ and then disable it by dumping the handlers beforehand.

It would also be interesting to print out desc->irqs_unhandled at some
point during suspend to get a feel for the magnitude of the difference.
After all, 99900 is an interesting choice of number!

> > Hmmm...  Do you have either CONFIG_PM_SLEEP, SUPPORT_VGA_SWITCHEROO,
> > or CONFIG_PM_RUNTIME set for these runs?
> 
> CONFIG_PM_SLEEP=y
> # CONFIG_VGA_SWITCHEROO is not set
> # CONFIG_PM_RUNTIME is not set
> 
> You meant CONFIG_VGA_SWITCHEROO and not SUPPORT_VGA_SWITCHEROO, right?

You are quite correct.

							Thanx, Paul

> Ok, let me try to disable the soundcard in the BIOS.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

