Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaENRaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:30:10 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:42192 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaENRaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:30:08 -0400
MIME-Version: 1.0
In-Reply-To: <53739871.9070407@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
	<20140514141914.446F7C4153D@trevor.secretlab.ca>
	<53738580.7000902@ahsoftware.de>
	<CACxGe6s4px_9CNk3bkc1OF1KGZGYdyh4gE_VufCKU5dLFBG48g@mail.gmail.com>
	<53739871.9070407@ahsoftware.de>
Date: Wed, 14 May 2014 12:30:07 -0500
Message-ID: <CAL_JsqJB4CAO60m1HTGQGHQRYVWcARxm_roOhn-PJh+ZR7OONg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
From: Rob Herring <robherring2@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 11:23 AM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 14.05.2014 18:05, schrieb Grant Likely:
>
>> On Wed, May 14, 2014 at 4:02 PM, Alexander Holler <holler@ahsoftware.de>
>> wrote:
>>>
>>> Am 14.05.2014 16:19, schrieb Grant Likely:
>>>
>>>
>>>> Rather than a dtb schema change, for the most common properties (irqs,
>>>> clocks, gpios), we could extract dependencies at boot time. I don't like
>>>> the idea of adding a separate depends-on property because it is very
>>>> easy to get it out of sync with the actual binding data (dtc is not the
>>>> only tool that manipulates .dtbs. Firmware will fiddle with it too).
>>>
>>>
>>>
>>> Then that stuff has to fiddle correct. Sorry, but trying to solve all
>>> problems right from the beginning just leads to endless talks with no end
>>> and nothing will happen at all because nobody aggrees how to start.
>>
>>
>> I appreciate the problem that you're trying to solve and why you're
>> using the dtc approach. My job is to poke at the solution and make
>> sure it is going to be reliable. Making sure all users know how to
>> fiddle with the new property correctly is not a trivial problem,
>> especially when it is firmware that will not necessarily be updated.
>
>
> The answer is just that they don't have to use this feature.

It's not just about users, but maintainers have to carry the code and
anything tied to DT is difficult to change or remove.

Lots of inter-dependencies are already described in DT. We should
leverage those first and then look at how to add dependencies that are
not described.

> It is more meant as a long-term solution to fix for the problem of
> increasing hard-coded workarounds which all are trying to fix the
> initialization order of drivers. Hardware has become a lot more complicated
> than it was in the good old days, and I think the time is right trying to
> adopt the init-system to this new century instead of still adding
> workarounds here and there.

I don't know when the good old days were, but this has been a problem
in embedded systems for as long as I have worked on Linux.

>> I'm not saying flat out 'no' here, but before I merge anything, I have
>> to be reasonably certain that the feature is not going to represent a
>> maintenance nightmare over the long term.
>
>
> The maintenance nightmare is already present in form of all the workarounds
> which are trying to fix the initialzation order necessary for modern
> hardware.

Do you have concrete examples or cases where deferred probe does not work?

Rob
