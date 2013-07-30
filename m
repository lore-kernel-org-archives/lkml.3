Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3G3Atf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:49:35 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:39168 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3G3Atd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:49:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307291739150.13736@nftneq.ynat.uz>
References: <2469263.vMN09Q7Tzi@flatron>
	<20130729150124.GS29916@titan.lakedaemon.net>
	<20130729164905.GB2280@localhost.localdomain>
	<20130729172339.GT29916@titan.lakedaemon.net>
	<alpine.DEB.2.02.1307291739150.13736@nftneq.ynat.uz>
Date: Mon, 29 Jul 2013 20:49:31 -0400
Message-ID: <CAKON4Ow2KMC_9xod3Ay51Yetg9RbfMxVcy4DH0A3baHpmxP+7A@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] Defining schemas for Device Tree
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: David Lang <david@lang.hm>
Cc: Jason Cooper <jason@lakedaemon.net>, Dave Martin <Dave.Martin@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 8:41 PM, David Lang <david@lang.hm> wrote:
> On Mon, 29 Jul 2013, Jason Cooper wrote:
>
>>
>>>
>>> I don't think that siblings have any defined order in DT.  If reading a
>>> device tree, there's no guarantee you get nodes or properties out in the
>>> same order as the original .dts file.
>>
>>
>> That's why I raised the point.  If people think encoding initialization
>> order in the DT is a good idea, then we should change the dtc so it
>> compiles/decompiles in the same order.
>
>
> if you make the initializaiton order 'magicly' correct by following the
> order of the flat representation, how do you reflect the case where
> initialization can be overlapped for different devices?

I agree with David, using DT to try and eliminate deferred probes
isn't a good solution.  Overlapped probes and doing probes on multiple
CPUs introduces a temporal angle to the problem. Best to just let the
deferred probing code dynamically solve the problem. From what I can
see the deferred probing solution is working out nicely.

Plus there isn't that much code being run in deferred probing. I
suspect potential savings (if there even is any) are under a
millisecond.

>
> you are just trading one side of the problem for the other.
>
> David Lang



-- 
Jon Smirl
jonsmirl@gmail.com
