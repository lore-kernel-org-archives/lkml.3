Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbaLJUkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:40:42 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:25572 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754AbaLJUkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:40:40 -0500
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="52757206"
Message-ID: <5488AFC6.3000209@broadcom.com>
Date: Wed, 10 Dec 2014 12:40:38 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>, Florian Fainelli <f.fainelli@gmail.com>,
        Scott Branden <sbranden@broadcom.com>
CC: Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rob Herring" <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/4] PCI: iproc: Add Broadcom iProc PCIe driver
References: <1418169871-19232-3-git-send-email-rjui@broadcom.com> <9707535.Y78sV0TgX4@wuerfel> <54887901.8070501@broadcom.com> <CAGVrzcbZ_f43Vf1mu2XErVi_Jehjggh2TREyrSs84ntSm98yvg@mail.gmail.com> <5488AC64.9010306@hauke-m.de>
In-Reply-To: <5488AC64.9010306@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/10/2014 12:26 PM, Hauke Mehrtens wrote:
> On 12/10/2014 07:46 PM, Florian Fainelli wrote:
>> 2014-12-10 8:46 GMT-08:00 Scott Branden <sbranden@broadcom.com>:
>>> On 14-12-10 03:31 AM, Arnd Bergmann wrote:
>>>>
>>>> On Tuesday 09 December 2014 16:04:29 Ray Jui wrote:
>>>>>
>>>>> Add initial version of the Broadcom iProc PCIe driver. This driver
>>>>> has been tested on NSP and Cygnus and is expected to work on all iProc
>>>>> family of SoCs that deploys the same PCIe host controller
>>>>>
>>>>> The driver also supports MSI
>>>>>
>>>>> Signed-off-by: Ray Jui <rjui@broadcom.com>
>>>>> Reviewed-by: Scott Branden <sbranden@broadcom.com>
>>>>
>>>>
>>>> The driver looks suspiciously like the one that Hauke already submitted a
>>>> while ago for bcm53xx. Please come up with a merged driver that works for
>>>> both.
>>>
>>> Could you please be a little more specific.  What driver did "Hauke already
>>> submitted"?  I do not see any driver in the kernel you are talking about.
>>
>> https://www.marc.info/?l=linux-pci&m=141547043110684&w=2
>
> Yes it also looks similar to me. Your code also contains the same
> comments as the driver used on Northstar (BCM5301X).Your driver has
> some more features, but I just have access to the consumer SoC Northstar
> where the PCIe controller is only used to connect some Broadcom Wifi
> chips to the SoC. I do not know If this controller does not have these
> features or the driver I used as a reference does not implement them.
>
Right, I wrote this driver based on some old Broadcom internal PCIe 
driver from a 3.6 kernel and might have copied some of the comments 
(especially in the check link function). The 3.6 driver is probably what 
you received?

> When I find some time I will try this driver on a Northstar device. I
> think your driver is more advanced then the one I send to the mailing list.
>
Please do that. I tested this driver on Cygnus and one of my colleagues 
helped to test it on North Star Plus. We do expect the same driver to 
work on NorthStar as well.

> When you want to stay with pure device tree I will send a patch adding
> additional support for registering to bcma.
>
What exactly is bcma? I guess I'll need to look into it in more details 
myself.

> Does your SoC also have a third PCIe controller which shares the PHY
> with the USB 3 controller?
No. Cygnus has only two PCIe controllers, each has its own dedicated PHY.

>
> Why is this stuff in the iproc_pcie_check_link() function needed? I
> think it is strange that the controller driver has to check if the
> device is there and set the correct speed. When we do not check if the
> card is there on BCM5301X the device stops working.
>
I need to check with our ASIC engineer on this. In theory we should be 
able to support hot plug eventually, but maybe not in the initial 
version of this driver.

>>>> Are you sure that iProc isn't based on the BCMA bus infrastructure after
>>>> all? Even the physical address of your PCI host falls into the address
>>>> range that is used for the internal BCMA bus on the other chips!
>>>
>>> BCMA seems to be for MIPS architectures.  It seems to be quite specific to
>>> those architectures using BCMA.  I see no use of it in bcm53xx code?
>>
>> BCMA lives in its own directory in drivers/bcma/ and is not specific
>> to MIPS actually. Older BCM47xx/BCM53xx MIPS-based SoCs traditionally
>> started with a discoverable Silicon Sonics Backplane (drivers/ssb) and
>> progressively migrated to BCMA (drivers/bcma), both subsystems offer a
>> very similar bus/device/driver abstraction and discovery mechanism.
>
> With mainline kernel 3.18 you can boot Linux on a BCM5301X SoC and bcma
> will find all the cores.
>
> Hauke
>
