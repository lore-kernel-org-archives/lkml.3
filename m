Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3C3PKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 11:10:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50014 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab3C3PKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 11:10:36 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 30 Mar 2013 08:10:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: gpio-ucb1400
Message-ID: <20130330151037.GA359@roeck-us.net>
References: <1364586399.4216.312.camel@amber.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364586399.4216.312.camel@amber.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 08:46:39PM +0100, Jean Delvare wrote:
> Hi all,
> 
> In September 2009, a driver for the GPIO function of the UCB1400 chip
> was added to the kernel tree. The probe function of this driver requires
> ucbdata to be set. The only place where this happens is in function
> ucb1400_gpio_set_data(). This function was never call, and still isn't.
> So this is dead code for 3.5 years as far as the upstream kernel is
> concerned.
> 
> To make things worse, this driver can't be built as a module, for no
> good reason that I can see.
> 
> Marek, can you explain what was the point of submitting this driver that
> nobody can use?
> 
> I would like either this driver to be fixed so that it can be used (and
> that would IMHO start with dropping the ugly ucb1400_gpio_set_data hook
> and global variable ucbdata), or this driver to be dropped from the
> kernel tree. If the driver is kept, it should be adjusted so that it can
> be built as a module.
> 
> If I overlooked something, please let me know.
> 
Interestingly, the author made an attempt to fix that with [1]. It looks like
the rest of that series was merged, but this patch wasn't, though I don't find
any information about the reason.

Guenter

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2010-October/028656.html
