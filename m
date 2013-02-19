Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab3BSKat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:30:49 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:34008 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab3BSKar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:30:47 -0500
MIME-Version: 1.0
In-Reply-To: <20130219010331.GC14932@verge.net.au>
References: <20130218142834.28739.39417.sendpatchset@w520>
	<20130219010331.GC14932@verge.net.au>
Date: Tue, 19 Feb 2013 19:30:46 +0900
Message-ID: <CANqRtoQUvojJTDDU8trh-Btt5yyfQUqrCwcm0bnPb00dtNBZEg@mail.gmail.com>
Subject: Re: [PATCH] irqchip: Renesas INTC External IRQ pin driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 10:03 AM, Simon Horman <horms@verge.net.au> wrote:
> On Mon, Feb 18, 2013 at 11:28:34PM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> This patch adds a driver for external IRQ pins connected
>> to the INTC block on recent SoCs from Renesas.
>>
>> The INTC hardware block usually contains a rather wide
>> range of features ranging from external IRQ pin handling
>> to legacy interrupt controller support. On older SoCs
>> the INTC is used as a general purpose interrupt controller
>> both for external IRQ pins and on-chip devices.
>>
>> On more recent ARM based SoCs with Cortex-A9 the main
>> interrupt controller is the GIC, but IRQ trigger setup
>> still need to happen in the INTC hardware block.
>>
>> This driver implements the glue code needed to configure
>> IRQ trigger and also handle mask/unmask and demux of
>> external IRQ pins hooked up from the INTC to the GIC.
>>
>> Tested on sh73a0 and r8a7779. The hardware varies quite
>> a bit with SoC model, for instance register width and
>> bitfield widths vary wildly. The driver requires one GIC
>> SPI per external IRQ pin to operate.  Each driver instance
>> will handle up to 8 external IRQ pins.
>>
>> The SoCs using this driver are currently mainly used
>> together with regular platform devices so this driver
>> allows configuration via platform data to support things
>> like static interrupt base address. DT support will
>> be added incrementally in the not so distant future.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>
> Hi Magnus, Hi all,
>
> I do not expect this code to go through the renesas tree.  However, in
> order to provide a basis for work on renesas SoCs I have added this patch
> to the topic/intc-external-irq topic branch in the reneas tree on
> kernel.org and merged it into topic/all+next.
>
> In other words, I am not picking this series up to merge it or add it to
> linux-next, rather I am storing it for reference.
>
>
> In the course of adding the branch I noticed a 3 whitespace warnings
> from git. I have highlighted them below.

Thanks Simon. I will fix those up in V2!

/ magnus
