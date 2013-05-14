Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab3ENIZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:25:51 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46251 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309Ab3ENIZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:25:48 -0400
Message-ID: <5191F503.2070301@free-electrons.com>
Date: Tue, 14 May 2013 10:25:39 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Christian Daudt <csd@broadcom.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 06/14] ARM: bcm281xx: Remove init_irq declaration in machine
 description
References: <1368438253-28218-1-git-send-email-maxime.ripard@free-electrons.com> <1368438253-28218-7-git-send-email-maxime.ripard@free-electrons.com> <519147C6.6080004@broadcom.com>
In-Reply-To: <519147C6.6080004@broadcom.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

Le 13/05/2013 22:06, Christian Daudt a écrit :
> On 13-05-13 02:44 AM, Maxime Ripard wrote:
>> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
>> specified") removed the need to explictly setup the init_irq field in
>> the machine description when using only irqchip_init. Remove that
>> declaration for bcm281xx as well.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> ---
>>   arch/arm/mach-bcm/board_bcm.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-bcm/board_bcm.c
>> b/arch/arm/mach-bcm/board_bcm.c
>> index 22e8421..24556cf 100644
>> --- a/arch/arm/mach-bcm/board_bcm.c
>> +++ b/arch/arm/mach-bcm/board_bcm.c
>> @@ -54,7 +54,6 @@ static void __init board_init(void)
>>   static const char * const bcm11351_dt_compat[] = { "bcm,bcm11351",
>> NULL, };
>>     DT_MACHINE_START(BCM11351_DT, "Broadcom Application Processor")
>> -    .init_irq = irqchip_init,
>>       .init_time = clocksource_of_init,
>>       .init_machine = board_init,
>>       .dt_compat = bcm11351_dt_compat,
> Acked-by: Christian Daudt <csd@broadcom.com>

Thanks!

I forgot to remove the include of irqchip.h into all these patches, so
I'll send a v2, and I guess you could probably merge it through your
tree after that directly.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
