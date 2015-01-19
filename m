Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbbASLyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:54:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:1971 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbbASLyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:54:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442235860"
Date: Mon, 19 Jan 2015 13:53:55 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] gpio: support for GPIO forwarding
Message-ID: <20150119115355.GA21244@kuha.fi.intel.com>
References: <1418890998-23811-1-git-send-email-heikki.krogerus@linux.intel.com>
 <CACRpkdY-yFKsYbCrMpnViMFoQEugyGQivaV0M+GDzLrbDO7i6Q@mail.gmail.com>
 <CAAVeFuJUxad0dJ9vK1DaDJPDLM+rc5b77=PgcJT5+Bv1=iWGxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFuJUxad0dJ9vK1DaDJPDLM+rc5b77=PgcJT5+Bv1=iWGxg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 02:59:54PM +0900, Alexandre Courbot wrote:
> I am not really fond of this idea since it adds complexity to the
> (already too complex) GPIO lookup, and only solves to a local level
> (GPIO) what is a more global problem (bad ACPI tables that can affect
> any subsystem).
> 
> Also I don't think any new functions is actually needed: on an ACPI
> system we can safely assume that the platform lookup tables are not
> used at all. So, although it is a hack as well, you can just call
> gpiod_add_lookup_table() with a runtime-built table from the driver
> that needs to pass the GPIO so the receipient can receive it through
> the lookup table fallback gpiod_get() uses if no GPIO is defined via
> ACPI.

Unfortunately that would require us to determine details about the
gpios in the consumer driver, details like the chip_label, chip_hwnum
and flags. Stuff that I don't think the consumers should touch.

In order to dig those out of the gpio description, the driver would
either need to include linux/gpio/machine.h, linux/gpio/driver.h and
linux/gpio/consumer.h or we would need to add helper functions to
gpiolib.c that do the digging for us. Most likely it would not be
possible to avoid the helpers. We would in any case have to add
removal function for the lookups and gpiod_add_lookup_table would need
to be exported.

It simply ended up being less of a hack to add the simple function
explicitly for consumers to be used in a case like this for creating
the lookups.

Br,

-- 
heikki
