Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab3C3XZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 19:25:58 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55322 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab3C3XZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 19:25:57 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 30 Mar 2013 16:25:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Jean Delvare <jdelvare@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: gpio-ucb1400
Message-ID: <20130330232559.GA12864@roeck-us.net>
References: <1364586399.4216.312.camel@amber.site>
 <20130330151037.GA359@roeck-us.net>
 <201303302020.44584.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303302020.44584.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 08:20:44PM +0100, Marek Vasut wrote:
> Dear Guenter Roeck,
> 
> > On Fri, Mar 29, 2013 at 08:46:39PM +0100, Jean Delvare wrote:
> > > Hi all,
> > > 
> > > In September 2009, a driver for the GPIO function of the UCB1400 chip
> > > was added to the kernel tree. The probe function of this driver requires
> > > ucbdata to be set. The only place where this happens is in function
> > > ucb1400_gpio_set_data(). This function was never call, and still isn't.
> > > So this is dead code for 3.5 years as far as the upstream kernel is
> > > concerned.
> > > 
> > > To make things worse, this driver can't be built as a module, for no
> > > good reason that I can see.
> > > 
> > > Marek, can you explain what was the point of submitting this driver that
> > > nobody can use?
> > > 
> > > I would like either this driver to be fixed so that it can be used (and
> > > that would IMHO start with dropping the ugly ucb1400_gpio_set_data hook
> > > and global variable ucbdata), or this driver to be dropped from the
> > > kernel tree. If the driver is kept, it should be adjusted so that it can
> > > be built as a module.
> > > 
> > > If I overlooked something, please let me know.
> > 
> > Interestingly, the author made an attempt to fix that with [1]. It looks
> > like the rest of that series was merged, but this patch wasn't, though I
> > don't find any information about the reason.
> 
> It's been a while. Guenter, thanks for finding that link, but I suspect the 
> patch is heavily obsolete by now.
> 
Oh, it most definitely is, starting with the gpio driver name. Just wonder
why it was never applied, and why no one seems to have noticed or cared.

Jean is absolutely right - it should get fixed, or the driver should be dropped
if no one is using it anyway.

Guenter
