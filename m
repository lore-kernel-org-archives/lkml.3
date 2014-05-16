Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaEPU1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:27:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58550 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbaEPU13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:27:29 -0400
Message-ID: <5376748B.7080302@ti.com>
Date: Fri, 16 May 2014 16:26:51 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware
 core driver
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <6048322.x3M3sdDEWO@wuerfel> <5374FD24.8000806@ti.com> <22200719.Jb5jnJylJH@wuerfel>
In-Reply-To: <22200719.Jb5jnJylJH@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/2014 2:20 PM, Arnd Bergmann wrote:
> On Thursday 15 May 2014 13:45:08 Murali Karicheri wrote:
>>>> +#ifdef CONFIG_PCI_KEYSTONE
>>>> +/*
>>>> + * The KeyStone PCIe controller has maximum read request size of 256 bytes.
>>>> + */
>>>> +static void quirk_limit_readrequest(struct pci_dev *dev)
>>>> +{
>>>> +    int readrq = pcie_get_readrq(dev);
>>>> +
>>>> +    if (readrq > 256)
>>>> +            pcie_set_readrq(dev, 256);
>>>> +}
>>>> +DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_readrequest);
>>>> +#endif /* CONFIG_PCI_KEYSTONE */
>>> This doesn't work: you can't just limit do this for all devices just based
>>> on PCI_KEYSTONE being enabled, you have to check if you are actually using
>>> this controller.
>>>
>>>        Arnd
>>    I assume, I need to check if PCI controller's vendor ID/ device ID
>> match with the keystone
>>    PCI controller's ID and call pcie_set_readrq() for all of the slave
>> PCI devices and do this fixup.
>> Is this correct understanding?  If you can point me to an example code
>> for this that will be
>> really helpful so that I can avoid re-inventing the wheel.
> I think it would be best to move the quirk into the keystone pci driver
> and compare compare the dev->driver pointer of the PCI controller device.
>
> 	Arnd
Arnd,

I will move this quirk to keystone pci driver. So in that case, I guess 
your original comment
is not applicable as  this quirk gets enabled only with PCI keystone 
driver enabled. Right?

Murali
