Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaENXB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:01:56 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50117 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbaENXBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:01:54 -0400
Message-ID: <5373F591.7040308@ahsoftware.de>
Date: Thu, 15 May 2014 01:00:33 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<20140514141914.446F7C4153D@trevor.secretlab.ca>	<53738580.7000902@ahsoftware.de>	<CACxGe6s4px_9CNk3bkc1OF1KGZGYdyh4gE_VufCKU5dLFBG48g@mail.gmail.com>	<53739871.9070407@ahsoftware.de>	<CAL_JsqJB4CAO60m1HTGQGHQRYVWcARxm_roOhn-PJh+ZR7OONg@mail.gmail.com>	<5373ABD2.9010508@ahsoftware.de> <CAL_JsqJ-=amrmRR9FfnOH1ELDQ1kTaG3e1n878mgpZP1FUw_jA@mail.gmail.com>
In-Reply-To: <CAL_JsqJ-=amrmRR9FfnOH1ELDQ1kTaG3e1n878mgpZP1FUw_jA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.05.2014 21:06, schrieb Rob Herring:
> On Wed, May 14, 2014 at 12:45 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>> Am 14.05.2014 19:30, schrieb Rob Herring:
>>
>>> On Wed, May 14, 2014 at 11:23 AM, Alexander Holler <holler@ahsoftware.de>
>>> wrote:
>>>>
>>>> Am 14.05.2014 18:05, schrieb Grant Likely:
>>>>
>>>>> On Wed, May 14, 2014 at 4:02 PM, Alexander Holler <holler@ahsoftware.de>
>>>>> wrote:
>>>>>>
>>>>>>
>>>>>> Am 14.05.2014 16:19, schrieb Grant Likely:
>>>>>>
>>>>>>
>>>>>>> Rather than a dtb schema change, for the most common properties (irqs,
>>>>>>> clocks, gpios), we could extract dependencies at boot time. I don't
>>>>>>> like
>>>>>>> the idea of adding a separate depends-on property because it is very
>>>>>>> easy to get it out of sync with the actual binding data (dtc is not
>>>>>>> the
>>>>>>> only tool that manipulates .dtbs. Firmware will fiddle with it too).
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> Then that stuff has to fiddle correct. Sorry, but trying to solve all
>>>>>> problems right from the beginning just leads to endless talks with no
>>>>>> end
>>>>>> and nothing will happen at all because nobody aggrees how to start.
>>>>>
>>>>>
>>>>>
>>>>> I appreciate the problem that you're trying to solve and why you're
>>>>> using the dtc approach. My job is to poke at the solution and make
>>>>> sure it is going to be reliable. Making sure all users know how to
>>>>> fiddle with the new property correctly is not a trivial problem,
>>>>> especially when it is firmware that will not necessarily be updated.
>>>>
>>>>
>>>>
>>>> The answer is just that they don't have to use this feature.
>>>
>>>
>>> It's not just about users, but maintainers have to carry the code and
>>> anything tied to DT is difficult to change or remove.
>>>
>>> Lots of inter-dependencies are already described in DT. We should
>>> leverage those first and then look at how to add dependencies that are
>>> not described.
>>
>>
>> Again, that's what this feature is about. One of the problems it solves is
>> that those dependencies which are described in the DT source in form of
>> phandle reference, do disappear in the blobs because the init-system would
>> have to know all bindings in order to identify phandle references (the
>> dependencies) again.
> 
> They don't disappear, but they become binding specific to recover.
> What you are loosing is type information which is something we would
> like to solve as well.
> 
> You can regenerate or figure out the dependencies with knowledge of
> the binding. The of_irq_init code does this. Maintaining this
> information in the dtb that can be parsed in a generic way and having
> the kernel handle non-bus oriented dependencies are really 2 separate
> problems. Let's not try to solve it all at once.
> 

Btw. I wonder if you have really read what I did and what I have
written. At first the need for knowledge of the binding is broken by
design and will never work for any general solution. Second, I've
already written almost the same as you've written in your first
paragraph in my pragraph you've just quoted directly above. And third,
if you like to solve that problem, I just posted a possible solution. ;)

You only have to take it, feel free to so, all the patches do contain a
Signed-off-by which means that I don't care much what you do with them.

Regards,

Alexander Holler
