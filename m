Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab3HQNYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 09:24:32 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:45494 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab3HQNYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 09:24:30 -0400
Message-ID: <520F798C.2040606@gmail.com>
Date: Sat, 17 Aug 2013 15:24:28 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 1/5] irqchip: add Armada 1500 APB interrupt controller
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376682098-10580-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1376682098-10580-2-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 09:41 PM, Sebastian Hesselbarth wrote:
> This adds irqchip drivers for the secondary interrupt controllers found
> on Armada 1500 APB and SYSMGT APB bus.
>
> I tried to find a compatible irqchip driver within v3.11-rc5, but there
> is no. I guess that it is a common IP core to buy for your SoC, so maybe
> one of the maintainers knows a better name for it. Could be DesignWare
> type-of as timers are DW, too.

 From a quick look into Synopsys DW ip library, it probably matches 
dw_apb_ictl best and should be named accordingly. Next round will
name the source dw_apb_ictl.c and corresponding compatible
"snps,dw-apb-ictl".

In addition, it looks like the ip can support up to 64 irqs. For orion
irq, I have used a "mavell,#interrupts" to allow to pass the number of
supported irqs. Above driver should also exploit a similar
snps-prefixed property.

Sebastian
