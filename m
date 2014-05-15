Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbaEOVr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:47:58 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50745 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaEOVr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:47:56 -0400
Date: Thu, 15 May 2014 14:47:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/6] watchdog: Add API to trigger reboots
Message-ID: <20140515214743.GA15577@roeck-us.net>
References: <1400186304-1691-1-git-send-email-linux@roeck-us.net>
 <1400186304-1691-2-git-send-email-linux@roeck-us.net>
 <20140515215020.38f03ab1@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515215020.38f03ab1@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 09:50:20PM +0100, One Thousand Gnomes wrote:
> > +void watchdog_do_reboot(void)
> > +{
> > +	if (wdd_reboot_dev)
> > +		wdd_reboot_dev->ops->reboot(wdd_reboot_dev);
> > +}
> > +EXPORT_SYMBOL(watchdog_do_reboot);
> 
> Crashes and burns if you are unloading a watchdog just as you try to
> reboot. Yes its wildly unlikely but it's still conceptually wrong.
> 
Possibly, but how is it different to the code it replaces ?

> >  
> > +	if (wdd->ops->reboot)
> > +		wdd_reboot_dev = wdd;
> > +
> 
> Two parallel registers from different bus types, parallel
> register/unregister ?
> 
Sorry, you lost me. What different bus types ?

> This feels to me like a backward step. We've gone from various device
> bits leaking into the core code (where they can work all the time) to
> various core code leaking into the devices which is asking for init order
> problems and other races.
> 
> Given we are talking about stuff of the order of 10-20 instructions I
> think duplication is not only the lesser evil it's also smaller, more
> reliable and easier to maintain.
> 
> IMHO this is a solution looking for a problem.
> 
Really ?  To me it seems to be much cleaner than setting the pointer to
arm_pm_restart directly from individual watchdog drivers. Also, and I was
told that other HW may benefit from it as well.

Do I understand it correctly that you prefer watchdog drivers to set
arm_pm_restart directly ? Maybe you can explain a bit why you believe
that to be a superior solution.

In addition to that, while I could obviously add some locking around access to
wdd_reboot_dev, existing code doesn't lock any changes to arm_pm_restart. I am
somewhat at loss why setting or clearing arm_pm_restart is less of a problem
that setting wdd_reboot_dev.

Thanks,
Guenter
