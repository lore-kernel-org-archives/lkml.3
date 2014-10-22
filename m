Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaJVALO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 20:11:14 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:16228 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaJVALL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 20:11:11 -0400
X-IronPort-AV: E=Sophos;i="5.04,765,1406617200"; 
   d="scan'208";a="48670140"
Message-ID: <5446F61C.8060400@broadcom.com>
Date: Tue, 21 Oct 2014 17:11:08 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Jonathan Richardson <jonathar@broadcom.com>
Subject: Re: [PATCH v5 1/6] ARM: cygnus: Initial support for Broadcom Cygnus
 SoC
References: <1413341936-17606-2-git-send-email-sbranden@broadcom.com> <4779079.vI0gT0iWvg@wuerfel> <544593E1.90608@broadcom.com> <38587325.kaAxCWAsmL@wuerfel>
In-Reply-To: <38587325.kaAxCWAsmL@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-10-20 10:48 PM, Arnd Bergmann wrote:
> On Monday 20 October 2014 15:59:45 Scott Branden wrote:
>> On 14-10-20 12:55 PM, Arnd Bergmann wrote:
>>> On Tuesday 14 October 2014 19:58:51 Scott Branden wrote:
>>>>    if ARCH_BCM
>>>>
>>>> +menu "iProc SoC based Machine types"
>>>> +       config ARCH_BCM_IPROC
>>>> +               bool
>>>> +               select ARM_GIC
>>>> +               select CACHE_L2X0
>>>> +               select HAVE_ARM_SCU if SMP
>>>> +               select HAVE_ARM_TWD if SMP
>>>> +               select ARM_GLOBAL_TIMER
>>>> +
>>>> +               select CLKSRC_MMIO
>>>> +               select ARCH_REQUIRE_GPIOLIB
>>>> +               select ARM_AMBA
>>>> +               select PINCTRL
>>>> +               help
>>>> +                 This enables support for systems based on Broadcom IPROC architected SoCs.
>>>> +                 The IPROC complex contains one or more ARM CPUs along with common
>>>> +                 core periperals. Application specific SoCs are created by adding a
>>>> +                 uArchitecture containing peripherals outside of the IPROC complex.
>>>> +                 Currently supported SoCs are Cygnus.
>>>> +
>>>> +       config ARCH_BCM_CYGNUS
>>>> +               bool "Broadcom Cygnus Support" if ARCH_MULTI_V7
>>>
>>> You still have a three-level menu structure. Please fix.
>>
>> Hi Arnd, we have ARCH_BCM->ARCH_BCM_CYGNUS.
>>
>> ARCH_BCM_IPROC is silent and selected by ARCH_BCM_CYGNUS.  This was the
>> change made between v3 and v5.
>>
>> Is there something else to be done here?
>>
>
> You have
>
> 	"Broadcom SoC Support"
> 		"iProc SoC based Machine types"
> 			 "Broadcom Cygnus Support"
OK, I will remove the "iProc SoC based Machine types".  This was 
grouping all iProc based SoCs under one menu and parallels what the 
existing "Broadcom Mobile Soc Support" menu does.
I can create another patch removing the "Broadcom Mobile SoC Support" 
menu if the ARM Maintainer now want all Broadcom devices are supposed to 
be contained in a single level?
>
> Get rid of one of them.
>
> 	Arnd
>

