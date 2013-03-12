Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab3CLONZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:13:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47132 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab3CLONW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:13:22 -0400
Message-ID: <513F37DD.9030301@ti.com>
Date: Tue, 12 Mar 2013 16:12:45 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: <balbi@ti.com>, <tony@atomide.com>, <mark.rutland@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 1/8] usb: phy: nop: Add some parameters to platform data
References: <1363087466-32444-1-git-send-email-rogerq@ti.com> <1363087466-32444-2-git-send-email-rogerq@ti.com> <513F177D.40500@pengutronix.de>
In-Reply-To: <513F177D.40500@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 01:54 PM, Marc Kleine-Budde wrote:
> On 03/12/2013 12:24 PM, Roger Quadros wrote:
>> Add clk_rate parameter to platform data. If supplied, the
>> NOP phy driver will program the clock to that rate during probe.
>>
>> Also add 2 flags, needs_vcc and needs_reset.
>> If the flag is set and the regulator couldn't be found
>> then the driver will bail out with -EPROBE_DEFER.
> 
> Is there a platform which fills out pdata.needs_vcc and
> pdata.needs_reset? IMHO it makes no sense to add features for the non DT
> case, if there isn't any user for it.
>

There can be a user in the non DT case as well. Consider the following example:
The power regulator that supplies VCC to the PHY device sits over the I2C bus.
The NOP transceiver driver is built into the kernel but the regulator driver
is built as a module.

During boot, the NOP transceiver driver's probe is called before the regulator can
be probed. So regulator_get() will fail and if the platform doesn't set the
needs_vcc flag, the driver will continue as normal and the PHY device won't work.

I know that beagleboard can benefit from this. The current workaround is to
register the regulator before we register the PHY in the board file. With the
needs_vcc flag, we don't need to have that limitation.

cheers,
-roger
