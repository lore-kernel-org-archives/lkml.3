Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3CUFs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 01:48:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37525 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab3CUFs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 01:48:56 -0400
Message-ID: <514A9F1C.6080609@ti.com>
Date: Thu, 21 Mar 2013 11:18:12 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <akpm@linux-foundation.org>, <rob@landley.net>, <davem@davemloft.net>,
        <cesarb@cesarb.net>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <b-cousson@ti.com>, <linux@arm.linux.org.uk>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <mchehab@redhat.com>,
        <santosh.shilimkar@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <swarren@nvidia.com>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 4/6] ARM: OMAP: USB: Add phy binding information
References: <1363770725-13717-1-git-send-email-kishon@ti.com> <1363770725-13717-5-git-send-email-kishon@ti.com> <20130320165141.GP16413@atomide.com>
In-Reply-To: <20130320165141.GP16413@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 20 March 2013 10:21 PM, Tony Lindgren wrote:
> * Kishon Vijay Abraham I <kishon@ti.com> [130320 02:17]:
>>
>> --- a/arch/arm/mach-omap2/board-2430sdp.c
>> +++ b/arch/arm/mach-omap2/board-2430sdp.c
>> @@ -265,6 +266,7 @@ static void __init omap_2430sdp_init(void)
>>
>>   	omap_mux_init_signal("usb0hs_stp", OMAP_PULL_ENA | OMAP_PULL_UP);
>>   	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
>> +	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
>>   	usb_musb_init(NULL);
>>
>>   	board_smc91x_init();
>> --- a/arch/arm/mach-omap2/board-3430sdp.c
>> +++ b/arch/arm/mach-omap2/board-3430sdp.c
>> @@ -601,6 +602,7 @@ static void __init omap_3430sdp_init(void)
>>   	omap_serial_init();
>>   	omap_sdrc_init(hyb18m512160af6_sdrc_params, NULL);
>>   	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
>> +	phy_bind("musb-hdrc.0.auto", 0, "twl4030_usb");
>>   	usb_musb_init(NULL);
>>   	board_smc91x_init();
>>   	board_flash_init(sdp_flash_partitions, chip_sel_3430, 0);
>
> Can't you call phy_bind() from usb_musb_init() with the default
> values automatically when usb_musb_init() is passed NULL?
>
> That way you don't have to patch every board-*.c file with the
> same lines, and don't need to include <linux/phy/phy.h> in each
> board-*.c file.
>
>> --- a/arch/arm/mach-omap2/board-4430sdp.c
>> +++ b/arch/arm/mach-omap2/board-4430sdp.c
>> @@ -32,6 +32,7 @@
>>   #include <linux/platform_data/omap4-keypad.h>
>>   #include <linux/usb/musb.h>
>>   #include <linux/usb/phy.h>
>> +#include <linux/phy/phy.h>
>>
>>   #include <asm/mach-types.h>
>>   #include <asm/mach/arch.h>
>> @@ -725,6 +726,7 @@ static void __init omap_4430sdp_init(void)
>>   	omap4_twl6030_hsmmc_init(mmc);
>>
>>   	usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
>> +	phy_bind("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
>>   	usb_musb_init(&musb_board_data);
>>
>>   	status = omap_ethernet_init();
>
> Here usb_musb_init() gets called with musb_board_data, so
> keeping the phy_bind() in the board-4430sdp.c can then override
> the default in usb_musb_init().

Currently phy_bind has a limitation to do that. Will change phy_bind() 
and have your comment incorporated.

Thanks
Kishon
