Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134AbaLLQ4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:56:23 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:25662 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934379AbaLLQ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:56:21 -0500
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="52921622"
Message-ID: <548B1E33.4090806@broadcom.com>
Date: Fri, 12 Dec 2014 08:56:19 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] ARM: mach-bcm: Enable PCIe support for iProc
References: <1418351817-14898-4-git-send-email-rjui@broadcom.com> <3173848.p74DGitYxH@wuerfel>
In-Reply-To: <3173848.p74DGitYxH@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/12/2014 4:15 AM, Arnd Bergmann wrote:
> On Thursday 11 December 2014 18:36:56 Ray Jui wrote:
>> Enable PCIe driver support for Broadcom iProc family of SoCs by
>> selecting PCIE_IPROC
>>
>> Signed-off-by: Ray Jui <rjui@broadcom.com>
>> Reviewed-by: Scott Branden <sbranden@broadcom.com>
>> ---
>>   arch/arm/mach-bcm/Kconfig |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
>> index aaeec78..a13a0b2 100644
>> --- a/arch/arm/mach-bcm/Kconfig
>> +++ b/arch/arm/mach-bcm/Kconfig
>> @@ -19,6 +19,7 @@ config ARCH_BCM_IPROC
>>   	select ARCH_REQUIRE_GPIOLIB
>>   	select ARM_AMBA
>>   	select PINCTRL
>> +	select PCIE_IPROC
>>   	help
>>   	  This enables support for systems based on Broadcom IPROC architected SoCs.
>>   	  The IPROC complex contains one or more ARM CPUs along with common
>>
>
> No, just enable it in multi_v7_defconfig and bcm_defconfig.
>
> 	Arnd
>
Or can I simply have the PCIE_IPROC default to y in 
drivers/pci/host/Kconfig? Note PCIE_IPROC depends on ARCH_BCM_IPROC. By 
defaulting it to y, it will be automatically enabled for all iProc 
family of SoCs.
