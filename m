Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaJ1NQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:16:10 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:59173 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaJ1NQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:16:08 -0400
Date: Tue, 28 Oct 2014 14:12:57 +0100
From: Johan Hovold <johan@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Johan Hovold <johan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Felipe Balbi <balbi@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-ID: <20141028131257.GS2006@localhost>
References: <20141024190251.GB19377@localhost>
 <20141024192540.GD11455@saruman>
 <20141024192948.GE11455@saruman>
 <20141024193655.GD19377@localhost>
 <20141024194442.GG11455@saruman>
 <20141024195532.GF19377@localhost>
 <20141027162251.d7ff2a5f31917c638d4e47f7@linux-foundation.org>
 <20141028002552.GX12379@n2100.arm.linux.org.uk>
 <20141028081616.GL2006@localhost>
 <20141028084745.GY12379@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028084745.GY12379@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 08:47:46AM +0000, Russell King - ARM Linux wrote:
> On Tue, Oct 28, 2014 at 09:16:16AM +0100, Johan Hovold wrote:
> > It looks like we're soon to be having power-off call chains, with
> > configurable priorities, to shut of various parts of the hardware
> 
> I really hope that they *don't* get used like that.  I guess this is
> what happens when people don't read the code before they decide to
> implement something.
> 
> All the reboot/power off/halt methods already call into the driver model,
> and the driver model then iterates over all bound drivers calling their
> "shutdown" method.  So, today, as it has been for years, all device
> drivers are notified of system power off.
> 
> That's where most device drivers should be cleanly stopping their
> hardware.
> 
> The only thing which is left is the actual hardware triggering of the
> action, and that should be what's done via the notifier.

That's not what I was trying to refer to. But the patch set explicitly
allows for multiple, prioritised power-off handlers, which can power
off a board in different ways and with various degrees of success.
Specifically, it allows for fallback handlers in case one or more
power-off handlers fail.

So if we allow for that, what is to prevent the final power-off handler
from failing? And should this not be logged by arch code in the same way
as failure to restart is?

Johan
