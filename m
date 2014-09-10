Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaIJNUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:20:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37285 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751215AbaIJNUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:20:22 -0400
Date: Wed, 10 Sep 2014 15:20:19 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Johan Hovold <johan@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] rtc: at91sam9: add DT bindings documentation
Message-ID: <20140910152019.111c4c01@bbrezillon>
In-Reply-To: <20140910121424.GG2974@localhost>
References: <1409733934-14465-1-git-send-email-boris.brezillon@free-electrons.com>
	<1409733934-14465-6-git-send-email-boris.brezillon@free-electrons.com>
	<20140910121424.GG2974@localhost>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014 14:14:24 +0200
Johan Hovold <johan@kernel.org> wrote:

> On Wed, Sep 03, 2014 at 10:45:34AM +0200, Boris BREZILLON wrote:
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > ---
> >  .../devicetree/bindings/rtc/atmel,at91sam9-rtc.txt   | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt b/Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt
> > new file mode 100644
> > index 0000000..9ca455f
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt
> > @@ -0,0 +1,20 @@
> > +Atmel AT91SAM9260 Real Time Timer
> > +
> > +Required properties:
> > +- compatible: should be: "atmel,at91sam9260-rtt"
> > +- reg: should contain 2 memory regions
> > +  * the first one encodes the memory region of the RTT controller
> > +  * the second one encodes the GPBR (General Purpose Backup Resgisters)
> > +    memory region used to store the current time
> > +- interrupts: rtc alarm/event interrupt
> > +- clocks: should contain one clock pointing the the slow clk
> > +
> > +Example:
> > +
> > +rtc@fffffe00 {
> > +	compatible = "atmel,at91sam9260-rtt";
> > +	reg = <0xfffffd20 0x10
> > +	       0xfffffd50 0x4>;
> > +	interrupts = <1 4 7>;
> > +	clocks = <&clk32k>;
> > +};
> 
> This does not describe the hardware, but rather a specific software
> configuration.
> 
> The RTT is first of all not an RTC (although it can be used as one in a
> specific software configuration). And the second register resource above
> is not an RTT register, but a general-purpose backup register could be
> used for other purposes (which register to use is currently configurable
> for legacy booting using CONFIG_RTC_DRV_AT91SAM9_GPBR).

We could use a syscon device (which exposes a regmap) for the GPBR
block.

rtc@ffffff20 {
	compatible = "atmel,at91sam9260-rtt";
	reg = <0xfffffd20 0x10>;
	interrupts = <1 4 7>;
	clocks = <&clk32k>;
	atmel,time-reg = <&gpbr 0x0>;
};

gpbr: syscon@fffffd50 {
	compatible = "atmel,at91sam9260-gpbr", "syscon";
	reg = <0xfffffd50 0x10>;
	
};

> 
> This was discussed in the thread where I posted an RFC for this last
> year (which you linked to in your original submission thread), but no
> conclusion was reached:
> 
> 	http://www.spinics.net/lists/arm-kernel/msg236292.html
> 
> Johan



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
