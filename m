Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbaGWHnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:43:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533AbaGWHnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:43:18 -0400
Date: Wed, 23 Jul 2014 09:43:14 +0200
From: Jan Kara <jack@suse.cz>
To: Andreas Bombe <aeb@debian.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [REGRESSION] Boot hang with 939f04bec printk: enable interrupts
 before calling console_trylock_for_printk()
Message-ID: <20140723074314.GA15688@quack.suse.cz>
References: <20140628225050.GA3484@amos.fritz.box>
 <20140714083527.GA30550@quack.suse.cz>
 <20140716213408.GA8749@amos.fritz.box>
 <20140717083137.GA1649@quack.suse.cz>
 <20140718225005.GA17140@amos.fritz.box>
 <20140721100434.GA26641@quack.suse.cz>
 <20140722232932.GB3791@amos.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722232932.GB3791@amos.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 23-07-14 01:29:32, Andreas Bombe wrote:
> On Mon, Jul 21, 2014 at 12:04:34PM +0200, Jan Kara wrote:
> > On Sat 19-07-14 00:50:05, Andreas Bombe wrote:
> > > I don't see anything in /sys/kernel/debug/tracing/trace_pipe or
> > > .../trace (besides the header) with your patch applied. In case you
> > > meant to test it with the problematic printk change, I also tried with
> > > the revert reverted. That still hangs as before without any error report
> > > to see.
> >   Yes, I meant testing my lockdep patch with the problematic printk change.
> > Thanks for having a look. I'm puzzled why it didn't help.
> > 
> > > I checked the kernel logs and there is also no lockdep report anywhere.
> > > I get the "trace_printk() being used" notice but nothing else of
> > > interest around there. Though the notice should mean trace_printk() was
> > > used at least once?
> >   Yes. Anyway, I'd be grateful if you could run one more test for me so
> > that I can better understand what's going on. Can you take recent vanilla
> > kernel (with the revert) and apply attached patch to it? It again enables
> > interrupts when calling console_unlock() but keeps lockdep coverage
> > unchanged. It helped Sasha so I want to see whether your case is similar or
> > different. Thanks!
> 
> Applied on top of 15ba2236f, works fine. 
  Great. Thanks for testing. I'll send the patch to Andrew.

> I still don't see what printing could have triggered the problem. The
> only thing that is a warning is from the PCI code about some missing
> pcie-to-pci bridge (which I really should report some time). That isn't
> the culprit however since I tested a build with that WARN_ON_ONCE
> removed and it still hung.
> 
> Okay, there's ACPI errors, but these seem to be rather late to matter, I
> think? Anyway, here's the log of this working boot from the start to
> just before initrd gets started:
  The prints you can see are those that are fine ;). The thing is that when
lockdep covers more of the printk & console code itself (as was the case
with my original patch), it finds something which makes it crash the
machine. I'm not sure why my patch to make lockdep use trace_printk didn't
really help, maybe the nature of the crash is different than I thought.
Sasha Levin was able to reproduce the problem with a virtual machine so
I'll ask him for a config and will hope I'll be able to reproduce myself
and experiment with it. Thanks again for testing!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
