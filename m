Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393Ab3E1OeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:34:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34046 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934279Ab3E1OeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:34:21 -0400
Message-ID: <51A4C060.50202@ti.com>
Date: Tue, 28 May 2013 17:34:08 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: =?UTF-8?B?QWRyaWVuIFZlcmfDqQ==?= <adrienverge@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Florian Fainelli <florian@openwrt.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yannick Brosseau <yannick.brosseau@gmail.com>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH] ARM: OMAP4: USB_EHCI_HCD needs USB_PHY and NOP_USB_XCEIV
References: <CANsc=4W7ZVuCoimeALsv6xEQAURYc=QYsCvXd_kZD-A52aTL5w@mail.gmail.com> <CANsc=4WDM0q=RwaN2ZrcNqgJ=fDsgGHcBDcufnDek4EVWcnGfw@mail.gmail.com> <201305272023.12281.arnd@arndb.de> <51A4676D.9010404@ti.com> <CANsc=4W0j62vQYXdcKkdd199Jp+jsx_Xgs0n+5fM+WR00pD9Og@mail.gmail.com>
In-Reply-To: <CANsc=4W0j62vQYXdcKkdd199Jp+jsx_Xgs0n+5fM+WR00pD9Og@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrien,

On 05/28/2013 04:30 PM, Adrien Vergé wrote:
> Dear Arnd and Roger, thank you for your answers.
> 
> 2013/5/28 Roger Quadros <rogerq@ti.com>
>> Selecting NOP_USB_XCEIV is wrong as it in turn depends on USB_PHY.
>>
>> I'm not for depends as it would hide USB_EHCI_HCD_OMAP in menuconfig.
>> I'm for explicitly selecting both, as it makes the user's life much
>> easier.
>> But I'm afraid maintainers might object to that.
>>
>> The other option is to enable the required drivers in omap2plus_defconfig.
>> http://comments.gmane.org/gmane.linux.ports.arm.omap/97899
> 
> This seems a good idea to me, since many OMAP users boot with NFS and
> need USB directly working (Ethernet over USB).
> 
>> Maybe you could just resend that patch after addressing Kevin's comments?
> 
> It's sad that USB_EHCI_HCD is too instable to be added in omap2plus_defconfig.

This is not true as of today. A lot has changed since 2012 and most of the issues that Kevin
had pointed out then have been fixed. The only piece that is missing is allowing the system
to hit lower power states (e.g. RETention) when USB host is suspended. This feature
will eventually be supported when we have IO daisy chaining working with device tree.

> Still, USB_PHY and NOP_USB_XCEIV are needed since v3.10 for USB
> support (and harmless): should I send a patch adding those two in
> omap2plus_defconfig?

Yes please. Thanks :). I'm working on the approach Arnd suggested as well.

cheers,
-roger
