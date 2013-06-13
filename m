Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab3FMPpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:45:52 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49123 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab3FMPpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:45:51 -0400
MIME-Version: 1.0
In-Reply-To: <1371135983-12592-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1371135983-12592-1-git-send-email-mathias.nyman@linux.intel.com>
Date: Thu, 13 Jun 2013 17:45:50 +0200
Message-ID: <CACRpkdbuGeciwhh=FC=ekZ4di11rdPve7g79aG5wNvJAbAxx1g@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] gpio driver for Intel Baytrail platforms
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 5:06 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> After looking at the pinctrl subsystem that Linus W. suggested I think
> pinctrl suits platforms that don't have firmware configuring the pins
> before the operating system is started, or when pins need to be configured
> on the fly.
>
> I'd still keep this driver under GPIO. Adding it to pinctrl
> feels like adding more complexity without any bigger use for the features.
>
> We expect BIOS to set all pin configurations correctly.
> The comments about pin muxing capabilities are removed from the driver.
> The same firmware is anyway listing gpio resources in ACPI tables, so pin
> configurations should be correct. (The previous indication in the driver
> about the need to configure pins was mostly because we're working with early
> develpment stage firmwares which still have small hickups)

This does not address the issue that you're reimplementing
the GPIO ranges from the pinctrl subsystem, and just hours ago
on the mailing list Christian Ruppert sent a patch making these
more flexible I think.

Subject "Add pin-list based GPIO ranges", please check this
patch, isn't that exactly the helper infrastructure you need?

Of course you can make an argument that is is a good idea to
duplicate this, but I want that to be explicit. To me it is still
quite obvious that these gpio to pad mappings are laid out
according to the actual hardware registers, and that the actual
hardware registers pertain to pads rather than what we call
"GPIOs", which in kernel terms are only some line.

I would still vote to put the thing in drivers/pinctrl anyway,
I am perfectly happy to house pure GPIO drivers there,
especially if they're obviously masking something more
pinctrl-like in reality, it will be way more flexible the day that
you just want to add "this one little quirk for this pin config
thing", then it'll fit just fine.

Yours,
Linus Walleij
