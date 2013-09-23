Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3IWKmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:42:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:37755 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab3IWKmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:42:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,961,1371106800"; 
   d="scan'208";a="382156856"
Date: Mon, 23 Sep 2013 13:48:09 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/2] gpio / ACPI: add support for GPIO operation regions
Message-ID: <20130923104809.GC28875@intel.com>
References: <1379085280-2211-1-git-send-email-mika.westerberg@linux.intel.com>
 <1379085280-2211-2-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdb5fqMycTxou50-+oiNOs3vzd+8XfWsPbX8vBJp2Su3aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb5fqMycTxou50-+oiNOs3vzd+8XfWsPbX8vBJp2Su3aw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 09:21:37PM +0200, Linus Walleij wrote:
> On Fri, Sep 13, 2013 at 5:14 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> (...)
> > +struct acpi_gpio_chip_data {
> > +       /*
> > +        * acpi_install_address_space_handler() wants to put the connection
> > +        * information at the start of the context structure we pass it, in
> > +        * case we are dealing with GPIO operation regions.
> > +        */
> > +       struct acpi_connection_info ci;
> > +       struct gpio_chip *chip;
> > +       struct list_head *evt_pins;
> > +};
> 
> Consider just naming this acpi_gpio_chip, as it is obviously some
> generic container that you will keep adding to.

Sure.

> I'm uncertain how things work, it wouldn't add something to have
> struct gpio_chip be a true member (not a pointer) so you can
> allocate one thing from the drivers, and e.g. use container_of()
> to get from the gpio_chip to the acpi_gpio_chip[_data]?

The drivers are just normal platform drivers (for example gpio-lynxpoint.c)
and they shouldn't care if they got enumerated from ACPI. Allocating
acpi_gpio_chip from a driver would make it depend on ACPI, if I'm
understanding correctly.
