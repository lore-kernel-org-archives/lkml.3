Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab3CESR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:17:59 -0500
Received: from xes-mad.com ([216.165.139.218]:34354 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757118Ab3CESRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:17:55 -0500
Message-ID: <1362507414.28106.62.camel@petert>
Subject: Re: [PATCH 1/2] gpio-ich: Check for pin availability at request time
From: Peter Tyser <ptyser@xes-inc.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 05 Mar 2013 12:16:54 -0600
In-Reply-To: <20130305090620.2c9f1ff5@endymion.delvare>
References: <20130305090620.2c9f1ff5@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Tue, 2013-03-05 at 09:06 +0100, Jean Delvare wrote:
> Stop checking for pin availability in get functions. These functions
> can be called repeatedly, so checking every time is bad for
> performance.
> 
> Instead, check at pin request time. This only happens once, and we can
> let the caller know of the unavailability much earlier.

Is there a reason to not remove the ichx_gpio_check_available() calls
from the ichx_gpio_direction_output() and ichx_gpio_direction_input()
functions in this change?

I had originally assumed these checks were to support the "legacy"
interface where users could use the GPIOs without first requesting the
GPIO, but after looking a bit further it looks like the gpiolib code to
set a GPIO as an input or output does auto-request the GPIO before
setting its direction.  So I'd assume your 1 check in 
ichx_gpio_request() would cover the "legacy" interface too.

Best,
Peter


