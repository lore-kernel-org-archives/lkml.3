Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3DQAA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:00:58 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:46205 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3DQAAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:00:55 -0400
Message-ID: <516DE62E.8020905@gmail.com>
Date: Wed, 17 Apr 2013 08:00:46 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH v9 09/16] PCI, x86: implement pcibios_{add|remove}_bus()
 hooks
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com> <1365781470-32379-10-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.02.1304161324500.30779@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1304161324500.30779@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 04:27 AM, David Rientjes wrote:
> On Fri, 12 Apr 2013, Jiang Liu wrote:
> 
>> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
>> index 901177d..305c68b 100644
>> --- a/arch/x86/pci/common.c
>> +++ b/arch/x86/pci/common.c
>> @@ -6,6 +6,7 @@
>>  
>>  #include <linux/sched.h>
>>  #include <linux/pci.h>
>> +#include <linux/pci-acpi.h>
>>  #include <linux/ioport.h>
>>  #include <linux/init.h>
>>  #include <linux/dmi.h>
>> @@ -170,6 +171,16 @@ void pcibios_fixup_bus(struct pci_bus *b)
>>  		pcibios_fixup_device_resources(dev);
>>  }
>>  
>> +void pcibios_add_bus(struct pci_bus *bus)
>> +{
>> +	acpi_pci_add_bus(bus);
>> +}
>> +
>> +void pcibios_remove_bus(struct pci_bus *bus)
>> +{
>> +	acpi_pci_remove_bus(bus);
>> +}
>> +
>>  /*
>>   * Only use DMI information to set this if nothing was passed
>>   * on the kernel command line (which was parsed earlier).
> 
> This causes build errors when CONFIG_ACPI isn't enabled since both 
> acpi_pci_{add,remove}_bus() aren't defined in such a configuration:
> 
> arch/x86/pci/common.c: In function 'pcibios_add_bus':
> arch/x86/pci/common.c:176:2: error: implicit declaration of function 'acpi_pci_add_bus'
> arch/x86/pci/common.c: In function 'pcibios_remove_bus':
> arch/x86/pci/common.c:181:2: error: implicit declaration of function 'acpi_pci_remove_bus'
> 
Hi David,
	Thanks for report, I have sent a patch to Bjorn to fix this issue,
and it should have been fixed in Bjorn's git tree.
	Regards!
	Gerry


