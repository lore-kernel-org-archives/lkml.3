Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab3FGVBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 17:01:36 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:42128 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab3FGVBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 17:01:34 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX185zyQbloRejqKh4SbU/Zp9
Date: Fri, 7 Jun 2013 14:01:30 -0700
From: Tony Lindgren <tony@atomide.com>
To: Balaji T K <balajitk@ti.com>
Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>, khilman@linaro.org,
        linus.walleij@linaro.org, sudhakar.raj@ti.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaibhav.bedia@ti.com, linux-omap@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/11] mmc: omap_hsmmc: enhance pinctrl support
Message-ID: <20130607210129.GH3331@atomide.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
 <1369995191-20855-10-git-send-email-gururaja.hebbar@ti.com>
 <20130604144632.GI3331@atomide.com>
 <51B1E1C7.7050407@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B1E1C7.7050407@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balaji T K <balajitk@ti.com> [130607 06:42]:
> On Tuesday 04 June 2013 08:16 PM, Tony Lindgren wrote:
> >* Hebbar Gururaja <gururaja.hebbar@ti.com> [130531 03:19]:
> >>Amend the hsmmc controller to optionally take a pin control handle and
> >>set the state of the pins to:
> >>
> >>- "default" on boot, resume and before performing a mmc transfer
> >>- "idle" after initial default, after resume default, and after each
> >>mmc/sd card access
> >>- "sleep" on suspend()
> >>
> >>By optionally putting the pins into sleep state in the suspend callback
> >>we can accomplish two things.
> >>- One is to minimize current leakage from pins and thus save power,
> >>- second, we can prevent the IP from driving pins output in an
> >>uncontrolled manner, which may happen if the power domain drops the
> >>domain regulator.
> >>
> >>If any of the above pin states are missing in dt, a warning message
> >>about the missing state is displayed.
> >>If certain pin-states are not available, to remove this warning message
> >>pass respective state name with null phandler.
> >
> >There's a similar patch in the "[RESEND PATCH v2 1/3] mmc: omap_hsmmc:
> >Enable SDIO IRQ using a GPIO in idle mode" thread. It also makes the
> >SDIO interrupts to work, so we need to consider that too.
> >
> 
> Hi Tony,
> 
> I will try to combine both of these and make use of
> pinctrl_pm_select_[*]_state helper functions.

OK thanks, I'll separate out the pinctrl parts from Andreas' patch
and repost.

Regards,

Tony
