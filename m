Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaIKJ4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:56:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44045 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753718AbaIKJ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:56:32 -0400
Date: Thu, 11 Sep 2014 11:56:28 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Johan Hovold <johan@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Johan Hovold <jhovold@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v3 8/8] rtc: at91sam9: add DT bindings documentation
Message-ID: <20140911115628.110a403b@bbrezillon>
In-Reply-To: <20140911094213.GC12295@localhost>
References: <1410425767-17874-1-git-send-email-boris.brezillon@free-electrons.com>
	<1410425767-17874-9-git-send-email-boris.brezillon@free-electrons.com>
	<20140911094213.GC12295@localhost>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014 11:42:13 +0200
Johan Hovold <johan@kernel.org> wrote:

> On Thu, Sep 11, 2014 at 10:56:07AM +0200, Boris BREZILLON wrote:
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > ---
> >  .../devicetree/bindings/rtc/atmel,at91sam9-rtc.txt | 24 ++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt b/Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt
> > new file mode 100644
> > index 0000000..258a036
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt
> > @@ -0,0 +1,24 @@
> > +Atmel AT91SAM9260 Real Time Timer
> > +
> > +Required properties:
> > +- compatible: should be: "atmel,at91sam9260-rtt"
> > +- reg: should encode the memory region of the RTT controller
> > +- interrupts: rtc alarm/event interrupt
> > +- clocks: should contain one clock pointing the the slow clk
> > +- atmel,time-reg: should encode the GPBR register used to store the RTC
> > +		  time. The first cell should point to the GPBR node and
> > +		  the second one encode the offset within the GPBR block
> > +		  (or in other terms, the GPBR register used to store the
> > +		  current time value).
> > +
> > +
> > +
> > +Example:
> > +
> > +rtc@fffffe00 {
> 
> This should be rtt@
> 
> > +	compatible = "atmel,at91sam9260-rtt";
> > +	reg = <0xfffffd20 0x10>;
> > +	interrupts = <1 4 7>;
> > +	clocks = <&clk32k>;
> > +	atmel,time-reg = <&gpbr 0x0>;
> 
> I think the property name could be more descriptive as it is specific to
> when the RTT is used as an RTC. Perhaps, atmel,rtt-rtc-time-reg?

No problem, I'll change both names for the next version.


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
