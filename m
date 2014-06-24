Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbaFXQXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:23:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41919 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbaFXQXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:23:04 -0400
Message-ID: <53A9A59B.9000709@ti.com>
Date: Tue, 24 Jun 2014 12:21:47 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Richard Zhu <r65037@freescale.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: Re: [PATCH v2 0/8] Add Keystone PCIe controller driver
References: <20140623051346.GC2666@pratyush-vbox> <53A85AAC.4070401@ti.com>
In-Reply-To: <53A85AAC.4070401@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mohit,

On 06/23/2014 12:49 PM, Santosh Shilimkar wrote:
>
>
>
> -------- Original Message --------
> Subject: Re: [PATCH v2 0/8] Add Keystone PCIe controller driver
> Date: Mon, 23 Jun 2014 10:43:46 +0530
> From: Pratyush Anand<pratyush.anand@st.com>
> To: Murali Karicheri<m-karicheri2@ti.com>
>
> On Sat, Jun 21, 2014 at 05:17:07AM +0800, Murali Karicheri wrote:
>>
>> Sorry, my previous response was in html and not sure it has made to the
>> list. I did
>> get an error as well. So resending my response.
>>
>> On 6/18/2014 6:14 AM, Mohit KUMAR DCG wrote:
>>> Hello Murali,
>>>
>>
>
> [...]
>
>> *pos = pos0;
>>
>> @@ -349,7 +353,10 @@ static int dw_msi_setup_irq(struct msi_chip *chip,
>> struct pci_dev *pdev,
>>
>> */
>>
>> desc->msi_attrib.multiple = msgvec;
>>
>> -msg.address_lo = virt_to_phys((void *)pp->msi_data);
>>
>> +if (pp->ops->get_msi_data)
>>
>> +msg.address_lo = pp->ops->get_msi_data(pp);
>>
>> +else
>>
>> +msg.address_lo = virt_to_phys((void *)pp->msi_data);
>>
>> msg.address_hi = 0x0;
>>
>> msg.data = pos;
>>
>>
>> What about this code? This requires get_msi_data() as well
>
> pp->msi_data is set in dw_pcie_msi_init, which is a global function
> called from vendor specific code. You can have your own
> keystone_pcie_msi_init and then you do not need above changes.
>
My Apologies for the email format as I lost the original email and had
to respond using a forwarded email.

If you look at my original patch, keystone driver was not calling
dw_pcie_msi_init(). However the issue is msi_chip of DW core is
re-used as most of the code is platform independent. However
code that sends write_msi_msg() can be re-used on keystone by
adding this get_msi_data() API as the only difference IMO is the
address EP writes to raise an MSI IRQ event. I don't see any
reason why the entire code needs to be duplicated on Keystone.
BTW, currently I have not tested the MSI IRQ and tested my driver
only with Legacy IRQ. I plan to test this before sending my
v3 of the patch.

Murali

>>
>>> -- 3rd to use pp->ops->msi_set/clear if defined.
>> Why not API enhancement and refactor the code in a single patch?
>
> Yes, can be. You can send changes in 2 or 3 patches as you wish, but I
> believe that should be able to solve problem in best way.
>
> Regards
> Pratyush
>>
>> Murali
>>> Pls let us know for any issue or have different opinion.
>>>
>>> Regards
>>> Mohit
>>>
>>>
>>>
>>>
>>>> --
>>>> 1.7.9.5
>>
>
>

