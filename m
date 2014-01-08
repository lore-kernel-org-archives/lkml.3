Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbaAHKP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:15:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:39686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbaAHKPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:15:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,623,1384329600"; 
   d="scan'208";a="463406326"
Date: Wed, 8 Jan 2014 12:22:24 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] gpio / ACPI: register to ACPI events automatically
Message-ID: <20140108102224.GO2494@intel.com>
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
 <1385460350-17543-5-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdZhw5At_X-mNkb3TmQ2n1hXc0FGWYAbkAVgxvzCw=xgtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZhw5At_X-mNkb3TmQ2n1hXc0FGWYAbkAVgxvzCw=xgtw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 06:50:00PM +0100, Linus Walleij wrote:
> On Tue, Nov 26, 2013 at 11:05 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > Instead of asking each driver to register to ACPI events we can just call
> > acpi_gpiochip_register_interrupts() for each chip that has an ACPI handle.
> > The function checks chip->to_irq and if it is set to NULL (a GPIO driver
> > that doesn't do interrupts) the function does nothing.
> >
> > We also add the a new header drivers/gpio/gpiolib.h that is used for
> > functions internal to gpiolib and add ACPI GPIO chip registering functions
> > to that header.
> >
> > Once that is done we can remove call to acpi_gpiochip_register_interrupts()
> > from its only user, pinctrl-baytrail.c
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Two questions:
> 
> - Can you please rebase patches 3-6 on my GPIO tree "devel" branch?

Yes.

> - Can this patch be placed first? It does not seem to depend on the
>   others, to to push dependent patches to the end of the series.

Sure - I'll post a rebased version in a moment.
