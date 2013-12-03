Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3LCX1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:27:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49947 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218Ab3LCX1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:27:13 -0500
Message-ID: <529E68CC.4090808@ti.com>
Date: Wed, 4 Dec 2013 08:27:08 +0900
From: Milo Kim <milo.kim@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 3/4] pwm: add LP3943 PWM driver
References: <1378949630-6275-1-git-send-email-milo.kim@ti.com> <20131203102455.GH21178@ulmo.nvidia.com>
In-Reply-To: <20131203102455.GH21178@ulmo.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 12/03/2013 07:24 PM, Thierry Reding wrote:
> On Thu, Sep 12, 2013 at 10:33:50AM +0900, Milo Kim wrote:
>> This is the other of the LP3943 MFD driver.
>> LP3943 can be used as a PWM generator, up to 2 channels.
>>
>> * Two PWM generators supported
>>
>> * Supported PWM operations
>>    request, free, config, enable and disable
>>
>> * Pin assignment
>>    A driver data, 'pin_used' is checked when a PWM is requested.
>>    If the output pin is already assigned, then returns as failure.
>>    If the pin is available, 'pin_used' is set.
>>    When the PWM is not used anymore, then it is cleared.
>>    It is defined as unsigned long type for atomic bit operation APIs,
>>    but only LSB 16bits are used because LP3943 has 16 outputs.
>>
>> Cc: Thierry Reding <thierry.reding@gmail.com>
>> Signed-off-by: Milo Kim <milo.kim@ti.com>
>> ---
>> * Patch v3
>>    Manual polarity not supported any more.
>>    Add encapsulation functions for accessing internal data structure.
>>    Use pwm_set_chip_data() and pwm_get_chip_data().
>>    And other code fixes based on Thierry's feedback.
>>
>>   drivers/pwm/Kconfig      |   10 ++
>>   drivers/pwm/Makefile     |    1 +
>>   drivers/pwm/pwm-lp3943.c |  314 ++++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 325 insertions(+)
>>   create mode 100644 drivers/pwm/pwm-lp3943.c
>
> Hi Milo,
>
> Is this patchset still the latest version? I've tried to remember the
> status of this series, but I could only draw a blank.

Thanks a lot for this reminder.
I forgot to check the status.

The latest one is the v4, but LP3943 PWM driver code is same as v3.

   Update from v3 to v4:
     Move the driver description from the documentation to the MFD 
driver file.

There are two things to be ACKed for v4.
One is the PWM driver. (https://lkml.org/lkml/2013/9/25/11)
The other is the documentation. (https://lkml.org/lkml/2013/9/25/10)

Thanks,
   Milo
