Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaLJCYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:24:53 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:10437 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaLJCYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:24:52 -0500
X-IronPort-AV: E=Sophos;i="5.07,549,1413270000"; 
   d="scan'208";a="52843638"
Message-ID: <5487AEF0.5010404@broadcom.com>
Date: Tue, 9 Dec 2014 18:24:48 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>,
        "Matt Porter" <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
CC: Scott Branden <sbranden@broadcom.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] ARM: mach-bcm: Enable I2C support for iProc
References: <Ray Jui <rjui@broadcom.com> <1418177893-22094-1-git-send-email-rjui@broadcom.com> <1418177893-22094-4-git-send-email-rjui@broadcom.com> <5487ADE5.4070705@gmail.com>
In-Reply-To: <5487ADE5.4070705@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/9/2014 6:20 PM, Florian Fainelli wrote:
> On 09/12/14 18:18, Ray Jui wrote:
>> Enable I2C driver support for Broadcom iProc family of SoCs by
>> selecting I2C_BCM_IPROC
>>
>> Signed-off-by: Ray Jui <rjui@broadcom.com>
>> Reviewed-by: Scott Branden <sbranden@broadcom.com>
>> ---
>>   arch/arm/mach-bcm/Kconfig |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
>> index aaeec78..86ee90b 100644
>> --- a/arch/arm/mach-bcm/Kconfig
>> +++ b/arch/arm/mach-bcm/Kconfig
>> @@ -19,6 +19,7 @@ config ARCH_BCM_IPROC
>>   	select ARCH_REQUIRE_GPIOLIB
>>   	select ARM_AMBA
>>   	select PINCTRL
>> +	select I2C_BCM_IPROC
>
> One way to avoid having to modify mach-bcm/Kconfig would be to have your
> i2c driver Kconfig do this:
>
> default ARCH_BCM_IPROC
>
> would that work?
>
Yes. So in which case it is better to select a driver from the 
architecture specific Kconfig?

>>   	help
>>   	  This enables support for systems based on Broadcom IPROC architected SoCs.
>>   	  The IPROC complex contains one or more ARM CPUs along with common
>>
>
