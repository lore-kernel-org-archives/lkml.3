Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbaLKBhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:37:09 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:15197 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097AbaLKBhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:37:06 -0500
X-IronPort-AV: E=Sophos;i="5.07,554,1413270000"; 
   d="scan'208";a="52626137"
Message-ID: <5488F53F.5060805@broadcom.com>
Date: Wed, 10 Dec 2014 17:37:03 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lucas Stach <l.stach@pengutronix.de>
CC: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/4] pci: iProc: define Broadcom iProc PCIe binding
References: <Ray Jui <rjui@broadcom.com>	 <1418169871-19232-1-git-send-email-rjui@broadcom.com>	 <1418169871-19232-2-git-send-email-rjui@broadcom.com> <1418207427.7616.5.camel@pengutronix.de>
In-Reply-To: <1418207427.7616.5.camel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/10/2014 2:30 AM, Lucas Stach wrote:
>> +Example:
>> +
>> +SoC specific DT Entry:
>> +
>> +	pcie0: pcie@18012000 {
>> +		compatible = "brcm,iproc-pcie";
>> +		reg = <0x18012000 0x1000>,
>> +			<0x18002000 0x1000>;
>> +		interrupts = <GIC_SPI 96 IRQ_TYPE_NONE>,
>> +			     <GIC_SPI 97 IRQ_TYPE_NONE>,
>> +			     <GIC_SPI 98 IRQ_TYPE_NONE>,
>> +			     <GIC_SPI 99 IRQ_TYPE_NONE>,
>> +			     <GIC_SPI 100 IRQ_TYPE_NONE>,
>> +			     <GIC_SPI 101 IRQ_TYPE_NONE>;
>
> This is missing the interrupt-map and interrupt-map-mask for the legacy
> INTx interrupts. If you add this you don't need to have a special map
> function in your driver, but can just use the standard
> of_irq_parse_and_map_pci() function.
>
> Regards,
> Lucas
>
Thanks for pointing this out. I will look into this and try it out.
