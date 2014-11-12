Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaKLFzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 00:55:15 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:60535 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaKLFzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 00:55:13 -0500
Message-ID: <5462F5F9.4000505@huawei.com>
Date: Wed, 12 Nov 2014 13:54:01 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 10/10] PCI/MSI: Remove useless bus->msi assignment
References: <1414396127-30023-1-git-send-email-wangyijing@huawei.com> <1414396127-30023-11-git-send-email-wangyijing@huawei.com> <20141112042454.GL28161@google.com>
In-Reply-To: <20141112042454.GL28161@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.5462F604.007F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: a335ac816efc971b3e19f8c32e04816f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/12 12:24, Bjorn Helgaas wrote:
> On Mon, Oct 27, 2014 at 03:48:47PM +0800, Yijing Wang wrote:
>> Thierry introduced MSI chip(now renamed to MSI controller)
>> framework to associate MSI chip and PCI bus in arm.
>> Other platforms still use its own arch MSI functions to
>> support MSI capability. Thierry introduced the bus->msi
>> assignment to make child bus can inherit bus->msi from the parent.
>> But in fact, drivers which used MSI chip always associate
>> MSI chip and PCI bus by add .add_bus() in arm PCI host bridge
>> drivers. Now we have saved MSI chip in pci_sys_data.
>> We can remove this bus->msi assignment safely.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> CC: Thierry Reding <thierry.reding@gmail.com>
>> CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> ---
>>  drivers/pci/msi.c   |    5 -----
>>  drivers/pci/probe.c |    1 -
>>  2 files changed, 0 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>> index f085f7f..27b6a54 100644
>> --- a/drivers/pci/msi.c
>> +++ b/drivers/pci/msi.c
>> @@ -37,11 +37,6 @@ struct msi_controller * __weak pcibios_msi_controller(struct pci_bus *bus)
>>  
>>  struct msi_controller *pci_msi_controller(struct pci_bus *bus)
>>  {
>> -	struct msi_controller *ctrl = bus->msi;
>> -
>> -	if (ctrl)
>> -		return ctrl;
>> -
>>  	return pcibios_msi_controller(bus);
>>  }
>>  
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index 5ed9930..4b18bf2 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -682,7 +682,6 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>>  
>>  	child->parent = parent;
>>  	child->ops = parent->ops;
>> -	child->msi = parent->msi;
> 
> Does this mean that struct pci_bus.msi is now unused?  If not, where is it
> still used?

Yes, now all arm platforms save msi_chip in pci_sys_data, no one uses it again,
actually, no platform/pcihost never use it, because all arm pci host drivers use
pcibios_add_bus() to associate it and pci bus before. Remove it is safety.

Thanks!
Yijing.

> 
>>  	child->sysdata = parent->sysdata;
>>  	child->bus_flags = parent->bus_flags;
>>  
>> -- 
>> 1.7.1
>>
> 
> .
> 


-- 
Thanks!
Yijing

