Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbaDQNYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:24:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59088 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbaDQNYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:24:17 -0400
Message-ID: <534FD5FC.6060703@gmail.com>
Date: Thu, 17 Apr 2014 15:24:12 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: linus.walleij@linaro.org, alexandre.belloni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 3/5] ARM: berlin: add the pinctrl dependency for
 the Marvell Berlin SoCs
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com> <1397135274-10764-4-git-send-email-antoine.tenart@free-electrons.com> <5347B065.8060001@gmail.com> <20140417131357.GA31034@kwain>
In-Reply-To: <20140417131357.GA31034@kwain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 03:13 PM, Antoine Ténart wrote:
> On Fri, Apr 11, 2014 at 11:05:41AM +0200, Sebastian Hesselbarth wrote:
>> On 04/10/2014 03:07 PM, Antoine Ténart wrote:
>>> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
>>> ---
>>>   arch/arm/mach-berlin/Kconfig | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
>>> index d3c5f14dc142..291f1cac6c3d 100644
>>> --- a/arch/arm/mach-berlin/Kconfig
>>> +++ b/arch/arm/mach-berlin/Kconfig
>>> @@ -4,6 +4,8 @@ config ARCH_BERLIN
>>>   	select GENERIC_IRQ_CHIP
>>>   	select DW_APB_ICTL
>>>   	select DW_APB_TIMER_OF
>>> +	select PINCTRL
>>> +	select PINCTRL_BERLIN
>>
>> As said in the review of the previous patch, drop PINCTRL here
>> and select it in the PINCTRL_BERLIN Kconfig. Also, you'll need
>> PINCTRL_BERLIN_BG2 and PINCTRL_BERLIN_BG2Q as we don't want to
>> bloat each Berlin kernel with both drivers.
>
> Regarding PINCTRL, I can't drop it, pin-controller drivers depend on it.
> drivers/pinctrl/Kconfig begins with:
> 	if PINCTRL

Ah, ok. Then select PINCTRL here and the corresponding
PINCTRL_BERLIN_foo in the individual SoC Kconfig entries.

Sebastian

