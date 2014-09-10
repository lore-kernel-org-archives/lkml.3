Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaIJPJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:09:03 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:59978 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaIJPJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:09:01 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 10 Sep 2014 17:07:02 +0200
From: Johan Hovold <johan@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Johan Hovold <johan@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
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
Message-ID: <20140910150702.GK2974@localhost>
References: <1409733934-14465-1-git-send-email-boris.brezillon@free-electrons.com>
 <1409733934-14465-6-git-send-email-boris.brezillon@free-electrons.com>
 <20140910121424.GG2974@localhost>
 <20140910152019.111c4c01@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910152019.111c4c01@bbrezillon>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 03:20:19PM +0200, Boris BREZILLON wrote:
> On Wed, 10 Sep 2014 14:14:24 +0200
> Johan Hovold <johan@kernel.org> wrote:

> > This does not describe the hardware, but rather a specific software
> > configuration.
> > 
> > The RTT is first of all not an RTC (although it can be used as one in a
> > specific software configuration). And the second register resource above
> > is not an RTT register, but a general-purpose backup register could be
> > used for other purposes (which register to use is currently configurable
> > for legacy booting using CONFIG_RTC_DRV_AT91SAM9_GPBR).
> 
> We could use a syscon device (which exposes a regmap) for the GPBR
> block.
> 
> rtc@ffffff20 {

rtt

> 	compatible = "atmel,at91sam9260-rtt";
> 	reg = <0xfffffd20 0x10>;
> 	interrupts = <1 4 7>;
> 	clocks = <&clk32k>;
> 	atmel,time-reg = <&gpbr 0x0>;
> };
> 
> gpbr: syscon@fffffd50 {
> 	compatible = "atmel,at91sam9260-gpbr", "syscon";
> 	reg = <0xfffffd50 0x10>;
> 	
> };

Yes, this essentially what I suggested in the thread (and my last reply)
and relying on syscon rather than a custom driver seems like a good
idea. It would allow early access to the registers too with the recently
proposed changes. It would not guarantee any kind of exclusivity,
though, but I guess that's tolerable?

Johan
