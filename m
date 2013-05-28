Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597Ab3E1Iko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:40:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529Ab3E1Ikn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:40:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roger Quadros <rogerq@ti.com>
Cc: Adrien =?ISO-8859-1?Q?Verg=E9?= <adrienverge@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Florian Fainelli <florian@openwrt.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yannick Brosseau <yannick.brosseau@gmail.com>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH] ARM: OMAP4: USB_EHCI_HCD needs USB_PHY and NOP_USB_XCEIV
Date: Tue, 28 May 2013 10:40:38 +0200
Message-ID: <2720824.63SknuJcmD@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <51A4676D.9010404@ti.com>
References: <CANsc=4W7ZVuCoimeALsv6xEQAURYc=QYsCvXd_kZD-A52aTL5w@mail.gmail.com> <201305272023.12281.arnd@arndb.de> <51A4676D.9010404@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:m0oISlkHtaW3SkB1+wy6H2XQc2lq/Us1lC6A7sNrvq5
 c+F5LAMq1qDHiBsZBhW1fcWb09fpQdqWKfgtVL20SdpHHDXfDq
 oKNmiVPLPOhtJFxbwxnqrcCNrpUO/gFW8yNHEph4B3hBqLLKT2
 xWf2926wmQWg9joeyBMpVageUIOyycpmEQX+TG055Y22MGe2jo
 84KH8KuNh8WldZyr0jON6YI3PazbrqOdtx/PLnrUFufBuqHLRF
 wDnkOmohoUul4vo/YPDVV57ABqzNJu58J7Fiqnf2F1h4u0aFv6
 9JMuakGQo1kR8hE3qZ0iBOMmlXWwvc8BdhpSsjDTyRRT0gGCeI
 cDLZk1P2geMAygcD+2LU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 May 2013 11:14:37 Roger Quadros wrote:
> >>         depends on USB_ARCH_HAS_EHCI
> >> +       select USB_PHY if ARCH_OMAP4
> >> +       select NOP_USB_XCEIV if ARCH_OMAP4
> >>         ---help---
> >>           The Enhanced Host Controller Interface (EHCI) is standard for USB 2.0
> >>           "high speed" (480 Mbit/sec, 60 Mbyte/sec) host controller hardware.
> > 
> > 'select'ing USB_PHY sounds wrong too, I think you mean 'depends on'.
> > 
> > Also note that Roger Quadros has just removed the 'select NOP_USB_XCEIV'
> > there, I think you should coordinate with him.
> 
> Selecting NOP_USB_XCEIV is wrong as it in turn depends on USB_PHY.
> 
> I'm not for depends as it would hide USB_EHCI_HCD_OMAP in menuconfig.
> I'm for explicitly selecting both, as it makes the user's life much easier.
> But I'm afraid maintainers might object to that.

My preferred option would be to turn the 'menuconfig PHY' into 'menu',
which is what we did to solve a similar problem in drivers/mfd: It lets
us 'select' specific PHY drivers without turning on the entire
menu. Using 'select PHY' has the nasty side-effect of creating an
incorrect dependency between the OMAP EHCI driver and all the
non-OMAP phy drivers that become visible once the usb-phy directory
gets enabled.

	Arnd
