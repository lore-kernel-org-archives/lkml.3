Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaFMIap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:30:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50274 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbaFMIam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:30:42 -0400
Message-ID: <539AB68C.5090001@ti.com>
Date: Fri, 13 Jun 2014 11:30:04 +0300
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
Subject: Re: [PATCH 18/36] ARM: OMAP2+: gpmc-onenand: Move Synchronous setting
 code to drivers/
References: <1402477001-31132-1-git-send-email-rogerq@ti.com> <1402477001-31132-19-git-send-email-rogerq@ti.com> <20140613075527.GP17845@atomide.com>
In-Reply-To: <20140613075527.GP17845@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 10:55 AM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [140611 01:59]:
>> Move the code that puts the onenand in synchronous mode
>> into the appropriate place i.e. drivers/mtd/onenand/omap2.c.
>>
>> Make use of omap_gpmc_get_clk_period() and omap_gpmc_retime()
>> to calculate the necessary timings and configure the GPMC
>> parent's timings.
> 
> Ideally we would just use the drivers/mtd/onenand/generic.c
> and get rid of drivers/mtd/onenand/omap2.c. We still need
> the bus glue, which should probably be in drivers/memory?
> 

But what about the runtime synchronous timing calculations onenand/omap2.c?
There is also OMAP2 and OMAP3 specific dma handling done there, which should probably be done generically using dmaengine.

cheers,
-roger


