Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936660Ab3DJIP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:15:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:47338 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936266Ab3DJIPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:15:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,444,1363158000"; 
   d="scan'208";a="320176362"
Message-ID: <51652035.5000802@linux.intel.com>
Date: Wed, 10 Apr 2013 11:17:57 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Walleij <linus.walleij@linaro.org>, grant.likely@secretlab.ca,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio / ACPI: Handle ACPI events in accordance with the
 spec
References: <3043137.BtEKcMiXSu@vostro.rjw.lan> <20130410075319.GN21818@intel.com>
In-Reply-To: <20130410075319.GN21818@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 10:53 AM, Mika Westerberg wrote:
> On Tue, Apr 09, 2013 at 03:57:25PM +0200, Rafael J. Wysocki wrote:
>> +void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
>> +{
>> +	acpi_handle handle;
>> +	acpi_status status;
>> +	struct list_head *evt_pins;
>> +	struct acpi_gpio_evt_pin *evt_pin, *ep;
>> +
>> +	if (!chip->dev || !chip->to_irq)
>> +		return;
>> +
>> +	handle = ACPI_HANDLE(chip->dev);
>> +	if (!handle)
>> +		return;
>> +
>> +	status = acpi_get_data(handle, acpi_gpio_evt_dh, (void **)&evt_pins);
>> +	if (ACPI_FAILURE(status))
>> +		return;
>> +
>> +	list_for_each_entry_safe_reverse(evt_pin, ep, evt_pins, node) {
>> +		devm_free_irq(chip->dev, evt_pin->irq, evt_pin);
>
> How about using normal request/free_irq() functions for both _EVT and
> non-_EVT events? Since we now need to call acpi_gpiochip_free_interrupts()
> anyway, I don't see the point using devm_* functions here.
>

Then we need to create a list of non-_EVT events, or add them to the 
evt_pins list.

