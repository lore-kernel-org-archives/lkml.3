Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3LJDMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 22:12:01 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1213 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab3LJDMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 22:12:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Dec 2013 19:08:38 -0800
Message-ID: <52A6867C.7030902@nvidia.com>
Date: Tue, 10 Dec 2013 12:11:56 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: return -ENOENT when no GPIO mapping exists
References: <1386295616-14192-1-git-send-email-acourbot@nvidia.com> <20131209124018.GD2281@intel.com>
In-Reply-To: <20131209124018.GD2281@intel.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 09:40 PM, Mika Westerberg wrote:
> On Fri, Dec 06, 2013 at 11:06:56AM +0900, Alexandre Courbot wrote:
>> Some devices drivers make use of optional GPIO parameters. For such
>> drivers, it is important to discriminate between the case where no
>> GPIO mapping has been defined for the function they are requesting, and
>> the case where a mapping exists but an error occured while resolving it
>> or when acquiring the GPIO.
>>
>> This patch changes the family of gpiod_get() functions such that they
>> will return -ENOENT if and only if no GPIO mapping is defined for the
>> requested function. Other error codes are used when an actual error
>> occured during the GPIO resolution.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>> I think this change should be merged early as not having it may prevent
>> some users to switch to gpiod. I stumbled upon this issue while
>> considering porting a simple driver (pwm_bl) that has an optional GPIO
>> parameter.
>>
>> Mika, Andy: if Linus agrees with this change, could you take care of
>> having -ENOENT returned as well for the ACPI and SFI GPIOs lookup?
>
> Sure. I have a patch for this already so once this gets merged, I'll send
> out the ACPI version.

Please feel free to send it now, as it should not break anything if your 
patch is merged before mine anyway.

