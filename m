Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaFMHja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:39:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32897 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaFMHj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:39:28 -0400
Message-ID: <539AAA8C.2070709@ti.com>
Date: Fri, 13 Jun 2014 10:38:52 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/36] mtd: nand: omap: Move IRQ handling from GPMC to
 NAND driver
References: <1402477001-31132-1-git-send-email-rogerq@ti.com> <1402477001-31132-6-git-send-email-rogerq@ti.com> <20140613071820.GI17845@atomide.com>
In-Reply-To: <20140613071820.GI17845@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 10:18 AM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [140611 01:58]:
>> Since the Interrupt Events are used only by the NAND driver,
>> there is no point in managing the Interrupt registers
>> in the GPMC driver and complicating it with irqchip modeling.
>>
>> Let's manage the interrupt registers directly in the NAND driver
>> and get rid of irqchip model from GPMC driver.
>>
>> Get rid of IRQ commands and unused commands from gpmc_configure() in
>> the GPMC driver.
> 
> This seems like a step backward to me. The GPMC interrupt enable
> register can do edge detection on the wait pins, how is that
> limited to NAND?

OK. But wait pin edge detection was not yet being used and I couldn't
think of how it would ever be used. Any ideas?

> 
> Further, let's not start mixing GPMC hardware module register
> access with the NAND driver register access. They can be clocked
> separately. And bugs in the NAND driver can cause issues in other
> GPMC using drivers.

I understood that NAND controller is integrated into the GPMC module and they are clocked
the same. Not sure why the hardware designers would keep the registers so closely knit.

FYI. memory/ti-amif.c and mtd/nand/davinci_nand.c share the AMIF register space in the
same way. I thought it'd be nice to be consistent across TI drivers.

cheers,
-roger
