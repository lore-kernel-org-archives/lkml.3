Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaHRHQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 03:16:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:31830 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbaHRHQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 03:16:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,884,1400050800"; 
   d="scan'208";a="469766422"
Message-ID: <53F1A831.4090309@intel.com>
Date: Mon, 18 Aug 2014 15:16:01 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Max Eliaser <max.eliaser@intel.com>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 6/9] gpiolib: add API to get gpio desc and flags
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com> <20140817130004.4B9FDC4137F@trevor.secretlab.ca> <D016516D.A1AFA%dvhart@linux.intel.com> <1927766.GeLld99ozq@vostro.rjw.lan>
In-Reply-To: <1927766.GeLld99ozq@vostro.rjw.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2014 12:57 PM, Rafael J. Wysocki wrote:
> On Sunday, August 17, 2014 12:43:38 PM Darren Hart wrote:
>> On 8/17/14, 6:00, "Grant Likely" <grant.likely@secretlab.ca> wrote:
>>
>>>>
>>>> +	/* Using device tree? */
>>>> +	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
>>>> +		desc = of_find_gpio(dev, NULL, idx, flags);
>>>
>>> of_find_gpio() doesn't exist.
>>
>> Hrm... As of 3.16.0 (e64df3ebe8262c8203d1fe4f541e0241c3112c01)
>>
>> $ git blame -L1455,1456 drivers/gpio/gpiolib.c
>> bae48da2 (Alexandre Courbot 2013-10-17 10:21:38 -0700 1455) static struct
>> gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
>>
>> Have we removed this in -next or something? (on the plane, will verify
>> upon landing)
> 
> In 3.17-rc1:
> 
> rafael@vostro:~/src/linux-pm> grep -r of_find_gpio *
> drivers/gpio/gpiolib.c:static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
> drivers/gpio/gpiolib.c:         desc = of_find_gpio(dev, con_id, idx, &lookupflags);

I also verified the following branch:
git://git.secretlab.ca/git/linux devicetree/next
And of_find_gpio is there.

Regards,
Aaron
