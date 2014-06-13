Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaFMHpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:45:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47158 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaFMHpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:45:13 -0400
Message-ID: <539AABE5.10907@ti.com>
Date: Fri, 13 Jun 2014 10:44:37 +0300
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
Subject: Re: [PATCH 14/36] ARM: OMAP2+: gpmc: Allow drivers to reconfigure
 GPMC settings & timings
References: <1402477001-31132-1-git-send-email-rogerq@ti.com> <1402477001-31132-15-git-send-email-rogerq@ti.com> <20140613072550.GM17845@atomide.com>
In-Reply-To: <20140613072550.GM17845@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 10:25 AM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [140611 01:58]:
>> Some devices (e.g. TUSB6010, omap-onenand) need to reconfigure the GPMC
>> timings in order to operate with different peripheral clock frequencies.
>> Introduce omap_gpmc_retime() to allow them to do that. The driver
>> needs to pass the chips select number, GPMC settings and Device timings to
>> omap_gpmc_retime().
>>
>> NOTE: Device tree and board code must still pass the most conservative
>> timings to GPMC so that the device can be probed by the respective driver.
>> e.g. Onenand must operate in asynchronous mode at bootup. The device driver
>> can then request for more optimal timings via omap_gpmc_retime().
> 
> Hmm but many of the devices are Linux generic like sms91x and 8250 so it's
> not nice to start stuffing omap bus specific data there.

Those drivers should never need to use this function. Hopefully they will work with a one time setup where we specify the timings in the DT. This function is primarily for use by omap-onenand and tusb6010, which are both OMAP specific.

cheers,
-roger

> 
> I wonder if we should just keep device specific gpmc-smc91x.c etc
> in drivers/memory?
> 
> Regards,
> 
> Tony
> 

