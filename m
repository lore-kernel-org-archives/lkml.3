Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab3CETk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:40:27 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:35809 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3CETk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:40:26 -0500
Date: Tue, 5 Mar 2013 20:40:15 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] gpio-ich: Check for pin availability at request
 time
Message-ID: <20130305204015.36639af6@endymion.delvare>
In-Reply-To: <1362507414.28106.62.camel@petert>
References: <20130305090620.2c9f1ff5@endymion.delvare>
	<1362507414.28106.62.camel@petert>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, 05 Mar 2013 12:16:54 -0600, Peter Tyser wrote:
> On Tue, 2013-03-05 at 09:06 +0100, Jean Delvare wrote:
> > Stop checking for pin availability in get functions. These functions
> > can be called repeatedly, so checking every time is bad for
> > performance.
> > 
> > Instead, check at pin request time. This only happens once, and we can
> > let the caller know of the unavailability much earlier.
> 
> Is there a reason to not remove the ichx_gpio_check_available() calls
> from the ichx_gpio_direction_output() and ichx_gpio_direction_input()
> functions in this change?

No valid reason other than me being a chicken ;)

I seemed to remember that requesting GPIOs was optional so I didn't
want to remove too many checks. However...

> I had originally assumed these checks were to support the "legacy"
> interface where users could use the GPIOs without first requesting the
> GPIO, but after looking a bit further it looks like the gpiolib code to
> set a GPIO as an input or output does auto-request the GPIO before
> setting its direction.  So I'd assume your 1 check in 
> ichx_gpio_request() would cover the "legacy" interface too.

... you are implying that this memory of mine refers to ancient times
and this is no longer true. Apparently the change happened in April
2009, not sure how I managed to miss that for so long.

Given that, I completely agree that the check can go away from
ichx_gpio_direction_output() and ichx_gpio_direction_input() as well.
The performance gain won't be as important as for ichx_gpio_get*() but
it's free so let's take it.

Thanks a lot for the review, I'll send v2 of this patch.

-- 
Jean Delvare
