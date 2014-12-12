Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030937AbaLLRJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:09:28 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:28003 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030303AbaLLRJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:09:26 -0500
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="53087375"
Message-ID: <548B2144.4070408@broadcom.com>
Date: Fri, 12 Dec 2014 09:09:24 -0800
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
References: <1418351817-14898-4-git-send-email-rjui@broadcom.com> <3173848.p74DGitYxH@wuerfel> <548B1E33.4090806@broadcom.com> <2928443.nLu7V1bDNK@wuerfel>
In-Reply-To: <2928443.nLu7V1bDNK@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/12/2014 9:02 AM, Arnd Bergmann wrote:
> On Friday 12 December 2014 08:56:19 Ray Jui wrote:
>>>>
>>>> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
>>>> index aaeec78..a13a0b2 100644
>>>> --- a/arch/arm/mach-bcm/Kconfig
>>>> +++ b/arch/arm/mach-bcm/Kconfig
>>>> @@ -19,6 +19,7 @@ config ARCH_BCM_IPROC
>>>>       select ARCH_REQUIRE_GPIOLIB
>>>>       select ARM_AMBA
>>>>       select PINCTRL
>>>> +    select PCIE_IPROC
>>>>       help
>>>>         This enables support for systems based on Broadcom IPROC architected SoCs.
>>>>         The IPROC complex contains one or more ARM CPUs along with common
>>>>
>>>
>>> No, just enable it in multi_v7_defconfig and bcm_defconfig.
>>>
>>>        Arnd
>>>
>> Or can I simply have the PCIE_IPROC default to y in
>> drivers/pci/host/Kconfig? Note PCIE_IPROC depends on ARCH_BCM_IPROC. By
>> defaulting it to y, it will be automatically enabled for all iProc
>> family of SoCs.
>
> I still think it's best not to turn it on automatically. The convention
> for device drivers is to make them all optional.
>
> What you can do however is to add
>
> 	depends on ARCH_BCM_IPROC || COMPILE_TEST
>
> to the driver to do the reverse and not let the driver be turned on
> unless IPROC is selected or you are just testing the build.
> A lot of distros just turn on all drivers, so this way you wouldn't
> accidentally enable it for a kernel that doesn't support IPROC.
>
> 	Arnd
>
Okay I'll do that. Thanks.
