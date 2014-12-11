Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350AbaLKJpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:45:00 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:8993 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934317AbaLKJof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:44:35 -0500
X-IronPort-AV: E=Sophos;i="5.07,556,1413270000"; 
   d="scan'208";a="52646053"
Message-ID: <5489677E.3000607@broadcom.com>
Date: Thu, 11 Dec 2014 10:44:30 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: Scott Branden <sbranden@broadcom.com>, Arnd Bergmann <arnd@arndb.de>,
        Ray Jui <rjui@broadcom.com>, Bjorn Helgaas <bhelgaas@google.com>,
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
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH 2/4] PCI: iproc: Add Broadcom iProc PCIe driver
References: <1418169871-19232-3-git-send-email-rjui@broadcom.com> <9707535.Y78sV0TgX4@wuerfel> <54887901.8070501@broadcom.com> <CAGVrzcbZ_f43Vf1mu2XErVi_Jehjggh2TREyrSs84ntSm98yvg@mail.gmail.com>
In-Reply-To: <CAGVrzcbZ_f43Vf1mu2XErVi_Jehjggh2TREyrSs84ntSm98yvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Rafal

On 12/10/14 19:46, Florian Fainelli wrote:
> 2014-12-10 8:46 GMT-08:00 Scott Branden<sbranden@broadcom.com>:
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
>>>> Signed-off-by: Ray Jui<rjui@broadcom.com>
>>>> Reviewed-by: Scott Branden<sbranden@broadcom.com>
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
>
>>>
>>>
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

BCMA core is the bus driver for discoverable ARM AXI interconnect. Apart 
from that it also provides drivers for some cores. For the chips to be 
discoverable it needs additional IP logic. If that is not used in the 
iProc family devices, it can not use the BCMA-based PCIe controller 
driver that Hauke submitted unless BCMA would provide an API to provide 
the chips' core information statically either per core or a full list.

Regards,
Arend
