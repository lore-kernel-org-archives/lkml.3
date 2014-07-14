Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbaGNSMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:12:54 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:54978 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbaGNSMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:12:46 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:137d:b41e:cc55:8ebd:a466]
In-Reply-To: <61d660b7-17a9-4817-ba34-40a5c1674d28@BY2FFO11FD032.protection.gbl>
References: <1404075022-28745-1-git-send-email-afaerber@suse.de>
	<1404075022-28745-2-git-send-email-afaerber@suse.de>
	<CAOesGMhKY1Lb+o8AbtFXS5c7SLg2uGt4-oosdro2FMj_+bB6Tw@mail.gmail.com>
	<61d660b7-17a9-4817-ba34-40a5c1674d28@BY2FFO11FD032.protection.gbl>
Date: Mon, 14 Jul 2014 11:12:45 -0700
Message-ID: <CAOesGMjMEiQkrCfYyc6y+s9kst74jAjTghbYvxUJ+9KvPGXj1Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: dts: zynq: Add Parallella device tree
From: Olof Johansson <olof@lixom.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Andreas Olofsson <andreas@adapteva.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 4:18 AM, Michal Simek <michal.simek@xilinx.com> wrote:
> On 06/30/2014 07:15 AM, Olof Johansson wrote:
>> Hi,
>>
>> On Sun, Jun 29, 2014 at 1:50 PM, Andreas Färber <afaerber@suse.de> wrote:
>>> This allows to boot the Adapteva Parallella board to serial console.
>>>
>>> Cc: Andreas Olofsson <andreas@adapteva.com>
>>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>>
>> Nice and clean DTS, just a couple of comments below.
>>
>>> diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
>>> new file mode 100644
>>> index 0000000..98df66c
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/zynq-parallella.dts
>>> @@ -0,0 +1,63 @@
>>> +/*
>>> + * Copyright (c) 2014 SUSE LINUX Products GmbH
>>> + *
>>> + * Derived from zynq-zed.dts:
>>> + *
>>> + *  Copyright (C) 2011 Xilinx
>>> + *  Copyright (C) 2012 National Instruments Corp.
>>> + *  Copyright (C) 2013 Xilinx
>>> + *
>>> + * This software is licensed under the terms of the GNU General Public
>>> + * License version 2, as published by the Free Software Foundation, and
>>> + * may be copied, distributed, and modified under those terms.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + */
>>> +/dts-v1/;
>>> +/include/ "zynq-7000.dtsi"
>>> +
>>> +/ {
>>> +       model = "Parallella Board";

You might want to have this say "Adapteva Parallella Board" instead
(just noticed).

>>> +       compatible = "xlnx,zynq-7000";
>>
>> This should have a more specific compatible as the first one. Probably
>> something like:
>>    compatible = "adapteva,parallella", "xlnx,zynq-7000";
>
> We were using these compatible properties but later there is no reason
> to create them because they will be unused.
> It is easy to add it when you need it which is not this case.

No, please add it from day one, otherwise everybody needs to update
their device tree, some will miss doing it, etc, etc. It's a simple
and trivial thing to do, and no reason to leave it o ut.

>>> +
>>> +       memory {
>>> +               device_type = "memory";
>>> +               reg = <0 0x20000000>;
>>
>> Does the bootloader update this entry, or is it truly static? If it's
>> updated then it's become recent habit to leave the memory size empty
>> in the static file.
>
> Depends on your bootloader. I think it is good to have it here.
> Also this file can be used by u-boot for example and u-boot can be configured
> from it that's why I think that make sense to keep this here.

Ok. It's become commonplace to leave memory empty for the machines
where it's guaranteed that the bootloader will have updated it, to
avoid having stale or incorrect values in the static tree. I'm not
going to be strict about it, but it's something to consider.


-Olof
