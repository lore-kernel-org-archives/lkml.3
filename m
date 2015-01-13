Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbbAMJF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:05:26 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:53175 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbbAMJEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:04:55 -0500
MIME-Version: 1.0
In-Reply-To: <1421139747.22660.76.camel@x220>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
 <1418831474-24428-4-git-send-email-ricardo.ribalda@gmail.com> <1421139747.22660.76.camel@x220>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 13 Jan 2015 10:04:33 +0100
Message-ID: <CAPybu_1DRCuJFGsw6p2pqZLDXjp=fAD_i-Yj6+7GX-Vr++fpOA@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] gpio/xilinx: Add support for X86 Arch
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul

Thanks for noticing

Shall I send the patch or you want to do it yourself?


Thanks again!

On Tue, Jan 13, 2015 at 10:02 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Wed, 2014-12-17 at 16:51 +0100, Ricardo Ribalda Delgado wrote:
>> Core can be accessed via PCIe on X86 platform.
>> This patch also allows the driver to be used as module.
>>
>> Acked-by: Michal Simek <michal.simek@xilinx.com>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> ---
>>  drivers/gpio/Kconfig       | 4 ++--
>>  drivers/gpio/gpio-xilinx.c | 2 +-
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> This patch became c586b3075d5b ("gpio/xilinx: Add support for X86 Arch")
> in today's linux-next (next-20150113). I noticed because a script I use
> to check linux-next spotted a problem in it.
>
>> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
>> index 414d055..b17d226 100644
>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -366,8 +366,8 @@ config GPIO_XGENE
>>         here to enable the GFC GPIO functionality.
>>
>>  config GPIO_XILINX
>> -     bool "Xilinx GPIO support"
>> -     depends on PPC_OF || MICROBLAZE || ARCH_ZYNQ
>> +     tristate "Xilinx GPIO support"
>> +     depends on OF_GPIO && (PPC_OF || MICROBLAZE || ARCH_ZYNQ || ARCH_X86)
>
> There's no Kconfig symbol "ARCH_X86". Did you actually mean "X86"?
>
>>       help
>>         Say yes here to support the Xilinx FPGA GPIO device
>>
>> diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
>> index c7ed92b..554060a 100644
>> --- a/drivers/gpio/gpio-xilinx.c
>> +++ b/drivers/gpio/gpio-xilinx.c
>> @@ -30,7 +30,7 @@
>>  #define XGPIO_CHANNEL_OFFSET 0x8
>>
>>  /* Read/Write access to the GPIO registers */
>> -#ifdef CONFIG_ARCH_ZYNQ
>> +#if defined(CONFIG_ARCH_ZYNQ) || defined(CONFIG_X86)
>
> Yes, you probably did want just "X86".
>
>>  # define xgpio_readreg(offset)               readl(offset)
>>  # define xgpio_writereg(offset, val) writel(val, offset)
>>  #else
>
>
> Paul Bolle
>



-- 
Ricardo Ribalda
