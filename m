Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3IWRHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:07:41 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55176 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3IWRHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:07:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18hClar6nYfsaXaXWNAuHFY
Date: Mon, 23 Sep 2013 10:07:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Jon Hunter <jgchunter@gmail.com>,
        linux-gpio@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] gpio/omap: auto-setup a GPIO when used as an IRQ
Message-ID: <20130923170724.GG2684@atomide.com>
References: <1379860848-29020-1-git-send-email-javier.martinez@collabora.co.uk>
 <20130923164519.GF2684@atomide.com>
 <524073BC.9080907@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524073BC.9080907@collabora.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Javier Martinez Canillas <javier.martinez@collabora.co.uk> [130923 10:09]:
> On 09/23/2013 06:45 PM, Tony Lindgren wrote:
> > 
> > Hmm does this still work for legacy platform data based
> > drivers that are doing gpio_request() first?
> > 
> 
> Yes it still work when booting using board files. I tested on my OMAP3 board and
> it worked in both DT and legacy booting mode.

OK great.
 
> > And what's the path for clearing things for PM when free_irq()
> > gets called? It seems that this would leave the GPIO bank
> > enabled causing a PM regression?
> > 
> 
> Indeed, I did set bank->mod_usage |= 1 << offset so the bank is enabled if the
> device goes to suspended and then resumed but I completely forget about the
> clearing path when the IRQ is freed.
> 
> Which makes me think that we should probably maintain two usage variables, one
> for GPIO and another one for IRQ and check both of them on the suspend/resume pm
> functions.

Yes that it seems that they should be treated separately.

Regards,

Tony
