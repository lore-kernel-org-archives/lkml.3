Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469Ab3FRRKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:10:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58064 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756Ab3FRRKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:10:20 -0400
Message-ID: <51C09478.30909@wwwdotorg.org>
Date: Tue, 18 Jun 2013 11:10:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Dom Cobley <popcornmix@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        linux-rpi-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v4] watchdog: Add Broadcom BCM2835 watchdog timer driver
References: <1364320200-23569-1-git-send-email-lkundrak@v3.sk>  <1364402424-19503-1-git-send-email-lkundrak@v3.sk>  <5153B24D.1010408@wwwdotorg.org>  <20130526142200.GA7603@spo001.leaseweb.com> <1371574241.18688.5.camel@hobbes.kokotovo>
In-Reply-To: <1371574241.18688.5.camel@hobbes.kokotovo>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 10:50 AM, Lubomir Rintel wrote:
> Hi Wim,
> 
> On Sun, 2013-05-26 at 16:22 +0200, Wim Van Sebroeck wrote:
>> Hi Lubomir,
>>
>>> On 03/27/2013 10:40 AM, Lubomir Rintel wrote:
>>>> This adds a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
>>>> used in Raspberry Pi and Roku 2 devices.
>>>>
>>>> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
>>>> Signed-off-by: Dom Cobley <popcornmix@gmail.com>
>>>
>>> Those two s-o-b lines should be swapped, since if Dom did sign off on
>>> any part of this patch, he did it before you did.
>>>
>>> That said...
>>>
>>> I wonder if it's actually appropriate to include Dom's s-o-b here, since
>>> I don't think he really wrote this patch itself. I think you mentioned
>>> that you hadn't use much of the downstream driver except for some defines?
>>>
>>> To be clear, I mentioned the existence of the S-o-b line downstream
>>> simply to demonstrate that the commits you were getting information from
>>> had correctly followed the process described in
>>> Documentation/SubmittingPatches, and so it was OK to use that
>>> information while creating a GPL'd driver.
>>>
>>> So there are a couple of ways that this patch could have been created:
>>>
>>> 1) You took the downstream commit itself, cherry-picked it into the
>>> upstream kernel, modified it to suit upstream, and then submitted that.
>>> The modifications might be extensive, such as renaming the file,
>>> removing parts of the code that the upstream watchdog core now handles,
>>> adding some new features, fixing bugs, cleanup, etc.; whatever is needed
>>> to upstream the patch.
>>>
>>> In this case, I believe it would be appropriate to maintain any S-o-b
>>> lines from the original downstream commit, and add yours. But, I believe
>>> you should also (a) maintain the git author field from the original
>>> downstream commit (b) include a list of the changes you made to the
>>> patch in the commit description, so you can be blamed for them rather
>>> than the original author:-)
>>>
>>> 2) You read the downstream commit for information, but created a
>>> completely new driver for the upstream kernel, using the downstream
>>> driver just as a reference. In this case, I believe it's fine for the
>>> git author field to be you, and for the only s-o-b line present to be
>>> yours, since you really did write the patch from scratch. However, you
>>> should credit the downstream work in the (c) header and/or commit
>>> description.
>>>
>>> This current patch sees to be a slight hybrid of both approaches (you're
>>> listed as the git author, but have included Dom's s-o-b line on a patch
>>> I don't think he created, and wasn't directly derived from one he created).
>>>
>>> I'm not sure if I'm being too picky. I guess I'll leave it up to Wim Van
>>> Sebroeck, since he's the watchdog maintainer and would be the person who
>>> applies this patch.
>>
>> Can you create a patch v5 with yourselve as author and add the necessary (c)
>> and references in it so that I can do the final review? (That is if situation
>> 2 is indeed the case. If however it is situation 1 then we should get the
>> original code and have that as a patch and then add a second patch with your
>> modifications.).
> 
> I'm still not sure what to do. For most part, the driver is written from
> scratch, since the original one was not utilizing recent enough
> frameworks (such as watchdog-core or device tree bindings). Thus the
> patch against the original driver would not make any sense at all.
> 
> On the other hand, I've referred to the original driver for hardware
> information and copied a couple of defines as they are (such as
> SECS_TO_WDOG_TICKS), thus I figured out it's a required to include the
> original driver's sign-off and copyright information.
> 
> Thus neither 1) nor 2) is the case, and I can't figure out myself what
> needs to be changed at this point. I'm wondering if you could help me
> decide?

This sounds exactly like case (2) to me; copying a few defines for HW
constants doesn't really sound like having derived the driver from the
original commit.
