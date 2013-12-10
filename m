Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3LJHjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:39:14 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:16121 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3LJHi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:38:57 -0500
Message-ID: <52A6C4E8.5030003@huawei.com>
Date: Tue, 10 Dec 2013 15:38:16 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, <linux-alpha@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-ia64@vger.kernel.org>,
        <linux-parisc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <sparclinux@vger.kernel.org>
Subject: Re: [PATCH 1/9] PCI: Use dev_is_pci() to check whether it is pci
 device
References: <1386244373-35796-1-git-send-email-wangyijing@huawei.com> <20131210000154.GE4699@google.com>
In-Reply-To: <20131210000154.GE4699@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/10 8:01, Bjorn Helgaas wrote:
> [+cc arch lists]
> 
> On Thu, Dec 05, 2013 at 07:52:53PM +0800, Yijing Wang wrote:
>> Use dev_is_pci() instead of directly compare
>> pci_bus_type to check whether it is pci device.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> 
> I applied all these to my pci/yijing-dev_is_pci branch for v3.14, thanks!
> 
> Browse them here: http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/yijing-dev_is_pci

Thanks!
Bjorn, I sent the "[patch v2 4/9] sparc/PCI: Use dev_is_pci() to identify PCI devices" to
correct build error found by kbuild test, Because I have no sparc platform, I guess the build error was introduced
by I remove the CONFIG_PCI #ifdef in that patch. Now I keep the CONFIG_PCI code and that patch should be no functional change.


> 
> This should be no functional change.
> 
>  arch/alpha/kernel/pci_iommu.c        |    2 +-
>  arch/arm/common/it8152.c             |    4 ++--
>  arch/arm/mach-ixp4xx/common-pci.c    |    6 +++---
>  arch/ia64/hp/common/sba_iommu.c      |    2 +-
>  arch/ia64/sn/pci/pci_dma.c           |   24 ++++++++++++------------
>  arch/parisc/kernel/drivers.c         |   22 +++++-----------------
>  arch/powerpc/sysdev/fsl_pci.c        |    2 +-
>  arch/sparc/include/asm/dma-mapping.h |   10 ++++------
>  arch/sparc/kernel/iommu.c            |    2 +-
>  arch/sparc/kernel/ioport.c           |    4 +---
>  arch/x86/kernel/acpi/boot.c          |    4 +---
>  drivers/pci/pci-acpi.c               |    2 +-
>  12 files changed, 33 insertions(+), 51 deletions(-)
> 
> Bjorn
> 
>> ---
>>  drivers/pci/pci-acpi.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
>> index 577074e..e0431f1 100644
>> --- a/drivers/pci/pci-acpi.c
>> +++ b/drivers/pci/pci-acpi.c
>> @@ -358,7 +358,7 @@ static void pci_acpi_cleanup(struct device *dev)
>>  
>>  static bool pci_acpi_bus_match(struct device *dev)
>>  {
>> -	return dev->bus == &pci_bus_type;
>> +	return dev_is_pci(dev);
>>  }
>>  
>>  static struct acpi_bus_type acpi_pci_bus = {
>> -- 
>> 1.7.1
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 


-- 
Thanks!
Yijing

