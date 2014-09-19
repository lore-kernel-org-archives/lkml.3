Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbaIST2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:28:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43664 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757747AbaIST2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:28:13 -0400
Date: Fri, 19 Sep 2014 20:27:24 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wenyou Yang <wenyou.yang@atmel.com>
Subject: Re: [PATCH] ARM: at91: sama5: configure L2 cache
Message-ID: <20140919192724.GH26036@leverpostej>
References: <1411072716-20769-1-git-send-email-alexandre.belloni@free-electrons.com>
 <20140918210212.GD5182@n2100.arm.linux.org.uk>
 <20140918212836.GD29620@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918212836.GD29620@piout.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> > There have been DT bindings proposed for prefetch control register.  I
> > suggest that you search this mailing list for that patch, and check
> > whether it is acceptable for your platform.
> > 
> 
> I'm really wondering whether we should really put that in the device
> tree... We will soon end up with a property for each bit of each
> registers and the binding will end up being huge. Also, that is
> configuration, not HW description.

If it's configuration, why is putting it in a board file any better?
The optimal values will depend on the workload, which depends on more
than the just the machine. If anything this kind of tuning might be
better handled using kernel command line parameters.

> I actually tried multiple things, without any satisfaction:
>  - using DT, with the main issue that we will definitely end up with one
>    property per bit of configuration
> 
>  - adding an .l2c_prefetch_val to the machine start but that is kind of
>    ugly.
> 
>  - adding a new parameter to l2x0_of_init()
> 
> So I ended up choosing to do it in the platform code. But if everybody
> is fine with adding more properties to DT, I can go that way.

We can add properties as necessary. The fun part is deciding what is
necessary.

Mark.
