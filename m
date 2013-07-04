Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab3GDMLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:11:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52430 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab3GDMLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:11:36 -0400
Message-ID: <51D56631.2010901@ti.com>
Date: Thu, 4 Jul 2013 17:40:25 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>
Subject: Re: [PATCH 1/4] arm: omap: Add phy binding info for musb in plat
 data
References: <1371631951-369-1-git-send-email-kishon@ti.com> <1371631951-369-2-git-send-email-kishon@ti.com> <20130704114439.GA5523@atomide.com>
In-Reply-To: <20130704114439.GA5523@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 04 July 2013 05:14 PM, Tony Lindgren wrote:
> * Kishon Vijay Abraham I <kishon@ti.com> [130619 01:58]:
>> In order for controllers to get PHY in case of non dt boot, the phy
>> binding information (phy label) should be added in the platform
>> data of the controller.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> Acked-by: Felipe Balbi <balbi@ti.com>
>> Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> ---
>>   arch/arm/mach-omap2/usb-musb.c |    6 +++++-
>>   include/linux/usb/musb.h       |    3 +++
>>   2 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
>> index 3242a55..5ddbe39 100644
>> --- a/arch/arm/mach-omap2/usb-musb.c
>> +++ b/arch/arm/mach-omap2/usb-musb.c
>> @@ -85,8 +85,12 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
>>   	musb_plat.mode = board_data->mode;
>>   	musb_plat.extvbus = board_data->extvbus;
>>
>> -	if (cpu_is_omap44xx())
>> +	if (cpu_is_omap44xx()) {
>>   		musb_plat.has_mailbox = true;
>> +		musb_plat.phy_name = "omap-usb2";
>> +	} else if (cpu_is_omap34xx()) {
>> +		musb_plat.phy_name = "twl4030";
>> +	}
>>
>>   	if (soc_is_am35xx()) {
>>   		oh_name = "am35x_otg_hs";
>
> Care to refresh this patch against the current mainline tree?

I'll do that on monday as I'm not in office and I dont have any boards
to test at my disposal now.
> Now omap4 is DT only, so this part won't apply. Mostly I'm wondering
> what the phy_name should be for am35xx that's not covered by this
> patch.

am35xx doesn't have a separate PHY driver yet (I guess the programming
is done in the controller code now). So this binding is not needed for
am35xx.
>
> Also let me know if the last patch is safe to queue alone as a fix
> or if it depends on the driver related changes in this series.

No. The last patch is kind-of cleanup needed after applying the first
3 patches. It's better it's applied along with the other patches.

Thanks
Kishon
