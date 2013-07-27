Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab3G0KfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 06:35:00 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4728 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab3G0Kez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 06:34:55 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <51F3A238.3020505@broadcom.com>
Date: Sat, 27 Jul 2013 12:34:32 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Tomasz Figa" <tomasz.figa@gmail.com>
cc: "Richard Cochran" <richardcochran@gmail.com>,
        "Olof Johansson" <olof@lixom.net>, "Mark Brown" <broonie@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "Ian Campbell" <ian.campbell@citrix.com>,
        "Pawel Moll" <Pawel.Moll@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Domenico Andreoli" <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
        "Dave P Martin" <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <CAOesGMhEr3DiFm5uSgoHPFUMY4jWu4HkeTU2UmOGj=dS75Vk+g@mail.gmail.com>
 <20130727050406.GB4221@netboy> <2007664.vYsECFSKrV@flatron>
 <51F39FD8.6080808@broadcom.com>
In-Reply-To: <51F39FD8.6080808@broadcom.com>
X-WSS-ID: 7DED7ED331W56449300-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 12:24 PM, Arend van Spriel wrote:
> On 07/27/2013 11:51 AM, Tomasz Figa wrote:
>> On Saturday 27 of July 2013 07:04:08 Richard Cochran wrote:
>>> On Fri, Jul 26, 2013 at 08:49:43AM -0700, Olof Johansson wrote:
>>>> Long term, final goal is likely to be close to what Russell is saying
>>>
>>> Why is this a long term goal? Start today.
>>>
>>>> -- nothing should go into the kernel tree unless the binding is in a
>>>> fully stable state. However, we have a transitional period between now
>>>> and then, and even when we're at the final state there will be need to
>>>> have some sort of sandbox for development and test of future bindings.
>>>
>>> Why not just set up a git tree right away?
>>>
>>>> Dealing with all that, as well as the actual process for locking in
>>>> bindings, is what needs to be sorted out.
>>>>
>>>> I think we're all in agreement that bindings that change over time are
>>>> nothing but pain, but we're arguing that in circles anyway.
>>>
>>> No.
>>>
>>> I keep saying, the bindings must be stable ABI, *today*.
>>>
>>> You keep saying, maybe later, but until then we will make things up as
>>> we go along.
>>
>> We have currently a lot of broken bindings, because people didn't know
>> how
>> to define ones and those they defined have not been properly reviewed. Do
>> you really want such broken ABI in the kernel?
>>
>> Sure, there are many existing bindings that can be just made stable and
>> well they probably are already de facto stable. This is mostly about
>> subsystem bindings and whatever already has many users, both made them
>> get
>> more thought when designing and more review before merging.
>>
>> Still, a lot of device and platform-specific bindings are simply broken.
>> Take max8925 backlight driver, that Olof started this whole discussion
>> with, as an example. We need to sort them out before they can be
>> stabilized.
>
> That is a nice summary of how we got from null to now and Richard seems
> to be simply saying: let's stop mucking about and make this a project
> with a well-defined process of dealing with staging and stable bindings
> and keep stable bindings stable. Whether it should be within the kernel
> repo as a separate subsystem or in an entire different repo is a trivial
> decision, but still a decision that needs to be made.
>
> Apart from stable DT bindings I would love to see a DT compiler that
> that next to DT syntax detects mistakes in properties used for the
> selfish reason that I spent hours debugging regulator code, because I
> typed vmmc_supply iso vmmc-supply. I did not go through all the
> bindings, but this may require a more formal description so it could be
> compiled/read in the DT compiler.

Oh, and the reason for my tinkering on dts is here:

http://mid.gmane.org/51E7AA24.6080600@broadcom.com

Happily using Pandaboard for my driver testing and than *kaboom*. 
board-omap4panda.c is gone although the device tree does not provide the 
same functionality. Of course, this is not about DT bindings.

Regards,
Arend


