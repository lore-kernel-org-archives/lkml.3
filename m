Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965154Ab3HHKkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:40:14 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47508 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965049Ab3HHKkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:40:12 -0400
MIME-Version: 1.0
In-Reply-To: <5203C1D1.8020707@ti.com>
References: <1371999607-6483-1-git-send-email-prabhakar.csengg@gmail.com>
 <1371999607-6483-7-git-send-email-prabhakar.csengg@gmail.com>
 <51F8A4FF.8020803@ti.com> <CA+V-a8smEd_75Ab-_vxjBATr8Q9Sefs0tpxc+kgQJRtuLJad=w@mail.gmail.com>
 <5203C1D1.8020707@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 8 Aug 2013 16:09:50 +0530
Message-ID: <CA+V-a8vHxB0Yy46LLEtVM7-VfPwC=UNux_cpQE=Xmon6Uvxbsg@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] ARM: davinci: da850: configure system
 configuration chip(CFGCHIP3) for emac
To: Sekhar Nori <nsekhar@ti.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Heiko Schocher <hs@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 9:35 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On Thursday 08 August 2013 04:02 PM, Prabhakar Lad wrote:
>> Hi Sekhar,
>>
>> Sorry for the  delayed response I was on leave and now back again up
>> and running.
>>
>> On Wed, Jul 31, 2013 at 11:17 AM, Sekhar Nori <nsekhar@ti.com> wrote:
>>> On Sunday 23 June 2013 08:30 PM, Prabhakar Lad wrote:
>>>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>>>
>>>> This patch makes a common function for to configure emac and calls
>>>> it appropriately in DT and non DT boot mode. The system configuration
>>>> chip CFGCHIP3, controls the emac module. This patch appropriately
>>>> configures this register for emac and sets DA850_MII_MDIO_CLKEN_PIN
>>>> GPIO pin appropriately.
>>>>
>> [Snip]
>>
>>>> +     if (rmii_enabled)
>>>> +             val |= BIT(8);
>>>> +     else
>>>> +             val &= ~BIT(8);
>>>> +
>>>> +     /* configure the CFGCHIP3 register for RMII or MII */
>>>> +     writel(val, cfg_chip3_base);
>>>> +
>>>> +     ret = davinci_cfg_reg(DA850_GPIO2_6);
>>>> +     if (ret)
>>>> +             pr_warn("%s:GPIO(2,6) mux setup failed\n", __func__);
>>>> +
>>>> +     ret = gpio_request(DA850_MII_MDIO_CLKEN_PIN, "mdio_clk_en");
>>>> +     if (ret) {
>>>> +             pr_warn("Cannot open GPIO %d\n", DA850_MII_MDIO_CLKEN_PIN);
>>>> +             return;
>>>> +     }
>>>
>>> You cannot do this in SoC specific code. All boards wont use a GPIO to
>>> choose between MII/RMII. You need to do this in a EVM specific manner.
>>> This just means you retain the GPIO part of code in board-da850-evm.c
>>
>> OK
>>
>>> and for the DT case use a board specific GPIO node. See a similar
>>> example in arch/arm/boot/dts/ste-nomadik-s8815.dts and how the code uses
>> Alrite something similar to usb-s8815 node.
>>
>>> it in arch/arm/mach-nomadik/cpu-8815.c.
>>>
>> But I don't see any code to access this node in this file, can
>> you point me to right direction ?
>
> Look at cpu8815_eth_init() function in this file.
>
Thanks, I was looking at some earlier version of code here [1],
where this was missing.

[1] https://github.com/AndrewDB/rk3066-kernel/blob/master/arch/arm/mach-nomadik/cpu-8815.c

Regards,
--Prabhakar Lad
