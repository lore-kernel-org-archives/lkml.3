Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3FNOfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:35:34 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:42900 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3FNOfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:35:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130612225630.GC8146@quad.lixom.net>
References: <1371040448-28742-1-git-send-email-jonas.jensen@gmail.com>
	<1371040448-28742-4-git-send-email-jonas.jensen@gmail.com>
	<20130612225630.GC8146@quad.lixom.net>
Date: Fri, 14 Jun 2013 16:35:32 +0200
Message-ID: <CACmBeS0ra+32VVFtCpNiz0xrENFbTZFpnb3KppxiOfMiiKUXVQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: mach-moxart: add MOXA ART UART debug files
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, arm@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the replies.

On 13 June 2013 00:56, Olof Johansson <olof@lixom.net> wrote:
>> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
>> index 1d41908..a0e4a32 100644
>> --- a/arch/arm/Kconfig.debug
>> +++ b/arch/arm/Kconfig.debug
>> @@ -422,6 +422,15 @@ choice
>>                 Say Y here if you want kernel low-level debugging support
>>                 on Allwinner A1X based platforms on the UART1.
>>
>> +    config DEBUG_MOXART_UART0
>> +        bool "Kernel low-level debugging messages via MOXART UART0"
>> +        depends on ARCH_MOXART
>> +        help
>> +          Say Y here if you want kernel low-level debugging support
>> +          on MOXART based platforms on the UART0.
>> +          select this to make sure "putc" in arch/arm/boot/compressed/debug.S
>> +          uses arch/arm/include/debug/moxart.S:s "addruart" macro
>
> Looks like the last two lines above are leftovers? It's not super-helpful for
> someone trying to figure out if they want this option or not; the first two
> lines covers that quite nicely.

Leftovers removed. I only added them because I spent some time
figuring out the call chain around putc.

>> +++ b/arch/arm/include/debug/moxart.S
>> @@ -0,0 +1,14 @@
>> +/* Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License as published by the
>> + * Free Software Foundation; either version 2 of the License,
>> + * or (at your option) any later version. */
>> +
>> +#define MOXART_UART_DEBUG_PHYS_BASE          0x98200000
>> +
>> +.macro       addruart, rp, rv, tmp
>> +     ldr     \rp, =MOXART_UART_DEBUG_PHYS_BASE       @ physical
>
> You need to set rv here too.

Done. Used to be set with the IO_ADDRESS macro I worked so hard to
remove. Looking at other platforms, it seems accepted to set a
hardcoded value here.


Best regards,
Jonas
