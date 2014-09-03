Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbaICSGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 14:06:08 -0400
Received: from xes-mad.com ([216.165.139.218]:5005 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbaICSGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 14:06:07 -0400
X-Greylist: delayed 2131 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2014 14:06:06 EDT
From: Peter Tyser <ptyser@xes-inc.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Prarit Bhargava <prarit@redhat.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] x86, lpc, Allow only one load of lpc_ich
Date: Wed, 03 Sep 2014 12:29:28 -0500
Message-ID: <1598720.9R5g9ohVoY@petert>
User-Agent: KMail/4.13.3 (Linux/3.13.0-34-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140903155718.GA26776@roeck-us.net>
References: <1409695097-5831-1-git-send-email-prarit@redhat.com> <54070842.2000700@redhat.com> <20140903155718.GA26776@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >>> Then why do they [have two devices specified]?
> > >> 
> > >> Because the vendor didn't/forgot to hide one from the kernel in BIOS --
> > >> hence FW_BUG.
> > > 
> > > If only one is useful, why have the second one in the first place?
> > 
> > That's just it -- it shouldn't have been exposed (again, according to
> > Intel).> 
> > > If the devices are present and we can see them, why not have 2?  Some
> > > users might find a use for them.
> > 
> > No one will.
> 
> Really ? I must be the "no one" then.
> 
> If available, I like using two watchdogs: One to be controlled by, say,
> systemd, one to be controlled by the watchdog daemon. If I have three, I
> might find use for it as well: One more to be controlled by whatever
> application is running on the system.
> 
> Sure, that may be considered overkill, but declaring that "no one will use
> them" if more than one watchdog is available is just not correct. After
> all, there was a _reason_ for introducing the capability to support more
> than one watchdog into the watchdog subsystem.
> 
> Similar, if there are multiple LPCs with separate GPIO pins on each in the
> system, I don't entirely understand why the GPIO pins on the second chip
> would or should be declared to be unusable. Why ?

I agree with Guenter - I'd like to support and use as many watchdogs and GPIOs 
as available.  High reliability applications often have 2 watchdogs as a data 
point, and more GPIO is always nice!

Can you give more background on your hardware and firmware setup?  Are there 
physically two ICH bridges, or just one that is showing up two times due to a 
firmware bug?  If there are two ICH bridges, how are they wired up to your CPU?  
Understanding your configuration would help others give suggestions on fixes or 
workarounds.

Regards,
Peter
