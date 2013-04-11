Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964941Ab3DKRdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:33:49 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:33973 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935364Ab3DKRds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:33:48 -0400
Message-ID: <5166F3EC.8040807@ahsoftware.de>
Date: Thu, 11 Apr 2013 19:33:32 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] USB: ehci-omap: Select USB_PHY
References: <5166856C.3080906@ti.com> <20130411100435.GB14394@arwen.pp.htv.fi> <516695A4.2050804@ti.com> <20130411105557.GE14394@arwen.pp.htv.fi> <5166AFD2.4070108@ti.com> <5166B450.1000404@ahsoftware.de> <5166CC30.4060507@ti.com>
In-Reply-To: <5166CC30.4060507@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.04.2013 16:44, schrieb Roger Quadros:

>> Sorry, but this just will end up with many users having broken configs
>> because of disabled stuff they don't know why they have to enable them.
>> And thus with a never ending stream of questions and thus with a needed
>> FAQ entry.
>>
>
> Alexander,
>
> I agree with you that it can get difficult with users. But it is best for
> users do not disable anything they are not familiar with.
>
> As the USB_PHY option doesn't depend on anything, it is safe to select it
> from USB_EHCI_HCD_OMAP.
>
> However, the PHY drivers themselves must be selected from the board configs.

Maybe I understood something wrong, but if the OMAP USB driver requires 
CONFIG_USB_PHY (or similiar), it should be selected automatically and 
not just enabled in the board config.

I just had it to often, that I needed to search around why a driver 
doesn't work (or even compiles), just to find out that I need to enable 
some strange config option which wasn't selected automatically. 
Especially with OMAPs. ;)

And this not only occured when disabling options, it often occured by 
just updating the kernel. Suddenly some obscur option was needed too, it 
wasn't selected automatically by make oldconfig, bang. So the argument 
to not remove anything from a board config doesn't help much.

Sorry for the rant. ;)

Regards,

Alexander
