Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab3JDXRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 19:17:05 -0400
Received: from mail.wdtv.com ([66.118.69.84]:35669 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab3JDXRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 19:17:03 -0400
From: Gene Heskett <gheskett@wdtv.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: Re: [PATCH v2 3/6] PowerCap: Added to drivers build
Date: Fri, 4 Oct 2013 19:17:00 -0400
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1380904616-17519-1-git-send-email-srinivas.pandruvada@linux.intel.com> <201310041622.29259.gheskett@wdtv.com> <524F2B4C.7080702@linux.intel.com>
In-Reply-To: <524F2B4C.7080702@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201310041917.01126.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 October 2013, Srinivas Pandruvada wrote:
>On 10/04/2013 01:22 PM, Gene Heskett wrote:

[and snipped]

>>> <Sorry, I didn't understand. Are you pointing any problem in this
>>> patch or patch-set in general?
>> 
>> Not that my relatively untrained eyes can spot.
>> 
>>> This change added powercap directory to the kernel build. Is something
>>> wrong with it or any other way to do that?
>> 
>> The prospect of having a poorly configured way to power down a port
>> that is running heavy machinery under real time control scares me. 
>> And that is what this patch series seems to be leading up to if I am
>> reading the patch headers correctly.  If I am not reading it
>> correctly, then assume I am issuing a pre-emptive strike just to make
>> sure you folks trying to save a milliwatt here and there, and there is
>> not a thing wrong with the basic idea, are made aware of the potential
>> for maiming mischief should you decide to power down a port just
>> because its last access was 5 milliseconds ago.  Even a completely
>> servo driven configuration will tickle it faster than that, however an
>> e-stop condition, which might shut down a charge pump pulse generator
>> must be maintained until cleared by the operator, which means the
>> control channel to the machine, whatever port it is, must be kept
>> alive to be human safe around the machine.  The capability to do that
>> to a given port should therefore be made a kernel .config selection
>> incapable of being overridden by some other perceived dependency in
>> kconfig.
>> 
>> I hope this is a better explanation. :)
>
>The idea of power capping is to cap total power not power down and also
>need root level access to modify.

No.  Restricting it to root control only is NOT an option.  There has to be 
some mechanism whereby the users non-root program can control it.  We don't 
run this software as root, ever.  And the part of this software that needs 
the parport (or a pci card access) is running on a cpu core that has been 
isolated for its use by an isocpus= statement, not visible to top or any 
other system monitoring utility, so you would never know we are pounding on 
that port, both reads and multiple writes, at least 3 times every 23 
microseconds.  So you might see it as idle and turn it off.

>There is a minimum and maximum values is also defined, which should make
>sure that the system is
>running with reduced performance, not power down.

When cutting steel, or anything else for that matter, power used is not a 
consideration as long as there is enough, so in this case, reduced 
performance is not a viable option particularly if stepper motors are 
involved as they need a very steady heartbeat. And its just as important in 
the cpu driving the machine as it is in the motors driving the machine.  
Right now, there are only about 4 or 5 motherboards on the planet that can 
do this job fairly well for stepper based systems.

2 of them are your atom powered boards.  One of them is the BeagleBone 
Black but we are still designing the I/O cape for that so its not cutting 
steel daily, yet.  Had you not disco'd the D-525-MW boards, the market 
channel for those could easily absorb 10 or more per week for a nearly 
indefinite period.  You accidentally made the nearly ideal board and its 
not a power hog.  The BIG Reason? IRQ latency is 2 to 3 microseconds, and 
there is nothing else x86 based that can touch that figure that we have 
found so far.

When I say you, I am of course referring to Intel, since you are coming in 
from an Intel address. :)

>This patch is not affecting Linux PM. Power down a port trigger
>generated by PM framework in coordination
>with the driver controlling the port.

But what if you cannot detect that driver, and its port use, because its 
behind an isolcpus=0 statement on the kernel command line in grub?

This is what scares me spitless.  It could get somebody injured/killed, or 
wreck a $500,000 machine.

>If some port is capable of powercapping and implemented a client driver
>for this, they can disable the whole
>power capping by setting CONFIG_POWERCAP=n for such systems.

Good.

>> And please, lets keep such discussion on the list where it belongs.

I clicked on reply to list and got no To: line contents at all.  KMail does 
that to me when its a PM. Only been using it since '98, I really should 
learn to use it right someday. :)

>I am still doing reply to all to keep everyone in the mailing list in
>loop.

So am I, now.
>
>
>
>Thanks,
>Srinivas


Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

Of course power tools and alcohol don't mix.  Everyone knows power
tools aren't soluble in alcohol...
		-- Crazy Nigel
A pen in the hand of this president is far more
dangerous than 200 million guns in the hands of
         law-abiding citizens.
