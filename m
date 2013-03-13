Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab3CMPSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:18:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36171 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3CMPSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:18:15 -0400
Message-ID: <514098A0.1030809@ti.com>
Date: Wed, 13 Mar 2013 16:17:52 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130301 Thunderbird/17.0.3
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, <balbi@ti.com>, <tony@atomide.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 1/8] usb: phy: nop: Add some parameters to platform data
References: <1363087466-32444-1-git-send-email-rogerq@ti.com> <1363087466-32444-2-git-send-email-rogerq@ti.com> <513F177D.40500@pengutronix.de> <513F37DD.9030301@ti.com> <513F38DF.5040404@pengutronix.de> <513F3B7E.8000002@ti.com> <513F3EF0.3030609@pengutronix.de> <513F47B4.2060004@ti.com>
In-Reply-To: <513F47B4.2060004@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 04:20 PM, Roger Quadros wrote:
> Adding Peter to the loop. I faintly remember him mentioning this issue before
> for beagle. We really need the deferred probe mechanism or we need to resort
> to device registering order.

Yes, BeagleBoard is a good example. Long story short: we have external
dependency and the correct way to handle that is via deferred probe.

As of now we are not ready to kill the legacy support but over time we should
move as much as we can to DT only mode.

> The first user for needs_vcc flag will be the beagleboard file. I just didn't
> implement it in this patch [1].
> 
> On second thoughts, since [1] does work on beagleboard without requiring the
> needs_vcc flag, I think we can just live without it.

The BeagleBoard works because the bootloader happen to enable the PWM
generator which is used as a GPIO for the external HUB enable port. As soon as
the bootloader stops doing this we are going to be in trouble.

> 
> Felipe, Peter, what do you think?
> 
> cheers,
> -roger
> 
> [1] https://lkml.org/lkml/2013/3/12/244
> 


-- 
Péter
