Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaIIVvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:51:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57514 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaIIVvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:51:21 -0400
Message-ID: <540F764B.8030303@ti.com>
Date: Tue, 9 Sep 2014 17:51:07 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <bhelgaas@google.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] PCI: keystone: update to support multiple pci
 ports
References: <1410293835-13050-1-git-send-email-m-karicheri2@ti.com> <3294679.puV171E8qx@wuerfel> <540F6646.3010607@ti.com> <9042477.aRbAhpkfQ5@wuerfel> <540F75DF.5050904@ti.com>
In-Reply-To: <540F75DF.5050904@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 05:49 PM, Murali Karicheri wrote:
> On 09/09/2014 05:09 PM, Arnd Bergmann wrote:
>> On Tuesday 09 September 2014 16:42:46 Murali Karicheri wrote:
>>>>>
>>>>> /* update the Vendor ID */
>>>>> - vendor_device_id = readl(ks_pcie->va_reg_pciid);
>>>>> - writew((vendor_device_id>> 16), pp->dbi_base + PCI_DEVICE_ID);
>>>>> + writew(ks_pcie->device_id, pp->dbi_base + PCI_DEVICE_ID);
>>>>>
>>>>> /* update the DEV_STAT_CTRL to publish right mrrs */
>>>>> val = readl(pp->dbi_base + PCIE_CAP_BASE + PCI_EXP_DEVCTL);
>>>>
>>>> This change must have slipped in accidentally, at least it's not
>>>> described in the changelog. Should this be another patch?
>>>> The change seems useful.
>>> Are you referring to mrrs or update to device id? device id is in a SoC
>>> register at index2 and is read and updated by the driver here. MRRS
>>> update was originally in the code.
>>>
>>
>> I meant the device id change. Maybe you accidentally did 'git commit
>> --amend' during a rebase and that replaced the real changelog with
>> the one of the patch in front of it and merged the two patches?
>>
> Actually this is an inteded. The vendor ID is in a register indicated by
> reg offset and as per the device spec, it needs to be read and updated
> by the software. Now since multiple instances of PCI device needs to be
> read the same register, the reading happens in the probe() and same is
> unmapped after that.
>
> + ks_pcie->device_id = readl(reg_p) >> 16;
> + devm_iounmap(dev, reg_p);
> + devm_release_mem_region(dev, res->start, resource_size(res));
>
> Afetr that in ks_pcie_host_init(), it update the device_id in the RC's
> config space.
>
BTW, I will update the commit log with more description to indicate the 
above and re-send it if this is fine.

> Thanks
>
> Murali
>> That happened to me a few times and would explain the strange mix
>> of two changes.
>>
>> Arnd
>

