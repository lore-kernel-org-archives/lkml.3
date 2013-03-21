Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3CUKBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:01:44 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:12765 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab3CUKBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:01:43 -0400
Message-ID: <514ADA7F.7070303@atmel.com>
Date: Thu, 21 Mar 2013 11:01:35 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>, <a.zummo@towertech.it>,
        <rtc-linux@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Joachim Eastwood <manabian@gmail.com>,
        <devicetree-discuss@lists.ozlabs.org>, <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: at91rm9200: add DT support
References: <1360879147-17273-1-git-send-email-manabian@gmail.com> <5139ABEF.2000408@atmel.com>
In-Reply-To: <5139ABEF.2000408@atmel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 10:14 AM, Nicolas Ferre :
> On 02/14/2013 10:59 PM, Joachim Eastwood :
>> Signed-off-by: Joachim Eastwood <manabian@gmail.com>
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Alessandro, do you want to queue this one on your side?

Ping?

Maybe Andrew, you may take this one on your side?

> Best regards,
> 
>> ---
>>  .../devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt      | 15 +++++++++++++++
>>  drivers/rtc/rtc-at91rm9200.c                              |  9 +++++++++
>>  2 files changed, 24 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
>>
>> diff --git a/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt b/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
>> new file mode 100644
>> index 0000000..2a3feab
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
>> @@ -0,0 +1,15 @@
>> +Atmel AT91RM9200 Real Time Clock
>> +
>> +Required properties:
>> +- compatible: should be: "atmel,at91rm9200-rtc"
>> +- reg: physical base address of the controller and length of memory mapped
>> +  region.
>> +- interrupts: rtc alarm/event interrupt
>> +
>> +Example:
>> +
>> +rtc@fffffe00 {
>> +	compatible = "atmel,at91rm9200-rtc";
>> +	reg = <0xfffffe00 0x100>;
>> +	interrupts = <1 4 7>;
>> +};
>> diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
>> index b6469e2..2ea0ee3 100644
>> --- a/drivers/rtc/rtc-at91rm9200.c
>> +++ b/drivers/rtc/rtc-at91rm9200.c
>> @@ -28,6 +28,8 @@
>>  #include <linux/ioctl.h>
>>  #include <linux/completion.h>
>>  #include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>>  
>>  #include <asm/uaccess.h>
>>  
>> @@ -382,12 +384,19 @@ static const struct dev_pm_ops at91_rtc_pm = {
>>  #define at91_rtc_pm_ptr	NULL
>>  #endif
>>  
>> +static const struct of_device_id at91_rtc_dt_ids[] = {
>> +	{ .compatible = "atmel,at91rm9200-rtc" },
>> +	{ /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, at91_rtc_dt_ids);
>> +
>>  static struct platform_driver at91_rtc_driver = {
>>  	.remove		= __exit_p(at91_rtc_remove),
>>  	.driver		= {
>>  		.name	= "at91_rtc",
>>  		.owner	= THIS_MODULE,
>>  		.pm	= at91_rtc_pm_ptr,
>> +		.of_match_table = of_match_ptr(at91_rtc_dt_ids),
>>  	},
>>  };


-- 
Nicolas Ferre
