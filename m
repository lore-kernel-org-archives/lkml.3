Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaJTW7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:59:51 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:51077 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaJTW7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:59:49 -0400
X-IronPort-AV: E=Sophos;i="5.04,758,1406617200"; 
   d="scan'208";a="48932394"
Message-ID: <544593E1.90608@broadcom.com>
Date: Mon, 20 Oct 2014 15:59:45 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
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
References: <1413341936-17606-2-git-send-email-sbranden@broadcom.com> <4779079.vI0gT0iWvg@wuerfel>
In-Reply-To: <4779079.vI0gT0iWvg@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-10-20 12:55 PM, Arnd Bergmann wrote:
> On Tuesday 14 October 2014 19:58:51 Scott Branden wrote:
>>   if ARCH_BCM
>>
>> +menu "iProc SoC based Machine types"
>> +       config ARCH_BCM_IPROC
>> +               bool
>> +               select ARM_GIC
>> +               select CACHE_L2X0
>> +               select HAVE_ARM_SCU if SMP
>> +               select HAVE_ARM_TWD if SMP
>> +               select ARM_GLOBAL_TIMER
>> +
>> +               select CLKSRC_MMIO
>> +               select ARCH_REQUIRE_GPIOLIB
>> +               select ARM_AMBA
>> +               select PINCTRL
>> +               help
>> +                 This enables support for systems based on Broadcom IPROC architected SoCs.
>> +                 The IPROC complex contains one or more ARM CPUs along with common
>> +                 core periperals. Application specific SoCs are created by adding a
>> +                 uArchitecture containing peripherals outside of the IPROC complex.
>> +                 Currently supported SoCs are Cygnus.
>> +
>> +       config ARCH_BCM_CYGNUS
>> +               bool "Broadcom Cygnus Support" if ARCH_MULTI_V7
>
> You still have a three-level menu structure. Please fix.

Hi Arnd, we have ARCH_BCM->ARCH_BCM_CYGNUS.

ARCH_BCM_IPROC is silent and selected by ARCH_BCM_CYGNUS.  This was the 
change made between v3 and v5.

Is there something else to be done here?
>
>> +static const char const *bcm_cygnus_dt_compat[] = {
>> +       "brcm,cygnus",
>> +       NULL,
>> +};
>> +
>> +DT_MACHINE_START(BCM_CYGNUS_DT, "Broadcom Cygnus SoC")
>> +       .l2c_aux_val    = 0,
>> +       .l2c_aux_mask   = ~0,
>> +       .dt_compat = bcm_cygnus_dt_compat,
>> +MACHINE_END
>>
> This looks good.
>
> 	Arnd
>

