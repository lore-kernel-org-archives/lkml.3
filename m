Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab3E0SYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 14:24:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59198 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab3E0SX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 14:23:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Adrien =?utf-8?q?Verg=C3=A9?= <adrienverge@gmail.com>
Subject: Re: [PATCH] ARM: OMAP4: USB_EHCI_HCD needs USB_PHY and NOP_USB_XCEIV
Date: Mon, 27 May 2013 20:23:12 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Florian Fainelli <florian@openwrt.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yannick Brosseau <yannick.brosseau@gmail.com>, rogerq@ti.com
References: <CANsc=4W7ZVuCoimeALsv6xEQAURYc=QYsCvXd_kZD-A52aTL5w@mail.gmail.com> <CANsc=4WDM0q=RwaN2ZrcNqgJ=fDsgGHcBDcufnDek4EVWcnGfw@mail.gmail.com>
In-Reply-To: <CANsc=4WDM0q=RwaN2ZrcNqgJ=fDsgGHcBDcufnDek4EVWcnGfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201305272023.12281.arnd@arndb.de>
X-Provags-ID: V02:K0:lpOQFQqdEle6XY6TP+PGIXQwssCTGMmRJ3vYhJa5HYT
 M/p2oWpXjXDtqnWOyKGT+TI6w3grsz9a1M6eu9iRplkpmEWMkB
 WM0VyzC3AW+ZDflixMLHaZq0LAlOhDX231+RDb3xAQFOtRuHKl
 cdIp8Uy/xoKLXw1nsIqYzJS9csOGsR5Id0JlBt76gu0vO3xR3h
 I/beijrG91T683n0LKH0BACvc12iLJC7GyDS71Qo9JNWvwZeyM
 QNH8a+SUsdCNlXAAW8BKe2FIo/NAJfYPuKYiV3UuE7raRcsDZG
 h5fTZlh0AX7bRWX4rz1OozuYgqPwxZezqWCB6yVieYN+sUr1NB
 qi2sSkLt8OwAkDbFjoNM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 May 2013, Adrien Vergé wrote:
> On OMAP4 platforms, EHCI HCD needs the physical layer signalling
> activated, along with the NOP USB Transceiver driver. Otherwise, the
> kernel boots without registering any USB device.

This does not actually sound like a critical error: If a user forgets
to enable a driver, that driver will not be loaded. Of course the
kernel should not just crash when a non-essential driver is missing,
and it should not fail to build, but your description sounds harmless.

Am I missing something?

> This patch applies to Linux 3.10-rc2.
> 
> Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
> ---
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index de94f26..47959d7 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -44,6 +44,8 @@ endif # USB_XHCI_HCD
>  config USB_EHCI_HCD
>         tristate "EHCI HCD (USB 2.0) support"

This is the wrong place: it should be in USB_EHCI_HCD_OMAP
if any.

>         depends on USB_ARCH_HAS_EHCI
> +       select USB_PHY if ARCH_OMAP4
> +       select NOP_USB_XCEIV if ARCH_OMAP4
>         ---help---
>           The Enhanced Host Controller Interface (EHCI) is standard for USB 2.0
>           "high speed" (480 Mbit/sec, 60 Mbyte/sec) host controller hardware.

'select'ing USB_PHY sounds wrong too, I think you mean 'depends on'.

Also note that Roger Quadros has just removed the 'select NOP_USB_XCEIV'
there, I think you should coordinate with him.

	Arnd
