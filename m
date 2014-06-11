Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaFKLz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:55:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37475 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbaFKLzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:55:24 -0400
Message-ID: <53984389.40000@ti.com>
Date: Wed, 11 Jun 2014 14:54:49 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Tony Lindgren <tony@atomide.com>, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        <kyungmin.park@samsung.com>, "Gupta, Pekon" <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>, <nsekhar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/36] OMAP: GPMC: Restructure and move OMAP GPMC driver
 out of mach-omap2
References: <1402477001-31132-1-git-send-email-rogerq@ti.com> <CABxcv=mMAnnjd=F7itDWCt5QpVr=U5_mP=xhCW-oB5c2Doo75w@mail.gmail.com>
In-Reply-To: <CABxcv=mMAnnjd=F7itDWCt5QpVr=U5_mP=xhCW-oB5c2Doo75w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On 06/11/2014 02:52 PM, Javier Martinez Canillas wrote:
> Hello Roger,
> 
> What a great series!!

Thanks :)

> 
> On Wed, Jun 11, 2014 at 10:56 AM, Roger Quadros <rogerq@ti.com> wrote:
>> Hi,
>>
>> This is a complete functional set to get the gpmc driver out of mach-omap2
>> and into drivers/memory. The DT binding remains the same except for the
>> following minor changes
> 
> I probably won't have time to do a proper review until at least next
> week but doing a quick glance it looks very good to me.
> 
>> - compatible property is required for NAND & OneNAND nodes
> 
> This is a minor ABI breakage but I agree with you that it is wrong
> that these were not introduced in the first place and relied on the
> dev node so I think is not that bad to break it in this case.
> 
>> - Second register space and interrupts properties are required for
>>   NAND controller node
>> - ti,onenand-sync-rw property added for OneNAND node.
>>
>> The series does the following changes
>> - Move GPMC IRQ and NAND register handling to NAND driver.
>>   The entire GPMC register space is made available to the NAND driver.
>> - Clean up NAND device tree handling. Don't rely on legacy platform device
>>   i.e. don't call gpmc_nand_init()
>> - Add 2 public APIs omap_gpmc_retime() and omap_gpmc_get_clk_period()
>>   omap_gpmc_retime() allows to reconfigure the GPMC settings and timings
>>   for the specified Chip select region.
>>   omap_gpmc_get_clk_period() allows to query the GPMC_CLK (external clock)
>>   period, to perform timing calculations.
>>   Both functions will be needed by the OneNAND driver since it calculates
>>   device timings on the fly and needs to change from Asynchronous mode
>>   to Synchronous mode.
>> - Setup OneNAND in Asynchronous mode by default and move Synchronous
>>   setting code into OneNAND driver.
>> - Clean up OneNAND device tree handling. Don't rely on legacy platform device
>>   i.e. don't call gpmc_onenand_init()
>> - Introduce gpmc_generic_init() that should be used by board files to specify
>>   GPMC chip select setting/timing and platform device within that Chip Select.
>> - Stop using all gpmc*() that are meant to be private to GPMC driver.
>> - Move GPMC driver into drivers/memory
>>
>> Tested on:
>>
>> - beagleboard C4: NAND
>> - Nokia N900: OneNAND
>>
> 
> Do you have a tree somewhere that I can use it to test on the boards I
> maintain and post patches to update the DTS according the new binding?

You can find the series at
git@github.com:rogerq/linux.git
gpmc-3.16-v1

cheers,
-roger

