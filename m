Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaENVup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:50:45 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55253 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221AbaENVun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:50:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+lB5F2RqgDsmRHQ+bWDcHt
Date: Wed, 14 May 2014 14:50:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: George Cherian <george.cherian@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, bcousson@baylibre.com,
        ezequiel@vanguardiasur.com.ar, bigeasy@linutronix.de,
        yegorslists@googlemail.com, balbi@ti.com
Subject: Re: [RFC PATCH] ARM: dts: am33xx: Re-arrange the USB dt to reflect
 the h/w configuration
Message-ID: <20140514215034.GL27426@atomide.com>
References: <1399617068-19826-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399617068-19826-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* George Cherian <george.cherian@ti.com> [140508 23:34]:
> Re arrange the USB dt for AM33xx to take it a bit closer
> to the hardware configuration.
> 
> The USBSS is designed as follows
> 
> USB control Module	0x44e10_0620
> 
> USBSS			0x4740_0000
> 
> USB0			0x4740_1000
> USB0_PHY		0x4740_1300
> USB0_CORE		0x4740_1400
> 
> USB1			0x4740_1800
> USB1_PHY		0x4740_1b00
> USB1_CORE		0x4740_1c00
> 
> CPPI DMA Controller	0x4740_2000
> CPPI DMA Scheduler	0x4740_3000
> Queue Manager		0x4740_4000
> 
> So model the DT as follows
> USBSS {
>     usb_ctrl_mod: {
>         0x44e10_0620
>     }
>     usb0: {
>     0x4740_1000
>     0x4740_1400
>     }
>     usb0_phy:{
>     0x4740_1300
>     }
>     usb1:{
>     0x4740_1800
>     0x4740_1c00
>     }
>     usb1_phy: {
>     0x4740_1b00
>     }
>     cppi41dma: {
>     0x4740_2000
>     0x4740_3000
>     0x4740_4000
>     }
> }

Is this just a cosmetic change or is this trying to workaround
some edma related init order issue?

Regards,

Tony
