Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3AQNLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:11:10 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:33610 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3AQNLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:11:07 -0500
MIME-Version: 1.0
In-Reply-To: <50F7EF23.8080903@ti.com>
References: <1358348462-27693-1-git-send-email-kishon@ti.com>
	<1358348462-27693-3-git-send-email-kishon@ti.com>
	<CAFp+6iGEC9KgfuQz6nqnAY5JrmtPG=HkGw5yjKw7-1=8AG_=dg@mail.gmail.com>
	<50F7EF23.8080903@ti.com>
Date: Thu, 17 Jan 2013 18:41:04 +0530
Message-ID: <CAFp+6iH3kxtx2fM9m50Skcb6aqJOhL4d+Vg6W3mo7uUoAp0F1Q@mail.gmail.com>
Subject: Re: [RFC PATCH 2/6] ARM: OMAP: USB: Add phy binding information
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: kishon <kishon@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-sh@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, balbi@ti.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        b-cousson@ti.com, tony@atomide.com, linux@arm.linux.org.uk,
        horms@verge.net.au, magnus.damm@gmail.com, cbou@mail.ru,
        dwmw2@infradead.org, alexander.shishkin@linux.intel.com,
        gregkh@linuxfoundation.org, leoli@freescale.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, stern@rowland.harvard.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,


Thanks for the explanation.

On Thu, Jan 17, 2013 at 6:01 PM, kishon <kishon@ti.com> wrote:
> Hi,
>
>
> On Thursday 17 January 2013 05:41 PM, Vivek Gautam wrote:
>>
>> Hi Kishon,
>>
>>
>> On Wed, Jan 16, 2013 at 8:30 PM, Kishon Vijay Abraham I <kishon@ti.com>
>> wrote:
>>>
>>> This is in preparation for the changes in PHY library to support adding
>>> and getting multiple PHYs of the same type. In the new design, the
>>> binding information between the PHY and the USB controller should be
>>> specified in the platform specific initialization code. So it's been
>>> done for OMAP platforms here.
>>>
>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>> ---
>>> This kind-of binding should be done in all the platforms (I've done only
>>> for OMAP platform).
>>>   arch/arm/mach-omap2/usb-musb.c |    7 ++++++-
>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm/mach-omap2/usb-musb.c
>>> b/arch/arm/mach-omap2/usb-musb.c
>>> index 9d27e3f..bbe2fa5 100644
>>> --- a/arch/arm/mach-omap2/usb-musb.c
>>> +++ b/arch/arm/mach-omap2/usb-musb.c
>>> @@ -24,6 +24,7 @@
>>>   #include <linux/dma-mapping.h>
>>>   #include <linux/io.h>
>>>   #include <linux/usb/musb.h>
>>> +#include <linux/usb/phy.h>
>>>
>>>   #include "omap_device.h"
>>>   #include "soc.h"
>>> @@ -85,8 +86,12 @@ void __init usb_musb_init(struct omap_musb_board_data
>>> *musb_board_data)
>>>          musb_plat.mode = board_data->mode;
>>>          musb_plat.extvbus = board_data->extvbus;
>>>
>>> -       if (cpu_is_omap44xx())
>>> +       if (cpu_is_omap44xx()) {
>>>                  musb_plat.has_mailbox = true;
>>> +               usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
>>> +       } else if (cpu_is_omap34xx()) {
>>> +               usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
>>> +       }
>>
>>
>> Just trying to understand things here.
>> Is the device name we are using here the platform device name (pdev->name)
>> ?
>
>
> it's pdev->dev.name.
>
>> If i am not wrong then for devices added through device tree
>> the device name would actually include the device address in the string,
>
>
> Ideally for device tree, devm_usb_get_phy_by_phandle() introduced in the 5th
> patch of this series should be used.

Ok.
> usb_bind_phy should be called from platform specific initialization files
> (like your board file), which won't get executed in dt boot.
>
Right.

>> wouldn't that make things somewhat weird, since we will have to add
>> such bindings
>> using this address string.
>>
>> one more doubt please :)
>> is it possible to bind phy in the controllers' driver somehow ?
>
> Thats not going to be good. Why do you need to do that?
>
I was certainly missing something while understanding your patches.
That's why got some doubt on this. :)


> Thanks
> Kishon



-- 
Thanks & Regards
Vivek
