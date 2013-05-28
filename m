Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761Ab3E1JR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:17:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60656 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933615Ab3E1JR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:17:26 -0400
Message-ID: <51A4761C.80903@ti.com>
Date: Tue, 28 May 2013 12:17:16 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: =?ISO-8859-1?Q?Adrien_Verg=E9?= <adrienverge@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Florian Fainelli <florian@openwrt.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yannick Brosseau <yannick.brosseau@gmail.com>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH] ARM: OMAP4: USB_EHCI_HCD needs USB_PHY and NOP_USB_XCEIV
References: <CANsc=4W7ZVuCoimeALsv6xEQAURYc=QYsCvXd_kZD-A52aTL5w@mail.gmail.com> <201305272023.12281.arnd@arndb.de> <51A4676D.9010404@ti.com> <2720824.63SknuJcmD@wuerfel>
In-Reply-To: <2720824.63SknuJcmD@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 11:40 AM, Arnd Bergmann wrote:
> On Tuesday 28 May 2013 11:14:37 Roger Quadros wrote:
>>>>         depends on USB_ARCH_HAS_EHCI
>>>> +       select USB_PHY if ARCH_OMAP4
>>>> +       select NOP_USB_XCEIV if ARCH_OMAP4
>>>>         ---help---
>>>>           The Enhanced Host Controller Interface (EHCI) is standard for USB 2.0
>>>>           "high speed" (480 Mbit/sec, 60 Mbyte/sec) host controller hardware.
>>>
>>> 'select'ing USB_PHY sounds wrong too, I think you mean 'depends on'.
>>>
>>> Also note that Roger Quadros has just removed the 'select NOP_USB_XCEIV'
>>> there, I think you should coordinate with him.
>>
>> Selecting NOP_USB_XCEIV is wrong as it in turn depends on USB_PHY.
>>
>> I'm not for depends as it would hide USB_EHCI_HCD_OMAP in menuconfig.
>> I'm for explicitly selecting both, as it makes the user's life much easier.
>> But I'm afraid maintainers might object to that.
> 
> My preferred option would be to turn the 'menuconfig PHY' into 'menu',
> which is what we did to solve a similar problem in drivers/mfd: It lets
> us 'select' specific PHY drivers without turning on the entire
> menu. Using 'select PHY' has the nasty side-effect of creating an
> incorrect dependency between the OMAP EHCI driver and all the
> non-OMAP phy drivers that become visible once the usb-phy directory
> gets enabled.
>

Good idea, thanks. I will give this a try.

cheers,
-roger
