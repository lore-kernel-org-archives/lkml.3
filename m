Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3BKLku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:40:50 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38179 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab3BKLks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:40:48 -0500
Date: Mon, 11 Feb 2013 11:40:40 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Roger Quadros <rogerq@ti.com>
Cc: "tony@atomide.com" <tony@atomide.com>,
        "b-cousson@ti.com" <b-cousson@ti.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "kishon@ti.com" <kishon@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/14] usb: phy: nop: Add device tree support and
 binding information
Message-ID: <20130211114040.GA2726@e106331-lin.cambridge.arm.com>
References: <1360252974-7912-1-git-send-email-rogerq@ti.com>
 <1360252974-7912-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
In-Reply-To: <1360252974-7912-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Feb 2013 11:40:43.0323 (UTC) FILETIME=[9FE1B8B0:01CE084C]
X-MC-Unique: 113021111404619001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 07, 2013 at 04:02:41PM +0000, Roger Quadros wrote:
> The PHY clock, clock rate, VCC regulator and RESET regulator
> can now be provided via device tree.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> ---
>  .../devicetree/bindings/usb/usb-nop-xceiv.txt      |   34 ++++++++++++++++++
>  drivers/usb/otg/nop-usb-xceiv.c                    |   36 +++++++++++++++----
>  2 files changed, 62 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt
> 
> diff --git a/Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt b/Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt
> new file mode 100644
> index 0000000..d7e2726
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt
> @@ -0,0 +1,34 @@
> +USB NOP PHY
> +
> +Required properties:
> +- compatible: should be usb-nop-xceiv

This might be better as "linux,usb-no-xceiv", given this is a Linux-specific
'device'.

Saying that, I'm not sure I understand why this device needs to be instantiated
from devicetree. As I understand it from looking at the driver, it's purely a
Linux implementation detail used in the case of autonomous PHYs, and not an
actual piece of hardware or firmware system. I must admit to being unfamiliar
with this area of hardware, have I misunderstood somethign here?

Can we not have drivers for autonomous PHYs initialise/register nop-usb-xceiv?
That way we don't leak Linux implementation details to the outside world, and
the dt can describe purely what's actually present in the system.

[...]

Thanks,
Mark.


