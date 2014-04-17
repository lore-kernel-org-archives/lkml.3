Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaDQQsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:48:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50744 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaDQQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:47:56 -0400
Message-ID: <535005BA.1040405@codeaurora.org>
Date: Thu, 17 Apr 2014 11:47:54 -0500
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mathias Nyman <mathias.nyman@linux.intel.com>
CC: Linus <linus.walleij@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com>	<1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com> <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com> <534B93BA.6020406@linux.intel.com> <534BFAAF.3070805@codeaurora.org> <534D0370.50108@linux.intel.com>
In-Reply-To: <534D0370.50108@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 05:01 AM, Mathias Nyman wrote:
>>
>> This device will only be used on an ACPI system, right?  And isn't ACPI
>> supposed to hide all the pinctrl programming from the OS?  I thought
>> that was the whole point behind ACPI and the reason why ARM64 isn't
>> going to use device trees.
>>
>
> This was my starting point as well, and the driver was initially
> submitted as a GPIO driver. But Linus W. suggested pinctrl instead, and
> as he's the maintainer of both those subsystem I trust his judgment.

Do you think, for an ACPI pinctrl driver, that we will need to specify 
any function groups?  When I look at the ASL that configures GPIOs, I 
see only lines like this:

GpioIo (Exclusive, PullDefault, , , , "\\GIO0") {0x1D, 0x1E}

This tells me that ACPI will never use any of the names that are 
defined.  I see that .get_function_name is called on my ACPI system, but 
I don't see where it is used.

The reason I ask is because I would like to make a "generic" ACPI 
pinctrl/gpio driver that doesn't specify any pin groups.  So if we use 
the same pinctrl/gpio hardware on multiple SOCs, the only thing that the 
driver needs from ACPI is the number of pins.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by the Linux Foundation.
