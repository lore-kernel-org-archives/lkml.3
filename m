Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141Ab3E1NaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:30:24 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:65056 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933952Ab3E1NaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:30:21 -0400
MIME-Version: 1.0
In-Reply-To: <51A4676D.9010404@ti.com>
References: <CANsc=4W7ZVuCoimeALsv6xEQAURYc=QYsCvXd_kZD-A52aTL5w@mail.gmail.com>
	<CANsc=4WDM0q=RwaN2ZrcNqgJ=fDsgGHcBDcufnDek4EVWcnGfw@mail.gmail.com>
	<201305272023.12281.arnd@arndb.de>
	<51A4676D.9010404@ti.com>
Date: Tue, 28 May 2013 09:30:20 -0400
Message-ID: <CANsc=4W0j62vQYXdcKkdd199Jp+jsx_Xgs0n+5fM+WR00pD9Og@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP4: USB_EHCI_HCD needs USB_PHY and NOP_USB_XCEIV
From: =?UTF-8?Q?Adrien_Verg=C3=A9?= <adrienverge@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Florian Fainelli <florian@openwrt.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yannick Brosseau <yannick.brosseau@gmail.com>,
        "Balbi, Felipe" <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd and Roger, thank you for your answers.

2013/5/28 Roger Quadros <rogerq@ti.com>
> Selecting NOP_USB_XCEIV is wrong as it in turn depends on USB_PHY.
>
> I'm not for depends as it would hide USB_EHCI_HCD_OMAP in menuconfig.
> I'm for explicitly selecting both, as it makes the user's life much
> easier.
> But I'm afraid maintainers might object to that.
>
> The other option is to enable the required drivers in omap2plus_defconfig.
> http://comments.gmane.org/gmane.linux.ports.arm.omap/97899

This seems a good idea to me, since many OMAP users boot with NFS and
need USB directly working (Ethernet over USB).

> Maybe you could just resend that patch after addressing Kevin's comments?

It's sad that USB_EHCI_HCD is too instable to be added in omap2plus_defconfig.
Still, USB_PHY and NOP_USB_XCEIV are needed since v3.10 for USB
support (and harmless): should I send a patch adding those two in
omap2plus_defconfig?

Cheers,
Adrien
