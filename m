Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964871Ab3DIQk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:40:57 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54822 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936277Ab3DIQkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:40:55 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 9 Apr 2013 09:41:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kevin Strasser <kevin.strasser@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Brunner <michael.brunner@kontron.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>, Michael Brunner <mibru@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/4] gpio: Kontron PLD gpio driver
Message-ID: <20130409164101.GA20001@roeck-us.net>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1365441321-21952-3-git-send-email-kevin.strasser@linux.intel.com>
 <CACRpkdYrGK_SPbiRssFUrg2vMvWbYO_iXsy+aZr99tyFtk88Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYrGK_SPbiRssFUrg2vMvWbYO_iXsy+aZr99tyFtk88Uw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 10:46:15AM +0200, Linus Walleij wrote:
> On Mon, Apr 8, 2013 at 7:15 PM, Kevin Strasser
> <kevin.strasser@linux.intel.com> wrote:
> 
> > From: Michael Brunner <michael.brunner@kontron.com>
> >
> > Add gpio support for the on-board PLD found on some Kontron embedded
> > modules.
> >
> > Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> > Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
> 
> This looks very generic, setting and clearing bits in bytesized
> registers.
> 
> Can you please attempt to use generic GPIO for this?
> 
Linus,

I looked into it, but for my part I seem to be missing how the generic GPIO code
permits locking access to the hardware (PLD) and setting the PLD's page register.
In other words, I don't immediately see how to call kempld_get_mutex_set_index()
from the generic GPIO code. The other drivers using generic GPIO code don't
seem to have that requirement.

Thanks,
Guenter

> drivers/gpio/gpio-generic.c
> <linux/basic_mmio_gpio.h>
> 
> See for example:
> gpio-ep93xx.c, gpio-sodaville.c ...
> 
> Since you don't even have IRQ support in this it will be even simpler.
> 
> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
