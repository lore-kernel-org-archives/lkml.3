Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaIPWhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:37:31 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41491 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaIPWha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:37:30 -0400
Message-ID: <5418BBAB.6040508@linaro.org>
Date: Tue, 16 Sep 2014 23:37:31 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v8 6/9] arm: netx: Migrate DEBUG_LL macros to shared directory
References: <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org>	 <1408459715-10151-1-git-send-email-daniel.thompson@linaro.org>	 <1408459715-10151-7-git-send-email-daniel.thompson@linaro.org> <1410798874.31130.57.camel@x220> <54175E87.2070509@linaro.org>
In-Reply-To: <54175E87.2070509@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/09/14 22:47, Daniel Thompson wrote:
> On 15/09/14 17:34, Paul Bolle wrote:
>> On Tue, 2014-08-19 at 15:48 +0100, Daniel Thompson wrote:
>>> As part of the migration we introduce DEBUG_UART_PHYS/DEBUG_UART_VIRT
>>> which default to UART1 but allow a user to configure UART2 or UART3.
>>> We also introduce symbolic names for the registers and flags.
>>>
>>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Acked-by: Arnd Bergmann <arnd.bergmann@linaro.org>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>
>> This patch landed in today's linux-next, as 880fa9b6fd73 ("ARM: 8144/1:
>> netx: Migrate DEBUG_LL macros to shared directory").
>>
>>> [...]
>>> --- a/arch/arm/Kconfig.debug
>>> +++ b/arch/arm/Kconfig.debug
>>> @@ -447,6 +447,14 @@ choice
>>>  		  Say Y here if you want kernel low-level debugging support
>>>  		  on Vybrid based platforms.
>>>  
>>> +	config DEBUG_NETX_UART
>>> +		bool "Kernel low-level debugging messages via NetX UART"
>>> +		depends on ARCH_NETX
>>> +		select DEBUG_UART_NETX
>>
>> There's no Kconfig symbol DEBUG_UART_NETX in next-20140915. So in
>> linux-next this is currently a nop. Is this symbol queued somewhere?
> 
> No. The symbol isn't queued anywhere.
> 
> DEBUG_UART_NETX is a config value that existed transiently when I wrote
> the patch and I didn't clean it up properly. I suspect its visual
> similarity to DEBUG_NETX_UART means it didn't jump out when I self reviewed.
> 
> Thanks for raising this. I will share a patch to remove this.

I was just finalizing this and, since it was on my screen anyway, took
another look at my assembler changes.

They are broken! Rather than initializing \rp and \rv as they are
supposed to they set \rp to two different values leaving \rv uninitialized.

This I will also fix.


Daniel.
