Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab3B1KwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:52:00 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56403 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab3B1Kv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:51:57 -0500
Message-ID: <512F36B0.9040907@ti.com>
Date: Thu, 28 Feb 2013 16:21:28 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "Manjunathappa, Prakash" <prakash.pm@ti.com>, <linux-mmc@vger.kernel.org>,
        <grant.likely@secretlab.ca>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <hs@denx.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cjb@laptop.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 5/5] ARM: davinci: da850: override mmc DT node device
 name
References: <1360909322-1858-1-git-send-email-prakash.pm@ti.com> <1360909322-1858-6-git-send-email-prakash.pm@ti.com> <512E1259.5020903@gmail.com>
In-Reply-To: <512E1259.5020903@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 2/27/2013 7:34 PM, Rob Herring wrote:
> On 02/15/2013 12:22 AM, Manjunathappa, Prakash wrote:
>> Populate OF_DEV_AUXDATA with desired device name expected by
>> davinci_mmc driver. Without this clk_get of davinci_mmc DT driver
>> fails.
>>
>> Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
>> Cc: linux-mmc@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: davinci-linux-open-source@linux.davincidsp.com
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: cjb@laptop.org
>> Cc: Sekhar Nori <nsekhar@ti.com>
>> ---
>> Since v2:
>> Rebased on top of v3.9/dt-2 branch of linux_davinci and reordered this patch.
>>
>>  arch/arm/mach-davinci/da8xx-dt.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
>> index 5404e92..2b740a9 100644
>> --- a/arch/arm/mach-davinci/da8xx-dt.c
>> +++ b/arch/arm/mach-davinci/da8xx-dt.c
>> @@ -40,6 +40,8 @@ static void __init da8xx_init_irq(void)
>>  struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
>>  	OF_DEV_AUXDATA("ti,davinci-i2c", 0x01c22000, "i2c_davinci.1", NULL),
>>  	OF_DEV_AUXDATA("ti,davinci-wdt", 0x01c21000, "watchdog", NULL),
>> +	OF_DEV_AUXDATA("ti,davinci-mmc-da830", 0x01c40000, "davinci-mmc-da830.0",
>> +			NULL),
> 
> If you only need clock lookup, just add a clkdev entry with the new name.

That would work, but wouldn't it be better to keep this here so it can
all be dropped once clocks are converted to DT?

Thanks,
Sekhar
