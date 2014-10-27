Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaJ0RAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:00:08 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:32817 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJ0RAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:00:06 -0400
Date: Mon, 27 Oct 2014 17:56:54 +0100
From: Johan Hovold <johan@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Johan Hovold <johan@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtc: omap: add support for pmic_power_en
Message-ID: <20141027165654.GF2006@localhost>
References: <1413913086-12730-1-git-send-email-johan@kernel.org>
 <1414397368-26480-1-git-send-email-johan@kernel.org>
 <20141027164544.GI14253@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027164544.GI14253@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 11:45:44AM -0500, Felipe Balbi wrote:
> On Mon, Oct 27, 2014 at 09:09:28AM +0100, Johan Hovold wrote:
> > Add new property "ti,system-power-controller" to register the RTC as a
> > power-off handler.
> > 
> > Some RTC IP revisions can control an external PMIC via the pmic_power_en
> > pin, which can be configured to transition to OFF on ALARM2 events and
> > back to ON on subsequent ALARM (wakealarm) events.
> > 
> > This is based on earlier work by Colin Foe-Parker and AnilKumar Ch. [1]
> > 
> > [1] https://www.mail-archive.com/linux-omap@vger.kernel.org/msg82127.html
> > 
> > Tested-by: Felipe Balbi <balbi@ti.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> > 
> > Changes since v2:
> >  - add two-second delay to allow alarm to trigger before returning
> > 
> > Andrew, can you replace just this patch in the series that you already
> > have in your tree, or do you prefer I resend the whole series (with
> > Felipe's Tested-by tags)?
> > 
> > Thanks,
> > Johan
> > 
> > 
> >  Documentation/devicetree/bindings/rtc/rtc-omap.txt |  9 +-
> >  drivers/rtc/rtc-omap.c                             | 95 ++++++++++++++++++++++
> >  2 files changed, 103 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/rtc/rtc-omap.txt b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
> > index 5a0f02d34d95..750efd40c72e 100644
> > --- a/Documentation/devicetree/bindings/rtc/rtc-omap.txt
> > +++ b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
> > @@ -5,11 +5,17 @@ Required properties:
> >  	- "ti,da830-rtc"  - for RTC IP used similar to that on DA8xx SoC family.
> >  	- "ti,am3352-rtc" - for RTC IP used similar to that on AM335x SoC family.
> >  			    This RTC IP has special WAKE-EN Register to enable
> > -			    Wakeup generation for event Alarm.
> > +			    Wakeup generation for event Alarm. It can also be
> > +			    used to control an external PMIC via the
> > +			    pmic_power_en pin.
> >  - reg: Address range of rtc register set
> >  - interrupts: rtc timer, alarm interrupts in order
> >  - interrupt-parent: phandle for the interrupt controller
> >  
> > +Optional properties:
> > +- ti,system-power-controller: whether the rtc is controlling the system power
> 
> isn't there a discussion going on to drop the vendor prefix ? I wonder
> if we should just use the final binding to avoid supporting this for
> rtc-omap too. OTOH, all of that can be hidden under
> of_is_system_power_controller() itself.

Exactly, Romain intends to support both versions (i.e. with and without
the prefix) with his helper function as there are already other uses of
this variant in the wild.

As I believe I mentioned in my cover letter, I suggest simply updating
to the generic property name (i.e. use the helper and drop the prefix)
once that code has been merged. Either way, we should always be able
to change the property name before it has been used in a mainline
release (as long as we update the driver and any dts use in one commit
in order not to break bisectability).

Johan
