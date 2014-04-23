Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaDWLes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:34:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:49780 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbaDWLer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:34:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,911,1389772800"; 
   d="scan'208";a="526066001"
Message-ID: <5357A80B.8030701@linux.intel.com>
Date: Wed, 23 Apr 2014 14:46:19 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Timur Tabi <timur@codeaurora.org>
CC: Linus <linus.walleij@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com>	<1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com> <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com> <534B93BA.6020406@linux.intel.com> <534BFAAF.3070805@codeaurora.org> <534D0370.50108@linux.intel.com> <535005BA.1040405@codeaurora.org>
In-Reply-To: <535005BA.1040405@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 07:47 PM, Timur Tabi wrote:
> On 04/15/2014 05:01 AM, Mathias Nyman wrote:
>>>
>>> This device will only be used on an ACPI system, right?  And isn't ACPI
>>> supposed to hide all the pinctrl programming from the OS?  I thought
>>> that was the whole point behind ACPI and the reason why ARM64 isn't
>>> going to use device trees.
>>>
>>
>> This was my starting point as well, and the driver was initially
>> submitted as a GPIO driver. But Linus W. suggested pinctrl instead, and
>> as he's the maintainer of both those subsystem I trust his judgment.
>
> Do you think, for an ACPI pinctrl driver, that we will need to specify
> any function groups?  When I look at the ASL that configures GPIOs, I
> see only lines like this:
>
> GpioIo (Exclusive, PullDefault, , , , "\\GIO0") {0x1D, 0x1E}
>
> This tells me that ACPI will never use any of the names that are
> defined.  I see that .get_function_name is called on my ACPI system, but
> I don't see where it is used.
>
> The reason I ask is because I would like to make a "generic" ACPI
> pinctrl/gpio driver that doesn't specify any pin groups.  So if we use
> the same pinctrl/gpio hardware on multiple SOCs, the only thing that the
> driver needs from ACPI is the number of pins.
>

Mika, Rafael (and me) have done some effort already on supporting ACPI 
gpio resources.

ACPI code creates a platfrom device out of the GPIO device defined ACPI 
tables, with all the resources set, and a hook back to the ACPI node.

Helper functions to translate the ACPI GpioIO and GpioInt resources to 
linux gpio numbers can be found in gpio/gpiolib-acpi.c together with 
other ACPI and gpio related helper functions.

see also
Documentation/acpi/enumeration.txt for some GPIO and ACPI related info

-Mathias

