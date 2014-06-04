Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaFDTcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:32:43 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43653 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFDTcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:32:42 -0400
Message-ID: <538F7460.6020600@cogentembedded.com>
Date: Wed, 04 Jun 2014 23:32:48 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vidya Sagar <vidyas@nvidia.com>, linux@arm.linux.org.uk,
        bhelgaas@google.com, wangyijing@huawei.com, thierry.reding@gmail.com,
        jason@lakedaemon.net, will.deacon@arm.com, swarren@nvidia.com,
        kthota@nvidia.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sagar.tv@gmail.com
Subject: Re: [PATCH] ARM: fix debug prints relevant to PCI devices
References: <1401909447-8434-1-git-send-email-vidyas@nvidia.com>
In-Reply-To: <1401909447-8434-1-git-send-email-vidyas@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/04/2014 11:17 PM, Vidya Sagar wrote:

> As per PCIe spec, fast back-to-back transactions feature
> is not applicable to PCIe devices. Hence, do not print
> that fast back-to-back trasactions are disabled when
> there is a PCIe device found on the bus

> Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
> ---
>   arch/arm/kernel/bios32.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)

> diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> index 17a26c1..95ad3fb 100644
> --- a/arch/arm/kernel/bios32.c
> +++ b/arch/arm/kernel/bios32.c
[...]
> @@ -354,9 +357,11 @@ void pcibios_fixup_bus(struct pci_bus *bus)
>
>   	/*
>   	 * Report what we did for this bus
> +	 * (only if the bus doesn't have even one PCIe device)
>   	 */
> -	printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",
> -		bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
> +	if (!has_pcie_dev)
> +		printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",

    Time to change this to pr_info()...

> +			bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
>   }
>   EXPORT_SYMBOL(pcibios_fixup_bus);

WBR, Sergei

