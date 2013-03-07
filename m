Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab3CGGb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:31:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:58046 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab3CGGb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:31:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,800,1355126400"; 
   d="scan'208";a="296531440"
Date: Thu, 7 Mar 2013 08:35:41 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Peter Tyser <ptyser@xes-inc.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] gpio: gpio-ich: fix ichx_gpio_check_available() return
 what callers expect
Message-ID: <20130307063541.GS31790@intel.com>
References: <1361978715-14948-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdb21s+XDc+Ad0RBDT+KQ2C7CbK-rPO3GwEU4mOzpjj+TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb21s+XDc+Ad0RBDT+KQ2C7CbK-rPO3GwEU4mOzpjj+TQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 04:23:56AM +0100, Linus Walleij wrote:
> Hi Mika,
> 
> On Wed, Feb 27, 2013 at 4:25 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > -static int ichx_gpio_check_available(struct gpio_chip *gpio, unsigned nr)
> > +static bool ichx_gpio_check_available(struct gpio_chip *gpio, unsigned nr)
> >  {
> > -       return (ichx_priv.use_gpio & (1 << (nr / 32))) ? 0 : -ENXIO;
> > +       return ichx_priv.use_gpio & (1 << (nr / 32));
> >  }
> 
> Strictly speaking what you're returning there is not a bool.
> Shouldn't it be:
> 
> return !!(ichx_priv.use_gpio & (1 << (nr / 32)));
> 
> ?

A C reference manual says something like: When converting any scalar value
to type _Bool, all nonzero values are converted to 1, while zero values are
converted to 0 (1 being canonical value for true).

However, I'm happy to send a patch changing this if you like so (Grant
applied the patch already).
