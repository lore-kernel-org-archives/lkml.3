Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaFNWVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 18:21:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46902 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaFNWVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 18:21:46 -0400
Date: Sun, 15 Jun 2014 00:21:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nishanth Menon <nm@ti.com>
Cc: dbaryshkov@gmail.com, tony@atomide.com, balbi@ti.com,
        linux@arm.linux.org.uk, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH V2 2/2] power: twl4030_charger: attempt to power off in
 case of critical events
Message-ID: <20140614222122.GA1389@xo-6d-61-c0.localdomain>
References: <1401313610-14252-1-git-send-email-nm@ti.com>
 <1401313610-14252-3-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401313610-14252-3-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +	if (irqs2 & TWL4030_ACCHGOV) {
>  		dev_crit(bci->dev, "Ac charger overvoltage\n");
> +		power_off = true;
> +	}
> +
> +	/* Try to shutdown the system */
> +	if (power_off)
> +		orderly_poweroff(true);
>  
>  	return IRQ_HANDLED;
>  }

Userland can make orderly_poweroff take long time, or even forever. (Think disconnected
network with nfsroot).

Should we do something more forceful here? Userland has to handle sudden poweroffs, anyway...

(You could invent new function "give userland 5 seconds to shut system down" if you
really wanted...)

										Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
