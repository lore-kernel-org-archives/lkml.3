Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab3ARI76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 03:59:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45334 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab3ARI75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 03:59:57 -0500
Message-ID: <1358499533.6252.80.camel@cumari.coelho.fi>
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport
 power functions
From: Luciano Coelho <coelho@ti.com>
To: Tony Lindgren <tony@atomide.com>, "Cousson, Benoit" <b-cousson@ti.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date: Fri, 18 Jan 2013 10:58:53 +0200
In-Reply-To: <20130117231608.GP14149@atomide.com>
References: <1358372702-13102-1-git-send-email-coelho@ti.com>
	 <50F7C4A7.5060202@ti.com> <20130117093417.GH10814@arwen.pp.htv.fi>
	 <50F7CA82.4050509@ti.com> <20130117100510.GI10814@arwen.pp.htv.fi>
	 <20130117100919.GJ10814@arwen.pp.htv.fi>
	 <1358418917.6252.31.camel@cumari.coelho.fi> <50F7D535.6030205@ti.com>
	 <20130117173131.GL14149@atomide.com>
	 <1358445456.6252.64.camel@cumari.coelho.fi>
	 <20130117231608.GP14149@atomide.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 15:16 -0800, Tony Lindgren wrote:
> * Luciano Coelho <coelho@ti.com> [130117 10:04]:
> > But this patch is pretty small and simple, so why not include it to at
> > least fix the breakage in 3.7 and 3.8? Whether you take it or not now
> > won't make any difference in the 5k LOC in these kernel versions.
> 
> Well we are planning to drop the non-DT support for omap4 as soon as it's
> usable with DT. For omap4 we are only carrying SDP and panda support to
> make this transition easier. The only bindings missing AFAIK are wl12xx and
> USB.

In my view this is a regression and it should be fixed with as simple a
patch as possible.  The alternative to my solution is to revert the
patch that removed the enable/disable from the ti-st driver *and* fix
u-boot, because if it doesn't mux the UART2 pins properly (and it
doesn't) the shared transport still won't work.


> If we add this, then it implies we're somehow supporting it, which is not
> the way to go IMHO as we need to get rid of these platform callbacks instead.

It's a regression fix, not a new feature.  I also think these callbacks
are silly, but it's the quickest solution I found for 3.7 and 3.8.


> What's your estimate of having minimal wl12xx WLAN DT binding available?

To tell you the truth, I haven't even started looking into DT for wl12xx
myself.  So I have no idea when it will be ready.  Benoit has been
looking into it, but I don't know how far he is.

--
Luca.

