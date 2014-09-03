Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaICTWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:22:32 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51983 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbaICTWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:22:31 -0400
Date: Wed, 3 Sep 2014 12:22:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] x86, lpc, Allow only one load of lpc_ich
Message-ID: <20140903192224.GA6008@roeck-us.net>
References: <1409695097-5831-1-git-send-email-prarit@redhat.com>
 <54070842.2000700@redhat.com>
 <20140903155718.GA26776@roeck-us.net>
 <1598720.9R5g9ohVoY@petert>
 <54075663.8090204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54075663.8090204@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 01:56:51PM -0400, Prarit Bhargava wrote:
> 
> 
> On 09/03/2014 01:29 PM, Peter Tyser wrote:
> >>>>>> Then why do they [have two devices specified]?
> >>>>>
> >>>>> Because the vendor didn't/forgot to hide one from the kernel in BIOS --
> >>>>> hence FW_BUG.
> >>>>
> >>>> If only one is useful, why have the second one in the first place?
> >>>
> >>> That's just it -- it shouldn't have been exposed (again, according to
> >>> Intel).> 
> >>>> If the devices are present and we can see them, why not have 2?  Some
> >>>> users might find a use for them.
> >>>
> >>> No one will.
> >>
> >> Really ? I must be the "no one" then.
> >>
> >> If available, I like using two watchdogs: One to be controlled by, say,
> >> systemd, one to be controlled by the watchdog daemon. If I have three, I
> >> might find use for it as well: One more to be controlled by whatever
> >> application is running on the system.
> 
> IMO you're conflating a general system watchdog with the iTCO watchdog.  They're
> two very different things.
> 
The lpc driver instantiates iTCO watchdogs, so yes, this is the one I refer to.
Please explain its difference to a 'system watchdog', and what your
understanding of a system watchdog is if it is different to the iTCO watchdog.

> http://h50146.www5.hp.com/products/software/oe/linux/mainstream/support/whitepaper/pdfs/c03231796.pdf
> 
This document talks about consistent device names, so guess I must be missing
something.

> >>
> >> Sure, that may be considered overkill, but declaring that "no one will use
> >> them" if more than one watchdog is available is just not correct. After
> >> all, there was a _reason_ for introducing the capability to support more
> >> than one watchdog into the watchdog subsystem.
> 
> I thought that was to get all the various watchdogs (NMI, softlockup, fs, etc)
> using the same functionality?  But I do see your point.
> 
No. It lets you, for example, use a SuperIO based watchdog _and_ the iTCO
watchdog in the same system at the same time. Plus, if you want, you can add
a software watchdog as well.

> >>
> >> Similar, if there are multiple LPCs with separate GPIO pins on each in the
> >> system, I don't entirely understand why the GPIO pins on the second chip
> >> would or should be declared to be unusable. Why ?
> 
> Hmm ... good question.  I'll have to see whether or not ACPI, etc., can even
> distinguish between two.
> 
> > 
> > I agree with Guenter - I'd like to support and use as many watchdogs and GPIOs 
> > as available.  High reliability applications often have 2 watchdogs as a data 
> > point, and more GPIO is always nice!
> > 
> > Can you give more background on your hardware and firmware setup?  
> 
> Unfortunately I cannot :(  The system isn't "mine" per se.  It is (as the dumps
> show) IBM's.
> 
> Are there
> > physically two ICH bridges, or just one that is showing up two times due to a 
> > firmware bug?  
> 
> I can answer that.  There are two physical ICH bridges, and according to Intel
> one should be masked off.  We shouldn't run with two.
> 
But if the second chip is not masked off, what prevents the system vendor from
enabling the iTCO watchdog on both, and/or the GPIO pins on both ? Plus, even
if only one of the ICHs is supposed to be used, but if both are enabled by the
BIOS, how is the OS supposed to know which of the two chips is the one that is 
supposed to be active ? How does the OS know that or if it is the first chip
it encounters and not the second one ?

Thanks,
Guenter
