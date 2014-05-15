Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaEORpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:45:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38482 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaEORpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:45:42 -0400
Message-ID: <5374FD24.8000806@ti.com>
Date: Thu, 15 May 2014 13:45:08 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware
 core driver
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <1400169692-9677-6-git-send-email-m-karicheri2@ti.com> <6048322.x3M3sdDEWO@wuerfel>
In-Reply-To: <6048322.x3M3sdDEWO@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,


Thanks for the review. I may have more questions as I digest the 
comments. Here is the
immediate one.

>> +#ifdef CONFIG_PCI_KEYSTONE
>> +/*
>> + * The KeyStone PCIe controller has maximum read request size of 256 bytes.
>> + */
>> +static void quirk_limit_readrequest(struct pci_dev *dev)
>> +{
>> +	int readrq = pcie_get_readrq(dev);
>> +
>> +	if (readrq > 256)
>> +		pcie_set_readrq(dev, 256);
>> +}
>> +DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_readrequest);
>> +#endif /* CONFIG_PCI_KEYSTONE */
> This doesn't work: you can't just limit do this for all devices just based
> on PCI_KEYSTONE being enabled, you have to check if you are actually using
> this controller.
>
> 	Arnd
  I assume, I need to check if PCI controller's vendor ID/ device ID 
match with the keystone
  PCI controller's ID and call pcie_set_readrq() for all of the slave 
PCI devices and do this fixup.
Is this correct understanding?  If you can point me to an example code 
for this that will be
really helpful so that I can avoid re-inventing the wheel.

Murali

