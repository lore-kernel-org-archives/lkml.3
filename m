Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3JFUQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 16:16:06 -0400
Received: from mail.wdtv.com ([66.118.69.84]:44533 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab3JFUQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 16:16:03 -0400
From: Gene Heskett <gheskett@wdtv.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH v2 3/6] PowerCap: Added to drivers build
Date: Sun, 6 Oct 2013 16:15:59 -0400
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1380904616-17519-1-git-send-email-srinivas.pandruvada@linux.intel.com> <201310041917.01126.gheskett@wdtv.com> <525186B2.1000205@linux.intel.com>
In-Reply-To: <525186B2.1000205@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201310061616.00303.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 October 2013, Arjan van de Ven wrote:
>On 10/4/2013 4:17 PM, Gene Heskett wrote:
>>>> I hope this is a better explanation. :)
>>> 
>>> The idea of power capping is to cap total power not power down 

What is the difference to us if it wrecks a $1000 part, or a $100,000 
machine?

>>> and
>>> also need root level access to modify.
>> 
>> No.  Restricting it to root control only is NOT an option.  There has
>> to be some mechanism whereby the users non-root program can control
>> it.  We don't run this software as root, ever.  And the part of this
>> software that needs the parport (or a pci card access) is running on a
>> cpu core that has been isolated for its use by an isocpus= statement,
>> not visible to top or any other system monitoring utility, so you
>> would never know we are pounding on that port, both reads and multiple
>> writes, at least 3 times every 23 microseconds.  So you might see it
>> as idle and turn it off.
>
>I understand that you do not want to see powercapping in effect.
>I think I mostly understand the realtime angle you're coming from as
>well.
>
>However, powercapping is not done for energy savings, it is done for
>SURVIVAL. It is not something optional that you can just turn off and
>ignore; if you ignore it... something either has a thermal meltdown or
>trips a circuit breaker... or in the case of a laptop/tablet kind of
>shape, you give the user burn blisters.

Nobody puts an accessible I/O port, in this case an EPP capable parport, or 
except for the card slot on some of them, any port we can use for real time 
control, so obviously we aren't using any laptops or netbooks in such a 
system, so those concerns are completely out of our playing field.  They 
simply don't apply.

>(the thermal meltdown effect can be either damage to the system or a hard
>reset done by a hardware safety mechanism.. neither is what you want for
>your realtime workload)

No it surely isn't, but we are comparing the worth of replacing a failed 
motherboard that sells for less than 100 bucks, with the worth of a machine 
that may be carving a Toyota O.R.R. engine block at the time of the 
failure.  We can buy a couple cases of those motherboards without raising 
the price of that engine block to the racer, its simply not that big a 
factor.  The ruined but 99% finished engine block now is, so it had better 
not be a weekly occurrence. It is also not something that any of our group 
has ever experienced and gone public with.

>The solution to not use powercapping in combination with realtime is to
>make sure there is ample cooling for the system, and to make sure the
>circuit breakers are big enough... .... not ways to try to turn it off
>from non-root.
>
>(and note that powerclamp for example takes realtime priority into
>account by only running at "half priority"... ... but if the real
>realtime prevents clamping altogether, other, more dracionian things
>will kick in)
>
>
>and if you wonder what linux does today without the framework; there are
>mechanisms that kick in at the very end of the range, that are very
>draconian like taking the 3.0Ghz processor down to effectively 100MHz,
>or even a system reboot. The point of what Jacob and Srinivas are trying
>to add is to intervene slightly earlier (these failsafe mechanisms are
>still there) but much much more gently.

First off, we are not using the type of boards for controllers that would 
burn anything up sans its normal cooling, which is entirely passive on an 
atom powered board as you well know.  So there is no fan to fail and start 
your doomsday scenario in abut 30% of the cases now, but there are a rather 
dukes mixture of other boards being used yet.  Those will be replaced in 
due time as they fail, or the IRQ latency finally starts costing the shop 
owner money because the machine can't be run at the optimum speed with that 
poorly architect-ed board, probably with Atoms or BBB's.

So, let me ask, will your patches initiate a parport hardware shutdown, 
when that port is in fact being used at 1 millisecond intervals best case, 
20 u-sec worst case, by a process you can't see because it is behind an 
isolcpus= statement naming the processor core that is using it?

We can't see past that isolcpus=statement to see how hard that core is 
running, nor can we see the port activity without wasting a pin to drive an 
enabling charge pump.

If you insist on doing this, in the face of ample evidence its nothing but 
a feel good action on your part, then the least we ask is for a tally 
signal output, far enough in advance, say 0.25 seconds, to do a graceful, 
controlled e-stop before the machine self-destructs, or kills somebody 
standing just past the normal travel turn around and goes 2 meters past 
that turn around point because we didn't have time to run all the servo 
outputs to 0.000 volts, stopping the machine in a reasonable time frame 
that doesn't sheer the 3" bolts anchoring it to the floor.  We wouldn't 
care if the seismographs 20 miles away record that stop, which they will & 
have done quite a few times already in the Cincinnati area, but its a safe 
stop except for the potential damages to the workpiece on the table because 
the cutting motions during the stop would be out of the normal path 
tolerance window.

In fact, I'd go so far as to say that any hardware capable of self-
destructing in normal operation, does not need to guarded by this proposed 
function, but blacklisted instead, it is patently a defective design from 
square one regardless of the brand name on the box.  Or just let it burn 
up, the warranty returns will educate the maker/designer soon enough.

Maybe the best compromise is to just put a switch, either on the kernel 
command line, or in kconfig, allowing us to shut this function off on 
installs where this would be dangerous.

Linuxcnc, because of the truly invasive RTAI patches that often takes 
months to properly apply, do not build a new kernel very often, but we 
could shut it off either of those places and be happy.  We are currently 
running 90% of the machines on a 2.6.32-128-RTAI patched kernel, but recent 
experiments with the 3.4.xx + xenomai patch kit have also shown promise.
 
Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

Love is the delusion that one woman differs from another.
		-- H. L. Mencken
A pen in the hand of this president is far more
dangerous than 200 million guns in the hands of
         law-abiding citizens.
