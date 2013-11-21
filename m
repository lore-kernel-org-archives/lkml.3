Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3KUQ3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:29:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:5783 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3KUQ3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:29:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,745,1378882800"; 
   d="scan'208";a="437425736"
Message-ID: <1385051340.1871.2.camel@smile>
Subject: Re: [PATCH v2 2/3] gpiolib: append SFI helpers for GPIO API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        "linux-gpio @ vger . kernel . org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Len Brown <len.brown@intel.com>
Date: Thu, 21 Nov 2013 18:29:00 +0200
In-Reply-To: <20131121104006.GB2281@intel.com>
References: <1384957896-3477-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1384957896-3477-3-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20131121104006.GB2281@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-21 at 12:40 +0200, Mika Westerberg wrote:
> On Wed, Nov 20, 2013 at 04:31:35PM +0200, Andy Shevchenko wrote:
> > diff --git a/include/linux/gpio/sfi.h b/include/linux/gpio/sfi.h
> > new file mode 100644
> > index 0000000..3e111ad
> > --- /dev/null
> > +++ b/include/linux/gpio/sfi.h
> > @@ -0,0 +1,37 @@
> > +#ifndef _LINUX_SFI_GPIO_H_
> > +#define _LINUX_SFI_GPIO_H_
> > +
> > +#include <linux/err.h>
> > +#include <linux/errno.h>
> > +#include <linux/gpio/consumer.h>
> > +#include <linux/sfi.h>
> > +
> > +#ifdef CONFIG_GPIO_SFI
> > +
> > +struct gpio_desc *sfi_get_gpiod_by_name(const char *name);
> 
> I'm wondering should this function be exported at all? What the drivers
> should be using is gpiod_get_xxx() APIs and not DT/ACPI/SFI specific
> interfaces.

I won't mix this with generic stuff since we have really few users of
SFI and there should be no new users at all.

> Yeah, we have the same in ACPI version but I'm planning to get rid of it
> completely.

I'm okay to move to this direction, if Linus and others are okay with
it.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

