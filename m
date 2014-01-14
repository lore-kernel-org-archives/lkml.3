Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaANQwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:52:01 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44924 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbaANQv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:51:59 -0500
Message-ID: <52D56B13.2050409@ti.com>
Date: Tue, 14 Jan 2014 10:51:31 -0600
From: "Anna, Suman" <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 7/7] hwspinlock/omap: enable build for AM33xx, AM43xx
 & DRA7xx
References: <1389658764-39199-1-git-send-email-s-anna@ti.com> <1389658764-39199-8-git-send-email-s-anna@ti.com> <20140114131207.GB10818@saruman.home>
In-Reply-To: <20140114131207.GB10818@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

On 01/14/2014 07:12 AM, Felipe Balbi wrote:
> On Mon, Jan 13, 2014 at 06:19:24PM -0600, Suman Anna wrote:
>> HwSpinlocks are supported on AM33xx, AM43xx and DRA7xx SoC
>> device families as well. The IPs are identical to that of
>> OMAP4/OMAP5, except for the number of locks.
>>
>> Add a depends on to the above family of SoCs to enable the
>> build support for OMAP hwspinlock driver for any of the above
>> SoC configs.
>>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> ---
>>   drivers/hwspinlock/Kconfig | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/hwspinlock/Kconfig b/drivers/hwspinlock/Kconfig
>> index 70637d2..3612cb5 100644
>> --- a/drivers/hwspinlock/Kconfig
>> +++ b/drivers/hwspinlock/Kconfig
>> @@ -10,7 +10,7 @@ menu "Hardware Spinlock drivers"
>>
>>   config HWSPINLOCK_OMAP
>>   	tristate "OMAP Hardware Spinlock device"
>> -	depends on ARCH_OMAP4 || SOC_OMAP5
>> +	depends on ARCH_OMAP4 || SOC_OMAP5 || SOC_DRA7XX || SOC_AM33XX || SOC_AM43XX
>
> how about just using ARCH_OMAP2PLUS ?

We do not want the driver to build in OMAP2-only and/or OMAP3-only 
configurations, on which the hwspinlock IP is not even present.

regards
Suman

