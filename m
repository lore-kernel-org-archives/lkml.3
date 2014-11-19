Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaKSQIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:08:43 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:57775 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266AbaKSQFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:05:08 -0500
Message-ID: <546CBFAC.9040906@free.fr>
Date: Wed, 19 Nov 2014 17:05:00 +0100
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:33.0) Gecko/20100101 Firefox/33.0 SeaMonkey/2.30
MIME-Version: 1.0
To: =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Device Tree <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: Looking for good references for ARM driver development
References: <546C920A.7060800@free.fr> <546CB0EB.9080005@suse.de>
In-Reply-To: <546CB0EB.9080005@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

On 19/11/2014 16:02, Andreas Färber wrote:

> Am 19.11.2014 um 13:50 schrieb Mason:
>
>> [...] I'm writing a driver for a temperature sensor, which is
>> supposed to work within the hwmon/lm-sensors framework.
>>
>> The sensor's API consists of 3 memory-mapped registers, which are
>> accessible over the SoC's memory bus. [...]
>>
>> 1) Which bus should I be using for this driver?
>> Is the platform bus appropriate?
>
> Probably.

Is there an exhaustive list of available buses (on the ARM platform)
and an overview of when/where each one is appropriate?

>> 2) platform.txt states
>>
>>> Some drivers are not fully converted to the driver model, because
>>> they take on a non-driver role:  the driver registers its
>>> platform device, rather than leaving that for system
>>> infrastructure.  Such drivers can't be hotplugged or coldplugged,
>>> since those mechanisms require device creation to be in a
>>> different system component than the driver.
>>
>> How do I "leave device registration for the system
>> infrastructure"? Where should I put that code? Is it a good idea to
>> separate device registration and driver registration in the case of
>> a SoC, where the device is embedded in the SoC and is not
>> "hot-plugged" (or anything-plugged for that matter, it's just
>> "there").
>
> Since this appears to be about an ARM SoC according to your To list,
> in general, you create a device tree binding, that binding is
> registered within your platform/... driver code and referenced in the
> device tree for SoC or board, and then your driver will automatically
> be probed.

I know nothing about DT (aside from the Wikipedia entry).
I'll take a closer look at Documentation/devicetree.
Will that explain what platform/... is?

I see a drivers/platform folder, but nothing ARM-specific there?

>> 4) Can I use platform_driver_probe, instead of
>> platform_driver_register?
>
> Most likely you do not need to call either yourself.

Hmmm, color me even more confused. I had really come to believe that
driver registration was a mandatory part of the driver, something
that wasn't left to "infrastructure code".

> Just compare other platform drivers on the one hand, and temperature
> sensor drivers on the other (such as I2C based gmt,g781 / LM90). Did
> you already check whether there is a driver that is both?

Please excuse my naive question: what are platform drivers, and where
are they stored in the kernel source tree?

Regards.

