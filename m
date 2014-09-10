Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaIJPyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:54:40 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:39295 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaIJPyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:54:38 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 10 Sep 2014 17:52:36 +0200
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
Message-ID: <20140910155236.GL2974@localhost>
References: <1409733934-14465-1-git-send-email-boris.brezillon@free-electrons.com>
 <1409733934-14465-6-git-send-email-boris.brezillon@free-electrons.com>
 <20140910121424.GG2974@localhost>
 <20140910152019.111c4c01@bbrezillon>
 <20140910150702.GK2974@localhost>
 <20140910173114.593dd132@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910173114.593dd132@bbrezillon>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 05:31:14PM +0200, Boris BREZILLON wrote:
> On Wed, 10 Sep 2014 17:07:02 +0200
> Johan Hovold <johan@kernel.org> wrote:

> > Yes, this essentially what I suggested in the thread (and my last reply)
> > and relying on syscon rather than a custom driver seems like a good
> > idea. It would allow early access to the registers too with the recently
> > proposed changes. It would not guarantee any kind of exclusivity,
> > though, but I guess that's tolerable?
> 
> Yep, that's one of the concern I had with the syscon/regmap
> approach :-(, but I guess I'll give this solution a try and post a new
> version of this series ;-).

Perhaps we should see what Nicolas and Jean-Christophe says before
rushing into anything (again). ;)

I remember J-C considered loosing track of what was using a particular
backup register to be a regression. But I guess you can't have it both
ways (e.g. if you also want the early access soon provided by syscon).

I'll refresh my rtt and gmbr-node patches meanwhile, as they should be
needed in some form at least.

> Can we just leave the rtt as an rtc problem on the side for now and bind
> it to the rtc-at91sam9 driver.
> 
> If we ever decide to add a new driver using the RTT for another purpose
> we will still be able to reference the RTT block like this (and keep
> the existing rtt node definition):
> 
> rtt-based-rtc {
> 	compatible = "atmel,rtt-rtc";
> 	atmel,rtt = <&rtt>;
> 	atmel,time-reg = <&gpbr 0x0>;
> }

But why not do this from the start?

> rtt-based-xdev {
> 	compatible = "atmel,rtt-xdev";
> 	atmel,rtt = <&rtt>;
> 	/*...*/
> }

Johan
