Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab3BBKTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 05:19:42 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33620 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab3BBKTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 05:19:40 -0500
Date: Sat, 2 Feb 2013 10:18:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Felipe Balbi <balbi@ti.com>, Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, "Cousson, Benoit" <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
	arm/common
Message-ID: <20130202101851.GY2637@n2100.arm.linux.org.uk>
References: <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com> <20130201184915.GP2244@beef> <510C1D0E.6030401@mvista.com> <20130201185820.GE29898@arwen.pp.htv.fi> <510C2A47.1090607@mvista.com> <20130201205600.GA31762@arwen.pp.htv.fi> <20130201213003.GW2637@n2100.arm.linux.org.uk> <510C58DF.3010103@mvista.com> <20130202004455.GX2637@n2100.arm.linux.org.uk> <510C7554.3060800@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510C7554.3060800@mvista.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 06:09:24AM +0400, Sergei Shtylyov wrote:
> Hello.
>
> On 02-02-2013 4:44, Russell King - ARM Linux wrote:
>
>>>>> On Fri, Feb 01, 2013 at 11:49:11PM +0300, Sergei Shtylyov wrote:
>>>>>>> good point, do you wanna send some patches ?
>
>>>>>>      I have already sent them countless times and even stuck CPPI 4.1 support (in
>>>>>> arch/arm/common/cppi41.c) in Russell's patch system. TI requested to remove the
>>>>>> patch. :-(
>
>>>>> sticking into arch/arm/common/ wasn't a nice move. But then again, so
>>>>> wasn't asking for the patch to be removed :-s
>
>>>> Err, patches don't get removed, they get moved to 'discarded'.
>
>>>     Any chance to bring it back to life? :-)
>>>     Although... drivers/usb/musb/cppi41.c would need to be somewhat
>>> reworked for at least AM35x and I don't have time. But that may change,
>>> of course.
>
>> Right, I've just looked back at the various meeting minutes from December
>> 2010 when the CPPI stuff was discussed.  Yes, I archive these things and
>> all email discussions for referencing in cases like this.
>
>    Thanks.
>
>> Unfortunately, they do not contain any useful information other than the
>> topic having been brought up.  At that point, the CPPI stuff was in
>> mach-davinci, and I had suggested moving it into drivers/dma.
>
>    I don't remember that, probably was out of the loop again.
>
>> The result of that was to say that it doesn't fit the DMA engine APIs.
>
>    I remember this as a discussion happening post me sending the patch to 
> the patch system and it being discarded...
>
>> So someone came up with the idea of putting it in arch/arm/common - which
>
>    Probably was me. There was also idea of putting it into 
> drivers/usb/musb/ -- which TI indeed followed in its Arago prject. I 
> firmly denied that suggestion.
>
>> I frankly ignored by email (how long have we been saying "no drivers in
>> arch/arm" ?)
>
>    But there *are* drivers there! And look at edma.c which is about to be 
> moved there... Anyway, I haven't seen such warnings, probably was too 
> late in the game.

I've already objected about the header moving to some random place in
arch/arm/include.  Really, edma.c needs to find another home too - but
there's a difference here.  edma.c is already present under arch/arm.
CPPI is _not_.  CPPI is new code appearing under arch/arm (you can see
that for yourself by looking at the diffstat of 6305/1... it doesn't
move files, it adds new code.)

>> Now, it would've been discussed in that meeting, but unfortunately no
>> record exists of that.  What does follow that meeting is a discussion
>> trail.  From what I can see there, but it looks to me like the decision
>> was taken to move it to the DMA engine API, and work on sorting out MUSB
>> was going to commence.
>
>> The last email in that says "I'll get to that soon"... and that is also
>> the final email I have on this topic.  I guess if nothing has happened...
>> Shrug, that's someone elses problem.
>
>    Well, as usual... :-(
>
>> Anyway, the answer for putting it in arch/arm/common hasn't changed,
>> and really, where we are now, post Linus having a moan about the size
>> of arch/arm, that answer is even more concrete in the negative.  It's
>> 54K of code which should not be under arch/arm at all.
>
>> Anyway, if you need to look at the patch, it's 6305/1.  Typing into the
>> summary search box 'cppi' found it in one go.
>
>    Thanks, I remember this variant was under arch/arm/common/.
>    Now however, I see what happened to that variant in somewhat different 
> light. Looks like it was entirely your decision to discard the patch, 
> without TI's request...

Firstly, it is *my* perogative to say no to anything in arch/arm, and I
really don't have to give reasons for it if I choose to.

Secondly, it *was* discussed with TI, and the following thread of
discussion (threaded to the minutes email) shows that *something* was
going to happen _as a result of that meeting_ to address the problem of
it being under arch/arm.  And *therefore* it was discarded from the patch
system - because there was expectation that it was going to get fixed.

For christ sake, someone even agreed to do it.  Even a target was mentioned,
of 2.6.39.  That was mentioned on 7th December 2010.  And 6305/1 was
discarded on 8th December 2010.  Cause and effect.

And yes, *you* were not part of that discussion.  You work for Montavista
which contracts with TI to provide this support.  It is up to TI to pass
stuff like this on to their contractors.

There are two people on this thread CC list who were also involved or
CC'd on the mails from the thread in 2010...  Tony and Felipe.
Unfortunately, the person who agreed to do the work is no longer in the
land of the living.  Yes I know it's inconvenient for people to die
when they've still got lots of important work to do but that's what can
happen...
