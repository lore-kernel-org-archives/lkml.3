Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab3GBIWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:22:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54267 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab3GBIWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:22:44 -0400
Message-ID: <51D28DB9.704@ti.com>
Date: Tue, 2 Jul 2013 11:22:17 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
References: <Pine.LNX.4.44L0.1307011655580.1547-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1307011655580.1547-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 12:01 AM, Alan Stern wrote:
> On Mon, 1 Jul 2013, Felipe Balbi wrote:
> 
>>> I don't know what Pad wakeup is.  The wakeup signal has to originate 
>>> from the EHCI controller, doesn't it?  If not, how does the Pad know 
>>> when a wakeup is needed?
>>
>> That's really an OMAP thing, I guess. Pad wakeup sits in the PRCM (IIRC)
>> inside and always on power domain. EHCI sits in another power domain
>> which be turned off. When it's turned off (power gated and clock gated)
>> the EHCI block has no means to wakeup whatsoever. That's when pad wakeup
>> comes into play. It is generated when PRCM sees a change in the actual
>> pad of the die. To check who should 'own' the wakeup, it checks the
>> muxing settings to verify whose pad is that.
> 
> How does the PRCM know which changes should generate wakeup events?  

It doesn't know. It will always generate a wakeup on any change in the monitored pins.
We can only configure which pins we want to monitor.
So we can't choose which wakeup events we want to monitor. We just can
enable or disable all events.

> In the EHCI controller, this is managed by the settings of the WKOC_E,
> WKDSCNNT_E, and WKCNNT_E bits in the PORTSC registers.  But if EHCI is
> powered off, those bits can't be used.

Is "powered off" same as ehci_suspend? If yes then how does it work on other systems
for remote wakeup?

> 
> Also, once the wakeup signal has been turned on, how does it get turned 
> off again?

That is taken care of by the OMAP pinctrl driver. It will always turn off the
wakeup signal once the event is detected and forwarded as an IRQ.

I know that all this is a bit ugly :(.

cheers,
-roger
