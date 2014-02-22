Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaBVUmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 15:42:33 -0500
Received: from mail.active-venture.com ([67.228.131.205]:52589 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaBVUm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 15:42:28 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <53090BAF.3080806@roeck-us.net>
Date: Sat, 22 Feb 2014 12:42:23 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>, Michal Simek <michal.simek@xilinx.com>
CC: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 10/11] watchdog: xilinx: Enable this driver for Zynq
References: <cover.1392212059.git.michal.simek@xilinx.com> <a978b8d0511748e4558f5169896da44c742a49f3.1392212059.git.michal.simek@xilinx.com> <20140222184419.GA21504@spo001.leaseweb.com>
In-Reply-To: <20140222184419.GA21504@spo001.leaseweb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2014 10:44 AM, Wim Van Sebroeck wrote:
> Hi Michal,
>
>> Enable this driver for Zynq.
>> Move it to architecture independent Kconfig part.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>
>> Changes in v3: None
>> Changes in v2: None
>>
>> Build tested by zero day testing system.
>> ---
>>   drivers/watchdog/Kconfig | 22 +++++++++-------------
>>   1 file changed, 9 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
>> index 9db5d3c..6120403 100644
>> --- a/drivers/watchdog/Kconfig
>> +++ b/drivers/watchdog/Kconfig
>> @@ -111,6 +111,15 @@ config WM8350_WATCHDOG
>>   	  Support for the watchdog in the WM8350 AudioPlus PMIC.  When
>>   	  the watchdog triggers the system will be reset.
>>
>> +config XILINX_WATCHDOG
>> +	tristate "Xilinx Watchdog timer"
>> +	select WATCHDOG_CORE
>> +	help
>> +	  Watchdog driver for the xps_timebase_wdt ip core.
>> +
>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called of_xilinx_wdt.
>> +
>>   # ALPHA Architecture
>>
>>   # ARM Architecture
>> @@ -1022,19 +1031,6 @@ config M54xx_WATCHDOG
>>
>>   # MicroBlaze Architecture
>>
>> -config XILINX_WATCHDOG
>> -	tristate "Xilinx Watchdog timer"
>> -	depends on MICROBLAZE
>> -	select WATCHDOG_CORE
>> -	---help---
>> -	  Watchdog driver for the xps_timebase_wdt ip core.
>> -
>> -	  IMPORTANT: The xps_timebase_wdt parent must have the property
>> -	  "clock-frequency" at device tree.
>> -
>> -	  To compile this driver as a module, choose M here: the
>> -	  module will be called of_xilinx_wdt.
>> -
>>   # MIPS Architecture
>>
>>   config ATH79_WDT
>> --
>> 1.8.2.3
>>
>
> Are we sure that we don't need an additional dependancy (like depends on HAS_IOMEM) to not have issues with other architectures?
>

Hi Wim,

Doesn't look like it. I have the series in my build test and did not
see any failures because of it. See http://server.roeck-us.net:8010/builders,
branch watchdog-next.

Which reminds me that I wanted to reparent the branch to 3.14-rc3.
I just did that; you should be able to see build results in a couple
of hours.

Guenter

