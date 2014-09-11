Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaIKKYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:24:10 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38023 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbaIKKYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:24:09 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 11 Sep 2014 12:22:06 +0200
From: Johan Hovold <johan@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Johan Hovold <johan@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
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
Subject: Re: [PATCH v3 0/8] rtc: at91sam9: add DT support
Message-ID: <20140911102206.GA20727@localhost>
References: <1410425767-17874-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140911093942.GA12295@localhost>
 <20140911120659.14daa624@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911120659.14daa624@bbrezillon>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 12:06:59PM +0200, Boris BREZILLON wrote:
> On Thu, 11 Sep 2014 11:39:42 +0200
> Johan Hovold <johan@kernel.org> wrote:
> 
> > On Thu, Sep 11, 2014 at 10:55:59AM +0200, Boris BREZILLON wrote:
> > 
> > > Johan, let me know if this version addresses part of your concerns.
> > 
> > Looks good to me. I just have a few minor comments on two of the patches.
> > 
> > > I'm open to any suggestion/rework to address other previously discussed
> > > issues, as long as it does not end up in a dead-end (like the discussion
> > > you had last year):
> > >  - the fact that the RTT block could be used for something that is not
> > >    an RTC
> > >  - the fact that referencing the GPBR node and defining a GPBR register
> > >    number to store RTC time info could be considered as an HW config and
> > >    not an HW description and thus should not be described in the DT
> > 
> > No doubt.
>
> Okay then. Any suggestion to do otherwise ?

I didn't mean it that way. We've already agreed that modifying the
configuration (use) of the RTT in DT was acceptable for now.

And arguably, for a specific machine, describing that one of the gpbr is
used by the rtt could be considered a hw description of that machine
(comparable to saying that this gpio is used by this i2c controller, or
whatever)?

> Alexandre suggested to pass the GPBR register number through a module
> parameter, and retrieve the GPBR syscon by searching for a gpbr node
> (or atmel,at91sam9260-gpbr compatible node) in the device tree.
> 
> I'm not a big fan of this solution, as it implies passing driver
> specific config to the global cmdline (and we'll have to handle the
> 9263 case where 2 RTT blocks are availables).

I agree with you, and we should really not be adding any more module
parameters.

Also continuing the hw description discussion above, the register
allocation really should be specified in DT if you consider that the
bootloader could one day be able to use it for whatever purpose.

Whether to search for a specific gpbr compatible node is perhaps a
different issue? What would the arguments be to restrict which type of
sysconf register to use (besides the obvious one, that not using a
battery-backed one would be rather pointless)?

Johan
