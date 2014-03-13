Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaCMUs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:48:59 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:33598 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755139AbaCMUs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:48:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19WGGIWNDfC4/31haJiJGnh
Date: Thu, 13 Mar 2014 13:48:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@TI.com>
Cc: Rob Herring <robh@kernel.org>, Tero Kristo <t-kristo@TI.com>,
        Nishanth Menon <nm@TI.com>, Suman Anna <s-anna@TI.com>,
        Felipe Balbi <balbi@TI.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 4/5] clocksource: omap-timer: Introduce clocksource driver
 for OMAP SoCs
Message-ID: <20140313204851.GB23432@atomide.com>
References: <1394742919-32163-1-git-send-email-joelf@ti.com>
 <1394742919-32163-5-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394742919-32163-5-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@TI.com> [140313 13:43]:
> We introduce functions to initialize clocksource and clockevent, use
> CLOCKSOURCE_OF_DECLARE to declare the clocksource, and handle the clocksource
> selection on a per-SoC basis (Currently only AM335x is supported). Powering up
> of the timer will be done with the help of the mach-omap layer function that's
> introduced earlier in the series.
> 
> We make a local copy of dmtimer API for use by clocksource, the original
> dmtimer API in plat-omap is kept as-is till the migration of all SoCs is
> completed after which it can't be deleted.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  drivers/clocksource/Makefile     |    1 +
>  drivers/clocksource/omap-timer.c | 1157 ++++++++++++++++++++++++++++++++++++++
>  drivers/clocksource/omap-timer.h |  422 ++++++++++++++
>  3 files changed, 1580 insertions(+)
>  create mode 100644 drivers/clocksource/omap-timer.c
>  create mode 100644 drivers/clocksource/omap-timer.h

Hmm this leaves duplicate arch/arm/plat-omap/dmtimer.c code, please
sort out that issue too by allowing omap1 and omap3 still to use
the legacy timer init functions but with timer code under
drivers/clocksource/omap-timer.c.

And not the that drivers/clocksource/omap-timer.h won't be needed at
all, those defines can stay private to the drivers/clocksource/omap-timer.c.

So this patch really should just be moving of the code to the new
location.

Regards,

Tony
