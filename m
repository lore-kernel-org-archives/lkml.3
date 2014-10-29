Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaJ2HmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:42:13 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15289 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaJ2HmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:42:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 29 Oct 2014 00:41:29 -0700
Message-ID: <54509A3B.5090709@nvidia.com>
Date: Wed, 29 Oct 2014 16:41:47 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Darren Hart <dvhart@linux.intel.com>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / GPIO: Pass index to acpi_get_gpiod_by_index()
 when using properties
References: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com> <2740724.5yjNTKs1RY@vostro.rjw.lan>
In-Reply-To: <2740724.5yjNTKs1RY@vostro.rjw.lan>
X-NVConfidentiality: public
X-Originating-IP: [10.19.57.128]
X-ClientProxiedBy: HKMAIL104.nvidia.com (10.18.16.13) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 06:59 AM, Rafael J. Wysocki wrote:
> On Tuesday, October 28, 2014 01:15:27 PM Mika Westerberg wrote:
>> acpi_dev_add_driver_gpios() makes it possible to set up mapping between
>> properties and ACPI GpioIo resources in a driver, so we can take index
>> parameter in acpi_find_gpio() into use with _DSD device properties now.
>>
>> This index can be used to select a GPIO from a property with multiple
>> GPIOs:
>>
>>    Package () {
>>    	"data-gpios",
>>    	Package () {
>>    		\_SB.GPIO, 0, 0, 0,
>>    		\_SB.GPIO, 1, 0, 0,
>>    		\_SB.GPIO, 2, 0, 1,
>>    	}
>>    }
>>
>> In order to retrieve the last GPIO from a driver we can simply do:
>>
>>    desc = devm_gpiod_get_index(dev, "data", 2);
>>
>> and so on.
>>
>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>
> Cool. :-)
>
> Any objections anyone?

Looks good to me!

Acked-by: Alexandre Courbot <acourbot@nvidia.com>

Since this looks like a bug fix, shouldn't this be squashed into the 
relevant patch of the device-properties set?
