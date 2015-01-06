Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbbAFVKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:10:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33696 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbbAFVKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:10:17 -0500
Message-ID: <54AC4EDB.1000400@ti.com>
Date: Tue, 6 Jan 2015 16:08:43 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] of/pci: add of_pci_dma_configure() update dma
 configuration
References: <1419459099-6667-1-git-send-email-m-karicheri2@ti.com> <1419459099-6667-2-git-send-email-m-karicheri2@ti.com> <CAL_JsqJtVnP_5zAiUvMwL00JQV0mjw-R_hEkxiv13ZuNrQ8nAA@mail.gmail.com> <54A6D375.6050604@ti.com> <CAL_Jsq+krOUA3BPvMCdaOBhALoi+pzWbw3YndXqR8x52OJogZg@mail.gmail.com> <54A71CD1.4070107@ti.com> <20150106195033.GH32449@arm.com>
In-Reply-To: <20150106195033.GH32449@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 02:50 PM, Will Deacon wrote:
> On Fri, Jan 02, 2015 at 10:33:53PM +0000, Murali Karicheri wrote:
>> On 01/02/2015 03:45 PM, Rob Herring wrote:
>>> On Fri, Jan 2, 2015 at 11:20 AM, Murali Karicheri<m-karicheri2@ti.com>   wrote:
>>>> On 12/26/2014 02:33 PM, Rob Herring wrote:
>>>>> On Wed, Dec 24, 2014 at 4:11 PM, Murali Karicheri<m-karicheri2@ti.com>
>>>>>> +               coherent = of_dma_is_coherent(parent_np);
>>>>>> +               dev_dbg(dev, "device is%sdma coherent\n",
>>>>>> +                       coherent ? " " : " not ");
>>>>>> +
>>>>>> +               arch_setup_dma_ops(dev, dma_addr, size, NULL, coherent);
>>>>>
>>>>>
>>>>> This is the same code as of_dma_configure. The only difference I see
>>>>> is which node ptr is passed to of_dma_get_range. You need to make that
>>>>> a function param of of_dma_configure.
>>>>>
>>>>> of_dma_configure also has iommu handling now. You will probably need
>>>>> something similar for PCI in that you setup an iommu based on the root
>>>>> bus DT properties.
>>>>>
>>>> Initially I had the same idea to re-use the existing function
>>>> of_dma_configure() for this. I wanted to defer this until we have an
>>>> agreement on the changes required for the subject functionality. My quick
>>>> review of the code suggestio this would require additional API changes as
>>>> below. I did a quick test of the changes and it works for Keystone, but need
>>>> to be reviewed by everyone as I touch the IOMMU functionality here and I
>>>> don't have a platform with IOMMU. Need test by someone to make sure I don't
>>>> break anything.
>>>
>>> The IOMMU changes look trivial. We may want to address the comment in
>>> of_iommu_configure about parent nodes. We should be sure these changes
>>> work with how we would do searching parent nodes.
>>
>> I have no experience with IOMMU and may not offer much help here as I
>> originally wrote above. Will Deacon has added this API and probably able
>> to offer some help in this discussion.
>>
>> Will Deacon,
>>
>> Any comment?
>
> Sorry for the delay; I'm still catching up on email after the Christmas
> break, but I *will* get around to looking at this. If you have a new version
> to post based on the comments from Rob and Arnd, feel free to send that and
> I'll look at that instead.
>
> Will
Will,

I will be posting v3 of the patch tomorrow and you can review that.

Regards,

Murali


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
