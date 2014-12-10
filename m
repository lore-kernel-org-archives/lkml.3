Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbaLJU0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:26:18 -0500
Received: from hauke-m.de ([5.39.93.123]:49514 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821AbaLJU0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:26:16 -0500
Message-ID: <5488AC64.9010306@hauke-m.de>
Date: Wed, 10 Dec 2014 21:26:12 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>,
        Scott Branden <sbranden@broadcom.com>
CC: Arnd Bergmann <arnd@arndb.de>, Ray Jui <rjui@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/4] PCI: iproc: Add Broadcom iProc PCIe driver
References: <1418169871-19232-3-git-send-email-rjui@broadcom.com> <9707535.Y78sV0TgX4@wuerfel> <54887901.8070501@broadcom.com> <CAGVrzcbZ_f43Vf1mu2XErVi_Jehjggh2TREyrSs84ntSm98yvg@mail.gmail.com>
In-Reply-To: <CAGVrzcbZ_f43Vf1mu2XErVi_Jehjggh2TREyrSs84ntSm98yvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 07:46 PM, Florian Fainelli wrote:
> 2014-12-10 8:46 GMT-08:00 Scott Branden <sbranden@broadcom.com>:
>> On 14-12-10 03:31 AM, Arnd Bergmann wrote:
>>>
>>> On Tuesday 09 December 2014 16:04:29 Ray Jui wrote:
>>>>
>>>> Add initial version of the Broadcom iProc PCIe driver. This driver
>>>> has been tested on NSP and Cygnus and is expected to work on all iProc
>>>> family of SoCs that deploys the same PCIe host controller
>>>>
>>>> The driver also supports MSI
>>>>
>>>> Signed-off-by: Ray Jui <rjui@broadcom.com>
>>>> Reviewed-by: Scott Branden <sbranden@broadcom.com>
>>>
>>>
>>> The driver looks suspiciously like the one that Hauke already submitted a
>>> while ago for bcm53xx. Please come up with a merged driver that works for
>>> both.
>>
>> Could you please be a little more specific.  What driver did "Hauke already
>> submitted"?  I do not see any driver in the kernel you are talking about.
> 
> https://www.marc.info/?l=linux-pci&m=141547043110684&w=2

Yes it also looks similar to me. Your code also contains the same
comments as the driver used on Northstar (BCM5301X). Your driver has
some more features, but I just have access to the consumer SoC Northstar
where the PCIe controller is only used to connect some Broadcom Wifi
chips to the SoC. I do not know If this controller does not have these
features or the driver I used as a reference does not implement them.

When I find some time I will try this driver on a Northstar device. I
think your driver is more advanced then the one I send to the mailing list.

When you want to stay with pure device tree I will send a patch adding
additional support for registering to bcma.

Does your SoC also have a third PCIe controller which shares the PHY
with the USB 3 controller?

Why is this stuff in the iproc_pcie_check_link() function needed? I
think it is strange that the controller driver has to check if the
device is there and set the correct speed. When we do not check if the
card is there on BCM5301X the device stops working.

>>> Are you sure that iProc isn't based on the BCMA bus infrastructure after
>>> all? Even the physical address of your PCI host falls into the address
>>> range that is used for the internal BCMA bus on the other chips!
>>
>> BCMA seems to be for MIPS architectures.  It seems to be quite specific to
>> those architectures using BCMA.  I see no use of it in bcm53xx code?
> 
> BCMA lives in its own directory in drivers/bcma/ and is not specific
> to MIPS actually. Older BCM47xx/BCM53xx MIPS-based SoCs traditionally
> started with a discoverable Silicon Sonics Backplane (drivers/ssb) and
> progressively migrated to BCMA (drivers/bcma), both subsystems offer a
> very similar bus/device/driver abstraction and discovery mechanism.

With mainline kernel 3.18 you can boot Linux on a BCM5301X SoC and bcma
will find all the cores.

Hauke
