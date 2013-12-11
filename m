Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab3LKWgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:36:32 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:36164 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3LKWg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:36:27 -0500
Message-ID: <52A8F6FC.40201@cogentembedded.com>
Date: Thu, 12 Dec 2013 02:36:28 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org
CC: linux-sh@vger.kernel.org, benh@kernel.crashing.org,
        grant.likely@secretlab.ca, horms@verge.net.au, tglx@linutronix.de
Subject: Re: [PATCH] irqchip: Renesas IRQC driver
References: <20130227081501.30706.60471.sendpatchset@w520>
In-Reply-To: <20130227081501.30706.60471.sendpatchset@w520>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02/27/2013 11:15 AM, Magnus Damm wrote:

> From: Magnus Damm <damm@opensource.se>

    Magnus, explain me one thing about your driver please.

> This patch adds a driver for external IRQ pins connected
> to the IRQC hardware block on recent SoCs from Renesas.
>
> The IRQC hardware block is used together with more
> recent ARM based SoCs using the GIC. As usual the GIC
> requires external IRQ trigger setup somewhere else
> which in this particular case happens to be IRQC.
>
> This driver implements the glue code needed to configure
> IRQ trigger and also handle mask/unmask and demux of
> external IRQ pins hooked up from the IRQC to the GIC.

    Judging on the R8A779x manual pictures, IRQn enter the SoC via IRQC, right?
Why then you call request_irq() on GIC interrupt numbers and expect an 
interrupt to "enter" from the GIC side, and then only read IRQC's 
DETECT_STATUS register to make sure the matching IRQn is really active (you 
call it demux, but I don't really see much of a demultiplexing there). This 
seems to me fundamentally broken, and is probably why the interrupt from PHY 
doesn't happen despite I set the interrupt type to active low via a call to 
irq_set_irq_type()...

> Tested on r8a73a4 but is designed to work with a wide
> range of SoCs. The driver requires one GIC SPI per
> external IRQ pin to operate.  Each driver instance
> will handle up to 32 external IRQ pins.

    Ah, so you've even tested it... I got an impression from your words that 
the driver hasn't been tested.

> The SoCs using this driver are currently mainly used
> together with regular platform devices so this driver
> allows configuration via platform data to support things
> like static interrupt base address. DT support will
> be added incrementally in the not so distant future.

> Signed-off-by: Magnus Damm <damm@opensource.se>

WBR, Sergei

