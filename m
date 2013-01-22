Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3AVRDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:03:07 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44857 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab3AVRDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:03:02 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v1 0/6] USB: Add support for multiple PHYs of same type
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <50FEBB61.9000707@ti.com>
Date: Tue, 22 Jan 2013 18:02:56 +0100
Cc: <tony@atomide.com>, <balbi@ti.com>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org List" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Jason Kridner <jkridner@beagleboard.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <B9531499-0746-44DA-BDBB-999D4CA31E63@dominion.thruhere.net>
References: <1358848694-20145-1-git-send-email-kishon@ti.com> <2D906ABA-71F2-4843-9DBE-F82527A1240A@dominion.thruhere.net> <50FEB3FD.3050001@ti.com> <50FEBB61.9000707@ti.com>
To: kishon <kishon@ti.com>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 22 jan. 2013, om 17:16 heeft kishon <kishon@ti.com> het volgende geschreven:

> Hi,
> 
> On Tuesday 22 January 2013 09:15 PM, kishon wrote:
>> On Tuesday 22 January 2013 09:11 PM, Koen Kooi wrote:
>>> 
>>> Op 22 jan. 2013, om 10:58 heeft Kishon Vijay Abraham I <kishon@ti.com>
>>> het volgende geschreven:
>>> 
>>>> This patch series adds support for adding multiple PHY's (of same type).
>>>> The binding information has to be present in the PHY library (otg.c) in
>>>> order for it to return the appropriate PHY whenever the USB controller
>>>> request for the PHY. So added a new API usb_bind_phy() to pass the
>>>> binding
>>>> information. This API should be called by platform specific
>>>> initialization
>>>> code.
>>>> 
>>>> So the binding should be done something like
>>>> usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto"); specifying
>>>> the USB
>>>> controller device name, index, and the PHY device name.
>>>> I have done this binding for OMAP platforms, but it should be done for
>>>> all the platforms.
>>>> 
>>>> After this design, the phy can be got by passing the USB controller
>>>> device
>>>> pointer and the index.
>>>> 
>>>> Developed this patch series on
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git xceiv
>>>> after applying "usb: musb: add driver for control module" patch series
>>>> and "ARM: dts: omap: add dt data for MUSB"
>>>> 
>>>> Did basic enumeration testing in omap4 panda and omap3 beagle.
>>> 
>>> With this patchset USB completely breaks on am33xx beaglebone, is that
>>> intended?
>> Not really.
>> Does am33xx makes use of omap2430.c? Which PHY does am33xx uses?
> 
> I figured out it uses drivers/usb/musb/musb_dsps.c (So it doesn't use omap2430.c). I think it uses TWL4030_USB (TPS659x0) as PHY.

Actually it uses nop-phy as a phy, which is missing from arch/arm/boot/dts/am33xx.dtsi, so mainline is already broken. But adding the nop-phy to the DT is easy enough to patch in locally.

regards,

Koen