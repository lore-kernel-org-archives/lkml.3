Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaIOVry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:47:54 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35095 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805AbaIOVru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:47:50 -0400
Message-ID: <54175E87.2070509@linaro.org>
Date: Mon, 15 Sep 2014 22:47:51 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v8 6/9] arm: netx: Migrate DEBUG_LL macros to shared directory
References: <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org>	 <1408459715-10151-1-git-send-email-daniel.thompson@linaro.org>	 <1408459715-10151-7-git-send-email-daniel.thompson@linaro.org> <1410798874.31130.57.camel@x220>
In-Reply-To: <1410798874.31130.57.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/09/14 17:34, Paul Bolle wrote:
> On Tue, 2014-08-19 at 15:48 +0100, Daniel Thompson wrote:
>> As part of the migration we introduce DEBUG_UART_PHYS/DEBUG_UART_VIRT
>> which default to UART1 but allow a user to configure UART2 or UART3.
>> We also introduce symbolic names for the registers and flags.
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Acked-by: Arnd Bergmann <arnd.bergmann@linaro.org>
>> Cc: linux-arm-kernel@lists.infradead.org
> 
> This patch landed in today's linux-next, as 880fa9b6fd73 ("ARM: 8144/1:
> netx: Migrate DEBUG_LL macros to shared directory").
> 
>> [...]
>> --- a/arch/arm/Kconfig.debug
>> +++ b/arch/arm/Kconfig.debug
>> @@ -447,6 +447,14 @@ choice
>>  		  Say Y here if you want kernel low-level debugging support
>>  		  on Vybrid based platforms.
>>  
>> +	config DEBUG_NETX_UART
>> +		bool "Kernel low-level debugging messages via NetX UART"
>> +		depends on ARCH_NETX
>> +		select DEBUG_UART_NETX
> 
> There's no Kconfig symbol DEBUG_UART_NETX in next-20140915. So in
> linux-next this is currently a nop. Is this symbol queued somewhere?

No. The symbol isn't queued anywhere.

DEBUG_UART_NETX is a config value that existed transiently when I wrote
the patch and I didn't clean it up properly. I suspect its visual
similarity to DEBUG_NETX_UART means it didn't jump out when I self reviewed.

Thanks for raising this. I will share a patch to remove this.


