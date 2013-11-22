Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3KVKuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 05:50:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:38455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab3KVKuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 05:50:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,751,1378882800"; 
   d="scan'208";a="439793573"
Date: Fri, 22 Nov 2013 12:50:16 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>, linux-gpio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] net: rfkill: gpio: convert to descriptor-based GPIO
 interface
Message-ID: <20131122105016.GA8670@xps8300>
References: <1385045153-25160-1-git-send-email-mika.westerberg@linux.intel.com>
 <1385045153-25160-2-git-send-email-mika.westerberg@linux.intel.com>
 <CAHp75VeEEWCVXz4X1qazfVKZBDBgP6NPfPnuS-b7qEiT4m7f=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeEEWCVXz4X1qazfVKZBDBgP6NPfPnuS-b7qEiT4m7f=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Thu, Nov 21, 2013 at 05:32:28PM +0200, Andy Shevchenko wrote:
> > +       /* Make sure at-least one of the GPIO is defined and that
> > +        * a name is specified for this instance
> > +        */
> > +       if ((!rfkill->reset_gpio && !rfkill->shutdown_gpio) || !rfkill->name) {
> > +               pr_warn("%s: invalid platform data\n", __func__);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (pdata && pdata->gpio_runtime_setup) {
> > +               ret = pdata->gpio_runtime_setup(pdev);
> >                 if (ret) {
> > -                       pr_warn("%s: failed to get shutdown gpio.\n", __func__);
> > +                       pr_warn("%s: can't set up gpio\n", __func__);
> 
> Could you use dev_* family of functions to print messages?

OK, I'll change them. Thanks!

-- 
heikki
