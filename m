Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab3LBOD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:03:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:44735 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab3LBODx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:03:53 -0500
Message-ID: <529C9343.3010000@linutronix.de>
Date: Mon, 02 Dec 2013 15:03:47 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: Michael Trimarchi <michael@amarulasolutions.com>,
        Felipe Balbi <balbi@ti.com>, lee.jones@linaro.org,
        sameo@linux.intel.com, tomi.valkeinen@ti.com,
        Stefan Roese <sr@denx.de>, ljkenny.mailinglists@gmail.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems
 on OMAP4 Panda
References: <1385730118-26402-1-git-send-email-rogerq@ti.com>	<1385730118-26402-2-git-send-email-rogerq@ti.com> <CAOf5uwmEkzFd=e3j8m8=qdTCAMkk_-DPw0fTm=7Vzy0PbE2oDQ@mail.gmail.com> <529C55DF.3000808@ti.com> <529C76AF.10106@linutronix.de> <529C7922.5000601@ti.com> <529C854F.3010101@linutronix.de> <529C8CBD.4070003@ti.com> <529C8D74.10007@linutronix.de> <529C8ED0.6060805@ti.com>
In-Reply-To: <529C8ED0.6060805@ti.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 02:44 PM, Roger Quadros wrote:
> "Errata id: i660
> DESCRIPTION
> In the following configuration :
> • USBHOST module is set to smart-idle mode
> • PRCM asserts idle_req to the USBHOST module. (This typically happens when the system is going to
> a low power mode : all ports have been suspended, the master part of the USBHOST module has
> entered the standby state, and SW has cut the functional clocks.)
> • an USBHOST interrupt occurs before the module is able to answer idle_ack, typically a remote wakeup
> IRQ.
> Then the USB HOST module will enter a deadlock situation where it is no more accessible nor functional.
> The only way to recover will be to perform a software reset of the module.
> 
> WORKAROUND
> The best workaround consists in switching the module to force idle mode right before cutting the
> module's FCLK.
> • the bus has reached the suspend state.
> • write SYSCONFIG:Idlemode= ForceIdle and read it back to ensure the write has been taken into
> account in case of posted writes.
> • cut the FCLK
> • Idle_req will be asserted and idle_ack answered within one L3 clock cycle.
> Upon resume or remote wakeup, switch back the module to smart-idle.
> This workaround reduces the failure window to only one L3 clock cycle. The probability for an interrupt to
> fire at this exact time is considered extremely low, and the case has never been hit on board."
> 
> Based on this, I don't see anything wrong in Resetting the module at probe or at boot.

If u-boot configured USB into something not smart-idle and the reset
would bring it back then the reset should remain.
If you could tell hwmod not use smart-idle nor smart-standby and you
make sure that the suspend code manually puts the device into suspend
via forceidle then I think could get rid of the "do-not-reset-thingy".

> 
> cheers,
> -roger
> 

Sebastian
