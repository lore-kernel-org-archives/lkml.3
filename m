Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbbA2KSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:18:17 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45792 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759798AbbA2KSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:18:14 -0500
Date: Thu, 29 Jan 2015 10:17:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>
Subject: Re: [PATCH] Devicetree binding for omap3-serial & bcm2048 combination
Message-ID: <20150129101748.GQ17721@leverpostej>
References: <20150128093501.GA17338@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128093501.GA17338@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 09:35:01AM +0000, Pavel Machek wrote:
> Nokia N900 contains bluetooth module connected on serial
> port. Unfortunately, serial and bluetooth are rather closely coupled,
> so standard serial driver can not be used, and we really don't want
> /dev/ttyS1 to be published for internal port of bluetooth
> stack... Hence solution below.

How are they closely coupled?

> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/Documentation/devicetree/bindings/serial/omap_serial.txt b/Documentation/devicetree/bindings/serial/omap_serial.txt
> index 342eedd..e9fde42 100644
> --- a/Documentation/devicetree/bindings/serial/omap_serial.txt
> +++ b/Documentation/devicetree/bindings/serial/omap_serial.txt
> @@ -4,7 +4,14 @@ Required properties:
>  - compatible : should be "ti,omap2-uart" for OMAP2 controllers
>  - compatible : should be "ti,omap3-uart" for OMAP3 controllers
>  - compatible : should be "ti,omap4-uart" for OMAP4 controllers
> +- compatible : should be "ti+brcm,omap3-uart,bcm2048" for bcm2048
> +	       bluetooth connected to OMAP3 serial

I'm very much not keen on munging the two devices into one.

Elsewhere Neil Brown and others having been looking into allowing UARTs
to function as busses for single devices, which to me seems to cover
this case.

Mark.

>  - ti,hwmods : Must be "uart<n>", n being the instance number (1-based)
>  
>  Optional properties:
>  - clock-frequency : frequency of the clock input to the UART
> +
> +Required properties for ti+brcm,omap3-uart,bcm2048:
> +- reset-gpios : gpio for reset pin
> +- host-wakeup-gpios : gpio for host wakeup
> +- bluetooth-wakeup-gpios : gpio for bluetooth wakeup
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
