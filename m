Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbaICKaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:30:21 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:57021 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbaICKaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:30:17 -0400
Message-ID: <5406EDB8.8080401@linaro.org>
Date: Wed, 03 Sep 2014 11:30:16 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Russell King <linux@arm.linux.org.uk>, linaro-kernel@lists.linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>, patches@linaro.org,
        kgdb-bugreport@lists.sourceforge.net, Nicolas Pitre <nico@linaro.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Fabio Estevam <festevam@gmail.com>, Colin Cross <ccross@android.com>,
        kernel-team@android.com, Dave Martin <Dave.Martin@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v11 00/19] arm: KGDB NMI/FIQ support
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.10.1409030032010.3333@nanos> <5406D91A.9090209@linaro.org> <alpine.DEB.2.10.1409031140350.3333@nanos>
In-Reply-To: <alpine.DEB.2.10.1409031140350.3333@nanos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 11:06, Thomas Gleixner wrote:
> On Wed, 3 Sep 2014, Daniel Thompson wrote:
>> On 03/09/14 00:02, Thomas Gleixner wrote:
>>> The use case you are looking for is the most irrelevant of all. Just
>>> because KGDB is on some managerial "must have items" checklist does
>>> not make it useful.
>>
>> The FIQ based interactive debugger use case is fairly common on Android,
>> especially for Nexus devices (they have an out-of-tree debugger similar
>> to kdb for this).
>>
>> I think it finds favour there because during the development phases
>> where the console is unplugged to allow developers to go walkabout live
>> with a prototype phone. The interactive debugger is used for
>> post-morteming when something breaks. At this stage of development are
>> reluctant to expose/consume hardware resources (JTAG pins, RAM, FLASH)
>> for JTAG or kexec/kdump post-mortems.
> 
> If things are common and favoured for whatever reasons, that does not
> make them a proper solution per se.
> 
> I rather have a kexec debug kernel started if my production/test
> kernel explodes than hooking up a lousy debugger via serial, but thats
> a matter of taste and reason.
> 
>>> The only relevant use cases of FIQs are the same as those of NMIs on
>>> x86:
>>>
>>>   - Watchdog to detect stuck cpus and issue stack traces
>>
>> Russell put together a quick 'n dirty version of the NMI stack trace
>> code based on a subset of my patchset. Based on his feedback, later
>> revisions of my patchset are structured to simplify adding this code.
> 
> And I still say, that this is the first use case which should be
> provided as it is simple enough, immediately usefull and testable for
> everyone.
> 
> So, really what I want to see in the first place is a minimalistic
> patch series which
> 
>  1) Implements the core infrastructure for FIQ support
> 
>  2) Converts a single interrupt controller to play with #1
> 
>  3) Provides the simplest useful use case using #1
> 
> That's at max 5 patches, which are easy enough to review, and not a
> patch series which changes the world and some more in one go.

Ok. I'll look into this.


> We need to get the design and the infrastructure right in the first
> place. What I've seen so far is just a complete lack of design. If you
> take off your KGDB blinkers, you might notice that yourself.

Good point. I have tried shrinking the patchset previously but I ended
up splitting it by sub-system rather than simplifying the use-case.

The guess the effect of shrinking the patchset in this way was more to
shrink the pool of likely reviewers than to shrink the size of the
problem... Clearly not a good idea (and not intentional on my part).


> As I said before:
> 
>>> KGDB falls into place once you solved the above.

I hope so...
