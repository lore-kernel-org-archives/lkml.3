Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab3FNMKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:10:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:20774 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab3FNMKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:10:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,866,1363158000"; 
   d="scan'208";a="349828086"
Message-ID: <51BB090F.5060002@linux.intel.com>
Date: Fri, 14 Jun 2013 15:14:07 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/1] gpio driver for Intel Baytrail platforms
References: <1371135983-12592-1-git-send-email-mathias.nyman@linux.intel.com> <CACRpkdbuGeciwhh=FC=ekZ4di11rdPve7g79aG5wNvJAbAxx1g@mail.gmail.com>
In-Reply-To: <CACRpkdbuGeciwhh=FC=ekZ4di11rdPve7g79aG5wNvJAbAxx1g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 06:45 PM, Linus Walleij wrote:
> On Thu, Jun 13, 2013 at 5:06 PM, Mathias Nyman
> <mathias.nyman@linux.intel.com>  wrote:
>
>> After looking at the pinctrl subsystem that Linus W. suggested I think
>> pinctrl suits platforms that don't have firmware configuring the pins
>> before the operating system is started, or when pins need to be configured
>> on the fly.
>>
>> I'd still keep this driver under GPIO. Adding it to pinctrl
>> feels like adding more complexity without any bigger use for the features.
>>
>> We expect BIOS to set all pin configurations correctly.
>> The comments about pin muxing capabilities are removed from the driver.
>> The same firmware is anyway listing gpio resources in ACPI tables, so pin
>> configurations should be correct. (The previous indication in the driver
>> about the need to configure pins was mostly because we're working with early
>> develpment stage firmwares which still have small hickups)
>
> This does not address the issue that you're reimplementing
> the GPIO ranges from the pinctrl subsystem, and just hours ago
> on the mailing list Christian Ruppert sent a patch making these
> more flexible I think.
>
> Subject "Add pin-list based GPIO ranges", please check this
> patch, isn't that exactly the helper infrastructure you need?

It fits better yes, with that patch I could use
struct pinctrl_gpio_range instead of the custom struct gpio_bank.
The .name entry can be used for acpi_id to identify the range.

Also the gpio_to_pad() function is usable.

>
> Of course you can make an argument that is is a good idea to
> duplicate this, but I want that to be explicit. To me it is still
> quite obvious that these gpio to pad mappings are laid out
> according to the actual hardware registers, and that the actual
> hardware registers pertain to pads rather than what we call
> "GPIOs", which in kernel terms are only some line.
>

That is true, it's about mapping between layout of hw registers.
I guess it's a tradeoff between more

> I would still vote to put the thing in drivers/pinctrl anyway,
> I am perfectly happy to house pure GPIO drivers there,
> especially if they're obviously masking something more
> pinctrl-like in reality, it will be way more flexible the day that
> you just want to add "this one little quirk for this pin config
> thing", then it'll fit just fine.
>

I'm fine with having it under drivers/pinctrl as a GPIO driver, either 
just as it is, or by using the pinctrl_gpio_range structure and helper 
functions such as gpio_to_pad(), once Christian Rupperts patch is accepted.

any naming preference?
gpio-baytrail.c
pinctrl-gpio-baytrail.c
pinctrl-baytrail.c

-Mathias
