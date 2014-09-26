Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaIZJ1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:27:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64725 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbaIZJ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:27:48 -0400
Message-ID: <54253195.5040003@linaro.org>
Date: Fri, 26 Sep 2014 10:27:49 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
References: <20140926112344.3ee87d2f@canb.auug.org.au> <20140926081804.GH5182@n2100.arm.linux.org.uk>
In-Reply-To: <20140926081804.GH5182@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/09/14 09:18, Russell King - ARM Linux wrote:
> On Fri, Sep 26, 2014 at 11:23:44AM +1000, Stephen Rothwell wrote:
>> Hi all,
>>
>> Today's linux-next merge of the arm-soc tree got a conflict in
>> arch/arm/Kconfig.debug between commits 0889a9e35bd3 ("ARM: 8142/1:
>> ks8695: Migrate debug_ll macros to shared directory"), e38c399ca584
>> ("ARM: 8144/2: netx: Migrate DEBUG_LL macros to shared directory"),
>> 6741cacfa3f1 ("ARM: 8145/1: sa1100: Migrate DEBUG_LL macros to shared
>> directory") and debf843bf7ee ("ARM: 8146/1: Seperate DEBUG_UART_PHYS
>> from DEBUG_LL on EP93XX") from the arm tree and commits d8a00916b303
>> ("ARM: meson: debug: add debug UART for earlyprintk support"),
>> b125170a39ea ("CNS3xxx: Fix debug UART") and b51312bebfa4 ("ARM:
>> BCM63XX: add low-level UART debug support") from the arm-soc tree.
>>
>> I fixed it up (hopefully - see below) and can carry the fix as
>> necessary (no action is required).
>>
>> You may be able to clean some of this up by using intermediate config
>> symbols that are selected by the low level symbols and depended upon by
>> the higher level config symbols.
> 
> Actually, I'll drop the patch set I have.  I didn't spot this earlier,
> but people seem to have a hard time sorting stuff numerically:
> 
>         default 0xffd82340 if ARCH_IOP13XX
> +       default 0xfffb0000 if DEBUG_OMAP1UART1 || DEBUG_OMAP7XXUART1
> +       default 0xfffb0800 if DEBUG_OMAP1UART2 || DEBUG_OMAP7XXUART2
> +       default 0xfffb9800 if DEBUG_OMAP1UART3 || DEBUG_OMAP7XXUART3
>         default 0xfff36000 if DEBUG_HIGHBANK_UART

Oops. This is disappointing from my point-of-view but there's no one to
blame but me.

I have fixed this in my tree and will requeue for 3.19.


> It also looks like the same is true for arm-soc:
> 
>> @@@ -1174,9 -1133,7 +1213,10 @@@
>>   	default 0x50008000 if DEBUG_S3C24XX_UART && (DEBUG_S3C_UART2 || \
>>   				DEBUG_S3C2410_UART2)
>>   	default 0x7c0003f8 if FOOTBRIDGE
>>  +	default 0x80010000 if DEBUG_SA1100_UART1
>>  +	default 0x80030000 if DEBUG_SA1100_UART2
>>  +	default 0x80050000 if DEBUG_SA1100_UART3
>> + 	default 0x78000000 if DEBUG_CNS3XXX
> 
> Last time I checked, 0x78000000 comes before 0x7c0003f8.
> 

