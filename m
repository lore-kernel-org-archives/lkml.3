Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab3BMRdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:33:42 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36534 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934405Ab3BMRdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:33:41 -0500
MIME-Version: 1.0
In-Reply-To: <511BC043.4030506@gmail.com>
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com>
	<1360264144-20714-2-git-send-email-robherring2@gmail.com>
	<CAHTX3dKLCbfhBaHKBE=fVTcRReVL6yotA9e_8S70bH+_gajL5Q@mail.gmail.com>
	<511BC043.4030506@gmail.com>
Date: Wed, 13 Feb 2013 18:33:39 +0100
Message-ID: <CAHTX3d+2rGBE3ZBwiHbq7tOi+OE+5KGPh34APzp0NhRP=mBv+w@mail.gmail.com>
Subject: Re: [PATCH 1/4] clocksource: pass DT node pointer to init functions
From: Michal Simek <monstr@monstr.eu>
To: Rob Herring <robherring2@gmail.com>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/13 Rob Herring <robherring2@gmail.com>:
> On 02/13/2013 10:21 AM, Michal Simek wrote:
>> 2013/2/7 Rob Herring <robherring2@gmail.com>:
>>> From: Rob Herring <rob.herring@calxeda.com>
>>>
>>> In cases where we have multiple nodes of the same type, we may need the
>>> node pointer to know which node was matched. Passing the node pointer
>>> also keeps the init function from having to match the node a 2nd time.
>>>
>>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>>> Cc: John Stultz <johnstul@us.ibm.com>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> ---
>>>  drivers/clocksource/clksrc-of.c |    4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Tested-by: Michal Simek <michal.simek@xilinx.com>
>>
>> The rest is just the same as I have done. Any option to add these
>> patches to v3.9?
>
> I would like to before we have more users to fix, but it will have to be
> post rc1. If not, Arnd/Olof should be be able to provide a stable branch
> for 3.10.

ok

>> Because I need these patches for zynq timer because we have two in the soc.
>> Is it OK to register several clock source and clockevent devices?
>
> If it is 1 DT node, then that should be fine.

zynq is using two triple timer counter IP . There are also described by two
different DT nodes because there are separated and uses different baseaddresses.

Does it mean that if there are 2 DT nodes that it won't work?


One more thing. Is there any rule which should describe which timer should be
used for clockevent and for clocksource?


>> btw: there is still one issue because you can just setup only one
>> compatibility string.
>
> You can have multiple CLOCKSOURCE_OF_DECLARE statements. The gic code
> does this for irqchips.

Ok. Will look at it.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
