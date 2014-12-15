Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750921AbaLOTQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:16:54 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:56995 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaLOTQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:16:53 -0500
X-IronPort-AV: E=Sophos;i="5.07,581,1413270000"; 
   d="scan'208";a="53105958"
Message-ID: <548F338F.9030203@broadcom.com>
Date: Mon, 15 Dec 2014 11:16:31 -0800
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
Subject: Re: [PATCH v2 2/4] PCI: iproc: Add Broadcom iProc PCIe driver
References: <1418351817-14898-3-git-send-email-rjui@broadcom.com> <2190666.DfrpWiLTCc@wuerfel> <548B2120.4080207@broadcom.com> <1790462.K12S5vem48@wuerfel>
In-Reply-To: <1790462.K12S5vem48@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/12/2014 9:21 AM, Arnd Bergmann wrote:
> On Friday 12 December 2014 09:08:48 Ray Jui wrote:
>>
>> On 12/12/2014 4:29 AM, Arnd Bergmann wrote:
>> Doesn't Hauke's driver depends on BCMA? In that case, how does it work
>> on the SoCs that do not have the IP block to support BCMA?
>
> I hadn't realized that there are some SoCs that are not BCMA based.
> As the host controller implementation is closely related, we will
> have to come up with some solution.
>
I agree with you that we should have a common PCIe host driver which 
supports all iProc SoCs, BCM4708, BCM5301X, and some other similar SoCs.

> One way to solve this would be by turning the driver into a library
> the same way as the pcie-dw driver, and have separate front-ends
> for it for platform_device and bcma_device.
>
I'm fine with this solution, i.e., to introduce a common pcie-iproc core 
driver (just like pcie-designware) and have different front-ends 
depending on the device/bus type. If we end up deciding to go with this 
solution, I need to discuss with Hauke to come up with a plan to 
collaborate.

But before we choose to go with that route, may I ask, what is the 
purpose of tying a PCIe host driver to BCMA? What benefit does BCMA give 
us? If we have a generic platform based PCIe driver that can work on all 
iProc SoCs + BCM4708 and BCM5301X with all HW specific configurations 
taken care of by device tree, why do we still need to use BCMA?

I thought all a BCMA device here does is to auto-instantiate based on 
some register readings?
