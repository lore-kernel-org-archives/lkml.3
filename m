Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaLPA21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:28:27 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:6789 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaLPA2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:28:25 -0500
X-IronPort-AV: E=Sophos;i="5.07,583,1413270000"; 
   d="scan'208";a="53131299"
Message-ID: <548F7CA7.8070600@broadcom.com>
Date: Mon, 15 Dec 2014 16:28:23 -0800
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
References: <1418351817-14898-3-git-send-email-rjui@broadcom.com> <1790462.K12S5vem48@wuerfel> <548F338F.9030203@broadcom.com> <2242033.mU3KpyO3Rt@wuerfel>
In-Reply-To: <2242033.mU3KpyO3Rt@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/15/2014 1:37 PM, Arnd Bergmann wrote:
> On Monday 15 December 2014 11:16:31 Ray Jui wrote:
>> On 12/12/2014 9:21 AM, Arnd Bergmann wrote:
>>> On Friday 12 December 2014 09:08:48 Ray Jui wrote:
>>> One way to solve this would be by turning the driver into a library
>>> the same way as the pcie-dw driver, and have separate front-ends
>>> for it for platform_device and bcma_device.
>>>
>> I'm fine with this solution, i.e., to introduce a common pcie-iproc core
>> driver (just like pcie-designware) and have different front-ends
>> depending on the device/bus type. If we end up deciding to go with this
>> solution, I need to discuss with Hauke to come up with a plan to
>> collaborate.
>
> Ok
>
>> But before we choose to go with that route, may I ask, what is the
>> purpose of tying a PCIe host driver to BCMA? What benefit does BCMA give
>> us? If we have a generic platform based PCIe driver that can work on all
>> iProc SoCs + BCM4708 and BCM5301X with all HW specific configurations
>> taken care of by device tree, why do we still need to use BCMA?
>>
>> I thought all a BCMA device here does is to auto-instantiate based on
>> some register readings?
>
> Basically, DT is a hack that we only need for nondiscoverable buses.
> As BCMA is (mostly) discoverable, we should use that, just like we do
> for things like PCI and USB. There are clearly some limitations to
> BCMA as well, e.g. on bcm4708 we don't have proper IRQ numbers in
> the device list and we need to work around that using DT, but overall
> it still seems to have more upsides than downsides to use it.
>
> It's also good to point other SoC makers to Broadcom as a good example
> for how to do things they claim are impossible to do.
>
> 	Arnd
>
Okay. Fair enough. Let's go with your proposal to create a generic 
driver pcie-iproc to be used by both bcma and platform bus. I'll 
initiate another email thread with you, Hauke, Scott, and me. We can 
discuss how to collaborate on that email thread.

Thanks.
