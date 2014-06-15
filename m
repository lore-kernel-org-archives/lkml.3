Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaFOOzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 10:55:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51067 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750989AbaFOOz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 10:55:29 -0400
Message-ID: <539DB3DF.5050301@free-electrons.com>
Date: Sun, 15 Jun 2014 16:55:27 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: jjhiblot@traphandler.com, Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 2/7] pwm: add support for atmel-hlcdc-pwm device
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com> <1402329860-27520-3-git-send-email-boris.brezillon@free-electrons.com> <539D6328.4020505@traphandler.com>
In-Reply-To: <539D6328.4020505@traphandler.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello JJ,

On 15/06/2014 11:11, Jean-Jacques Hiblot wrote:
>
> On 06/09/2014 06:04 PM, Boris BREZILLON wrote:
>> The HLCDC IP available in some Atmel SoCs (i.e. sam9x5i.e. at91sam9n12,
>> at91sam9x5 family or sama5d3 family) provide a PWM device.
>>
>> This driver add support for this PWM device.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>  .../devicetree/bindings/pwm/atmel-hlcdc-pwm.txt    |  40 ++++
>>  drivers/pwm/Kconfig                                |   9 +
>>  drivers/pwm/Makefile                               |   1 +
>>  drivers/pwm/pwm-atmel-hlcdc.c                      | 216 +++++++++++++++++++++
>>  4 files changed, 266 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
>>  create mode 100644 drivers/pwm/pwm-atmel-hlcdc.c
>>
>> diff --git a/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
>> new file mode 100644
>> index 0000000..5e2ba87
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
>> @@ -0,0 +1,40 @@
[...]
>> +++ b/drivers/pwm/Kconfig
>> @@ -50,6 +50,15 @@ config PWM_ATMEL
>>  	  To compile this driver as a module, choose M here: the module
>>  	  will be called pwm-atmel.
>>  
>> +config PWM_ATMEL_HLCDC_PWM
>> +	tristate "Atmel HLCDC PWM support"
>> +	depends on MFD_ATMEL_HLCDC
> I'd personnaly prefer a 'select' instead of 'depends on' here. Or maybe
> the MFD driver should enabled y defaut for platforms supporting the hlcdc.

I don't have any strong opinion on the "select" vs "depends on" approach.
Does anyone else think we should use a 'select' instead of a 'depends on' ?
I see at least one benefit, we would be able to see the HLCDC_PWM option
even if the HLCDC driver is not enabled.

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

