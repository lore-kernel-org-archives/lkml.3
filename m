Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbbAMOcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:32:54 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:53679 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbbAMOcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:32:52 -0500
Message-ID: <54B52C6D.20006@st.com>
Date: Tue, 13 Jan 2015 15:32:13 +0100
From: David Paris <david.paris@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        <kernel@stlinux.com>
Subject: Re: [4/4] watchdog: st_wdt: Add new driver for ST's LPC Watchdog
References: <1414077524-6469-5-git-send-email-lee.jones@linaro.org> <20150113142341.GA15707@roeck-us.net>
In-Reply-To: <20150113142341.GA15707@roeck-us.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.83]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-13_05:2015-01-13,2015-01-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

     Please forget this implementation of ST LPC Watchdog, Lee has 
provided a new patchset. Search for "[STLinux Kernel] [PATCH 0/8] mfd: 
watchdog: rtc: New driver for ST's LPC IP"

     David

On 01/13/2015 03:23 PM, Guenter Roeck wrote:
> On Thu, Oct 23, 2014 at 04:18:44PM +0100, Lee Jones wrote:
>> Signed-off-by: David Paris <david.paris@st.com>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Digging myself out of my hole. Sorry for the laaaate reply.
>
>> ---
>>   drivers/watchdog/Kconfig  |  16 +++
>>   drivers/watchdog/Makefile |   1 +
>>   drivers/watchdog/st_wdt.c | 317 ++++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 334 insertions(+)
>>   create mode 100644 drivers/watchdog/st_wdt.c
>>
>> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
>> index f57312f..c8abf57 100644
>> --- a/drivers/watchdog/Kconfig
>> +++ b/drivers/watchdog/Kconfig
>> @@ -432,6 +432,22 @@ config SIRFSOC_WATCHDOG
>>   	  Support for CSR SiRFprimaII and SiRFatlasVI watchdog. When
>>   	  the watchdog triggers the system will be reset.
>>   
>> +config ST_WATCHDOG
>> +       tristate "STMicroelectronics LPC Watchdog"
>> +       depends on ARCH_STI && OF
>> +       depends on !RTC_DRV_ST_LPC
> RTC_DRV_ST_LPC is not in mainline nor in -next. Is this still current ?
>
>> +       select WATCHDOG_CORE
>> +       help
>> +	 Say Y here to include Watchdog timer support for the watchdog
>> +	 existing in the LPC of STMicroelectronics SOCs.
>> +	 !!! BE CARREFUL !!!
>> +	 This driver shares hardware resources with RTC Alarm part of the
>> +	 LPC. Both LPC Watchdog driver and LPC RTC driver cannot be
>> +	 used together.
>> +
> Arnd has asked if/how this is enforced by the code. Was this ever resolved ?
>
>> +	 To compile this driver as a module, choose M here: the
>> +	 module will be called st-wdt.
>> +
> [ ... ]
>
>> +	watchdog_set_drvdata(&st_wdog_dev, st_wdog);
>> +	watchdog_set_nowayout(&st_wdog_dev, WATCHDOG_NOWAYOUT);
>> +
>> +	/* Init Watchdog timeout with value in DT */
>> +	ret = watchdog_init_timeout(&st_wdog_dev, 0, &pdev->dev);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "Unable to initialise watchdog timeout\n");
> Missing clk_disable_unprepare().
>
>> +		return ret;
>> +	}
>> +
>> +	ret = watchdog_register_device(&st_wdog_dev);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "Unable to register watchdog\n");
>> +		clk_disable_unprepare(clk);
>> +		return ret;
>> +	}
>> +
>> +	st_wdog_setup(st_wdog, true);
>> +
>> +	dev_info(&pdev->dev, "LPC Watchdog driver registered, reset type is %s",
>> +		 st_wdog->warm_reset ? "warm" : "cold");
> Missing newline.
>
> Guenter
>
>

